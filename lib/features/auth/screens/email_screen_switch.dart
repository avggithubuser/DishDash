import 'package:dish_dash/features/auth/screens/email_login_in.dart';
import 'package:dish_dash/features/auth/screens/email_sign_up.dart';
import 'package:flutter/material.dart';

class EmailScreenSwitch extends StatefulWidget {
  const EmailScreenSwitch({super.key});

  @override
  State<EmailScreenSwitch> createState() => _EmailScreenSwitchState();
}

class _EmailScreenSwitchState extends State<EmailScreenSwitch> {
  // initially show login page
  bool showLogin = true;

  void togglePages() {
    setState(() {
      showLogin = !showLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    return showLogin
        ? EmailLoginIn(onTap: togglePages)
        : EmailSignUp(onTap: togglePages);
  }
}
