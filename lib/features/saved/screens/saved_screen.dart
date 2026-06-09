import 'dart:ui';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dish_dash/data/models/dishdash_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:dish_dash/core/services/theme_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dish_dash/features/saved/widgets/popup_card.dart';
import 'package:provider/provider.dart';

class SavedScreen extends StatefulWidget {
  const SavedScreen({super.key});

  @override
  State<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
  String selectedTab = 'Liked';
  Map<String, dynamic> userRestaurants = {'liked': [], 'saved': []};

  // 🔹 Dummy offline lists (replace with Firebase later)
  List<Map<String, dynamic>> likedRestaurants = [];
  List<Map<String, dynamic>> savedRestaurants = [];

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

    return Consumer<DishDashDatabase>(
      builder: (context, value, child) => Scaffold(
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
                    AutoSizeText(
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
                    AutoSizeText(
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
            future: value.userSavedAndLiked(),
            builder: (context, snapshot) {
              //
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData) {
                return Center(
                  child: AutoSizeText("UNABLE TO FETCH RESTAURANTS"),
                );
              } else {
                Map<String, dynamic> data =
                    snapshot.data as Map<String, dynamic>;
                List likedNames = data['liked'];
                List savedNames = data['saved'];
                //

                QuerySnapshot<Map<String, dynamic>> allRestaurants =
                    value.allRestaurants;
                //
                likedRestaurants.clear();
                savedRestaurants.clear();
                //
                allRestaurants.docs.forEach((restaurant) {
                  Map<String, dynamic> resData = restaurant.data();
                  if (likedNames.contains(resData['name'])) {
                    likedRestaurants.add(resData);
                  }
                  if (savedNames.contains(resData['name'])) {
                    savedRestaurants.add(resData);
                  }
                });

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
                                  restaurant['imageUrl'],
                                  width: 100.w,
                                  height: 120.h,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.all(12.w),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                        rating:
                                            double.tryParse(
                                              restaurant['rating'],
                                            ) ??
                                            0.0,
                                        itemBuilder: (context, _) => const Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                        ),
                                        itemSize: 20.sp,
                                      ),
                                      SizedBox(height: 4.h),
                                      Text(
                                        restaurant['located'],
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
              }
            },
          ),
        ),
      ),
    );
  }
}
