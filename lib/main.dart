import 'package:flutter/material.dart';
import 'features/swipe/screens/home_screen.dart';
import 'package:google_fonts/google_fonts.dart';

/// Global notifier that holds the current ThemeMode.
/// You can call ThemeService.toggle() or ThemeService.setDark() / setLight() / setSystem()
/// from anywhere in the app (for example from a settings screen or an AppBar action).
final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.system);

/// Helper service to change theme mode from anywhere.
class ThemeService {
  ThemeService._();

  static ValueNotifier<ThemeMode> get notifier => themeNotifier;

  static ThemeMode get mode => themeNotifier.value;

  static void setLight() => themeNotifier.value = ThemeMode.light;

  static void setDark() => themeNotifier.value = ThemeMode.dark;

  static void setSystem() => themeNotifier.value = ThemeMode.system;

  static void toggle() {
    if (themeNotifier.value == ThemeMode.dark) {
      themeNotifier.value = ThemeMode.light;
    } else {
      themeNotifier.value = ThemeMode.dark;
    }
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData light = ThemeData(
      textTheme: TextTheme(
        displayLarge: GoogleFonts.poppins(fontSize: 42),
        bodyMedium: GoogleFonts.inter(fontSize: 16),
        labelSmall: GoogleFonts.robotoMono(),
      ),
      primarySwatch: Colors.deepOrange,
    );

    final ThemeData dark = ThemeData.dark().copyWith(
      textTheme: TextTheme(
        displayLarge: GoogleFonts.poppins(fontSize: 42, color: Colors.white),
        bodyMedium: GoogleFonts.inter(fontSize: 16, color: Colors.white70),
        labelSmall: GoogleFonts.robotoMono(color: Colors.white70),
      ),
      primaryColor: const Color.fromRGBO(200, 100, 100, 1),
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: Colors.deepOrange,
        brightness: Brightness.dark,
      ),
      scaffoldBackgroundColor: const Color(0xFF121212),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1F1F1F),
        foregroundColor: Colors.white,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xFF1F1F1F),
        selectedItemColor: Color(0xFFF5DAA7),
        unselectedItemColor: Colors.grey,
      ),
    );

    // Wrap MaterialApp in a ValueListenableBuilder so the app rebuilds when themeNotifier changes.
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, ThemeMode mode, _) {
        return MaterialApp(
          title: 'Dish Dash',
          debugShowCheckedModeBanner: false,
          theme: light,
          darkTheme: dark,
          themeMode: mode, // switched dynamically by themeNotifier
          home: const HomeScreen(),
        );
      },
    );
  }
}
