SPLITTERJAR=/home/marco/OpenTopoMap/garmin/tools/splitter-r615/splitter.jar
MKGMAPJAR=/home/marco/OpenTopoMap/garmin/tools/mkgmap-r4802/mkgmap.jar
SEA=/home/marco/OpenTopoMap/garmin/sea/sea/
BOUNDS=/home/marco/OpenTopoMap/garmin/bounds/


mkdir data
pushd data > /dev/null

#rm -f georgia-latest.osm.pbf
#wget "https://download.geofabrik.de/europe/georgia-latest.osm.pbf"

rm -f 6324*.pbf
java -jar $SPLITTERJAR --precomp-sea=$SEA "$(pwd)/georgia-latest.osm.pbf"
DATA="$(pwd)/6324*.pbf"

popd > /dev/null

OPTIONS="$(pwd)/opentopomap_options"
STYLEFILE="$(pwd)/style/opentopomap"

pushd style/typ > /dev/null

java -jar $MKGMAPJAR --family-id=35 OpenTopoMap.txt
TYPFILE="$(pwd)/OpenTopoMap.typ"

popd > /dev/null

java -jar $MKGMAPJAR -c $OPTIONS --style-file=$STYLEFILE \
    --precomp-sea=$SEA \
    --output-dir=output --bounds=$BOUNDS $DATA $TYPFILE

# optional: give map a useful name:
mv output/gmapsupp.img output/georgia.img
./tools/jmc_cli -src=output -dest=output -bmap=georgia.img -gmap="georgia.gmap"

DATE=`date +%s`
mkdir -p output/georgia

mv output/georgia.img output/georgia/georgia_${DATE}.img
mv output/georgia.gmap output/georgia/georgia_${DATE}.gmap

#rm output/*
