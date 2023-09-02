#!/bin/bash 
#Start the renderd service

echo "Setup apache "
rm -rf /etc/apache2/sites-enabled/*
ln -s /etc/apache2/sites-available/renderd.conf /etc/apache2/sites-enabled/


echo "start the render"
/usr/bin/renderd 
echo "start the apache"
apachectl -DFOREGROUND