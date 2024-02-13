FROM ubuntu:latest

RUN apt-get update
RUN apt-get install -y postgresql-client
RUN apt install -y gdal-bin

COPY init/init.sh /usr/local/bin/

RUN chmod +x /usr/local/bin/init.sh

# Run the script when the container starts
CMD ["sh", "/usr/local/bin/init.sh"]

