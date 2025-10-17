import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class ReservationsScreen extends StatelessWidget {
  const ReservationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AutoSizeText(
          "R E S E R V A T I O N S",
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}
