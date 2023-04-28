import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:budget_bud/auth/validators/validators.dart';
import 'package:budget_bud/misc/colors.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../components/my_button.dart';
import '../components/squred_tiles.dart';
import '../misc/txtStyles.dart';
import '../misc/widgetSize.dart';
import '../services/auth_service.dart';
import 'forgotPassword_page/forgot_pwd_page.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;

  LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final pwdController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    emailController.dispose();
    pwdController.dispose();
    super.dispose();
  }

  //Login user
  void signUserIn() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
    }

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
          title: 'Error',
          message: message,

          /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
          contentType: ContentType.failure,
        ),
      );

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);
    }

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: pwdController.text,
      );
      //pop Loading Circle
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      if (e.code == 'network-request-failed') {
        showErrorMessage("There is a problem on internet connection");
        //devtools.log('No Internet Connection');
      } else if (e.code == "wrong-password") {
        showErrorMessage('Please enter correct password');
      } else if (e.code == 'user-not-found') {
        showErrorMessage('Email not found, Please Sign-Up!');
        // print('Email not found');
      } else if (e.code == 'too-many-requests') {
        showErrorMessage('Too many attempts please try later');
      } else if (e.code == 'invalid-email') {
        showErrorMessage('You inputted a wrong email!');
      } else if (e.code == 'unknown') {
        showErrorMessage('Email and Password Fields are required');
        //print(e.code);
      } else {
        showErrorMessage(e.code);
      }
      emailController.clear();
      pwdController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    //screen size to use
    final size = MediaQuery.of(context).size;
    //for show/hide
    bool _isObscured = true;

    void toggleVisibility() {
      setState(() {
        _isObscured = !_isObscured;
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
                  height: size.height * 0.25,
                ),
              ),

              //textfield email

              Expanded(
                child: Form(
                  key: formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
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
                          addVerticalSpace(20),
                          Text(
                            'Welcome Back',
                            style: ThemeText.headerAuth,
                          ),
                          Text(
                            'Input your email and password',
                            style: ThemeText.subAuth,
                          ),

                          addVerticalSpace(20),
                          //FORM AREA =======================
                          SizedBox(
                            width: Adaptive.w(90),
                            child: Column(
                              children: [
                                TextFormField(
                                  controller: emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  style: ThemeText.textfieldInput,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(Icons
                                        .email), // kulang sa focus border color
                                    hintText: 'Email',
                                    contentPadding: EdgeInsets.zero,
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)),

                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: BorderSide(
                                            color: AppColors.mainColorOne)),
                                  ),
                                  validator: validateEmail,
                                ),

                                addVerticalSpace(15),
                                //textfield password
                                TextFormField(
                                  controller: pwdController,
                                  obscureText: _isObscured,
                                  style: ThemeText.textfieldInput,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.lock),
                                    hintText: 'Password',
                                    contentPadding: EdgeInsets.zero,
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
                                  validator: validatePassword,
                                ),
                              ],
                            ),
                          ),

                          addVerticalSpace(15),
                          //forgot password
                          GestureDetector(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return ForgotPasswordPage();
                              }));
                            }, //function
                            child: Text(
                              'Forgot Password',
                              style: ThemeText.paragraph54Bold,
                            ),
                          ),

                          //textfield password

                          addVerticalSpace(15),

                          //sign in btn
                          MyButton(
                            btn: "Log In",
                            onTap: signUserIn,
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
                          SizedBox(height: 20),
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
                                'New user? ',
                                style: ThemeText.paragraph,
                              ),
                              GestureDetector(
                                onTap: widget.onTap,
                                child: Text(
                                  'Register here',
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
