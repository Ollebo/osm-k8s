# Openstreatmap in K8s
this is the base repo for deploying an openstreat map server in k8s. The project has 2 parts.

## Importer
The importer grabs a file from geofabrik and will add the file into a postgis server.
It will then install requerd styles and sql script for performance

## Service
The server is a Apacha server running renderd. It will use a mapnik to connect to our postgis server and then render the data.
The apache also host a web page to display the map.


## Not four your productions
This is a base for mu to run and you are free to run it. But please clone the repo and build your own images to use.
Dont trust my images to be updated regular.


## Why
I have for a while bean trying to understand and to build map for my cluster but most of the guides are old and confusing.
this is the result of weeks of fiddling and reading.


## How it works
First we take the data from openstreatmap its the file you can download. The file is imported into a postgis database.
And in then in the  database we also add some shades (Dont really now what they are good for)  styles and some sql to improve the speed (Index)

But when we want to view the map on a webclient we need to build tiles to show.
There are many different ways but in here we uses mapnik.
First we get a style that we can use and here we use the default openstreatmap-cargo.

To generate a xml file that mapnik can use to render the data from the sql we need to make an xlm file.
To generare the file we use a tool called carto

Carto takes the project file from the style (openstreetmap-cargo) and generates an xml files that mapnik kan uses.
In that mapnik file we also have SQL settings.(Hardcoded ??? be aware )

So now we have our database with the data. We have mapnik files that tells how things should look now we need to render our tiles.
And to do that we use a tool called renderd.

Renderd gets where on a map you are. Connect to mapnik using the XML we generated and mapnik goes to the sql to get the data.
Then mapnik generated the tiles and send them back.

To display the tiles to the web browser we have an apache server.

Yeee its alot of steps :-)


## Postgis
Its outside this scope to setup a postgis but i uses a regular postgres operator and add the postgis image to use.
This is working good for me.

## Ingress
I have not added any ingress to the helm but it will come.



# Install
You can install using the helm repo i will build 
