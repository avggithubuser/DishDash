import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class IconNeonButton extends StatelessWidget {
  final Widget? icon;
  final VoidCallback? onPressed;
  final Color bgcolor;
  final double size;

  const IconNeonButton({
    Key? key,
    this.icon,
    this.onPressed,
    this.bgcolor = Colors.pink,
    this.size = 40,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed ?? () {},
      child: Container(
        width: size.w,
        height: size.w,
        decoration: BoxDecoration(
          color: bgcolor.withOpacity(0.2), // semi-transparent neon bg
          border: Border.all(color: bgcolor, width: 1.5.w), // solid border
          borderRadius: BorderRadius.circular(12.w),
        ),
        child: Center(child: icon ?? SizedBox.shrink()),
      ),
    );
  }
}
