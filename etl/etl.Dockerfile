FROM ubuntu:latest

RUN apt-get update -y
RUN apt-get install -y postgresql-client
RUN apt install -y gdal-bin
RUN apt-get install -y python3 python3-pip
RUN pip3 install pandas googlemaps datetime

COPY init/init.sh /init.sh
COPY init/fct_getGooglePlacesData.py /fct_getGooglePlacesData.py

RUN chmod +x /usr/local/bin/init.sh

# Run the script when the container starts
CMD ["sh", "/usr/local/bin/init.sh"]
