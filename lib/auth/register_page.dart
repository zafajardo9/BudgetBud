import 'package:budget_bud/misc/widgetSize.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../components/my_button.dart';
import '../components/squred_tiles.dart';
import '../misc/colors.dart';
import '../misc/txtStyles.dart';
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
    //screen size to use
    final size = MediaQuery.of(context).size;
    //for show/hide
    bool showPassword = false;
    void togglevisibility() {
      setState(() {
        showPassword = !showPassword;
      });
    }

    //END VARIABLES
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: AppColors.backgroundWhite,
        body: Container(
          width: double.infinity,
          color: AppColors.mainColorOne,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //Logo
              Container(
                width: double.infinity,
                color: AppColors.mainColorOne,
                child: Image.asset(
                  'assets/bbLogo.png',
                  height: size.height * 0.15,
                ),
              ),

              //textfield email

              Expanded(
                child: Form(
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadiusDirectional.only(
                          topStart: Radius.circular(25),
                          topEnd: Radius.circular(25),
                        )),
                    padding: EdgeInsets.symmetric(
                      vertical: 20.0,
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          //text welcome
                          addVerticalSpace(25),
                          Text(
                            'Welcome Back',
                            style: ThemeText.headerAuth,
                          ),
                          Text(
                            'Enter your details',
                            style: ThemeText.subAuth,
                          ),

                          addVerticalSpace(20),
                          //FORM AREA =======================
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              children: [
                                TextFormField(
                                  controller: emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(Icons
                                        .email), // kulang sa focus border color
                                    hintText: 'Email',
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)),

                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: BorderSide(
                                            color: AppColors.mainColorOne)),
                                  ),
                                ),

                                addVerticalSpace(15),
                                //textfield password
                                TextFormField(
                                  controller: pwdController,
                                  obscureText: showPassword,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.lock),
                                    hintText: 'Password',
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: BorderSide(
                                            color: AppColors.mainColorOne)),
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        togglevisibility();
                                      }, //add FUNCTIONALITY
                                      icon: Icon(
                                        showPassword
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                      ),
                                    ),
                                  ),
                                  keyboardType: TextInputType.visiblePassword,
                                  textInputAction: TextInputAction.done,
                                ),
                                addVerticalSpace(15),
                                TextFormField(
                                  controller: pwdController,
                                  obscureText: showPassword,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.lock),
                                    hintText: 'Repeat Password',
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: BorderSide(
                                            color: AppColors.mainColorOne)),
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        togglevisibility();
                                      }, //add FUNCTIONALITY
                                      icon: Icon(
                                        showPassword
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                      ),
                                    ),
                                  ),
                                  keyboardType: TextInputType.visiblePassword,
                                  textInputAction: TextInputAction.done,
                                ),
                              ],
                            ),
                          ),

                          addVerticalSpace(15),
                          //forgot password
                          GestureDetector(
                            onTap: () {}, //function
                            child: Text(
                              'Forgot Password',
                              style: TextStyle(
                                  color: Colors.black45,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),

                          //textfield password

                          addVerticalSpace(15),

                          //sign in btn
                          MyButton(
                            btn: "Sign Up",
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Text(
                                    'or Sign in with',
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
                                btnName: ' Google',
                              ),
                              addHorizontalSpace(20),
                              SquaredTiles(
                                onTap: () {},
                                imageLocation: 'images/apple.png',
                                btnName: ' Apple',
                              ),
                            ],
                          ),

                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('New user? '),
                              GestureDetector(
                                onTap: widget.onTap,
                                child: Text(
                                  'Register here',
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
