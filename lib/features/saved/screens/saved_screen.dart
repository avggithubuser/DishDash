import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:dish_dash/core/services/theme_service.dart';
// import 'package:cloud_firestore/cloud_firestore.dart'; // 🔹 Firebase logic commented
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:dish_dash/features/saved/widgets/popup_card.dart';

class SavedScreen extends StatefulWidget {
  const SavedScreen({super.key});

  @override
  State<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
  String selectedTab = 'Liked';

  // 🔹 Dummy offline lists (replace with Firebase later)
  final List<Map<String, dynamic>> likedRestaurants = [
    {
      'name': 'Café Noir',
      'rating': 4.6,
      'location': 'Downtown',
      'image':
          'https://images.unsplash.com/photo-1482049016688-2d3e1b311543?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8Zm9vZHxlbnwwfHwwfHx8Mg%3D%3D&auto=format&fit=crop&q=60&w=600',
      'hasFoodpanda': true,
      'foodpandaUrl': 'https://www.foodpanda.com',
      'instagram': 'https://www.instagram.com/cafenoir',
      'hasReservations': true,
    },
    {
      'name': 'Sushi Zen',
      'rating': 4.8,
      'location': 'Uptown',
      'image':
          'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8Zm9vZHxlbnwwfHwwfHx8Mg%3D%3D&auto=format&fit=crop&q=60&w=600',
    },
  ];

  final List<Map<String, dynamic>> savedRestaurants = [
    {
      'name': 'The Green Bowl',
      'rating': 4.3,
      'location': 'Central Park',
      'image': 'https://picsum.photos/202/300',
    },
  ];

  void _showRestaurantPopup(Map<String, dynamic> restaurant) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        final colorScheme = Theme.of(context).colorScheme;
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 40.h),
          child: restaurantPopupCard(context, restaurant, colorScheme),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeService.isDark(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
                          ? colorScheme.primary
                          : Colors.grey,
                    ),
                  ),
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
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: FutureBuilder(
          future: Future.value(true),
          builder: (context, snapshot) {
            final restaurants = selectedTab == 'Liked'
                ? likedRestaurants
                : savedRestaurants;

            if (restaurants.isEmpty) {
              return Center(
                child: Text(
                  'No ${selectedTab.toLowerCase()} restaurants yet.',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: isDark ? Colors.white70 : Colors.black54,
                  ),
                ),
              );
            }

            return ListView.builder(
              itemCount: restaurants.length,
              itemBuilder: (context, index) {
                final restaurant = restaurants[index];

                return GestureDetector(
                  onTap: () => _showRestaurantPopup(restaurant),
                  child: Card(
                    color: const Color.fromRGBO(230, 216, 195, 1),
                    margin: EdgeInsets.only(bottom: 12.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: SizedBox(
                      height: 120.h,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(16.r),
                              bottomLeft: Radius.circular(16.r),
                            ),
                            child: Image.network(
                              restaurant['image'],
                              width: 100.w,
                              height: 120.h,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.all(12.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    restaurant['name'],
                                    style: GoogleFonts.montserrat(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold,
                                      color: colorScheme.primary,
                                    ),
                                  ),
                                  SizedBox(height: 4.h),
                                  RatingBarIndicator(
                                    rating: restaurant['rating'],
                                    itemBuilder: (context, _) => const Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    ),
                                    itemSize: 20.sp,
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    restaurant['location'],
                                    style: GoogleFonts.lora(
                                      fontSize: 12.sp,
                                      color: colorScheme.primary,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
