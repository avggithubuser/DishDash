import 'package:flutter/material.dart';

final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.system);

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

  // 👇 New helper method to check if dark theme is active
  static bool isDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  // 👇 Add your color schemes and theme data here
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color.fromARGB(255, 255, 237, 237),
    cardColor: const Color.fromRGBO(200, 100, 100, 1),
    colorScheme: const ColorScheme.light(
      primary: Color.fromRGBO(200, 100, 100, 1),
      secondary: Color(0xFFE57373),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Color(0xFF222222)),
      bodyMedium: TextStyle(color: Color(0xFF444444)),
    ),
    cardTheme: const CardThemeData(
      // color: Color.fromRGBO(200, 100, 100, 1),
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF121212),
    cardColor: const Color.fromRGBO(163, 29, 29, 1), //card color bhaa
    colorScheme: const ColorScheme.dark(
      primary: Color.fromRGBO(163, 29, 29, 1),
      secondary: Color(0xFFB71C1C),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Color(0xFFCCCCCC)),
    ),
    cardTheme: const CardThemeData(
      // color: Color(0xFF1F1F1F),
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
    ),
  );
}
