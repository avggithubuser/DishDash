import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyMethods {
  // right swipes
  rightSwipe(String restaurantName) async {
    try {
      String? userID = await FirebaseAuth.instance.currentUser!.uid;
      await FirebaseFirestore.instance.collection("users").doc(userID).update({
        "rightSwipes": FieldValue.arrayUnion([restaurantName]),
      });
    } catch (e) {
      print(e.toString());
    }
  }

  // left swipes
  leftSwipe(String restaurantName) async {
    try {
      String? userID = await FirebaseAuth.instance.currentUser!.uid;
      await FirebaseFirestore.instance.collection("users").doc(userID).update({
        "leftSwipes": FieldValue.arrayUnion([restaurantName]),
      });
    } catch (e) {
      print(e.toString());
    }
  }

  // super Likes omg
  favourites(String restaurantName) async {
    try {
      String? userID = await FirebaseAuth.instance.currentUser!.uid;
      await FirebaseFirestore.instance.collection("users").doc(userID).update({
        "favourites": FieldValue.arrayUnion([restaurantName]),
      });
    } catch (e) {
      print(e.toString());
    }
  }
}
