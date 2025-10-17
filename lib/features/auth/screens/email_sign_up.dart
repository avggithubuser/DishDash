import 'package:auto_size_text/auto_size_text.dart';
import 'package:dish_dash/features/auth/methods/auth_methods.dart';
import 'package:dish_dash/features/auth/widgets/button.dart';
import 'package:dish_dash/features/auth/widgets/input_field.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EmailSignUp extends StatefulWidget {
  final void Function()? onTap;
  const EmailSignUp({super.key, required this.onTap});

  @override
  State<EmailSignUp> createState() => _EmailSignUpState();
}

class _EmailSignUpState extends State<EmailSignUp> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPwController = TextEditingController();
  bool hidePas = true;
  bool hideConfirmPas = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SizedBox(
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: AutoSizeText(
                        "DishDash.",
                        style: GoogleFonts.fraunces(
                          fontSize: MediaQuery.of(context).size.height * 0.03,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.05),

                    AutoSizeText(
                      "WELCOME",
                      style: GoogleFonts.fraunces(
                        color: Theme.of(context).textTheme.headlineLarge!.color,
                        fontSize: Theme.of(
                          context,
                        ).textTheme.headlineMedium!.fontSize,
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.05),

                    SingleChildScrollView(
                      child: Column(
                        children: [
                          MyTextField(
                            controller: usernameController,
                            obscureText: false,
                            labelText: "Username",
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.010,
                          ),
                          MyTextField(
                            controller: emailController,
                            obscureText: false,
                            labelText: "Email",
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.010,
                          ),
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
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.010,
                          ),
                          MyTextField(
                            controller: confirmPwController,
                            obscureText: hideConfirmPas,
                            labelText: "Confirm Password",
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  hideConfirmPas = !hideConfirmPas;
                                });
                              },
                              icon: Icon(
                                hideConfirmPas
                                    ? Icons.remove_red_eye_outlined
                                    : Icons.remove_red_eye,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.080,
                    ),
                    MyButton(
                      title: "Register",
                      onTap: () async {
                        await Authentication().emailSignUp(
                          usernameController.text,
                          emailController.text,
                          passwordController.text,
                          confirmPwController.text,
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
                      "Already have an account?",
                      style: TextStyle(
                        color: Theme.of(context).textTheme.headlineLarge!.color,
                      ),
                    ),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: AutoSizeText(
                        " Login now!",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(
                            context,
                          ).textTheme.headlineLarge!.color,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
