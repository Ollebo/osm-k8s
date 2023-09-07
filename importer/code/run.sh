#!/bin/bash
#
#
# This script is used to run the importer
# setup databases in postgis and then import the data   
#
#
## setup our database
psql -U postgres -c "DROP DATABASE $PGDATABASE;"
psql -U postgres -c "CREATE DATABASE $PGDATABASE;"
psql -U postgres -d $PGDATABASE -c "CREATE EXTENSION postgis;"
psql -U postgres -d $PGDATABASE -c "CREATE EXTENSION hstore;"


osm2pgsql -G --hstore --style styles/openstreetmap-carto.style --tag-transform-script styles/openstreetmap-carto.lua  /openstreatmap/osm/sweden-latest.osm.pbf -d $PGDATABASE


#Import sweden into osm database
#/imposm3/imposm3 import -connection postgis://$PGUSER:$PGPASSWORD@$PGHOST/osm -mapping /imposm3/mapping.json -read /openstreatmap/sweden-latest.osm.pbf -write
#/imposm3/imposm3 import -connection postgis://$PGUSER:$PGPASSWORD@$PGHOST/osm -mapping /imposm3/mapping.json -deployproduction
#
## Usiing 
#osm2pgsql -c -d osm  -S /openstreatmap/default.style /openstreatmap/sweden-latest.osm.pbf
#
#
#echo "Import the land polygons"
#dataurls=(
#	"https://osmdata.openstreetmap.de/download/land-polygons-split-3857.zip"
#)
#
#psql -d osm -c "DROP TABLE IF EXISTS land_polygons"
#
## iterate our dataurls
#for i in "${!dataurls[@]}"; do
#	url=${dataurls[$i]}
#
#	echo "fetching $url";
#	curl $url > $i.zip;
#	unzip $i -d $i
#
#	shape_file=$(find $i -type f -name "*.shp")
#
#	echo $shape_file
#
#	# reproject data to webmercator (3857) and insert into our database
#	OGR_ENABLE_PARTIAL_REPROJECTION=true ogr2ogr -overwrite -t_srs EPSG:3857 -nlt PROMOTE_TO_MULTI -f PostgreSQL PG:"dbname='osm' host='$PGHOST' user='$PGUSER' password='$PGPASSWORD'" $shape_file
#
#	# clean up
#	rm -rf $i/ $i.zip
#done
#

#Setup external
echo "Setup external data"
envsubst < external-data.yml_tmp > external-data.yml
scripts/get-external-data.py

echo "Setup Helper and index"
psql  -d osm -a -f sql/indexes.sql 
psql  -d osm -a -f sql/postgis_helpers.sql
psql  -d osm -a -f sql/postgis_index.sql
echo "Done!"
exit 0
