import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Constants/login_text_field.dart';
import '../db/app_db.dart';
import '../models/user_modal.dart';
import 'login_screen.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});

  final TextEditingController nameController = TextEditingController();
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 100),
                AnimatedTextKit(
                  repeatForever: true,
                  isRepeatingAnimation: true,
                  animatedTexts: [
                    WavyAnimatedText(
                      "Create your account",
                      textStyle: GoogleFonts.habibi(
                        fontSize: 30,
                        color: Colors.black,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                CstmTextField(
                  hintText: "Enter your name",
                  controller: nameController,
                ),
                const SizedBox(height: 10),
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
                      if (nameController.text.isNotEmpty &&
                          emailController.text.isNotEmpty &&
                          passController.text.isNotEmpty) {
                        var appDb = AppDataBase.instance;
                        var check = await appDb.createAccount(UserModel(
                          user_id: 0,
                          user_name: nameController.text.toString(),
                          user_email: emailController.text.toString(),
                          user_pass: passController.text.toString(),
                        ));

                        var msg = "";

                        if (check) {
                          msg = "Account created successfully";
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (ctx) => LoginScreen()));
                        } else {
                          msg = "Can't create account as email already exists";
                        }
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text(msg)));
                      }
                    },
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(
                        fontSize: 22,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Already have an account?",
                      style: TextStyle(fontSize: 18),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (ctx) => LoginScreen()));
                      },
                      child: const Text(
                        "Login",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
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