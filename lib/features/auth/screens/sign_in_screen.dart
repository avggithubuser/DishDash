import 'package:auto_size_text/auto_size_text.dart';
import 'package:dish_dash/features/auth/methods/auth_methods.dart';
import 'package:dish_dash/features/auth/screens/email_screen_switch.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dish_dash/core/services/theme_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController idController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height * 0.02,
            horizontal: MediaQuery.of(context).size.width * 0.07,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment:
                    MainAxisAlignment.start, // vertical alignment
                crossAxisAlignment:
                    CrossAxisAlignment.start, // horizontal alignment
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.09),

                  AutoSizeText(
                    "Dish",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  AutoSizeText(
                    "Dash.",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),

              // sign in options
              Column(
                children: [
                  // Google Button
                  GestureDetector(
                    onTap: () async {
                      await Authentication().otherSignIn("Google", context);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 20,
                      ),
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const FaIcon(
                            FontAwesomeIcons.google,
                            color: Colors.red,
                          ),
                          AutoSizeText(
                            "Continue with Google",
                            style: TextStyle(color: Colors.grey.shade800),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.016,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Facebook Button
                  GestureDetector(
                    onTap: () async {
                      await Authentication().otherSignIn("Facebook", context);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 20,
                      ),
                      decoration: BoxDecoration(
                        color: Color(0xFF1877F2), // Facebook blue
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const FaIcon(
                            FontAwesomeIcons.facebook,
                            color: Colors.white,
                          ),
                          const AutoSizeText(
                            "Continue with Facebook",
                            style: TextStyle(color: Colors.white),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.016,
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  // divider
                  Row(
                    children: [
                      Expanded(child: Divider(color: Colors.grey)),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.02,
                        ),
                        child: Text(
                          'or',
                          style: TextStyle(color: Colors.grey.shade800),
                        ),
                      ),
                      Expanded(child: Divider(color: Colors.grey)),
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  // go to email page
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => EmailScreenSwitch(),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 20,
                      ),
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Center(
                        child: AutoSizeText(
                          "Continue with Email",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
