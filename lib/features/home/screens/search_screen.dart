import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// 🔸 Commented out Firebase import for offline mode
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dish_dash/features/home/screens/home_screen.dart';
import 'package:dish_dash/features/home/widgets/filters.dart';
import 'package:dish_dash/features/home/widgets/price_tags.dart';
import 'package:dish_dash/features/home/widgets/radius_slider.dart';
import 'package:dish_dash/methods/location_shi.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';

class SearchScreen extends StatefulWidget {
  SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  List<String> restaurants = [];

  List<String> matchingSearches = [];
  String searchedRestaurant = '';
  bool showSearchSuggestions = false;

  getRestaurantNames() async {
    restaurants.clear();
    QuerySnapshot<Map<String, dynamic>> allRestaurants = await FirebaseFirestore
        .instance
        .collection('restaurants')
        .get();
    allRestaurants.docs.forEach((doc) {
      Map<String, dynamic> docData = doc.data();
      restaurants.add(docData['name']);
    });
  }

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

  Map<String, Set<String>> allFilters = {};
  Map<String, Set<String>> selectedFilters = {};
  List<String> priceTags = [];
  double? radius;
  @override
  void initState() {
    super.initState();
    getRestaurantNames();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final background = theme.scaffoldBackgroundColor;

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(110, 146, 160, 1),
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
                    // onSubmitted: (value) => searchData(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      //
      //apply filters
      //
      floatingActionButton: Padding(
        padding: EdgeInsets.only(left: 40.w, right: 10.w, bottom: 20.h),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.primary.withOpacity(0.8),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
              padding: EdgeInsets.symmetric(vertical: 14.h),
            ),
            onPressed: () async {
              // apply filters

              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) {
                    return HomeScreen(
                      searchedRestaurant: searchedRestaurant,
                      priceTags: priceTags,
                      selectedFilters: selectedFilters,
                      radius: radius ?? 50,
                    );
                  },
                ),
                (Route<dynamic> route) => false,
              );
              // } else {
              //   ScaffoldMessenger.of(context).showSnackBar(
              //     SnackBar(
              //       content: AutoSizeText('Please allow Location Services'),
              //     ),
              //   );
              // }
            },
            child: AutoSizeText("Apply"),
          ),
        ),
      ),

      //
      body: ListView(
        shrinkWrap: true,
        children: [
          !showSearchSuggestions
              ? SingleChildScrollView(
                  child: SizedBox(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 20.w,
                                vertical: 10.h,
                              ),
                              child: SizedBox(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 10.w,
                                  ),
                                  child: PriceTagSlider(
                                    onPriceChanged: (List<String> priceRange) {
                                      setState(() {
                                        priceTags = priceRange;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 30.w,
                                vertical: 10.h,
                              ),
                              child: RadiusSlider(
                                onRadiusChanged: (radius1) {
                                  setState(() {
                                    radius = radius1 as double;
                                  });
                                },
                              ),
                            ),

                            StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection('restaurants')
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  const allowedKeys = {
                                    'ambience',
                                    'food',
                                    'occasion',
                                  };

                                  snapshot.data!.docs.forEach((doc) {
                                    var data = doc.data();
                                    data.forEach((key, value) {
                                      if (allowedKeys.contains(key) &&
                                          value is List &&
                                          value.every(
                                            (item) => item is String,
                                          )) {
                                        allFilters.putIfAbsent(
                                          key,
                                          () => <String>{},
                                        );
                                        allFilters[key]!.addAll(
                                          value.cast<String>(),
                                        );
                                      }
                                    });
                                  });
                                  return Column(
                                    children: [
                                      Column(
                                        children: allFilters.entries.map((
                                          entry,
                                        ) {
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
                                      ),
                                      SizedBox(height: 200),
                                    ],
                                  );
                                } else {
                                  return Center(
                                    child: Text(
                                      "loading ... ",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
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
                              onTap: () async {
                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return HomeScreen(
                                        searchedRestaurant:
                                            matchingSearches[index],
                                        priceTags: priceTags,
                                        selectedFilters: selectedFilters,
                                        radius:
                                            matchingSearches[index].isNotEmpty
                                            ? null
                                            : radius, // null if searching by name
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
