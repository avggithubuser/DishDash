import 'dart:ui';
import 'package:auto_size_text/auto_size_text.dart';
// 🔸 COMMENTED OUT FOR OFFLINE MODE
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dish_dash/methods/firebase_methods.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:swipe_cards/swipe_cards.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:dish_dash/core/widgets/icon_button.dart';
import 'package:dish_dash/core/widgets/text_button.dart';

class SwipeScreen extends StatefulWidget {
  final String? matchName;
  final Map<String, Set<String>>? selectedFilters;
  final List<String>? priceTags;

  const SwipeScreen({
    super.key,
    this.matchName,
    this.priceTags,
    this.selectedFilters,
  });

  @override
  State<SwipeScreen> createState() => _SwipeScreenState();
}

class _SwipeScreenState extends State<SwipeScreen> {
  late MatchEngine _matchEngine;
  final List<SwipeItem> _swipeItems = [];
  final List<Map<String, dynamic>> _resData = [];

  // 🔹 Mock offline restaurant data
  final List<Map<String, dynamic>> _mockRestaurants = [
    {
      "name": "Mock Bistro",
      "rating": 4.6,
      "priceRange": "\$\$",
      "food": ["Italian", "Pasta"],
      "desc": "A cozy Italian bistro offering handmade pasta and wine.",
      "imageUrl":
          "https://images.unsplash.com/photo-1555939594-58d7cb561ad1?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NHx8Zm9vZHxlbnwwfHwwfHx8Mg%3D%3D&auto=format&fit=crop&q=60&w=600",
      "instagram": "https://instagram.com/mockbistro",
      "hasFoodpanda": true,
      "foodpandaUrl": "https://www.foodpanda.com/",
      "hasReservations": true,
    },
    {
      "name": "The Burger Hub",
      "rating": 4.2,
      "priceRange": "\$",
      "food": ["Burgers", "Fast Food"],
      "desc": "Juicy handcrafted burgers with fresh ingredients.",
      "imageUrl":
          "https://images.unsplash.com/photo-1550547660-d9450f859349?w=800",
      "instagram": "",
      "hasFoodpanda": false,
      "hasReservations": false,
    },
    {
      "name": "Sushi Zen",
      "rating": 4.9,
      "priceRange": "\$\$\$",
      "food": ["Japanese", "Sushi"],
      "desc": "Elegant sushi experience with premium ingredients.",
      "imageUrl":
          "https://images.unsplash.com/photo-1579584425555-c3ce17fd4351?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&q=80&w=627",
      "instagram": "https://instagram.com/sushizen",
      "hasFoodpanda": true,
      "foodpandaUrl": "https://www.foodpanda.com/",
      "hasReservations": true,
    },
  ];

  @override
  void initState() {
    super.initState();
    // 🔸 COMMENTED OUT FOR OFFLINE MODE
    // _testFirestoreConnection();

    _initSwipeItemsOffline();
  }

