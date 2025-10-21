import 'package:dish_dash/features/auth/screens/sign_in_screen.dart';
import 'package:dish_dash/features/home/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // user logged in
          if (snapshot.hasData) {
            return HomeScreen();
          }
          // not logged in
          else {
            return const LoginScreen();
          }
        },
      ),
    );
  }
}
