SPLITTERJAR=/home/marco/repos/OpenTopoMap-NG/garmin/src/splitter-r615/splitter.jar
MKGMAP_JAR=/home/marco/repos/OpenTopoMap-NG/garmin/src/mkgmap-r4802/mkgmap.jar
SEA=/home/marco/repos/OpenTopoMap-NG/garmin/sea/sea/
BOUNDS=/home/marco/repos/OpenTopoMap-NG/garmin/bounds/

BOUNDS_FILE="$(pwd)/bounds-latest.zip"
SEA_FILE="$(pwd)/sea-latest.zip"
DEM_FILE=

continent=europe
countryname_short=georgia
continentdate=`date`
FAMILY_ID=42425
MKGMAP_OPTS="$(pwd)/opentopomap_options"
REDUCED_DENSITY=""
GMAPI="--gmapi"
mkgmapin="$(pwd)/data/6324*.pbf"
MKGMAP_TYP_FILE="$(pwd)/style/typ/opentopomap.typ"
MKGMAP_OUTPUT_DIR="output"
MKGMAP_STYLE_FILE="$(pwd)/style/opentopomap"

mkdir data
pushd data > /dev/null

#rm -f ${countryname_short}-latest.osm.pbf
#wget "https://download.geofabrik.de/${continent}/${countryname_short}-latest.osm.pbf"

rm -f 6324*.pbf
java -jar $SPLITTERJAR --precomp-sea=$SEA "$(pwd)/${countryname_short}-latest.osm.pbf"
DATA="$(pwd)/6324*.pbf"

popd > /dev/null

OPTIONS="$(pwd)/opentopomap_options"
STYLEFILE="$(pwd)/style/opentopomap"

pushd style/typ > /dev/null

java -jar $MKGMAP_JAR --family-id=35 opentopomap.txt
TYPFILE="$(pwd)/opentopomap.typ"

popd > /dev/null

#java -jar $MKGMAPJAR -c $OPTIONS --style-file=$STYLEFILE \
#    --precomp-sea=$SEA \
#    --output-dir=output --bounds=$BOUNDS $DATA $TYPFILE

java -Xmx5000m -jar $MKGMAP_JAR --output-dir=$MKGMAP_OUTPUT_DIR --style-file=$MKGMAP_STYLE_FILE --description="Waldrian TOPO ${countryname_short^} ${continentdate}" --area-name="Waldrian TOPO ${countryname_short^} ${continentdate}" --overview-mapname="Waldrian_TOPO_${countryname_short^}" --family-name="Waldrian TOPO ${countryname_short^} ${continentdate}" --family-id=$FAMILY_ID --series-name="Waldrian TOPO ${countryname_short^} ${continentdate}" --bounds=$BOUNDS_FILE --precomp-sea=$SEA_FILE -c $MKGMAP_OPTS $REDUCED_DENSITY $GMAPI $mkgmapin $MKGMAP_TYP_FILE &> $MKGMAP_OUTPUT_DIR/mkgmap.log
#java -Xmx10000m -jar $MKGMAP_JAR --output-dir=$MKGMAP_OUTPUT_DIR --style-file=$MKGMAP_STYLE_FILE --description="OpenTopoMap ${countryname_short^} ${continentdate}" --area-name="OpenTopoMap ${countryname_short^} ${continentdate}" --overview-mapname="OpenTopoMap_${countryname_short^}" --family-name="OpenTopoMap ${countryname_short^} ${continentdate}" --family-id=$FAMILY_ID --series-name="OpenTopoMap ${countryname_short^} ${continentdate}" --bounds=$BOUNDS_FILE --precomp-sea=$SEA_FILE --dem=$DEM_FILE -c $MKGMAP_OPTS $REDUCED_DENSITY $GMAPI $mkgmapin $MKGMAP_TYP_FILE &> $MKGMAP_OUTPUT_DIR/mkgmap.log



# optional: give map a useful name:
#mv output/gmapsupp.img output/${countryname_short}.img
#./src/jmc_cli -src=output -dest=output -bmap=${countryname_short}.img -gmap="georgia.gmap"

#DATE=`date +%s`
#mkdir -p output/${countryname_short}

#mv output/${countryname_short}.img output/georgia/georgia_${DATE}.img
#mv output/${countryname_short}.gmap output/georgia/georgia_${DATE}.gmap

#rm output/*
