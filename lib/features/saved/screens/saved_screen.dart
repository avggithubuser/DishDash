import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:dish_dash/core/services/theme_service.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SavedScreen extends StatefulWidget {
  const SavedScreen({super.key});

  @override
  State<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
  String selectedTab = 'Liked'; // Tracks which tab is active

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeService.isDark(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 🔹 Liked Button
            TextButton(
              onPressed: () => setState(() => selectedTab = 'Liked'),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Liked',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: selectedTab == 'Liked'
                          ? Colors.white
                          : Colors.grey,
                    ),
                  ),
                  // Small underline indicator
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    height: 2.h,
                    width: 40.w,
                    color: selectedTab == 'Liked'
                        ? colorScheme.primary
                        : Colors.transparent,
                    margin: EdgeInsets.only(top: 4.h),
                  ),
                ],
              ),
            ),
            SizedBox(width: 12.w),
            // 🔹 Saved Button
            TextButton(
              onPressed: () => setState(() => selectedTab = 'Saved'),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Saved',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: selectedTab == 'Saved'
                          ? colorScheme.primary
                          : Colors.grey,
                    ),
                  ),
                  // Small underline indicator
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    height: 2.h,
                    width: 40.w,
                    color: selectedTab == 'Saved'
                        ? colorScheme.primary
                        : Colors.transparent,
                    margin: EdgeInsets.only(top: 4.h),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      // 🔹 Main body (changes based on selected tab)
      body: Center(
        child: Text(
          selectedTab == 'Liked'
              ? 'Your Liked Restaurants'
              : 'Your Saved Favorites',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: isDark ? Colors.white70 : Colors.black87,
          ),
        ),
      ),
    );
  }
}
