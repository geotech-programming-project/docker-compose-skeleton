#!/usr/bin/env python3

import pandas as pd
import googlemaps
from datetime import datetime
import csv

def get_place_details(gmaps, place_id):
    place_details = gmaps.place(place_id=place_id)['result']
    return {
        'Name': place_details.get('name', 'N/A'),
        'Address': place_details.get('formatted_address', 'N/A'),
        'Place_ID': place_id,
        'Phone_Number': place_details.get('formatted_phone_number', 'N/A'),
        'Rating': place_details.get('rating', 'N/A'),
        'Website': place_details.get('website', 'N/A'),
        'Price_Level': place_details.get('price_level', 'N/A'),
        'Opening_Hours': place_details.get('opening_hours', {}).get('weekday_text', 'N/A'),
        'Types': ', '.join(place_details.get('types', [])),
        'Latitude': place_details.get('geometry', {}).get('location', {}).get('lat', 'N/A'),
        'Longitude': place_details.get('geometry', {}).get('location', {}).get('lng', 'N/A'),
        'User_Ratings_Total': place_details.get('user_ratings_total', 'N/A'),
        'Business_Status': place_details.get('business_status', 'N/A'),
        'Nearby': 'N/A'  # Placeholder for location information
    }


def write_csv(gmaps, query, location, radius, location_name, output_df):
    result = gmaps.places(query=query, location=location, radius=radius)

    for place in result['results']:
        place_id = place['place_id']
        place_details = get_place_details(gmaps, place_id)
        place_details['Location'] = location_name
        output_df = pd.concat([output_df, pd.DataFrame([place_details])], ignore_index=True)

    return output_df


def clean_na_values(df):
    # Replace "N/A" with NaN in the entire DataFrame
    df.replace("N/A", pd.NA, inplace=True)
    # Optionally, you can fill NaN values with a default value if needed
    # df.fillna(default_value, inplace=True)
    return df


# ------------------------------------------

# Parameters:
q='restaurants'
novaims=(38.731352, -9.160070)
ifgi=(51.969412, 7.595780)
uji=(39.994487, -0.069388)
r=1000
api_key = 'AIzaSyABgdLOMdnhVT_rggwcbFMS2yDdfTpf2eY'

# Gmaps client:
gmaps = googlemaps.Client(key=api_key)

# Create an empty DataFrame to store the results
df = pd.DataFrame(columns=['Name', 'Address', 'Place_ID', 'Phone_Number', 'Rating', 'Website', 'Price_Level',
                           'Opening_Hours', 'Types', 'Latitude', 'Longitude', 'User_Ratings_Total',
                           'Business_Status', 'Nearby'])

# Write data to the DataFrame for each location
df = write_csv(gmaps, q, novaims, r, 'novaims', df)
df = write_csv(gmaps, q, ifgi, r, 'ifgi', df)
df = write_csv(gmaps, q, uji, r, 'uji', df)

# Clean "N/A" values
df = clean_na_values(df)

# Save the combined DataFrame to a CSV file
df.to_csv('restaurants_nearby_geotech2.csv', index=False, sep=';')