  // 🔹 Offline initialization using mock data
  void _initSwipeItemsOffline() {
    _swipeItems.clear();
    _resData.clear();

    for (var data in _mockRestaurants) {
      _resData.add(data);
      _swipeItems.add(
        SwipeItem(
          content: AutoSizeText(data['name']),
          likeAction: () => print("Right swipe (offline): ${data['name']}"),
          nopeAction: () => print("Left swipe (offline): ${data['name']}"),
          superlikeAction: () => print("Favourite (offline): ${data['name']}"),
        ),
      );
    }

    setState(() {
      _matchEngine = MatchEngine(swipeItems: _swipeItems);
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(Icons.close, color: Colors.green, size: 30.sp),
              SizedBox(width: 25.w),
              Icon(Icons.bookmark, color: Colors.blueAccent, size: 30.sp),
              SizedBox(width: 25.w),
              Icon(Icons.favorite, color: Colors.redAccent, size: 30.sp),
            ],
          ),
          // 🔹 Offline SwipeCards
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 20.h),
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
                    return _buildSwipeCard(context, colorScheme, data);
                  },
                  itemChanged: (item, index) =>
                      debugPrint("Card changed: $index"),
                  upSwipeAllowed: true,
                  fillSpace: false,
                ),
              ),
            ),
          ),
          SizedBox(height: 100.h),
        ],
      ),
    );
  }

  Widget _buildSwipeCard(
    BuildContext context,
    ColorScheme colorScheme,
    Map<String, dynamic> data,
  ) {
    return Center(
      child: SizedBox(
        width: 320.w,
        height: 540.h,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: colorScheme.primary, width: 1.w),
            color: Colors.transparent,
            boxShadow: [
              BoxShadow(
                color: colorScheme.secondary.withOpacity(0.6),
                blurRadius: 20,
                spreadRadius: 3,
                offset: const Offset(-1, 0),
              ),
              BoxShadow(
                color: colorScheme.primary.withOpacity(0.6),
                blurRadius: 20,
                spreadRadius: 3,
                offset: const Offset(1, 0),
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
              filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.w),
                  color: Colors.white.withOpacity(0.35),
                  border: Border.all(
                    color: Colors.grey.shade300.withOpacity(0.5),
                    width: 1.2.w,
                  ),
                ),
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16.w),
                      child: data['imageUrl'] != null
                          ? Image.network(
                              data['imageUrl'],
                              width: double.infinity,
                              height: 250.h,
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
                    Row(
                      children: [
                        AutoSizeText(
                          data['name'] ?? "Unknown",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 5.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          if (data['hasFoodpanda'] == true)
                            IconNeonButton(
                              bgcolor: Colors.white,
                              icon: SizedBox(
                                height: 20.h,
                                child: Image.asset("assets/foodpanda.png"),
                              ),
                              onPressed: () async {
                                final url = data['foodpandaUrl'] ?? '';
                                if (url.isNotEmpty) {
                                  debugPrint("Opening Foodpanda: $url");
                                  await launchUrl(Uri.parse(url));
                                }
                              },
                            ),
                          SizedBox(width: 5.w),
                          if (data['instagram'] != null &&
                              data['instagram'].toString().isNotEmpty)
                            IconNeonButton(
                              bgcolor: Colors.white,
                              // height: 28.h,
                              onPressed: () async {
                                final url = data['instagram'];
                                if (url != null && url.toString().isNotEmpty) {
                                  debugPrint("Opening Instagram: $url");
                                  await launchUrl(Uri.parse(url));
                                }
                              },
                              icon: FaIcon(
                                FontAwesomeIcons.instagram,
                                color: Colors.white,
                              ),
                              // color: Colors.pink,
                            ),
                          SizedBox(width: 5.w),
                          if (data['hasReservations'] == true)
                            IconNeonButton(
                              bgcolor: Colors.white,
                              // iconSize: 28.h,
                              icon: Icon(
                                Icons.calendar_month,
                                color: Colors.white,
                              ),
                              // color: Colors.white,
                              onPressed: () {
                                debugPrint(
                                  "Reservation tapped for ${data['name']}",
                                );
                              },
                            ),
                          SizedBox(width: 5.w),
                          NeonButton(
                            text: "menu",
                            color: Colors.white,
                            horizontalPadding: 12,
                            verticalPadding: 8,
                            onPressed: () {
                              // handle menu tap
                            },
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        RatingBarIndicator(
                          rating:
                              double.tryParse(
                                data['rating']?.toString() ?? "0",
                              ) ??
                              0.0,
                          itemBuilder: (context, _) =>
                              const Icon(Icons.star, color: Colors.yellow),
                          itemCount: 5,
                          itemSize: 24.w,
                        ),
                        SizedBox(width: 4.w),
                        AutoSizeText(
                          "(${data['rating'] ?? "—"})",
                          style: TextStyle(
                            color: Theme.of(
                              context,
                            ).textTheme.bodyMedium?.color,
                            fontWeight: FontWeight.bold,
                            fontSize: 10.sp,
                          ),
                        ),
                        SizedBox(width: 4.w),
                        AutoSizeText(
                          "${data['priceRange'] ?? "—"}",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14.sp,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    // 🔹 Food tags with different colors
                    if (data['food'] != null)
                      Wrap(
                        spacing: 8,
                        children: (data['food'] as List).asMap().entries.map((
                          entry,
                        ) {
                          final index = entry.key;
                          final tag = entry.value;

                          // Neon + neutral palette
                          final chipColors = [
                            Colors.pinkAccent,
                            Colors.cyanAccent,
                            Colors.limeAccent,
                            Colors.deepPurpleAccent,
                            Colors.orangeAccent,
                            Colors.tealAccent,
                            Colors.amberAccent,
                            Colors.grey.shade400,
                            Colors.brown.shade300,
                          ];

                          final color = chipColors[index % chipColors.length];

                          return Chip(
                            labelPadding: EdgeInsets.symmetric(
                              horizontal: 0.w,
                              vertical: 0.h,
                            ),
                            label: Text(
                              tag.toString(),
                              style: GoogleFonts.montserrat(
                                fontSize: 8.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            side: BorderSide(
                              color: color.withOpacity(0.4),
                              width: 1.2.w,
                            ),
                            visualDensity: VisualDensity.compact,
                            backgroundColor: color.withOpacity(0.2),
                          );
                        }).toList(),
                      ),
                    SizedBox(height: 8.h),
                    AutoSizeText(
                      data['desc'] ?? "No description.",
                      maxLines: 3,
                      minFontSize: 1,
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
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
  }
}
