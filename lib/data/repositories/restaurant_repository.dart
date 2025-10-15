import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dish_dash/data/models/restaurant_model.dart';

class RestaurantRepository {
  final FirebaseFirestore _firestore;

  RestaurantRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference get _restaurantsList =>
      _firestore.collection('restaurants');

  /// All restaurants stream (live)
  Stream<List<Restaurant>> getRestaurants() {
    return _restaurantsList.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Restaurant.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  /// get by ID
  Future<Restaurant?> getRestaurantById(String id) async {
    final doc = await _restaurantsList.doc(id).get();
    if (!doc.exists) return null;
    return Restaurant.fromMap(doc.data() as Map<String, dynamic>, doc.id);
  }

  /// Add new resto
  Future<void> addRestaurant(Restaurant restaurant) async {
    await _restaurantsList.add(restaurant.toMap());
  }

  /// update resto
  Future<void> updateRestaurant(Restaurant restaurant) async {
    await _restaurantsList.doc(restaurant.id).update(restaurant.toMap());
  }

  /// remove resto (byebye)
  Future<void> deleteRestaurant(String id) async {
    await _restaurantsList.doc(id).delete();
  }
}
