import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dish_dash/features/auth/methods/auth_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Authentication {
  // login user
  Future<void> emailLogin(
    String email,
    String password,
    BuildContext context,
  ) async {
    showDialog(
      context: context,
      builder: (context) => Center(child: CircularProgressIndicator()),
    );

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      Navigator.of(context).pop();
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => AuthPage()),
        (Route<dynamic> route) => false,
      );
    } catch (e) {
      Navigator.of(context).pop();

      showDialog(
        context: context,
        builder: (context) =>
            Center(child: AlertDialog(title: AutoSizeText(e.toString()))),
      );
    }
  }

  // create user
  Future<void> emailSignUp(
    String username,
    String email,
    String password,
    String confirmPw,
    BuildContext context,
  ) async {
    showDialog(
      context: context,
      builder: (context) => Center(child: CircularProgressIndicator()),
    );
    try {
      if (password != confirmPw) {
        Navigator.of(context).pop();
        showDialog(
          context: context,
          builder: (context) => Center(
            child: AlertDialog(title: AutoSizeText("Passwords don't match")),
          ),
        );
      } else {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        await FirebaseFirestore.instance.collection("users").doc(email).set({
          "username": username,
          "email": email,
          "favourites": [],
          "rightSwipes": [],
          "leftSwipes": [],
          "reservationsHistory": [],
          "currentReservations": [],
        });
        Navigator.of(context).pop();
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => AuthPage()),
          (Route<dynamic> route) => false,
        );
      }
    } catch (e) {
      Navigator.of(context).pop();
      print(e.toString());
      showDialog(
        context: context,
        builder: (context) =>
            Center(child: AlertDialog(title: AutoSizeText(e.toString()))),
      );
    }
  }

  // google and facebook
  Future<void> otherSignIn(String name, BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => Center(child: CircularProgressIndicator()),
    );

    try {
      if (name == "Google") {
        final GoogleSignInAccount? user = await GoogleSignIn.instance
            .authenticate(scopeHint: ['email']);

        if (user == null) {
          Navigator.of(context).pop();
        } else {
          //
          final authClient = user.authorizationClient;
          final GoogleSignInClientAuthorization? authorization =
              await authClient.authorizationForScopes(['email']);
          final accessToken = authorization?.accessToken;
          //
          // Obtain the auth details from the Google account
          final GoogleSignInAuthentication googleAuth = user.authentication;
          // Create a new credential for Firebase
          final credential = GoogleAuthProvider.credential(
            idToken: googleAuth.idToken,
            accessToken: accessToken,
          );

          // Sign in to Firebase with the Google credential
          await FirebaseAuth.instance.signInWithCredential(credential);
          Navigator.of(context).pop();

          // Check if user exists in Firestore
          final userDoc = await FirebaseFirestore.instance
              .collection("users")
              .doc(user.email)
              .get();

          if (!userDoc.exists) {
            // Add new user if doesn't exist
            await FirebaseFirestore.instance
                .collection("users")
                .doc(user.email)
                .set({
                  "username": user.displayName,
                  "email": user.email,
                  "favourites": [],
                  "rightSwipes": [],
                  "leftSwipes": [],
                  "reservationsHistory": [],
                  "currentReservations": [],
                });
          }
        }
      }
      if (name == "Facebook") {
        final LoginResult result = await FacebookAuth.instance.login();
        if (result.status == LoginStatus.success) {
          final AccessToken accessToken = result.accessToken!;
          final OAuthCredential credential = FacebookAuthProvider.credential(
            accessToken.tokenString,
          );
          await FirebaseAuth.instance.signInWithCredential(credential);

          // pop loading
          Navigator.of(context).pop();

          final userData = await FacebookAuth.instance.getUserData();
          // Check if user exists in Firestore
          final userDoc = await FirebaseFirestore.instance
              .collection("users")
              .doc(userData['email'])
              .get();

          if (!userDoc.exists) {
            // Add new user if doesn't exist
            await FirebaseFirestore.instance
                .collection("users")
                .doc(userData['email'])
                .set({
                  "username": userData['name'],
                  "email": userData['email'],
                  "favourites": [],
                  "rightSwipes": [],
                  "leftSwipes": [],
                  "reservationsHistory": [],
                  "currentReservations": [],
                });
          }
        }
      }
    } catch (e) {
      Navigator.of(context).pop();
      print(e.toString());
      showDialog(
        context: context,
        builder: (context) =>
            Center(child: AlertDialog(title: AutoSizeText(e.toString()))),
      );
    }
  }
}
