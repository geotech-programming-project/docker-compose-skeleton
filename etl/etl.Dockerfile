FROM ubuntu:latest

RUN apt update -y
RUN apt upgrade -y
RUN apt install -y postgresql-client
RUN apt install -y gdal-bin
RUN apt-get update && apt-get install -y python3-pip

COPY init/init.sh init.sh
COPY init/fct_getGooglePlacesData.py fct_getGooglePlacesData.py
COPY init/requirements.txt requirements.txt

RUN pip install -r requirements.txt

RUN chmod +x init.sh

CMD ["sh", "init.sh"]
