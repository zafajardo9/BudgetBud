import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../components/my_button.dart';
import '../components/my_textfield.dart';
import '../components/squred_tiles.dart';
import '../services/auth_service.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;

  RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final confirmPwdController = TextEditingController();
  final pwdController = TextEditingController();

  //Login user
  void signUserUp() async {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    //error handler message
    void showErrorMessage(String message) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              backgroundColor: Colors.red.shade600,
              title: Text(
                message,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            );
          });
    }

    try {
      //check if password and confirm password is same
      if (pwdController.text == confirmPwdController.text) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: pwdController.text,
        );
      } else {
        //error if not the same
        showErrorMessage("Password don't match");
      }

      //pop Loading Circle
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);

      //show error message
      showErrorMessage(e.code);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey.shade200,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 50),
                //Logo
                Icon(
                  Icons.coffee_maker_rounded,
                  size: 100,
                ),
                //text welcome
                SizedBox(height: 50),
                Text(
                  'Make account',
                  style: TextStyle(color: Colors.black87, fontSize: 18),
                ),

                //textfield email
                SizedBox(height: 25),

                MyTextField(
                  controller: emailController,
                  hintText: 'Email',
                  obscureText: false,
                ),
                SizedBox(height: 15),
                //textfield password
                MyTextField(
                  controller: pwdController,
                  hintText: 'Password',
                  obscureText: true,
                ),
                SizedBox(height: 15),

                //textfield password
                MyTextField(
                  controller: confirmPwdController,
                  hintText: 'Confirm Password',
                  obscureText: true,
                ),
                SizedBox(height: 25),

                //sign in btn
                MyButton(
                  btn: "Create Account",
                  onTap: signUserUp,
                ),

                // other ways
                SizedBox(height: 20),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.red.shade300,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          'Or with',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.red.shade300,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SquaredTiles(
                      onTap: () => AuthService().signInWithGoogle(),
                      imageLocation: 'images/google.png',
                    ),
                    SizedBox(width: 20),
                    SquaredTiles(
                      onTap: () {},
                      imageLocation: 'images/apple.png',
                    ),
                    SizedBox(width: 20),
                    SquaredTiles(
                      onTap: () {},
                      imageLocation: 'images/github.png',
                    ),
                  ],
                ),

                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Have a account? '),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: Text(
                        'Sign in Here',
                        style: TextStyle(
                            color: Colors.red.shade900,
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
