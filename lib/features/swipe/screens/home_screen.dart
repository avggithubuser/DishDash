import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dish_dash/features/swipe/screens/swipe_screen.dart';
import 'package:dish_dash/core/widgets/toggle_switch.dart';
import 'package:dish_dash/core/services/theme_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const SwipeScreen(),
    // SavedScreen(),
    // RegistrationScreen(),
    // ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = ThemeService.isDark(context);

    final primary = colorScheme.primary;
    final textColor = theme.textTheme.bodyLarge?.color;
    final background = theme.scaffoldBackgroundColor;

    return Scaffold(
      extendBody: true,
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: primary,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            "DishDash",
            style: theme.textTheme.displayLarge?.copyWith(color: textColor),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              onPressed: () {
                // TODO: Add tag action here
              },
              icon: const Icon(Icons.filter_alt_rounded),
              iconSize: 26,
              color: const Color.fromRGBO(246, 239, 210, 1),
              tooltip: "Filter Tags",
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: GelToggleSwitch(onToggle: ThemeService.toggle),
          ),
        ],
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
                  color: isDark
                      ? Colors.grey.shade900.withOpacity(0.6)
                      : Colors.grey.shade50.withOpacity(0.65),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: isDark
                        ? Colors.grey.shade700.withOpacity(0.5)
                        : Colors.grey.shade300.withOpacity(0.4),
                    width: 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isDark
                          ? Colors.black.withOpacity(0.4)
                          : Colors.grey.shade400.withOpacity(0.25),
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
                  selectedItemColor: isDark
                      ? Colors.white70
                      : colorScheme.primary,
                  unselectedItemColor: isDark
                      ? Colors.grey.shade500
                      : Colors.grey.shade600,
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
                      icon: Icon(Icons.local_dining),
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
                      icon: Icon(Icons.person),
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
