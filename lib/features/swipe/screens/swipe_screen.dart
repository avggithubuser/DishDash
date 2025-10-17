import 'dart:ui';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:swipe_cards/swipe_cards.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:dish_dash/core/services/theme_service.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SwipeScreen extends StatefulWidget {
  const SwipeScreen({super.key});

  @override
  State<SwipeScreen> createState() => _SwipeScreenState();
}

class _SwipeScreenState extends State<SwipeScreen> {
  late MatchEngine _matchEngine;
  final List<SwipeItem> _swipeItems = [];
  final List<Map<String, dynamic>> _resData = [];

  @override
  Widget build(BuildContext context) {
    // final isDark = ThemeService.isDark(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 16.h),

          // Top swipe icons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(Icons.close, color: Colors.amberAccent, size: 24.sp),
              SizedBox(width: 25.w),
              Icon(Icons.bookmark, color: Colors.blueAccent, size: 24.sp),
              SizedBox(width: 25.w),
              Icon(Icons.favorite, color: Colors.redAccent, size: 24.sp),
            ],
          ),

          SizedBox(height: 20.h),

          // 🔹 Stream from Firestore
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('restaurants')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Expanded(
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              if (snapshot.hasError) {
                return Expanded(
                  child: Center(
                    child: Text(
                      'Error: ${snapshot.error}',
                      style: const TextStyle(color: Colors.redAccent),
                    ),
                  ),
                );
              }

              final docs = snapshot.data?.docs ?? [];
              if (docs.isEmpty) {
                return const Expanded(
                  child: Center(
                    child: Text(
                      "No restaurants available.",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                );
              }

              // Populate swipe items from Firestore
              _swipeItems.clear();
              _resData.clear();

              for (var doc in docs) {
                final data = doc.data() as Map<String, dynamic>;
                _resData.add(data);

                _swipeItems.add(
                  SwipeItem(
                    content: AutoSizeText(data['name'] ?? "Restaurant"),
                    likeAction: () => debugPrint("Liked ${data['name']}"),
                    nopeAction: () => debugPrint("Nope ${data['name']}"),
                    superlikeAction: () =>
                        debugPrint("Superliked ${data['name']}"),
                  ),
                );
              }

              _matchEngine = MatchEngine(swipeItems: _swipeItems);

              return Expanded(
                child: Center(
                  child: SwipeCards(
                    matchEngine: _matchEngine,
                    onStackFinished: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("No more restaurants!")),
                      );
                    },
                    itemBuilder: (context, index) {
                      final data = _resData[index];
                      return Center(
                        child: SizedBox(
                          width: 320.w,
                          height: 540.h,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.transparent,
                              boxShadow: [
                                BoxShadow(
                                  color: colorScheme.secondary.withOpacity(0.8),
                                  blurRadius: 20,
                                  spreadRadius: 3,
                                  offset: const Offset(-6, 0),
                                ),
                                BoxShadow(
                                  color: colorScheme.primary.withOpacity(0.8),
                                  blurRadius: 20,
                                  spreadRadius: 3,
                                  offset: const Offset(6, 0),
                                ),
                              ],
                              gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  colorScheme.secondary.withOpacity(0.4),
                                  colorScheme.primary.withOpacity(0.4),
                                ],
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(
                                  sigmaX: 15,
                                  sigmaY: 15,
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.white.withOpacity(0.35),
                                    border: Border.all(
                                      color: Colors.grey.shade300.withOpacity(
                                        0.5,
                                      ),
                                      width: 1.2.w,
                                    ),
                                  ),
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // 🔹 Image
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(16),
                                        child: data['imageUrl'] != null
                                            ? Image.network(
                                                data['imageUrl'],
                                                width: double.infinity,
                                                height: 200.h,
                                                fit: BoxFit.cover,
                                              )
                                            : Container(
                                                height: 200.h,
                                                width: double.infinity,
                                                color: Colors.grey.shade400,
                                                child: const Center(
                                                  child: Icon(
                                                    Icons.image_not_supported,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                      ),
                                      SizedBox(height: 16.h),

                                      // 🔹 Name
                                      AutoSizeText(
                                        data['name'] ?? "Unknown",
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(
                                            context,
                                          ).textTheme.bodyLarge?.color,
                                        ),
                                      ),

                                      SizedBox(height: 8.h),

                                      // 🔹 Rating
                                      RatingBarIndicator(
                                        rating:
                                            double.tryParse(
                                              data['rating']?.toString() ?? "0",
                                            ) ??
                                            0.0,
                                        itemBuilder: (context, _) => const Icon(
                                          Icons.star,
                                          color: Colors.yellow,
                                        ),
                                        itemCount: 5,
                                        itemSize: 28,
                                      ),

                                      SizedBox(height: 8.h),

                                      // 🔹 Price Range
                                      AutoSizeText(
                                        "Range: ${data['priceRange'] ?? "—"}",
                                        style: TextStyle(
                                          color: Theme.of(
                                            context,
                                          ).textTheme.bodyMedium?.color,
                                          fontSize: 15,
                                        ),
                                      ),

                                      SizedBox(height: 8.h),

                                      // 🔹 Tags
                                      if (data['tags'] != null)
                                        Wrap(
                                          spacing: 8,
                                          children: (data['tags'] as List)
                                              .map(
                                                (tag) => Chip(
                                                  label: Text(tag.toString()),
                                                  backgroundColor: colorScheme
                                                      .primary
                                                      .withOpacity(0.25),
                                                ),
                                              )
                                              .toList(),
                                        ),

                                      SizedBox(height: 8.h),

                                      // 🔹 Description
                                      AutoSizeText(
                                        data['desc'] ?? "No description.",
                                        maxLines: 3,
                                        minFontSize: 1,
                                        style: TextStyle(
                                          color: Theme.of(
                                            context,
                                          ).textTheme.bodyMedium?.color,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    itemChanged: (item, index) =>
                        debugPrint("Card changed: $index"),
                    upSwipeAllowed: true,
                    fillSpace: false,
                  ),
                ),
              );
            },
          ),

          SizedBox(height: 100.h),
        ],
      ),
    );
  }
}
