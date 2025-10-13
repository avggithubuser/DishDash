import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/services/theme_service.dart';
import 'package:dish_dash/features/swipe/screens/home_screen.dart';

void main() {
  runApp(const ProviderScope(child: DishDashApp()));
}

class DishDashApp extends StatelessWidget {
  const DishDashApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeService.notifier,
      builder: (_, mode, __) {
        return MaterialApp(
          title: 'DishDash',
          debugShowCheckedModeBanner: false,
          theme: ThemeService.lightTheme,
          darkTheme: ThemeService.darkTheme,
          themeMode: mode,
          home: const HomeScreen(), //to be replaced w login screen
        );
      },
    );
  }
}
