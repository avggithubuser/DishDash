import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'core/services/theme_service.dart';
import 'package:dish_dash/features/home/screens/home_screen.dart';

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
        return ScreenUtilInit(
          designSize: const Size(390, 844), // your Figma/Sketch design size
          minTextAdapt: true,
          builder: (context, child) {
            return MaterialApp(
              title: 'DishDash',
              debugShowCheckedModeBanner: false,
              theme: ThemeService.lightTheme,
              darkTheme: ThemeService.darkTheme,
              themeMode: mode,
              home: child,
            );
          },
          child: const HomeScreen(), // replace with LoginScreen later if needed
        );
      },
    );
  }
}
