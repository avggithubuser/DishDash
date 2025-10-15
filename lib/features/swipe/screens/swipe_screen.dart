import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:swipe_cards/swipe_cards.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:dish_dash/core/services/theme_service.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dish_dash/features/providers/restaurant_providers.dart';

class SwipeScreen extends ConsumerStatefulWidget {
  const SwipeScreen({super.key});

  @override
  State<SwipeScreen> createState() => _SwipeScreenState();
}

class _SwipeScreenState extends ConsumerState<SwipeScreen> {
  late MatchEngine _matchEngine;
  List<SwipeItem> _swipeItems = [];

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeService.isDark(context);
    final colorScheme = Theme.of(context).colorScheme;

    final restaurantsAsync = ref.watch(restaurantsStreamProvider);

    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 16.h),

          // Icons above now
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

          Expanded(
            child: restaurantsAsync.when(
              data: (restaurants) {
                if (restaurants.isEmpty) {
                  return const Center(
                    child: Text(
                      'No restaurants available.',
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }

                // 🔹 Build SwipeItems dynamically
                _swipeItems = restaurants
                    .map(
                      (r) => SwipeItem(
                        content: Text(r.name),
                        likeAction: () => debugPrint("Liked ${r.name}"),
                        nopeAction: () => debugPrint("Nope ${r.name}"),
                        superlikeAction: () =>
                            debugPrint("Superliked ${r.name}"),
                      ),
                    )
                    .toList();

                _matchEngine = MatchEngine(swipeItems: _swipeItems);

                return Center(
                  child: SwipeCards(
                    matchEngine: _matchEngine,
                    onStackFinished: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Stack Finished ig")),
                      );
                    },
                    itemBuilder: (context, index) {
                      final restaurant = restaurants[index];
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
                                    color: isDark
                                        ? Colors.grey.shade800.withOpacity(0.35)
                                        : Colors.white.withOpacity(0.35),
                                    border: Border.all(
                                      color: isDark
                                          ? Colors.grey.shade700.withOpacity(
                                              0.5,
                                            )
                                          : Colors.grey.shade300.withOpacity(
                                              0.5,
                                            ),
                                      width: 1.2.w,
                                    ),
                                  ),
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(16),
                                        child: Image.network(
                                          restaurant.image.isNotEmpty
                                              ? restaurant.image
                                              : _imagePaths[index %
                                                    _imagePaths.length],
                                          width: double.infinity.w,
                                          height: 200.h,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      SizedBox(height: 16.h),
                                      Text(
                                        restaurant.name,
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(
                                            context,
                                          ).textTheme.bodyLarge?.color,
                                        ),
                                      ),
                                      SizedBox(height: 8.w),
                                      RatingBarIndicator(
                                        rating: restaurant.rating,
                                        itemBuilder: (context, index) =>
                                            const Icon(
                                              Icons.star,
                                              color: Colors.yellow,
                                            ),
                                        itemCount: 5,
                                        itemSize: 30.0,
                                        direction: Axis.horizontal,
                                      ),
                                      SizedBox(height: 8.h),
                                      Text(
                                        restaurant.description,
                                        style: TextStyle(
                                          color: Theme.of(
                                            context,
                                          ).textTheme.bodyMedium?.color,
                                          fontSize: 16,
                                        ),
                                      ),
                                      SizedBox(height: 8.h),
                                      Wrap(
                                        spacing: 8.w,
                                        children: restaurant.tags
                                            .map(
                                              (tag) => Chip(
                                                label: Text(tag),
                                                backgroundColor: colorScheme
                                                    .primary
                                                    .withOpacity(0.2),
                                              ),
                                            )
                                            .toList(),
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
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Center(
                child: Text(
                  'Error: $err',
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            ),
          ),

          SizedBox(height: 100.h),
        ],
      ),
    );
  }
}
