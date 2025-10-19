import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.system);

class ThemeService {
  ThemeService._();

  static ValueNotifier<ThemeMode> get notifier => themeNotifier;
  static ThemeMode get mode => themeNotifier.value;

  static void setLight() => themeNotifier.value = ThemeMode.light;
  static void setDark() => themeNotifier.value = ThemeMode.dark;
  static void setSystem() => themeNotifier.value = ThemeMode.system;

  static void toggle() {
    themeNotifier.value = themeNotifier.value == ThemeMode.dark
        ? ThemeMode.light
        : ThemeMode.dark;
  }

  static bool isDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  // LIGHT
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color.fromARGB(255, 218, 204, 204),
    cardColor: const Color.fromRGBO(200, 100, 100, 1),
    colorScheme: const ColorScheme.light(
      primary: Color.fromRGBO(200, 100, 100, 1),
      secondary: Color(0xFFE57373),
    ),
    textTheme: TextTheme(
      titleLarge: GoogleFonts.fraunces(
        fontSize: 46.sp,
        fontWeight: FontWeight.bold,
        color: Color.fromRGBO(200, 100, 100, 1),
      ),
      displayLarge: GoogleFonts.fraunces(
        fontSize: 30.sp,
        fontWeight: FontWeight.bold,
        color: Color.fromRGBO(246, 239, 210, 1),
      ),
      titleMedium: GoogleFonts.fraunces(
        fontSize: 22.sp,
        fontWeight: FontWeight.w600,
        color: Color.fromRGBO(246, 239, 210, 1),
      ),
      bodyLarge: GoogleFonts.inter(
        fontSize: 18.sp,
        fontWeight: FontWeight.w500,
        color: Color.fromRGBO(246, 239, 210, 1),
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 12.sp,
        fontWeight: FontWeight.w400,
        color: Colors.white,
      ),
    ),
    cardTheme: const CardThemeData(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
    ),
  );

  //   // DARK
  //   static final ThemeData darkTheme = ThemeData(
  //     brightness: Brightness.dark,
  //     scaffoldBackgroundColor: const Color.fromARGB(255, 34, 34, 34),
  //     cardColor: const Color.fromRGBO(84, 18, 18, 1),
  //     colorScheme: const ColorScheme.dark(
  //       primary: Color.fromRGBO(84, 18, 18, 1),
  //       secondary: Color.fromRGBO(84, 18, 18, 1),
  //     ),
  //     textTheme: TextTheme(
  //       displayLarge: GoogleFonts.fraunces(
  //         fontSize: 30.sp,
  //         fontWeight: FontWeight.bold,
  //         color: Colors.white,
  //       ),
  //       titleMedium: GoogleFonts.fraunces(
  //         fontSize: 22.sp,
  //         fontWeight: FontWeight.w600,
  //         color: Colors.white,
  //       ),
  //       bodyLarge: GoogleFonts.inter(
  //         fontSize: 18.sp,
  //         fontWeight: FontWeight.w500,
  //         color: Colors.white,
  //       ),
  //       bodyMedium: GoogleFonts.inter(
  //         fontSize: 16.sp,
  //         fontWeight: FontWeight.w400,
  //         color: Color(0xFFCCCCCC),
  //       ),
  //     ),
  //     cardTheme: const CardThemeData(
  //       elevation: 8,
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.all(Radius.circular(20)),
  //       ),
  //     ),
  //   );
}
