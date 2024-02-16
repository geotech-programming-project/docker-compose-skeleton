import pandas as pd
import googlemaps
from datetime import datetime
import csv
import numpy as np


def get_place_details(gmaps, place_id):
    place_details = gmaps.place(place_id=place_id)['result']
    return {
        'Name': place_details.get('name', np.nan),
        'Address': place_details.get('formatted_address', np.nan),
        'Place_ID': place_id,
        'Phone_Number': place_details.get('formatted_phone_number', np.nan),
        'Rating': place_details.get('rating', np.nan),
        'Website': place_details.get('website', np.nan),
        'Price_Level': place_details.get('price_level', np.nan),
        # 'Opening_Hours': place_details.get('opening_hours', {}).get('weekday_text', np.nan),
        'Types': ', '.join(place_details.get('types', [])),
        'Latitude': place_details.get('geometry', {}).get('location', {}).get('lat', np.nan),
        'Longitude': place_details.get('geometry', {}).get('location', {}).get('lng', np.nan),
        'User_Ratings_Total': place_details.get('user_ratings_total', np.nan),
        'Business_Status': place_details.get('business_status', np.nan),
        'Nearby': np.nan  # Placeholder for location information
    }

def write_csv(gmaps, query, location, radius, location_name, output_df):
    result = gmaps.places(query=query, location=location, radius=radius)

    for place in result['results']:
        place_id = place['place_id']
        place_details = get_place_details(gmaps, place_id)
        place_details['Location'] = location_name
        output_df = output_df.append(place_details, ignore_index=True)

    return output_df


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
                          #  'Opening_Hours', 
                           'Types', 'Latitude', 'Longitude', 'User_Ratings_Total',
                           'Business_Status', 'Nearby'])

# Write data to the DataFrame for each location
df = write_csv(gmaps, q, novaims, r, 'novaims', df)
df = write_csv(gmaps, q, ifgi, r, 'ifgi', df)
df = write_csv(gmaps, q, uji, r, 'uji', df)
# df

# Save the combined DataFrame to a CSV file
df.to_csv('restaurants_nearby_geotech.csv', index=False, sep=';')
