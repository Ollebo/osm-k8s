# Openstreatmap in K8s

This is the base repo for deploying an Openstreat map server in k8s. Is uses the cloudnative postgress project to setup up a postgis server.
Then we can install the map using the importer tool.
Today the importer only use the map of Sweden but it shoul be easy to chanmge to any country of you like.

To serve the map we use Apache with mapnik and render. the server service will connect to the postgis and serve the map.


### For dev
This setup workes great on a minikube setup and for testing to work with the map server

### For prod
When use for prod setup a CDN ore some caching service infron of the apache service.
It shouls also be possible to chnage the postgis server to use RDS ore simular.

## Setup

### Importer
The importer grabs a file from GEOfabrik and add the file into a Postgis server.
It will then install styles and SQL script for performance

### Service
The server is an Apache server running renderd. It will use a mapnik to connect to our postgis server and then render the data.
The Apache also host a web page to display the map.


### Use Own images for productions
This is a base for my docker to run and you are free to run it. But please clone the repo and build your own images to use.
Dont trust my images to be updated regulary.


### Why
I have for a while trying to understand and build map for my cluster but most of the guides are old and confusing.
This id the result of weeks of fiddling and reading.


### How it works
First we take the data from openstreatmap its the file you can download. The file is imported into a Postgis database.
And in then in the  database we also add some shades (Dont really now what they are good for)  styles and some SQL to improve the speed (Index)

But when we want to view the map on a webclient we need to build tiles to show our map.
There are many different ways but in here we uses mapnik.
First we get a style that we can use and here we use the default openstreatmap-cargo.

To generate a xml file that mapnik can use to render the data from the sql. We need to make an xlm file.
And for that we use the tool Cargo.

Carto takes the project file from the style (openstreetmap-cargo) and generates anxml files that mapnik kan uses.
In that project file we also have SQL settings.(In our docker we replace them att upstart)

So now we have our database with the data. We have mapnik files that tells how things should look now we need to render our tiles.
And to do that we use a tool called renderd.

Renderd gets where on a map you are. Connect to mapnik using the XML we generated and mapnik goes to the sql to get the data.
Then mapnik generated the tiles and send them back.

To display the tiles to the web browser we have an apache server.

Yeee its alot of steps :-)



## Install


### Install postgress using the cloudnatove-pg

Lets install our postgres server using helm 

```
kubectl apply  -f   https://raw.githubusercontent.com/cloudnative-pg/cloudnative-pg/main/releases/cnpg-1.20.0.yaml
```
This will install the cloudnative operator so that we can create postgius clusters.
then the operator is running we can install the postgis cluster by applyting the yaml 


### Create the maps namespace

```
kubectl create namespace maps
```
Apply the Postgis from our examle folder

```
kubectl apply -f postgis/postgis.yaml -n maps 
```




### Install the Importer
the importer will

- Get the latest Sweden OSM image
- Add it to the postgis using the ENV in the yaml file
- Setup Shades file from OSM-Cargo
- Setup sql index for performance

In Kubernetes it will create a job and you can rerun it to update the Posgis with new data.


Dont like sweden ? Change to any file you like

```
        args: 
           - apt update && apt install wget -y;
             cd /openstreatmap/osm/;
             wget https://download.geofabrik.de/europe/sweden-latest.osm.pbf;
```

Install the import with the following command

```
kubectl apply -f yaml/importer.yaml
```

### Serve
Now when we have the data we can install our serve with will be a webbserver and render the tiles .

The serve will
- Update the project with SQL settings from ENV
- Build the mapnik tiles with cargo
- start reanderd with mapnik
- Setup a GUI so you can watch the map in apache defualt
- Start a apache server so you can see the map


```
kubectl apply -f yaml/serve.yaml
```


## Visit the MAP
Now you can open the map by visiting the serve service


![sweden](img/sweden.png "Sweden")
