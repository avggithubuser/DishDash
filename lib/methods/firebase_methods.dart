import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dish_dash/data/models/dishdash_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyMethods {
  // liked
  likeRestaurant(BuildContext context, String restaurantName) async {
    try {
      String? email = FirebaseAuth.instance.currentUser!.email;
      await FirebaseFirestore.instance.collection("users").doc(email).update({
        "liked": FieldValue.arrayUnion([restaurantName]),
      });

      // Optional: remove from local list immediately
      final db = Provider.of<DishDashDatabase>(context, listen: false);
      // db.removeRestaurant(restaurantName);
    } catch (e) {
      print(e.toString());
    }
  }

  // reject (left swipe)
  leftSwipe(BuildContext context, String restaurantName) async {
    try {
      String? email = FirebaseAuth.instance.currentUser!.email;
      await FirebaseFirestore.instance.collection("users").doc(email).update({
        "rejected": FieldValue.arrayUnion([restaurantName]),
      });

      // Remove restaurant from local list
      final db = Provider.of<DishDashDatabase>(context, listen: false);
      // db.removeRestaurant(restaurantName);
    } catch (e) {
      print(e.toString());
    }
  }

  // saved (superlike)
  saveRestaurant(BuildContext context, String restaurantName) async {
    try {
      String? email = FirebaseAuth.instance.currentUser!.email;
      await FirebaseFirestore.instance.collection("users").doc(email).update({
        "saved": FieldValue.arrayUnion([restaurantName]),
      });

      // Optional: remove from local list immediately
      final db = Provider.of<DishDashDatabase>(context, listen: false);
      // db.removeRestaurant(restaurantName);
    } catch (e) {
      print(e.toString());
    }
  }
}
