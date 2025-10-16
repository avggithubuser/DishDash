import 'package:flutter/material.dart';
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
        border: UnderlineInputBorder(),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade700),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
        ),
        labelStyle: GoogleFonts.inter(
          fontWeight: FontWeight.bold,
          fontSize: MediaQuery.of(context).size.height * 0.025,
          color: Theme.of(context).colorScheme.primary,
        ),
        counterText: '',
        filled: filled,
        suffixIcon: suffixIcon,
        hintStyle: TextStyle(color: Colors.grey[600]),
      ),
    );
  }
}
