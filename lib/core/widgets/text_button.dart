import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class NeonButton extends StatefulWidget {
  final String text;
  final Color color;
  final double horizontalPadding;
  final double verticalPadding;
  final double borderRadius;
  final VoidCallback onPressed;

  const NeonButton({
    Key? key,
    required this.text,
    this.color = Colors.blueAccent,
    this.horizontalPadding = 10,
    this.verticalPadding = 5,
    this.borderRadius = 12,
    required this.onPressed,
  }) : super(key: key);

  @override
  _NeonButtonState createState() => _NeonButtonState();
}

class _NeonButtonState extends State<NeonButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..repeat(reverse: true);
    _glowAnimation = Tween<double>(
      begin: 10,
      end: 30,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _glowAnimation,
      builder: (context, child) {
        return GestureDetector(
          onTap: widget.onPressed,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: widget.horizontalPadding,
              vertical: widget.verticalPadding,
            ),
            decoration: BoxDecoration(
              color: widget.color.withOpacity(0.2),
              border: Border.all(color: widget.color, width: 1.5.w),
              borderRadius: BorderRadius.circular(widget.borderRadius),
              boxShadow: [
                // BoxShadow(
                //   color: widget.color.withOpacity(0.6),
                //   blurRadius: _glowAnimation.value,
                //   spreadRadius: 1,
                // ),
                // BoxShadow(
                //   color: widget.color.withOpacity(0.4),
                //   blurRadius: _glowAnimation.value * 0.5,
                //   spreadRadius: 1,
                // ),
              ],
            ),
            child: Text(
              widget.text,
              style: GoogleFonts.montserrat(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                // letterSpacing: 2.w,
                fontSize: 12.sp,
              ),
            ),
          ),
        );
      },
    );
  }
}
