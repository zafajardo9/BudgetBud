import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:budget_bud/auth/sendEmail.dart';
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

  //Login user
  void signUserIn() async {
    FocusManager.instance.primaryFocus?.unfocus();

    // Validate
    if (emailController.text.isEmpty) {
      showErrorMessage("Please input your Email");
      return;
    }
    if (pwdController.text.isEmpty) {
      showErrorMessage("Please input your Password");
      return;
    }

    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      showDialog(
        context: context,
        barrierDismissible:
            false, // Prevent dismissing the dialog by tapping outside
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      );

      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text,
          password: pwdController.text,
        );

        // Dismiss the dialog
        Navigator.pop(context);

        // Clear the text fields
        emailController.clear();
        pwdController.clear();

        await sendEmail();
      } on FirebaseAuthException catch (e) {
        // Dismiss the dialog
        Navigator.pop(context);

        // Handle the different exception cases
        if (e.code == 'network-request-failed') {
          showErrorMessage("There is a problem with the internet connection");
        } else if (e.code == "wrong-password") {
          showErrorMessage('Please enter the correct password');
        } else if (e.code == 'user-not-found') {
          showErrorMessage('Email not found, please Sign Up!');
        } else if (e.code == 'too-many-requests') {
          showErrorMessage('Too many attempts, please try again later');
        } else if (e.code == 'invalid-email') {
          showErrorMessage('You entered an incorrect email');
        } else if (e.code == 'unknown') {
          showErrorMessage('Email and Password fields are required');
        } else {
          showErrorMessage(e.code);
        }
      }
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
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.mainColorOne,
                AppColors.mainColorOneSecondary,
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //Logo
              Container(
                width: double.infinity,
                child: Image.asset(
                  'assets/bbLogo.png',
                  height: size.height * 0.25,
                ),
              ),

              //textfield email

              Expanded(
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
                        addVerticalSpace(2),
                        Text(
                          'Welcome Back',
                          style: ThemeText.headerAuth,
                        ),
                        Text(
                          'Input your email and password',
                          style: ThemeText.subAuth,
                        ),

                        addVerticalSpace(2),
                        //FORM AREA =======================
                        SizedBox(
                          width: Adaptive.w(90),
                          child: Form(
                            key: formKey,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            child: Column(
                              children: [
                                Semantics(
                                  explicitChildNodes: true,
                                  child: TextFormField(
                                    key: Key('emailTextField'),
                                    controller: emailController,
                                    keyboardType: TextInputType.emailAddress,
                                    style: ThemeText.textfieldInput,
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(Icons.email,
                                          color: AppColors
                                              .mainColorOne), // kulang sa focus border color
                                      hintText: 'Email',
                                      contentPadding: EdgeInsets.zero,
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20)),

                                      focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          borderSide: BorderSide(
                                              color: AppColors.mainColorOne)),
                                    ),
                                    validator: validateEmail,
                                  ),
                                ),

                                addVerticalSpace(1.5),
                                //textfield password
                                Semantics(
                                  explicitChildNodes: true,
                                  child: TextFormField(
                                    key: Key('pwdTextField'),
                                    controller: pwdController,
                                    obscureText: _isObscured,
                                    style: ThemeText.textfieldInput,
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(Icons.lock,
                                          color: AppColors.mainColorOne),
                                      hintText: 'Password',
                                      contentPadding: EdgeInsets.zero,
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          borderSide: BorderSide(
                                              color: AppColors.mainColorOne)),
                                    ),
                                    keyboardType: TextInputType.visiblePassword,
                                    textInputAction: TextInputAction.done,
                                    validator: validatePassword,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        addVerticalSpace(1.5),
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

                        addVerticalSpace(1.5),

                        //sign in btn
                        MyButton(
                          btn: "Log In",
                          onTap: signUserIn,
                        ),

                        // other ways
                        addVerticalSpace(2),

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
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
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
                            addHorizontalSpace(2),
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
            ],
          ),
        ),
      ),
    );
  }
}
