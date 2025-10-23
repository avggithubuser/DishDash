import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  var filled;
  var suffixIcon;
  bool obscureText;
  void Function(String)? onSubmitted;
  MyTextField({
    super.key,
    required this.controller,
    required this.obscureText,
    this.filled,
    this.suffixIcon,
    this.onSubmitted,
    required this.labelText,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      onSubmitted: onSubmitted,
      obscureText: obscureText,
      controller: controller,
      style: TextStyle(color: Theme.of(context).textTheme.headlineSmall!.color),
      decoration: InputDecoration(
        labelText: labelText,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
        ),
        labelStyle: GoogleFonts.inter(
          fontWeight: FontWeight.bold,
          fontSize: 18.sp,
          color: Theme.of(context).colorScheme.primary,
        ),
        counterText: '',
        filled: filled,
        suffixIcon: suffixIcon,
      ),
    );
  }
}
