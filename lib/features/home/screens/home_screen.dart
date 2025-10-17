import 'dart:ui';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dish_dash/features/swipe/screens/swipe_screen.dart';
import 'package:dish_dash/features/saved/screens/saved_screen.dart';
import 'package:dish_dash/core/widgets/toggle_switch.dart';
import 'package:dish_dash/core/services/theme_service.dart';

// Tag colors for popup
final List<Color> _tagColors = [
  Colors.blueAccent,
  Colors.amberAccent,
  Colors.greenAccent,
  Colors.pinkAccent,
  Colors.orangeAccent,
  Colors.purpleAccent,
  Colors.cyanAccent,
];

Widget _tagChip(String label, Color color) {
  return FilterChip(
    label: Text(
      label,
      style: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
        color: Colors.white,
      ),
    ),
    backgroundColor: color.withOpacity(0.25),
    selectedColor: color.withOpacity(0.55),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12.r),
      side: BorderSide(color: color.withOpacity(0.4)),
    ),
    onSelected: (bool selected) {},
  );
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final TextEditingController _searchController = TextEditingController();

  final List<Widget> _screens = [const SwipeScreen(), const SavedScreen()];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _showTagsPopup(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        // final isDark = ThemeService.isDark(context);
        final colorScheme = Theme.of(context).colorScheme;
        final tags = [
          "Desi",
          "Vegan",
          "Fast Food",
          "Chinese",
          "Healthy",
          "Dessert",
        ];

        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  colorScheme.primary.withOpacity(0.2),
                  colorScheme.secondary.withOpacity(0.2),
                ],
              ),
              border: Border.all(
                color: Colors.white.withOpacity(0.4),
                width: 1.2,
              ),
            ),
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 28.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40.w,
                    height: 5.h,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                Center(
                  child: Text(
                    "Select Tags",
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                Wrap(
                  spacing: 10.w,
                  runSpacing: 10.h,
                  children: List.generate(
                    tags.length,
                    (index) => _tagChip(
                      tags[index],
                      _tagColors[index % _tagColors.length],
                    ),
                  ),
                ),
                SizedBox(height: 24.h),
                SizedBox(
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
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Apply"),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    // final isDark = ThemeService.isDark(context);
    final textColor = theme.textTheme.bodyLarge?.color;
    final background = theme.scaffoldBackgroundColor;

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
                        // Example logout hook
                        FirebaseAuth.instance.signOut();
                      },
                      icon: const Icon(Icons.exit_to_app),
                      iconSize: 30.r,
                      color: const Color.fromRGBO(246, 239, 210, 1),
                      tooltip: "Sign Out",
                    ),
                    IconButton(
                      onPressed: () => _showTagsPopup(context),
                      icon: const Icon(Icons.sort),
                      iconSize: 32.r,
                      color: const Color.fromRGBO(246, 239, 210, 1),
                      tooltip: "Filter Tags",
                    ),
                    // GelToggleSwitch(onToggle: ThemeService.toggle),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Row 2: Search bar
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 40.h,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      controller: _searchController,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: Colors.black87,
                      ),
                      decoration: InputDecoration(
                        hintText: "Search Karachi's best food directory...",
                        hintStyle: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.grey.shade400,
                        ),
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.grey.shade500,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                      onChanged: (query) {
                        // TODO: implement search/filter logic
                      },
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
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(
                height: 72,
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
