import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
// 🔸 Commented out Firebase import for offline mode
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dish_dash/features/home/screens/home_screen.dart';
import 'package:dish_dash/features/home/widgets/filters.dart';
import 'package:dish_dash/features/home/widgets/price_tags.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchScreen extends StatefulWidget {
  SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  List<String> restaurants = [
    // 🔸 Temporary offline mock data (you can remove when Firebase is back)
    "Kababjees",
    "Okra",
    "Xander’s",
    "Côte Rôtie",
    "Ginsoy",
  ];

  List<String> matchingSearches = [];
  String searchedRestaurant = '';
  bool showSearchSuggestions = false;

  // 🔸 Commented out Firestore fetching for offline mode
  /*
  getRestaurantNames() async {
    restaurants.clear();
    QuerySnapshot<Map<String, dynamic>> allRestaurants =
        await FirebaseFirestore.instance.collection('restaurants').get();
    allRestaurants.docs.forEach((doc) {
      Map<String, dynamic> docData = doc.data();
      restaurants.add(docData['name']);
    });
  }
  */

  List<String> searchData(String value) {
    String searchVal = value.toString().toLowerCase().replaceAll(
      RegExp(r'[^a-zA-Z0-9]'),
      '',
    );
    List<String> matchingNames = [];
    try {
      matchingNames = restaurants.where((restaurant) {
        String tempName = restaurant.toString().toLowerCase().replaceAll(
          RegExp(r'[^a-zA-Z0-9]'),
          '',
        );
        String tempSearch = searchVal;
        return tempName.contains(tempSearch);
      }).toList();
    } catch (e) {
      print(e.toString());
    }
    return matchingNames;
  }

  void onChanged(String value) {
    if (value.isEmpty) {
      setState(() {
        showSearchSuggestions = false;
      });
    } else {
      setState(() {
        showSearchSuggestions = true;
        matchingSearches = searchData(value);
      });
    }
  }

  void onSubmitted() {}

  Map<String, Set<String>> allFilters = {};
  Map<String, Set<String>> selectedFilters = {};
  List<String> priceTags = [];

  @override
  void initState() {
    super.initState();
    // 🔸 Commented out Firebase fetching
    // getRestaurantNames();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: colorScheme.primary,
        iconTheme: IconThemeData(color: Colors.white),
        toolbarHeight: 80.h,
        title: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 5.h),
                  child: TextField(
                    controller: _searchController,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: Colors.black87,
                      fontSize: 13.sp,
                    ),
                    decoration: InputDecoration(
                      isDense: true,
                      prefixIcon: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.w),
                        child: Icon(
                          Icons.search,
                          color: Colors.grey.shade800,
                          size: 18.sp,
                        ),
                      ),
                      prefixIconConstraints: BoxConstraints(
                        minWidth: 36.w,
                        minHeight: 20.h,
                      ),
                      hintText: "Search Karachi's best food directory...",
                      hintStyle: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.grey.shade800,
                      ),
                      border: InputBorder.none,
                    ),
                    onChanged: (value) => onChanged(value),
                    onSubmitted: (value) => onSubmitted(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: ListView(
        children: [
          !showSearchSuggestions
              ? SizedBox(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.w,
                              vertical: 10.h,
                            ),
                            child: Container(
                              child: AutoSizeText(
                                "Filter by:  ",
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  color: Colors.black,
                                  fontSize: 25.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.w,
                              vertical: 10.h,
                            ),
                            child: Container(
                              child: AutoSizeText(
                                "location slider here",
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  color: Colors.black,
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),

                          // 🔸 Commented out live Firebase Stream for offline use
                          /*
                          StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('restaurants')
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                snapshot.data!.docs.forEach((doc) {
                                  var data = doc.data();
                                  data.forEach((key, value) {
                                    if (value is List &&
                                        value.every((item) => item is String)) {
                                      allFilters.putIfAbsent(
                                          key, () => <String>{});
                                      allFilters[key]!.addAll(
                                          value.cast<String>());
                                    }
                                  });
                                });

                                return Column(
                                  children: allFilters.entries.map((entry) {
                                    final filterType = entry.key;
                                    final tagsList = entry.value.toList();
                                    return SizedBox(
                                      child: MyTags(
                                        tags: tagsList,
                                        filterType: filterType,
                                        onSelectionChanged:
                                            (Set<String> selectedTags) {
                                          setState(() {
                                            selectedFilters[filterType] =
                                                selectedTags;
                                          });
                                        },
                                      ),
                                    );
                                  }).toList(),
                                );
                              } else {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                            },
                          ),
                          */

                          // 🔹 Simple offline placeholder
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 10.h),
                            child: AutoSizeText(
                              "(Offline mode — filters disabled)",
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: Colors.grey,
                                fontSize: 14.sp,
                              ),
                            ),
                          ),

                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            child: SizedBox(
                              child: PriceTagSlider(
                                onPriceChanged: (List<String> priceRange) {
                                  setState(() {
                                    priceTags = priceRange;
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colorScheme.primary.withOpacity(
                                0.8,
                              ),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.r),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 14.h),
                            ),
                            onPressed: () {
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (context) {
                                    return HomeScreen(
                                      searchedRestaurant: searchedRestaurant,
                                      priceTags: priceTags,
                                      selectedFilters: selectedFilters,
                                    );
                                  },
                                ),
                                (Route<dynamic> route) => false,
                              );

                              print(selectedFilters);
                            },
                            child: AutoSizeText("Apply"),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 2.w),
                      padding: EdgeInsets.symmetric(vertical: 4.h),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      constraints: BoxConstraints(maxHeight: 200.h),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: matchingSearches.length,
                        itemBuilder: (context, index) {
                          return Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: ListTile(
                              leading: Icon(Icons.restaurant),
                              trailing: Icon(Icons.search),
                              title: AutoSizeText(
                                matchingSearches[index],
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.sp,
                                ),
                              ),
                              onTap: () {
                                setState(() {
                                  searchedRestaurant = matchingSearches[index];
                                });
                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return HomeScreen(
                                        searchedRestaurant: searchedRestaurant,
                                      );
                                    },
                                  ),
                                  (Route<dynamic> route) => false,
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
        ],
      ),
    );
  }
}
