import 'dart:ui';
import 'package:flutter/material.dart';

class GelToggleSwitch extends StatefulWidget {
  final VoidCallback onToggle;
  const GelToggleSwitch({Key? key, required this.onToggle}) : super(key: key);

  @override
  State<GelToggleSwitch> createState() => _GelToggleSwitchState();
}

class _GelToggleSwitchState extends State<GelToggleSwitch>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Sync initial position with current theme
    final isDark = Theme.of(context).brightness == Brightness.dark;
    _controller.value = isDark ? 1.0 : 0.0;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    widget.onToggle();
    // Play a local animation immediately for instant feedback
    if (_controller.status == AnimationStatus.completed) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          final isDark = _animation.value > 0.5;
          return ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                width: 60,
                height: 32,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: Colors.grey.withOpacity(0.18),
                    width: 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isDark
                          ? Color.fromRGBO(163, 29, 29, 1)
                          : Color.fromRGBO(200, 100, 100, 1),
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Align(
                      alignment: Alignment(_animation.value * 2 - 1, 0),
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: isDark
                                ? [Colors.redAccent, Colors.pinkAccent]
                                : [Colors.yellowAccent, Colors.orangeAccent],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: isDark
                                  ? Color.fromRGBO(163, 29, 29, 1)
                                  : Color.fromRGBO(200, 100, 100, 1),
                              blurRadius: 12,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: Icon(
                          isDark ? Icons.dark_mode : Icons.light_mode,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
