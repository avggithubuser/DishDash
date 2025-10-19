import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget buildActionButton({
  String? assetPath, // 👈 use this for custom image icons
  IconData? icon, // fallback if you want a normal icon
  String? label,
  required Color color,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(10.w),
        border: Border.all(color: color.withOpacity(0.5), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (assetPath != null) ...[
            Image.asset(
              assetPath,
              width: 20.w,
              height: 20.w,
              fit: BoxFit.contain,
            ),
            SizedBox(width: 4.w),
          ] else if (icon != null) ...[
            Icon(icon, color: color, size: 22.sp),
            SizedBox(width: 4.w),
          ],

          if (label != null)
            Text(
              label!,
              style: TextStyle(
                color: color,
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
        ],
      ),
    ),
  );
}
