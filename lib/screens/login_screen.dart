import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:expense/screens/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Constants/login_text_field.dart';
import '../db/app_db.dart';
import 'home_screen.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  static final String LOGIN_PREFS_KEY = "isLogin";

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image:
            AssetImage("assets/images/Login Screen BackGround Image.avif"),
            fit: BoxFit.cover),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 150, left: 30),
                  height: 270,
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AnimatedTextKit(
                        repeatForever: true,
                        isRepeatingAnimation: true,
                        animatedTexts: [
                          WavyAnimatedText(
                            "Welcome",
                            textStyle: GoogleFonts.habibi(
                              fontSize: 30,
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                      AnimatedTextKit(
                        repeatForever: true,
                        animatedTexts: [
                          TypewriterAnimatedText(
                            "Back",
                            speed: const Duration(milliseconds: 250),
                            textStyle: GoogleFonts.damion(
                              fontSize: 35,
                              color: Colors.black,
                              fontWeight: FontWeight.w900,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                CstmTextField(
                  hintText: "Enter your email",
                  controller: emailController,
                ),
                const SizedBox(height: 10),
                CstmTextField(
                  hintText: "Enter your password",
                  controller: passController,
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                    ),
                    onPressed: () async {
                      if (emailController.text.isNotEmpty &&
                          passController.text.isNotEmpty) {
                        var email = emailController.text.toString();
                        var pass = passController.text.toString();

                        var appDb = AppDataBase.instance;
                        if (await appDb.authenticateUser(email, pass)) {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (ctx) => const HomeScreen()));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                  Text("Invalid Email and Password !!!")));
                        }

                        var prefs = await SharedPreferences.getInstance();
                        prefs.setBool(LOGIN_PREFS_KEY, true);
                      }
                    },
                    child: const Text(
                      "Login",
                      style: TextStyle(
                        fontSize: 22,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                        onPressed: () {},
                        child: const Text(
                          "Forgot Password?",
                          style: TextStyle(fontSize: 17, color: Colors.black),
                        )),
                    const Divider(
                      height: 15,
                      thickness: 2,
                      color: Colors.black,
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (ctx) => SignUpScreen()));
                      },
                      child: const Text(
                        "Create New Account",
                        style: TextStyle(
                          fontSize: 22,
                          color: Colors.purple,
                        ),
                      ),
                    )
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