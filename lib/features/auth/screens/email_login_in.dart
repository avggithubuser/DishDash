import 'package:auto_size_text/auto_size_text.dart';
import 'package:dish_dash/features/auth/methods/auth_methods.dart';
import 'package:dish_dash/features/auth/widgets/button.dart';
import 'package:dish_dash/features/auth/widgets/input_field.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EmailLoginIn extends StatefulWidget {
  final void Function()? onTap;
  const EmailLoginIn({super.key, required this.onTap});

  @override
  State<EmailLoginIn> createState() => _EmailLoginInState();
}

class _EmailLoginInState extends State<EmailLoginIn> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool hidePas = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent),

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
                children: [
                  Center(
                    child: AutoSizeText(
                      "DishDash",
                      style: GoogleFonts.fraunces(
                        fontSize: MediaQuery.of(context).size.height * 0.07,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),

                  AutoSizeText(
                    textAlign: TextAlign.center,
                    "WELCOME BACK!",
                    style: GoogleFonts.fraunces(
                      color: Theme.of(context).textTheme.headlineLarge!.color,
                      fontSize: Theme.of(
                        context,
                      ).textTheme.headlineMedium!.fontSize,
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.08),

                  MyTextField(
                    controller: emailController,
                    obscureText: false,
                    labelText: "Email",
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.010),
                  MyTextField(
                    controller: passwordController,
                    obscureText: hidePas,
                    labelText: "Password",
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          hidePas = !hidePas;
                        });
                      },
                      icon: Icon(
                        hidePas
                            ? Icons.remove_red_eye_outlined
                            : Icons.remove_red_eye,
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.010),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        child: AutoSizeText(
                          "Forgot Password?",
                          style: TextStyle(
                            color: Theme.of(
                              context,
                            ).textTheme.headlineLarge!.color,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: MediaQuery.of(context).size.height * 0.080),
                  MyButton(
                    title: "Login",
                    onTap: () async {
                      await Authentication().emailLogin(
                        emailController.text,
                        passwordController.text,
                        context,
                      );
                    },
                  ),
                ],
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AutoSizeText(
                    "Don't have an account?",
                    style: TextStyle(
                      color: Theme.of(context).textTheme.headlineLarge!.color,
                    ),
                  ),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: AutoSizeText(
                      " Register now!",
                      style: TextStyle(
                        color: Theme.of(context).textTheme.headlineLarge!.color,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
