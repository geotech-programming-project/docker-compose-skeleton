FROM postgis/postgis:latest

ENV POSTGRES_DB=mydb
ENV SCHEMA=public
ENV POSTGRES_USER=user
ENV POSTGRES_PASSWORD=passwd

# Install necessary tools (shp2pgsql is included in the postgis image)
RUN apt-get update
RUN apt-get install -y postgresql-client
RUN apt install -y gdal-bin
RUN rm -rf /var/lib/apt/lists/*

