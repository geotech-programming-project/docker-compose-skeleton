#!/bin/bash

apt update

chmod +x fct_getGooglePlacesData.py

python3 fct_getGooglePlacesData.py

# Function to check if PostgreSQL is ready
is_postgres_ready() {
  pg_isready -h database -U user -d mydb -q
}

# Wait for PostgreSQL to be ready
until is_postgres_ready; do
  echo "PostgreSQL is not ready yet. Waiting..."
  sleep 5
done

echo "PostgreSQL is ready now."


PGPASSWORD=passwd psql -h database -U user -d mydb -c "CREATE TABLE restaurants_table (
    \"Name\" VARCHAR,
    \"Address\" VARCHAR,
    \"Place_ID\" VARCHAR PRIMARY KEY,
    \"Phone_Number\" VARCHAR,
    \"Rating\" FLOAT,
    \"Website\" VARCHAR,
    \"Price_Level\" INTEGER,
    \"Types\" VARCHAR,
    \"Latitude\" FLOAT,
    \"Longitude\" FLOAT,
    \"User_Ratings_Total\" INTEGER,
    \"Business_Status\" VARCHAR,
    \"Nearby\" VARCHAR,
    \"Location\" VARCHAR
);"


PGPASSWORD=passwd psql -h database -U user -d mydb -c "\COPY restaurants_table FROM 'restaurants_nearby_geotech.csv' WITH CSV HEADER DELIMITER ';'"

PGPASSWORD=passwd psql -h database -U user -d mydb -c "CREATE TABLE user_comments (
    \"comment_id\" SERIAL PRIMARY KEY,
    \"user_id\" INTEGER,
    \"restaurant_id\" INTEGER,
    \"comment_text\" TEXT,
    \"created_at\" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    -- Add other columns as needed
    CONSTRAINT fk_user_id FOREIGN KEY (user_id) REFERENCES users(user_id),
    CONSTRAINT fk_restaurant_id FOREIGN KEY (restaurant_id) REFERENCES restaurants_table(restaurant_id)
);"

PGPASSWORD=passwd psql -h database -U user -d mydb -c "CREATE TABLE comments_table (
    \"comment_id\" SERIAL PRIMARY KEY,
    \"user_id\" INTEGER,
    \"comment_text\" TEXT,
    \"created_at\" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    \"place_id\" VARCHAR,
    FOREIGN KEY (place_id) REFERENCES restaurants_table(Place_ID)
);"


# Run ogr2ogr command
# ogr2ogr -f "PostgreSQL" PG:"dbname=mydb user=user password=passwd host=postgres" -nlt PROMOTE_TO_MULTI -lco GEOMETRY_NAME=wkb_geometry data/shp_sc/shp_sc.shp

# if [ $? -eq 0 ]; then
#   echo "ogr2ogr added data/shp_sc/shp_sc.shp into PostgreSQL successfully"
# else
#   echo "ogr2ogr command failed with exit code $?"
# fi
