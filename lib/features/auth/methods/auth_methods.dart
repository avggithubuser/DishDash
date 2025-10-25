import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_functions/cloud_functions.dart';
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
      print(e.toString());

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: AutoSizeText(e.toString())));
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: AutoSizeText("Passwords don't match")),
        );
      } else {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        // final uid = FirebaseAuth.instance.currentUser!.uid;

        // Call the Firebase callable function
        final functions = FirebaseFunctions.instance;

        final result = await functions
            .httpsCallable('createUserIfNotExists')
            .call(<String, dynamic>{'username': username, 'email': email});

        print(result.data['message']);
        // String? uid = FirebaseAuth.instance.currentUser!.uid;
        // await FirebaseFirestore.instance.collection("users").doc(uid).set({
        //   "username": username,
        //   "email": email,
        //   "favourites": [],
        //   "rightSwipes": [],
        //   "leftSwipes": [],
        //   "reservationsHistory": [],
        //   "currentReservations": [],
        // });
        Navigator.of(context).pop();
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => AuthPage()),
          (Route<dynamic> route) => false,
        );
      }
    } catch (e) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: AutoSizeText(e.toString())));
    }
  }

  // google and facebook

  ///// old function
  // Future<void> otherSignIn(String name, BuildContext context) async {
  //   showDialog(
  //     context: context,
  //     builder: (context) => Center(child: CircularProgressIndicator()),
  //   );
  //   try {
  //     if (name == "Google") {
  //       final GoogleSignInAccount? user = await GoogleSignIn.instance
  //           .authenticate(scopeHint: ['email']);
  //       if (user == null) {
  //         Navigator.of(context).pop();
  //       } else {
  //         //
  //         final authClient = user.authorizationClient;
  //         final GoogleSignInClientAuthorization? authorization =
  //             await authClient.authorizationForScopes(['email']);
  //         final accessToken = authorization?.accessToken;
  //         //
  //         // Obtain the auth details from the Google account
  //         final GoogleSignInAuthentication googleAuth =
  //             await user.authentication;
  //         // Create a new credential for Firebase
  //         final credential = GoogleAuthProvider.credential(
  //           idToken: googleAuth.idToken,
  //           accessToken: accessToken,
  //         );
  //         // Sign in to Firebase with the Google credential
  //         await FirebaseAuth.instance.signInWithCredential(credential);
  //         Navigator.of(context).pop();
  //         String? uid = FirebaseAuth.instance.currentUser!.uid;
  //         // Check if user exists in Firestore
  //         final userDoc = await FirebaseFirestore.instance
  //             .collection("users")
  //             .doc(uid)
  //             .get();
  //         if (!userDoc.exists) {
  //           // Add new user if doesn't exist
  //           await FirebaseFirestore.instance.collection("users").doc(uid).set({
  //             "username": user.displayName,
  //             "email": user.email,
  //             "favourites": [],
  //             "rightSwipes": [],
  //             "leftSwipes": [],
  //             "reservationsHistory": [],
  //             "currentReservations": [],
  //           });
  //         }
  //       }
  //     }
  //     if (name == "Facebook") {
  //       final LoginResult result = await FacebookAuth.instance.login();
  //       if (result.status == LoginStatus.success) {
  //         final AccessToken accessToken = result.accessToken!;
  //         final OAuthCredential credential = FacebookAuthProvider.credential(
  //           accessToken.tokenString,
  //         );
  //         await FirebaseAuth.instance.signInWithCredential(credential);
  //         // pop loading
  //         Navigator.of(context).pop();
  //         String? uid = FirebaseAuth.instance.currentUser!.uid;
  //         final userData = await FacebookAuth.instance.getUserData();
  //         // Check if user exists in Firestore
  //         final userDoc = await FirebaseFirestore.instance
  //             .collection("users")
  //             .doc(uid)
  //             .get();
  //         if (!userDoc.exists) {
  //           // Add new user if doesn't exist
  //           await FirebaseFirestore.instance.collection("users").doc(uid).set({
  //             "username": userData['name'],
  //             "email": userData['email'],
  //             "favourites": [],
  //             "rightSwipes": [],
  //             "leftSwipes": [],
  //             "reservationsHistory": [],
  //             "currentReservations": [],
  //           });
  //         }
  //       }
  //     }
  //   } catch (e) {
  //     Navigator.of(context).pop();
  //     print(e.toString());
  //     showDialog(
  //       context: context,
  //       builder: (context) => AlertDialog(content: AutoSizeText(e.toString())),
  //     );
  //   }
  // }

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
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: AutoSizeText("Google sign-in cancelled.")),
          );
        } else {
          final authClient = user.authorizationClient;
          final GoogleSignInClientAuthorization? authorization =
              await authClient.authorizationForScopes(['email']);
          final accessToken = authorization?.accessToken;

          final GoogleSignInAuthentication googleAuth =
              await user.authentication;

          final credential = GoogleAuthProvider.credential(
            idToken: googleAuth.idToken,
            accessToken: accessToken,
          );

          await FirebaseAuth.instance.signInWithCredential(credential);

          Navigator.of(context).pop();

          // final uid = FirebaseAuth.instance.currentUser!.uid;

          // Call the Firebase callable function
          final functions = FirebaseFunctions.instance;

          final result = await functions
              .httpsCallable('createUserIfNotExists')
              .call(<String, dynamic>{
                'username': user.displayName,
                'email': user.email,
              });

          print(result.data['message']);
        }
      }

      // Facebook sign-in part
      if (name == "Facebook") {
        final LoginResult result = await FacebookAuth.instance.login();
        if (result.status == LoginStatus.success) {
          final AccessToken accessToken = result.accessToken!;
          final OAuthCredential credential = FacebookAuthProvider.credential(
            accessToken.tokenString,
          );
          await FirebaseAuth.instance.signInWithCredential(credential);

          Navigator.of(context).pop();

          // final uid = FirebaseAuth.instance.currentUser!.uid;
          final userData = await FacebookAuth.instance.getUserData();

          // Call the Firebase callable function for Facebook user
          final functions = FirebaseFunctions.instance;

          final resultCallable = await functions
              .httpsCallable('createUserIfNotExists')
              .call(<String, dynamic>{
                'username': userData['name'],
                'email': userData['email'],
              });

          print(resultCallable.data['message']);
        }
      }
    } catch (e) {
      Navigator.of(context).pop();
      print(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: AutoSizeText("Google sign-in failed: $e")),
      );
      showDialog(
        context: context,
        builder: (context) => AlertDialog(content: Text(e.toString())),
      );
    }
  }
}
