import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:budget_bud/misc/widgetSize.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

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
      final snackBar = SnackBar(
        /// need to set following properties for best effect of awesome_snackbar_content
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: 'On Snap!',
          message: message,

          /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
          contentType: ContentType.failure,
        ),
      );

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);

      // showDialog(
      //     context: context,
      //     builder: (context) {
      //       return AlertDialog(
      //         backgroundColor: Colors.red.shade600,
      //         title: Text(
      //           message,
      //           style: TextStyle(
      //             color: Colors.white,
      //           ),
      //         ),
      //       );
      //     });
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
    bool showPassword = true;
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
                            'Hello New User!',
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
                                  style: ThemeText.textfieldInput,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.zero,
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
                                  style: ThemeText.textfieldInput,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.zero,
                                    prefixIcon: Icon(Icons.lock),
                                    hintText: 'Password',
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: BorderSide(
                                            color: AppColors.mainColorOne)),
                                  ),
                                  keyboardType: TextInputType.visiblePassword,
                                  textInputAction: TextInputAction.done,
                                ),
                                addVerticalSpace(15),
                                TextFormField(
                                  controller: confirmPwdController,
                                  obscureText: showPassword,
                                  style: ThemeText.textfieldInput,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.zero,
                                    prefixIcon: Icon(Icons.lock),
                                    hintText: 'Repeat Password',
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: BorderSide(
                                            color: AppColors.mainColorOne)),
                                  ),
                                  keyboardType: TextInputType.visiblePassword,
                                  textInputAction: TextInputAction.done,
                                ),
                              ],
                            ),
                          ),

                          //forgot password

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
                                    'or Sign up with',
                                    style: TextStyle(
                                      fontSize: 15.sp,
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
                              Text(
                                'Already have account? ',
                                style: ThemeText.paragraph,
                              ),
                              GestureDetector(
                                onTap: widget.onTap,
                                child: Text(
                                  'Sign In now',
                                  style: TextStyle(
                                      fontSize: 15.sp,
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
