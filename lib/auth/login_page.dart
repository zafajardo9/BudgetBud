import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../components/my_button.dart';
import '../components/squred_tiles.dart';
import '../misc/widgetSize.dart';
import '../services/auth_service.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;

  LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();

  final pwdController = TextEditingController();

  //Login user
  void signUserIn() async {
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
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: pwdController.text,
      );
      //pop Loading Circle
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);

      //show error message
      showErrorMessage(e.code);
    }
  }

  bool showPassword = true;

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
        backgroundColor: Colors.grey.shade200,
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //Logo
                Icon(
                  Icons.coffee_maker_rounded,
                  size: size.height * 0.2,
                ),
                //text welcome
                addVerticalSpace(15),
                Text(
                  'Make account',
                  style: TextStyle(color: Colors.black87, fontSize: 18),
                ),

                //textfield email
                addVerticalSpace(15),

                Padding(
                  padding: const EdgeInsets.all(
                    20,
                  ),
                  child: Form(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 20.0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //FORM AREA =======================
                          TextFormField(
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.email),
                                labelText: 'Email',
                                hintText: 'Email',
                                border: OutlineInputBorder()),
                          ),
                          addVerticalSpace(15),
                          //textfield password
                          TextFormField(
                            controller: pwdController,
                            obscureText: showPassword,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.lock),
                              labelText: 'Password',
                              hintText: 'Password',
                              border: OutlineInputBorder(),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
