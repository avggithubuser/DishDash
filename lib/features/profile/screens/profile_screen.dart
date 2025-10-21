import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: AutoSizeText("P R O F I L E")));
  }
}
