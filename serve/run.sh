#!/bin/bash 
#Start the renderd service

echo "Setup apache "
rm -rf /etc/apache2/sites-enabled/*
ln -s /etc/apache2/sites-available/renderd.conf /etc/apache2/sites-enabled/


echo "Making mapnik render file (This will take a while)"
echo "Setup postgis Database for mapnik"
envsubst < /opt/mapnik/osm-cargo/project.mml_tmp > /opt/mapnik/osm-cargo/project.mml
echo "Making file"
carto /opt/mapnik/osm-cargo/project.mml > /opt/mapnik/osm-cargo/mapnik-carto.xml

sleep 10
echo "start the render"
/usr/bin/renderd 
echo "start the apache"
apachectl -DFOREGROUND