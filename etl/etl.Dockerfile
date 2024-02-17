FROM ubuntu:latest

RUN apt-get update -y
RUN apt-get install -y postgresql-client
RUN apt install -y gdal-bin
RUN apt-get install -y python3 python3-pip

COPY init/init.sh /usr/local/bin/init.sh
COPY init/get_googlePlacesData.py /usr/local/bin/get_googlePlacesData.py

RUN chmod +x /usr/local/bin/init.sh

RUN pip3 install pandas googlemaps datetime

# Run the script when the container starts
CMD ["sh", "/usr/local/bin/init.sh"]
