import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:dish_dash/core/services/theme_service.dart';
import 'package:dish_dash/firebase_options.dart';
import 'package:dish_dash/features/auth/methods/auth_page.dart';
import 'package:dish_dash/features/home/screens/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize Google Sign-In
  await GoogleSignIn.instance.initialize(
    clientId: Platform.isAndroid
        ? '42191251749-50pms8tqght3rlpr7p9hrjgh9con26bs.apps.googleusercontent.com'
        : '42191251749-107640rcurjvm5o2st6pj68plfaanr1h.apps.googleusercontent.com',
    serverClientId:
        '42191251749-t1cg6ohn7siht34pcl694hcg44fvnunj.apps.googleusercontent.com',
  );

  runApp(const ProviderScope(child: DishDashApp()));
}

class DishDashApp extends StatelessWidget {
  const DishDashApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeService.notifier,
      builder: (_, mode, __) {
        return ScreenUtilInit(
          designSize: const Size(390, 844),
          minTextAdapt: true,
          builder: (context, child) {
            return MaterialApp(
              title: 'DishDash',
              debugShowCheckedModeBanner: false,
              theme: ThemeService.lightTheme,
              darkTheme: ThemeService.darkTheme,
              themeMode: mode,
              home: const AuthGate(),
            );
          },
        );
      },
    );
  }
}

/// Handles routing based on Firebase authentication state
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // While checking auth state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // If user is logged in → go to HomeScreen
        if (snapshot.hasData) {
          return const HomeScreen();
        }

        // Otherwise → stay on AuthPage
        return const AuthPage();
      },
    );
  }
}
