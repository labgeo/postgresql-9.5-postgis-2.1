FROM postgres:9.5

ENV POSTGIS_VERSION 2.1.8

RUN buildDeps=" \
  postgresql-server-dev-${PG_MAJOR} \
  libgeos-dev \
  libproj-dev \ 
  libgdal-dev \
  libjson0-dev \
  make \
  curl \
  gcc \
  "; \
     apt-get update \
  && apt-get install -y $buildDeps libxml2 --no-install-recommends \
  && curl -o /tmp/postgis-$POSTGIS_VERSION.tar.gz -s \ 
      http://download.osgeo.org/postgis/source/postgis-$POSTGIS_VERSION.tar.gz \
  && tar xf /tmp/postgis-$POSTGIS_VERSION.tar.gz -C /usr/src/ \
  && cd /usr/src/postgis-$POSTGIS_VERSION \
  && ./configure \
  && make -j"$(nproc)" \
  && make install \
  && cd extensions \
  && make -j"$(nproc)" \
  && make install \
  && cd / && rm /tmp/postgis-$POSTGIS_VERSION.tar.gz \
  && apt-get purge --auto-remove -y $buildDeps \
  && rm -rf /var/lib/apt/lists/*

RUN postgisDeps=' \
  libgdal1h \
  libproj0 \
  libgeos-3.4.2 \
  libjson0 \
  '; \
    apt-get update \
  && apt-get install -y $postgisDeps \
  && rm -rf /var/lib/apt/lists/*
