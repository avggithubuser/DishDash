import 'dart:ui';
import 'package:auto_size_text/auto_size_text.dart';
// 🔸 Commented out Firebase imports so it compiles offline
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:dish_dash/methods/firebase_methods.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:swipe_cards/swipe_cards.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dish_dash/features/swipe/helper_widgets/bottom_row_action_buttons.dart';

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
  void initState() {
    super.initState();

    // 🔹 Offline fallback mock data
    final mockRestaurants = [
      {
        'name': 'Mojo Brew',
        'imageUrl':
            'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=800',
        'rating': 4.5,
        'priceRange': '\$\$',
        'tags': ['Coffee', 'Vegan', 'Brunch'],
        'desc':
            'A cozy cafe serving specialty coffee and all-day brunch in Karachi.',
        // added mock fields ↓↓↓
        'hasFoodpanda': true,
        'hasReservations': true,
        'instagram': 'https://www.instagram.com/mojobrew',
        'foodpandaUrl': 'https://www.foodpanda.pk/restaurant/mojobrew',
      },
      {
        'name': 'The Social Hub',
        'imageUrl':
            'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=800',
        'rating': 4.2,
        'priceRange': '\$\$',
        'tags': ['Continental', 'Desserts', 'Cafe'],
        'desc':
            'Trendy cafe known for its desserts, pasta, and Instagrammable vibe.',
        // added mock fields ↓↓↓
        'hasFoodpanda': false,
        'hasReservations': true,
        'instagram': 'https://www.instagram.com/thesocialhubpk',
        'foodpandaUrl': '',
      },
      {
        'name': 'Biryani Wala',
        'imageUrl':
            'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=800',
        'rating': 4.8,
        'priceRange': '\$',
        'tags': ['Desi', 'Biryani', 'Spicy'],
        'desc': 'Authentic Karachi-style biryani with raita and salad combo.',
        // added mock fields ↓↓↓
        'hasFoodpanda': true,
        'hasReservations': false,
        'instagram': '',
        'foodpandaUrl': 'https://www.foodpanda.pk/restaurant/biryaniwala',
      },
      {
        'name': 'Sushi & Co',
        'imageUrl':
            'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=800',

        'rating': 4.6,
        'priceRange': '\$\$\$',
        'tags': ['Japanese', 'Sushi', 'Seafood'],
        'desc':
            'Premium Japanese dining with sushi rolls and sashimi platters.',
        // added mock fields ↓↓↓
        'hasFoodpanda': false,
        'hasReservations': true,
        'instagram': 'https://www.instagram.com/sushiandco.pk',
        'foodpandaUrl': '',
      },
    ];

    // 🔹 Use mock data for offline testing
    for (var data in mockRestaurants) {
      _resData.add(data);
      _swipeItems.add(
        SwipeItem(
          content: AutoSizeText((data['name'] ?? 'Restaurant').toString()),
          // likeAction: () => MyMethods().rightSwipe(data['name'] as String),
          // nopeAction: () => MyMethods().leftSwipe(data['name'] as String),
          // superlikeAction: () => MyMethods().favourites(data['name'] as String),
          likeAction: () => debugPrint("Liked: ${data['name']}"),
          nopeAction: () => debugPrint("Nope: ${data['name']}"),
          superlikeAction: () => debugPrint("Superliked: ${data['name']}"),
        ),
      );
    }

    _matchEngine = MatchEngine(swipeItems: _swipeItems);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 16.h),

          // Top swipe icons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(Icons.close, color: Colors.amberAccent, size: 30.sp),
              SizedBox(width: 25.w),
              Icon(Icons.bookmark, color: Colors.blueAccent, size: 30.sp),
              SizedBox(width: 25.w),
              Icon(Icons.favorite, color: Colors.redAccent, size: 30.sp),
            ],
          ),

          SizedBox(height: 20.h),

          // 🔹 ORIGINAL FIREBASE SECTION (commented out for offline use)
          /*
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
                    child: AutoSizeText(
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
                    child: AutoSizeText(
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
                    likeAction: () =>
                        MyMethods().rightSwipe(data['name'] as String),
                    nopeAction: () =>
                        MyMethods().leftSwipe(data['name'] as String),
                    superlikeAction: () =>
                        MyMethods().favourites(data['name'] as String),
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
                      return _buildSwipeCard(context, colorScheme, data);
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
          */

          // 🔹 OFFLINE MODE (using mock data)
          Expanded(
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

          SizedBox(height: 100.h),
        ],
      ),
    );
  }

  // 🔹 Reusable card builder
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
                    // 🔹 Image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16.w),
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

                    //Title and price range
                    Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                            color: Colors.amber,
                            fontWeight: FontWeight.bold,
                            fontSize: 14.sp,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 8.h),

                    // 🔹 Tags
                    if (data['tags'] != null)
                      Wrap(
                        spacing: 8,
                        children: (data['tags'] as List)
                            .map(
                              (tag) => Chip(
                                side: BorderSide.none,
                                visualDensity: VisualDensity.compact,
                                labelPadding: EdgeInsets.symmetric(
                                  horizontal: 2.w,
                                  vertical: 0.h,
                                ),
                                label: Text(
                                  tag.toString(),
                                  style: GoogleFonts.fraunces(fontSize: 10.sp),
                                ),
                                backgroundColor: colorScheme.primary
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
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                        fontSize: 12.sp,
                      ),
                    ),

                    SizedBox(height: 20.h),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // 🍴 Foodpanda button — only if restaurant hasFoodpanda == true
                        if (data['hasFoodpanda'] == true)
                          buildActionButton(
                            // icon: Icons.delivery_dining,
                            assetPath: "assets/foodpanda.png",
                            // label: "Foodpanda",
                            color: Colors.pinkAccent,
                            onTap: () {
                              // open the restaurant's Foodpanda link
                              final url = data['foodpandaUrl'] ?? '';
                              if (url.isNotEmpty) {
                                debugPrint("Opening Foodpanda: $url");
                                // launchUrl(Uri.parse(url));
                              }
                            },
                          ),

                        SizedBox(width: 5.w),

                        // 📸 Instagram button — always visible if instagram exists
                        if (data['instagram'] != null &&
                            data['instagram'].toString().isNotEmpty)
                          buildActionButton(
                            // icon: Icons.camera_alt_outlined,
                            assetPath: "assets/instagram.png",
                            // label: "Instagram",
                            color: Colors.deepPurpleAccent,
                            onTap: () {
                              final url = data['instagram'];
                              if (url != null && url.toString().isNotEmpty) {
                                debugPrint("Opening Instagram: $url");
                                // launchUrl(Uri.parse(url));
                              }
                            },
                          ),

                        SizedBox(width: 5.w),
                        // 📅 Reservation button — only if restaurant takes reservations
                        if (data['hasReservations'] == true)
                          buildActionButton(
                            // icon: Icons.event_available,
                            label: "Reserve",
                            color: Colors.green,
                            onTap: () {
                              debugPrint(
                                "Reservation tapped for ${data['name']}",
                              );
                              // implement reservation action or popup
                            },
                          ),
                        SizedBox(width: 5.w),
                      ],
                    ),

                    // SizedBox(width: 20.w),
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
