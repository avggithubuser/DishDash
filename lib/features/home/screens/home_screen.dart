import 'dart:ui';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:dish_dash/features/home/screens/search_screen.dart';
import 'package:dish_dash/features/profile/screens/profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dish_dash/features/reservations/screens/reservations_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dish_dash/features/swipe/screens/swipe_screen.dart';
import 'package:dish_dash/features/saved/screens/saved_screen.dart';

// ignore: must_be_immutable
class HomeScreen extends StatefulWidget {
  String? searchedRestaurant;
  Map<String, Set<String>>? selectedFilters;
  List<String>? priceTags;

  HomeScreen({
    super.key,
    this.searchedRestaurant,
    this.priceTags,
    this.selectedFilters,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textColor = theme.textTheme.bodyLarge?.color;
    final background = theme.scaffoldBackgroundColor;
    final List<Widget> _screens = [
      SwipeScreen(
        matchName: widget.searchedRestaurant ?? '',
        priceTags: widget.priceTags ?? [],
        selectedFilters: widget.selectedFilters ?? {},
      ),
      const SavedScreen(),
      const ReservationsScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      extendBody: true,
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: colorScheme.primary,
        toolbarHeight: 110.h,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row 1: Title + filter + toggle
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AutoSizeText(
                  "DishDash",
                  maxLines: 1,
                  minFontSize: 18,
                  style: theme.textTheme.displayLarge?.copyWith(
                    color: textColor,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        // 🔹 Firebase logout (commented)
                        FirebaseAuth.instance.signOut();

                        // Offline mode message
                        // ScaffoldMessenger.of(context).showSnackBar(
                        //   const SnackBar(
                        //     content: Text("Offline mode: Sign-out disabled"),
                        //   ),
                        // );
                      },
                      icon: const Icon(Icons.exit_to_app),
                      iconSize: 30.r,
                      color: const Color.fromRGBO(246, 239, 210, 1),
                      tooltip: "Sign Out",
                    ),
                    // IconButton(
                    //   onPressed: () => _showTagsPopup(context),
                    //   icon: const Icon(Icons.sort),
                    //   iconSize: 32.r,
                    //   color: const Color.fromRGBO(246, 239, 210, 1),
                    //   tooltip: "Filter Tags",
                    // ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Row 2: Search bar
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => SearchScreen()),
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
                            padding: EdgeInsets.symmetric(horizontal: 8.w),
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
          ],
        ),
      ),

      body: _screens[_selectedIndex],

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
                  items: const [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.whatshot_outlined),
                      label: "Swipe",
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.bookmark_border_sharp),
                      label: "Saved",
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.calendar_today),
                      label: "Reservations",
                    ),
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
