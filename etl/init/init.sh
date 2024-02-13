#!/bin/bash


sudo apt update

# Function to check if PostgreSQL is ready
is_postgres_ready() {
  pg_isready -h postgres -U user -d mydb -q
}

# Wait for PostgreSQL to be ready
until is_postgres_ready; do
  echo "PostgreSQL is not ready yet. Waiting..."
  sleep 5
done

echo "PostgreSQL is ready now."

# Run ogr2ogr command
# ogr2ogr -f "PostgreSQL" PG:"dbname=mydb user=user password=passwd host=postgres" -nlt PROMOTE_TO_MULTI -lco GEOMETRY_NAME=wkb_geometry data/shp_sc/shp_sc.shp

# if [ $? -eq 0 ]; then
#   echo "ogr2ogr added data/shp_sc/shp_sc.shp into PostgreSQL successfully"
# else
#   echo "ogr2ogr command failed with exit code $?"
# fi
