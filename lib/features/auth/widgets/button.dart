import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class MyButton extends StatelessWidget {
  final String title;
  final void Function() onTap;
  double? width;
  Color? boxColor;

  MyButton({super.key, required this.title, required this.onTap, this.width});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.05,
        width: width ?? MediaQuery.of(context).size.width * 0.5,
        decoration: BoxDecoration(
          color: boxColor ?? Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(
            MediaQuery.of(context).size.width * 0.026,
          ),
        ),
        child: Center(child: AutoSizeText(title)),
      ),
    );
  }
}
