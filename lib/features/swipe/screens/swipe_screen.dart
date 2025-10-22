import 'dart:ui';
import 'package:auto_size_text/auto_size_text.dart';
// 🔸 Commented out Firebase imports so it compiles offline
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dish_dash/methods/firebase_methods.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:swipe_cards/swipe_cards.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

class SwipeScreen extends StatefulWidget {
  final String matchName;
  final Map<String, Set<String>> selectedFilters;
  final List<String> priceTags;
  SwipeScreen({
    super.key,
    required this.matchName,
    required this.priceTags,
    required this.selectedFilters,
  });

  @override
  State<SwipeScreen> createState() => _SwipeScreenState();
}

class _SwipeScreenState extends State<SwipeScreen> {
  late MatchEngine _matchEngine;
  final List<SwipeItem> _swipeItems = [];
  final List<Map<String, dynamic>> _resData = [];

  // 🔹 Helper to init swipe items once per data fetch
  void _initSwipeItems(List<QueryDocumentSnapshot> docs) {
    _swipeItems.clear();
    _resData.clear();

    final matchName = widget.matchName;
    final isSearch = matchName.isNotEmpty;
    final isFilterActive =
        widget.priceTags.isNotEmpty || widget.selectedFilters.isNotEmpty;

    List<QueryDocumentSnapshot> workingDocs = docs;

    if (isFilterActive) {
      workingDocs = workingDocs.where((doc) {
        final data = doc.data() as Map<String, dynamic>;
        final price = data['priceRange'] ?? '\$';
        if (widget.priceTags.isNotEmpty && !widget.priceTags.contains(price))
          return false;

        for (var entry in widget.selectedFilters.entries) {
          final field = entry.key;
          final requiredValues = entry.value;
          final docValues = data[field];

          if (docValues is List) {
            if (!requiredValues.any((val) => docValues.contains(val))) {
              return false;
            }
          } else {
            return false;
          }
        }

        return true;
      }).toList();
    }

    if (isSearch) {
      workingDocs.sort((a, b) {
        final aMatch = (a.data() as Map)['name'] == matchName;
        final bMatch = (b.data() as Map)['name'] == matchName;
        return bMatch ? 1 : (aMatch ? -1 : 0);
      });
    }

    for (var doc in workingDocs) {
      final data = doc.data() as Map<String, dynamic>;
      _resData.add(data);

      _swipeItems.add(
        SwipeItem(
          content: AutoSizeText(data['name'] ?? "Restaurant"),
          likeAction: () => MyMethods().rightSwipe(data['name'] as String),
          nopeAction: () => MyMethods().leftSwipe(data['name'] as String),
          superlikeAction: () => MyMethods().favourites(data['name'] as String),
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
              Icon(Icons.close, color: Colors.green, size: 30.sp),
              SizedBox(width: 25.w),
              Icon(Icons.bookmark, color: Colors.blueAccent, size: 30.sp),
              SizedBox(width: 25.w),
              Icon(Icons.favorite, color: Colors.redAccent, size: 30.sp),
            ],
          ),

          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('restaurants')
                .snapshots(),
            builder: (context, snapshot) {
              // 🔹 Debug Firestore test
              (() async {
                print("Fetching cards...");
                try {
                  final query = await FirebaseFirestore.instance
                      .collection('cards')
                      .get();
                  print("Cards fetched: ${query.docs.length}");
                } catch (e) {
                  print("Error fetching cards: $e");
                }
              })();

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
              print("Query snapshot size: ${docs.length}");

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

              // 🔹 Only init swipe items once per snapshot update
              if (_swipeItems.isEmpty) {
                _initSwipeItems(docs);
              }

              return Expanded(
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
              );
            },
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
                    if (data['food'] != null)
                      Wrap(
                        spacing: 8,
                        children: (data['food'] as List)
                            .map(
                              (tag) => Chip(
                                labelPadding: EdgeInsets.symmetric(
                                  horizontal: 2.w,
                                  vertical: 0.h,
                                ),
                                label: Text(
                                  tag.toString(),
                                  style: GoogleFonts.fraunces(fontSize: 10.sp),
                                ),
                                side: BorderSide.none,
                                visualDensity: VisualDensity.compact,
                                backgroundColor: colorScheme.primary
                                    .withOpacity(0.25),
                              ),
                            )
                            .toList(),
                      ),
                    SizedBox(height: 8.h),
                    AutoSizeText(
                      data['desc'] ?? "No description.",
                      maxLines: 3,
                      minFontSize: 1,
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                        fontSize: 12.sp,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 15.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          if (data['hasFoodpanda'] == true)
                            IconButton(
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
                            IconButton(
                              onPressed: () async {
                                final url = data['instagram'];
                                if (url != null && url.toString().isNotEmpty) {
                                  debugPrint("Opening Instagram: $url");
                                  await launchUrl(Uri.parse(url));
                                }
                              },
                              icon: FaIcon(FontAwesomeIcons.instagram),
                              color: Colors.pink,
                            ),
                          SizedBox(width: 5.w),
                          if (data['hasReservations'] == true)
                            IconButton(
                              icon: Icon(Icons.calendar_today),
                              onPressed: () {
                                debugPrint(
                                  "Reservation tapped for ${data['name']}",
                                );
                              },
                            ),
                        ],
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
