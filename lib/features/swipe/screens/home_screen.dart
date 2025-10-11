import 'package:flutter/material.dart';
import 'package:dish_dash/features/swipe/screens/swipe_screen.dart';
import 'package:dish_dash/main.dart'; // for ThemeService
import '../../swipe/widgets/toggle_switch.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // Screens for navigation
  final List<Widget> _screens = [
    const SwipeScreen(),
    // MatchesScreen(),
    // ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Theme-aware colors
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = isDark
        ? const Color.fromRGBO(163, 29, 29, 1)
        : const Color.fromRGBO(200, 100, 100, 1);
    final background = isDark
        ? const Color(0xFF121212)
        : const Color.fromRGBO(236, 220, 191, 1);
    final textColor = isDark
        ? Colors.white
        : const Color.fromRGBO(248, 242, 222, 1);
    final dockColor = isDark ? const Color(0xFF1F1F1F) : Colors.white;

    return Scaffold(
      extendBody: true,
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: primary,
        title: Text(
          "DishDash",
          style: Theme.of(
            context,
          ).textTheme.displayLarge?.copyWith(color: textColor),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: GelToggleSwitch(onToggle: ThemeService.toggle),
          ),
        ],
      ),
      body: _screens[_selectedIndex],

      // Floating rounded bottom navigation bar
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: Container(
            height: 72,
            decoration: BoxDecoration(
              color: dockColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                if (!isDark)
                  BoxShadow(
                    color: Colors.black.withOpacity(0.12),
                    blurRadius: 18,
                    offset: const Offset(0, 6),
                  ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: BottomNavigationBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                currentIndex: _selectedIndex,
                onTap: _onItemTapped,
                type: BottomNavigationBarType.fixed,

                selectedItemColor: primary,
                unselectedItemColor: isDark
                    ? Colors.grey.shade400
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
                    icon: Icon(Icons.favorite),
                    label: "Matches",
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
    );
  }
}
