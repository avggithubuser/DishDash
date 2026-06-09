import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore

cred = credentials.Certificate(r"D:\DISHDASH_service_key\serviceAccountKey.json")
firebase_admin.initialize_app(cred)

db = firestore.client()

restaurantFields = {
    'cuisine': '',
    'desc': '',
    'foodpandaUrl': '',
    'imageUrl': '',
    'instagram': '',
    'name': '',
    'priceRange': '',
    'rating': '',
    'ambience': [],
    'food': [],
    'occasion': [],
    'hasFoodpanda': True,
    'hasReservations': True,
}

