import 'dart:ui';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:dish_dash/data/models/dishdash_database.dart';
import 'package:dish_dash/methods/firebase_methods.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:swipe_cards/swipe_cards.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

class SwipeScreen extends StatefulWidget {
  final String? matchName;
  final Map<String, Set<String>>? selectedFilters;
  final List<String>? priceTags;
  double? radius;

  SwipeScreen({
    super.key,
    this.matchName,
    this.priceTags,
    this.selectedFilters,
    this.radius,
  });

  @override
  State<SwipeScreen> createState() => _SwipeScreenState();
}

class _SwipeScreenState extends State<SwipeScreen> {
  MatchEngine? _matchEngine;
  List<Map<String, dynamic>>? _builtList;
  bool _engineReady = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _tryBuildEngine());
  }

  void _tryBuildEngine() {
    if (_engineReady) return; // already built, never rebuild
    final db = context.read<DishDashDatabase>();
    if (db.devPos == null) return; // not ready yet, will retry

    final isSearching =
        (widget.priceTags?.isNotEmpty ?? false) ||
        (widget.selectedFilters?.isNotEmpty ?? false) ||
        (widget.radius != null) ||
        (widget.matchName?.isNotEmpty ?? false);

    List<Map<String, dynamic>> restaurants;
    if (isSearching) {
      restaurants = db.searchRestaurants(
        matchName: widget.matchName,
        priceTags: widget.priceTags,
        selectedFilters: widget.selectedFilters,
        radius: widget.radius,
        devPos: db.devPos!,
      );
    } else {
      restaurants = db.restaurants
          .where((r) => !db.swipedMain.contains(r['name']))
          .toList();
    }

    if (restaurants.isEmpty) {
      setState(() => _engineReady = true); // show empty state
      return;
    }

    final swipeItems = restaurants.map((data) {
      return SwipeItem(
        content: AutoSizeText(data['name'] ?? 'Restaurant'),
        likeAction: () {
          if (!isSearching) db.markSwipedMain(data['name']);
          MyMethods().likeRestaurant(context, data['name']);
        },
        nopeAction: () {
          if (!isSearching) db.markSwipedMain(data['name']);
          MyMethods().leftSwipe(context, data['name']);
        },
        superlikeAction: () {
          if (!isSearching) db.markSwipedMain(data['name']);
          MyMethods().saveRestaurant(context, data['name']);
        },
      );
    }).toList();

    setState(() {
      _builtList = restaurants;
      _matchEngine = MatchEngine(swipeItems: swipeItems);
      _engineReady = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 16.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(Icons.close, color: Colors.green, size: 30.sp),
            SizedBox(width: 25.w),
            Icon(Icons.bookmark_outline, color: Colors.blueAccent, size: 30.sp),
            SizedBox(width: 25.w),
            Icon(Icons.favorite_outline, color: Colors.redAccent, size: 30.sp),
          ],
        ),
        if (!_engineReady)
          // waiting for devPos
          Consumer<DishDashDatabase>(
            builder: (context, db, _) {
              if (db.devPos != null && !_engineReady) {
                WidgetsBinding.instance.addPostFrameCallback(
                  (_) => _tryBuildEngine(),
                );
              }
              return Center(child: CircularProgressIndicator());
            },
          )
        else if (_builtList == null || _builtList!.isEmpty)
          Center(child: Text("No restaurants found."))
        else
          Expanded(
            child: SwipeCards(
              matchEngine: _matchEngine!,
              fillSpace: true,
              itemBuilder: (context, idx) => _buildSwipeCard(
                context,
                Theme.of(context).colorScheme,
                _builtList![idx],
              ),
              upSwipeAllowed: true,
              onStackFinished: () => ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text("No more restaurants!"))),
            ),
          ),
        SizedBox(height: 100.h),
      ],
    );
  }

  Widget _buildSwipeCard(
    BuildContext context,
    ColorScheme colorScheme,
    Map<String, dynamic> data,
  ) {
    return Center(
      child: SizedBox(
        width: 300.w,
        height: 460.w,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.w),
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
              child: ListView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  Container(
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
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16.w),
                              child:
                                  data['imageUrl'] != null &&
                                      data['imageUrl'] != ''
                                  ? Image.network(
                                      data['imageUrl'],
                                      width: double.infinity,
                                      height: 200.w,
                                      fit: BoxFit.cover,
                                    )
                                  : Container(
                                      height: 200.w,
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
                            // name
                            Row(
                              children: [
                                Flexible(
                                  child: AutoSizeText(
                                    maxLines: 1,
                                    minFontSize: 1,
                                    data['name'] ?? "Unknown",
                                    style: TextStyle(
                                      fontSize: 20.w,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(
                                        context,
                                      ).textTheme.bodyLarge?.color,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            // foodpanda, instagram, res, menu, contact
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 16.h),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  if (data['instagram'] != null &&
                                      data['instagram'].toString().isNotEmpty)
                                    GestureDetector(
                                      // bgcolor: Colors.white,
                                      // height: 28.h,
                                      onTap: () async {
                                        final url = data['instagram'];
                                        if (url != null &&
                                            url.toString().isNotEmpty) {
                                          debugPrint("Opening Instagram: $url");
                                          await launchUrl(Uri.parse(url));
                                        }
                                      },
                                      child: FaIcon(
                                        FontAwesomeIcons.instagram,
                                        color: Colors.white,
                                      ),
                                    ),

                                  SizedBox(width: 10.w),
                                  GestureDetector(
                                    child: Icon(
                                      Icons.menu_book_outlined,
                                      color: Colors.white,
                                    ),

                                    onTap: () {
                                      // handle menu tap
                                    },
                                  ),
                                  SizedBox(width: 10.w),
                                  GestureDetector(
                                    onTap: () async {
                                      final phoneNumber = data['contact'][0];
                                      if (phoneNumber != null &&
                                          phoneNumber.toString().isNotEmpty) {
                                        debugPrint("Calling: $phoneNumber");
                                        await launchUrl(
                                          Uri(scheme: 'tel', path: phoneNumber),
                                        );
                                      }
                                    },
                                    child: FaIcon(
                                      FontAwesomeIcons.phone,
                                      size: 20.w,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(width: 10.w),

                                  if (data['hasFoodpanda'] == true)
                                    GestureDetector(
                                      child: SizedBox(
                                        height: 20.w,
                                        child: Image.asset(
                                          "assets/foodpanda.png",
                                        ),
                                      ),
                                      onTap: () async {
                                        final url =
                                            data['foodpandaUrl'][0] ?? '';
                                        if (url.isNotEmpty) {
                                          debugPrint("Opening Foodpanda: $url");
                                          await launchUrl(Uri.parse(url));
                                        }
                                      },
                                    ),
                                  SizedBox(width: 10.w),
                                ],
                              ),
                            ),

                            // ratings
                            Row(
                              children: [
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
                                children: (data['food'] as List)
                                    .asMap()
                                    .entries
                                    .map((entry) {
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

                                      final color =
                                          chipColors[index % chipColors.length];

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
                                        side: BorderSide.none,
                                        //  BorderSide(
                                        //   color: color.withOpacity(0.4),
                                        //   width: 1.2.w,
                                        // ),
                                        visualDensity: VisualDensity.compact,
                                        backgroundColor: color.withOpacity(0.2),
                                      );
                                    })
                                    .toList(),
                              ),
                            SizedBox(height: 8.h),

                            // description
                            AutoSizeText(
                              data['desc'] ?? "No description.",
                              maxLines: 3,
                              minFontSize: 1,
                              style: TextStyle(
                                color: Theme.of(
                                  context,
                                ).textTheme.bodyMedium?.color,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
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
    );
  }
}
