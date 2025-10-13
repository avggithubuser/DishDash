import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:swipe_cards/swipe_cards.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:dish_dash/core/services/theme_service.dart';

class SwipeScreen extends StatefulWidget {
  const SwipeScreen({super.key});

  @override
  State<SwipeScreen> createState() => _SwipeScreenState();
}

class _SwipeScreenState extends State<SwipeScreen> {
  late MatchEngine _matchEngine;
  final List<SwipeItem> _swipeItems = [];

  //placeholder images to be added soon
  final List<String> _imagePaths = [
    'assets/images/pic1.jpg',
    'assets/images/pic2.jpg',
    'assets/images/pic3.jpg',
    'assets/images/pic4.jpg',
    'assets/images/pic5.jpg',
  ];

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < 5; i++) {
      _swipeItems.add(
        SwipeItem(
          content: Text("Card $i"),
          likeAction: () => debugPrint("Liked $i"),
          nopeAction: () => debugPrint("Nope $i"),
          superlikeAction: () => debugPrint("Superliked $i"),
        ),
      );
    }

    _matchEngine = MatchEngine(swipeItems: _swipeItems);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeService.isDark(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 8),

          Expanded(
            child: Center(
              child: SwipeCards(
                matchEngine: _matchEngine,
                onStackFinished: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Stack Finished ig")),
                  );
                },
                itemBuilder: (context, index) {
                  return Center(
                    child: SizedBox(
                      width: 350,
                      height: 500,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.transparent,
                          boxShadow: [
                            // Left glow
                            BoxShadow(
                              color: colorScheme.secondary.withOpacity(0.8),
                              blurRadius: 20,
                              spreadRadius: 3,
                              offset: const Offset(-6, 0),
                            ),
                            // Right glow
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
                                borderRadius: BorderRadius.circular(20),
                                color: isDark
                                    ? Colors.grey.shade800.withOpacity(0.35)
                                    : Colors.white.withOpacity(0.35),
                                border: Border.all(
                                  color: isDark
                                      ? Colors.grey.shade700.withOpacity(0.5)
                                      : Colors.grey.shade300.withOpacity(0.5),
                                  width: 1.2,
                                ),
                              ),
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: Image.asset(
                                      _imagePaths[index % _imagePaths.length],
                                      width: double.infinity,
                                      height: 200,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    "Card ${index + 1}",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(
                                        context,
                                      ).textTheme.bodyLarge?.color,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  RatingBarIndicator(
                                    rating: 3.5,
                                    itemBuilder: (context, index) => const Icon(
                                      Icons.star,
                                      color: Colors.yellow,
                                    ),
                                    itemCount: 5,
                                    itemSize: 30.0,
                                    direction: Axis.horizontal,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "test description test description test description test description test description test description test description test description",
                                    style: TextStyle(
                                      color: Theme.of(
                                        context,
                                      ).textTheme.bodyMedium?.color,
                                      fontSize: 16,
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
          ),

          const SizedBox(height: 88),
        ],
      ),
    );
  }
}
