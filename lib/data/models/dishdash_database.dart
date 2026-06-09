import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dish_dash/methods/location_shi.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class DishDashDatabase extends ChangeNotifier {
  String? username;
  String? email;
  List<String>? liked;
  List<String>? saved;
  late FirebaseFirestore firestoreInstance;
  late QuerySnapshot<Map<String, dynamic>> allRestaurants; // used elsewhere

  // for swipe shi
  List<Map<String, dynamic>> _swipeRestaurants = [];
  int _currentIndex = 0;
  List<Map<String, dynamic>> get restaurants => _swipeRestaurants;
  int get currentIndex => _currentIndex;

  Position? devPos;

  DishDashDatabase() {
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null) {
        _initUser(user);
      } else {
        clear();
      }
    });
  }

  Future<void> _initUser(User user) async {
    await loadUserData();

    try {
      devPos = await devLocation().getDevLocation();
    } catch (e) {
      print("Location error: $e");
      devPos = null;
    }

    if (allRestaurants.docs.isNotEmpty && devPos != null) {
      setRestaurants(allRestaurants.docs, devPos: devPos!);
    }
  }

  // Call this once after fetching Firestore docs
  void setRestaurants(
    List<QueryDocumentSnapshot> docs, {
    String? matchName,
    List<String>? priceTags,
    Map<String, List<String>>? selectedFilters,
    double? radius,
    required Position devPos,
  }) {
    List<QueryDocumentSnapshot> workingDocs = List.from(docs);

    // --- Shuffle + Rating Sort ---
    workingDocs.shuffle();
    workingDocs.sort((a, b) {
      final aR = double.tryParse((a.data() as Map)['rating'] ?? '0') ?? 0;
      final bR = double.tryParse((b.data() as Map)['rating'] ?? '0') ?? 0;
      return bR.compareTo(aR);
    });

    // Save final list
    _swipeRestaurants = workingDocs
        .map((e) => e.data() as Map<String, dynamic>)
        .toList();
    _currentIndex = 0;
    notifyListeners();
  }

  // remove from list
  void removeRestaurant(String name) {
    _swipeRestaurants.removeWhere((r) => r['name'] == name);
    // reset current index if needed
    if (_currentIndex >= _swipeRestaurants.length) {
      _currentIndex = _swipeRestaurants.isEmpty
          ? 0
          : _swipeRestaurants.length - 1;
    }

    notifyListeners();
  }

  final Set<String> _swipedMain = {}; // persists across tab switches
  // searched list always starts fresh — no need to store

  void markSwipedMain(String name) {
    _swipedMain.add(name);
    notifyListeners();
  }

  Set<String> get swipedMain => _swipedMain;

  // searchRestaurant
  List<Map<String, dynamic>> searchRestaurants({
    String? matchName,
    List<String>? priceTags,
    Map<String, Set<String>>? selectedFilters,
    double? radius,
    required Position devPos,
  }) {
    List<QueryDocumentSnapshot> workingDocs = List.from(allRestaurants.docs);

    // --- Filters ---
    if ((priceTags?.isNotEmpty ?? false) ||
        (selectedFilters?.isNotEmpty ?? false) ||
        (radius != null)) {
      workingDocs = workingDocs.where((doc) {
        final data = doc.data() as Map<String, dynamic>;

        // Price
        if (priceTags != null &&
            priceTags.isNotEmpty &&
            !priceTags.contains(data['priceRange'] ?? '\$'))
          return false;

        // Other filters
        if (selectedFilters != null && selectedFilters.isNotEmpty) {
          for (var entry in selectedFilters.entries) {
            final docValues = data[entry.key];
            if (docValues is! List ||
                !entry.value.any((v) => docValues.contains(v))) {
              return false;
            }
          }
        }

        if ((matchName == null || matchName.isEmpty) && radius != null) {
          double? nearestDistance;

          final coordinates = List<Map<String, dynamic>>.from(
            data['coordinates'] ?? [],
          );
          for (var coord in coordinates) {
            final dist = distanceKm(
              devPos.latitude,
              devPos.longitude,
              coord['lat'],
              coord['lng'],
            );

            if (nearestDistance == null || dist < nearestDistance) {
              nearestDistance = dist;
            }
          }

          if (nearestDistance == null || nearestDistance > radius) {
            return false;
          }
        }

        return true;
      }).toList();
    }

    // --- Shuffle + Rating Sort first ---
    workingDocs.shuffle();
    workingDocs.sort((a, b) {
      final aR = double.tryParse((a.data() as Map)['rating'] ?? '0') ?? 0;
      final bR = double.tryParse((b.data() as Map)['rating'] ?? '0') ?? 0;
      return bR.compareTo(aR);
    });

    // --- Search boost last (guarantees match is on top) ---
    if (matchName != null && matchName.isNotEmpty) {
      final query = matchName.toLowerCase().trim();
      workingDocs.sort((a, b) {
        final aName = ((a.data() as Map)['name'] ?? '')
            .toString()
            .toLowerCase()
            .trim();
        final bName = ((b.data() as Map)['name'] ?? '')
            .toString()
            .toLowerCase()
            .trim();
        final aMatch = aName.contains(query);
        final bMatch = bName.contains(query);
        if (aMatch && !bMatch) return -1;
        if (bMatch && !aMatch) return 1;
        return 0;
      });
    }
    return workingDocs.map((e) => e.data() as Map<String, dynamic>).toList();
  }

  //
  void incrementIndex() {
    _currentIndex++;
    notifyListeners();
  }

  Future<Map<String, dynamic>> userSavedAndLiked() async {
    DocumentSnapshot<Map<String, dynamic>> userDoc = await FirebaseFirestore
        .instance
        .collection('users')
        .doc(email)
        .get();
    return userDoc.data() as Map<String, dynamic>;
  }

  // clear local data
  clear() {
    username = '';
    email = '';
    liked = [];
    saved = [];
    _swipeRestaurants = [];
    _currentIndex = 0;
    notifyListeners();
  }

  // load data from firebase

  loadUserData() async {
    firestoreInstance = FirebaseFirestore.instance;
    email = FirebaseAuth.instance.currentUser?.email;
    DocumentSnapshot<Map<String, dynamic>> userDoc = await firestoreInstance
        .collection('users')
        .doc(email)
        .get();
    Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
    username = userData['username'];

    allRestaurants = await firestoreInstance.collection('restaurants').get();
  }

  // update data to firebase
}
