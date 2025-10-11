import 'package:flutter/material.dart';
import 'package:swipe_cards/swipe_cards.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

// swipe screen (main one)
class SwipeScreen extends StatefulWidget {
  const SwipeScreen({super.key});

  @override
  State<SwipeScreen> createState() => _SwipeScreenState();
}

class _SwipeScreenState extends State<SwipeScreen> {
  late MatchEngine _matchEngine;
  final List<SwipeItem> _swipeItems = [];

  // just makin a random list of imgs for now lol
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

    // just makin 5 dummy cards for now lol
    for (int i = 0; i < 5; i++) {
      _swipeItems.add(
        SwipeItem(
          content: Text("Card $i"),
          likeAction: () {
            debugPrint("Liked $i");
          },
          nopeAction: () {
            debugPrint("Nope $i");
          },
          superlikeAction: () {
            debugPrint("Superliked $i");
          },
        ),
      );
    }

    // connect swipe items to match engine thing
    _matchEngine = MatchEngine(swipeItems: _swipeItems);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 8), // lil top gap

          Expanded(
            child: Center(
              child: SwipeCards(
                matchEngine: _matchEngine,
                onStackFinished: () {
                  // show snackbar when all cards done
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Stack Finished ig")),
                  );
                },

                // building each card
                itemBuilder: (context, index) {
                  return Center(
                    child: SizedBox(
                      width: 400, // card width
                      height: 500, // card height
                      child: Card(
                        color: const Color.fromRGBO(200, 100, 100, 1),
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),

                        // added padding so the content aint squished
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // main header img (static rn)
                              ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Image.asset(
                                  _imagePaths[index % _imagePaths.length],
                                  // loops back if cards > imgs
                                  width: double.infinity,
                                  height: 200,
                                  fit: BoxFit.cover,
                                ),
                              ),

                              const SizedBox(height: 16),

                              // title text
                              Text(
                                "Card ${index + 1}",
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),

                              const SizedBox(height: 8),

                              // rating bar thing (just tryna test)
                              RatingBarIndicator(
                                rating: 3.5, // hardcoded for now ig
                                itemBuilder: (context, index) => const Icon(
                                  Icons.star,
                                  color: Colors.yellow,
                                ),
                                itemCount: 5,
                                itemSize: 30.0,
                                direction: Axis.horizontal,
                              ),

                              const SizedBox(height: 8),

                              // small desc or smth
                              const Text(
                                "some random desc just to test spacing n stuff",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },

                // debug text when card changes
                itemChanged: (item, index) {
                  debugPrint("Card changed: $index");
                },

                upSwipeAllowed: true,
                fillSpace: false,
              ),
            ),
          ),

          const SizedBox(height: 88), // bottom spacing so it dont touch edges
        ],
      ),
    );
  }
}
