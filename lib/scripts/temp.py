import csv
import re
import requests
from urllib.parse import urlparse
import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore


def extract_lat_lng(url):
    try:
        response = requests.get(url, allow_redirects=True, timeout=5)
        full_url = response.url
    except Exception as e:
        print(f"Error expanding URL {url}: {e}")
        return None

    patterns = [
        r'/@([0-9\.\-]+),([0-9\.\-]+),',    # /@lat,lng,zoom
        r'@([0-9\.\-]+),([0-9\.\-]+)',       # @lat,lng
        r'!3d([0-9\.\-]+)!4d([0-9\.\-]+)',  # !3d<lat>!4d<lng>  (place/pin URLs)
        r'[?&]q=([0-9\.\-]+),([0-9\.\-]+)', # q=lat,lng
    ]

    for pattern in patterns:
        match = re.search(pattern, full_url)
        if match:
            try:
                return {
                    'lat': float(match.group(1)),
                    'lng': float(match.group(2))
                }
            except ValueError:
                continue

    print(f"Could not extract coords from: {full_url}")
    return None

cred = credentials.Certificate(r"D:\DISHDASH_service_key\dishdash-84c1b-59cadd173861.json")
firebase_admin.initialize_app(cred)

db = firestore.client()

restaurantFields = {}
with open('C:/Users/sanan/Desktop/DishDash/lib/scripts/data.csv', 'r') as file:
    reader = csv.DictReader(file)


    for row in reader:
        
        # For fields with multiple values separated by commas, split them:
        foodpanda_urls = [url.strip() for url in row['FoodPanda URL'].split(',')] if row['FoodPanda URL'] else []
        maps_urls = [url.strip() for url in row['Google Maps URL'].split(',')] if row['Google Maps URL'] else []
        # addresses = [addr.strip() for addr in row['Address'].split(',')] if row['Address'] else []
        contacts = [contact.strip() for contact in row['Contact Number'].split(',')] if row['Contact Number'] else []
        ambience = [tag.strip() for tag in row['Tag Ambience'].split(',')] if row['Tag Ambience'] else []
        occasions = [tag.strip() for tag in row['Tag Occasion'].split(',')] if row['Tag Occasion'] else []
        cuisines = [tag.strip() for tag in row['Tag Cuisine'].split(',')] if row['Tag Cuisine'] else []
        


        coordinates = []
        for url in maps_urls:
            if url:  # Only process non-empty URLs
                coord = extract_lat_lng(url)
                if coord:
                    coordinates.append(coord)
        restaurantFields = {            
            
            'name': row['Name'],
            'instagram': row['Instagram URL'],
            'foodpandaUrl': foodpanda_urls,
            'location': maps_urls,
            'coordinates': coordinates,
            'menuUrl': row['Menu URL'],
            'located': 'TEMPTEMP',
            'contact': contacts,
            'cuisine': cuisines[0],
            'ambience': ambience,
            'occasion': occasions,
            'food': cuisines,
            'rating': row['Rating'],
            'desc': 'some random desc',
            'imageUrl': '',
            'priceRange': '',
            'hasReservations': False,

        }
        
        restaurantFields['hasFoodpanda'] = len(restaurantFields['foodpandaUrl']) > 0 and restaurantFields['foodpandaUrl'][0].strip() != ''
        

        
        def sanitize_name(name):
            # Remove special characters, keep only alphanumeric, spaces, and hyphens
            return re.sub(r'[^a-zA-Z0-9\s\-]', '', name).strip()

        db.collection('restaurants').document(sanitize_name(restaurantFields['name'])).set(restaurantFields)
        print(f"{restaurantFields['name'] ,restaurantFields['coordinates']} added\n")