import 'dart:ui';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:dish_dash/features/home/screens/search_screen.dart';
import 'package:dish_dash/features/profile/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dish_dash/features/swipe/screens/swipe_screen.dart';
import 'package:dish_dash/features/saved/screens/saved_screen.dart';

// ignore: must_be_immutable
class HomeScreen extends StatefulWidget {
  String? searchedRestaurant;
  Map<String, Set<String>>? selectedFilters;
  List<String>? priceTags;
  double? radius;
  // double? myLat;
  // double? myLng;

  HomeScreen({
    super.key,
    this.searchedRestaurant,
    this.priceTags,
    this.selectedFilters,
    this.radius,
    // this.myLat,
    // this.myLng,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  bool isLoading = true;
  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    print('HomeScreen received: ${widget.searchedRestaurant}');
    _screens = [
      SwipeScreen(
        matchName: widget.searchedRestaurant ?? '',
        priceTags: widget.priceTags ?? [],
        selectedFilters: widget.selectedFilters ?? {},
        radius: widget.radius, // idk bud
      ),
      const SavedScreen(),
      const ProfileScreen(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final background = theme.scaffoldBackgroundColor;

    return Scaffold(
      extendBody: true,
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(110, 146, 160, 1),
        toolbarHeight: 90.h,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row 1: Title + filter + toggle
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
                    height: _selectedIndex != 0 ? 90.h : 50.h,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage("assets/logo.png"),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            _selectedIndex != 0
                ? Center()
                : Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => SearchScreen(),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 8.h),
                            child: Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8.w,
                                  ),
                                  child: Icon(
                                    Icons.search,
                                    color: Colors.grey.shade800,
                                    size: 18.sp,
                                  ),
                                ),
                                Text(
                                  "Search Karachi's best food directory...",
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: Colors.grey.shade800,
                                    fontSize: 13.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
            SizedBox(height: 10.h),
          ],
        ),
      ),

      body: Stack(
        children: [
          // Repeated background text
          Positioned.fill(
            child: GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5, // Number of repetitions horizontally
                childAspectRatio: 3, // Adjust spacing
              ),
              itemBuilder: (context, index) {
                return Center(
                  child: AutoSizeText(
                    "dishdash",
                    style: theme.textTheme.displayLarge!.copyWith(
                      fontSize: 40.sp,
                      color: Color.fromRGBO(64, 123, 146, 0.25),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
            ),
          ),
          _screens[_selectedIndex],
        ],
      ),

      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 12.h),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(
                height: 72.h,
                decoration: BoxDecoration(
                  color: Colors.grey.shade50.withOpacity(0.65),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: Colors.grey.shade300.withOpacity(0.4),
                    width: 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade400.withOpacity(0.25),
                      blurRadius: 20,
                      spreadRadius: 2,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: BottomNavigationBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  currentIndex: _selectedIndex,
                  onTap: _onItemTapped,
                  type: BottomNavigationBarType.fixed,
                  selectedItemColor: colorScheme.primary,
                  unselectedItemColor: Colors.grey.shade600,
                  selectedIconTheme: const IconThemeData(size: 30),
                  unselectedIconTheme: const IconThemeData(size: 24),
                  selectedFontSize: 14,
                  unselectedFontSize: 12,
                  selectedLabelStyle: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                  unselectedLabelStyle: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                  ),
                  items: [
                    BottomNavigationBarItem(
                      icon: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (context) => HomeScreen(),
                            ),
                            (route) => false,
                          );
                        },
                        child: Icon(Icons.whatshot_outlined),
                      ),
                      label: "Swipe",
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.bookmark_border_sharp),
                      label: "Saved",
                    ),
                    // BottomNavigationBarItem(
                    //   icon: Icon(Icons.calendar_today),
                    //   label: "Reservations",
                    // ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.person_outline),
                      label: "Profile",
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
