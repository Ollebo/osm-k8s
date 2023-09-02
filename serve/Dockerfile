FROM ubuntu


RUN apt-get update && apt-get install -y locales locales-all
ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

ENV TZ=Europe/London
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt update && apt install apache2 libapache2-mod-tile renderd -y
RUN apt update && apt install -y screen locate libapache2-mod-tile renderd git tar unzip wget bzip2 apache2 lua5.1 mapnik-utils python3-mapnik python3-psycopg2 python3-yaml gdal-bin npm fonts-noto-cjk fonts-noto-hinted fonts-noto-unhinted fonts-unifont fonts-hanazono postgresql postgresql-contrib postgis postgresql-14-postgis-3 postgresql-14-postgis-3-scripts osm2pgsql net-tools curl

#Install carto 
RUN npm install -g carto
COPY mapnik /opt/mapnik
COPY renderd /opt/renderd
COPY www /var/www/html

#Making mapnik 
WORKDIR /opt/mapnik
RUN carto osm-cargo/project.mml > osm-cargo/mapnik-carto.xml

COPY renderd/apache2/*.conf /etc/apache2/sites-available/
COPY renderd/renderd.conf /etc/renderd.conf


RUN mkdir -p /var/cache/renderd/tiles
RUN chmod -R 777 /var/cache/renderd
RUN chown -R www-data:www-data /var/cache/renderd/tiles

RUN mkdir -p /run/renderd/
RUN chmod -R 777 /run/renderd/

COPY run.sh /opt/run.sh
RUN chmod +x /opt/run.sh
WORKDIR /opt

CMD /opt/run.sh