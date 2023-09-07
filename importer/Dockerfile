from ghcr.io/osgeo/gdal:ubuntu-full-3.7.0

RUN apt-get update
RUN apt-get install -y locales locales-all
ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

ENV TZ=Europe/London
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

#Import pg client
RUN apt update && apt-get install -y postgresql-client osm2pgsql -y
RUN psql --version 

RUN apt-get update && \
    apt-get install -y git curl unzip gettext-base  python3-psycopg2 python3-yaml  mapnik-utils fontconfig && \
    rm -rf /var/lib/apt/lists/*



COPY imposm3 /imposm3
COPY code    /code

WORKDIR  /code
RUN chmod +x /code/run.sh

CMD /code/run.sh

