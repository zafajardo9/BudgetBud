import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:budget_bud/auth/validators/validators.dart';
import 'package:budget_bud/misc/widgetSize.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:validators/validators.dart';

import '../components/my_button.dart';
import '../components/squred_tiles.dart';
import '../data/user_data.dart';
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
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final confirmPwdController = TextEditingController();
  final pwdController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    emailController.dispose();
    confirmPwdController.dispose();
    confirmPwdController.dispose();
    super.dispose();
  }

  //Login user
  void signUserUp() async {
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
          title: 'Error!',
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
      //check if password and confirm password is same
      if (pwdController.text == confirmPwdController.text) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: pwdController.text,
        );
        String extractUsername(String email) {
          final usernameRegex = RegExp(r'^([^@]+)@');
          final match = usernameRegex.firstMatch(email);
          return match?.group(1) ?? '';
        }

        var user = UserData(
          userEmail: emailController.text,
          userName: extractUsername(emailController.text),
        );
        await FirebaseFirestore.instance.collection('User').add(user.toJson());
      } else {
        //error if not the same
        showErrorMessage("Password don't match");
      }
      //pop Loading Circle
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      if (e.code == 'network-request-failed') {
        showErrorMessage("There is a problem on internet connection");
        //devtools.log('No Internet Connection');
      } else if (e.code == "email-already-in-use") {
        showErrorMessage('There is already an account existing');
      } else if (e.code == 'operation-not-allowed') {
        showErrorMessage('There is a problem in the Authentication');
      } else if (e.code == 'too-many-requests') {
        showErrorMessage('Too many attempts please try later');
      } else if (e.code == 'invalid-email') {
        showErrorMessage('You inputted a wrong email!');
      } else if (e.code == 'unknown') {
        showErrorMessage('Email and Password Fields are required');
      } else if (e.code == 'weak-password') {
        showErrorMessage('Weak Password pls input more than 6');
      }
      emailController.clear();
      pwdController.clear();
      confirmPwdController.clear();
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
                          addVerticalSpace(2),
                          Text(
                            'Hello New User!',
                            style: ThemeText.headerAuth,
                          ),
                          Text(
                            'Enter your details',
                            style: ThemeText.subAuth,
                          ),

                          addVerticalSpace(2),
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
                                    prefixIcon: Icon(Icons.email,
                                        color: isEmailCorrect == false
                                            ? AppColors.mainColorOne
                                            : Colors
                                                .green), // kulang sa focus border color
                                    hintText: 'Email',
                                    suffixIcon: isEmailCorrect == false
                                        ? null
                                        : const Icon(
                                            Icons.done,
                                            color: Colors.green,
                                          ),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)),

                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: BorderSide(
                                            color: isEmailCorrect == false
                                                ? AppColors.mainColorOne
                                                : Colors.green)),
                                  ),
                                  validator: validateEmailSignUp,
                                  onChanged: (val) {
                                    setState(() {
                                      isEmailCorrect = isEmail(val);
                                    });
                                  },
                                ),

                                addVerticalSpace(1.5),
                                //textfield password
                                TextFormField(
                                  controller: pwdController,
                                  obscureText: showPassword,
                                  style: ThemeText.textfieldInput,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.zero,
                                    prefixIcon: Icon(Icons.lock,
                                        color: isPasswordCorrect == false
                                            ? AppColors.mainColorOne
                                            : Colors.green),
                                    hintText: 'Password',
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: BorderSide(
                                          color: isPasswordCorrect == false
                                              ? AppColors.mainColorOne
                                              : Colors.green),
                                    ),
                                  ),
                                  keyboardType: TextInputType.visiblePassword,
                                  textInputAction: TextInputAction.done,
                                  validator: validatePasswordSignUp,
                                  onChanged: (val) {
                                    setState(() {
                                      isPasswordCorrect = isLength(val, 6);
                                    });
                                  },
                                ),
                                addVerticalSpace(1.5),
                                TextFormField(
                                  controller: confirmPwdController,
                                  obscureText: showPassword,
                                  style: ThemeText.textfieldInput,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.zero,
                                    prefixIcon: Icon(Icons.lock,
                                        color: isRPwdCorrect == false
                                            ? AppColors.mainColorOne
                                            : Colors.green),
                                    hintText: 'Repeat Password',
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: BorderSide(
                                            color: isRPwdCorrect == false
                                                ? AppColors.mainColorOne
                                                : Colors.green)),
                                  ),
                                  keyboardType: TextInputType.visiblePassword,
                                  textInputAction: TextInputAction.done,
                                  validator: (val) {
                                    if (val == null || val.isEmpty) {
                                      return 'This field is required.';
                                    } else if (val !=
                                        confirmPwdController.text) {
                                      return 'Does not match to password';
                                    }

                                    return null;
                                  },
                                  onChanged: (val) {
                                    setState(() {
                                      isRPwdCorrect = isLength(val, 6);
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),

                          //forgot password

                          //textfield password

                          addVerticalSpace(1.5),

                          //sign in btn
                          MyButton(
                            btn: "Sign Up",
                            onTap: signUserUp,
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
                          addVerticalSpace(2.5),
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
                                onTap: null,
                                imageLocation: 'images/apple.png',
                                btnName: ' Apple',
                              ),
                            ],
                          ),

                          addVerticalSpace(2),
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
