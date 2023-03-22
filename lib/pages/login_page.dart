import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../misc/btnStyles.dart';
import '../misc/txtStyles.dart';
import '../misc/widgetSize.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.account_balance_wallet,
                  size: size.height * 0.2,
                ),
                Text(
                  'Login',
                  style: ThemeText.textHeader1,
                ),
                Text(
                  'We missed you',
                  style: ThemeText.subHeader3,
                ),
                Form(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          decoration: InputDecoration(
                              prefixIcon: Icon(Icons.email),
                              labelText: 'Email',
                              hintText: 'Email',
                              border: OutlineInputBorder()),
                        ),
                        addVerticalSpace(20),
                        TextFormField(
                          decoration: InputDecoration(
                              prefixIcon: Icon(Icons.lock),
                              labelText: 'Password',
                              hintText: 'Password',
                              border: OutlineInputBorder(),
                              suffixIcon: IconButton(
                                onPressed: () {}, //add FUNCTIONALITY
                                icon: Icon(
                                  Icons.remove_red_eye_outlined,
                                ),
                              )),
                        ),
                        addVerticalSpace(20),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                              onPressed: () {},
                              child: Text('Forgot Password',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 10,
                                  ))),
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: buttonPrimary,
                            child: Text(
                              'Login'.toUpperCase(),
                            ), //btn style from another file
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Divider(
                                  height: 1,
                                  thickness: 1,
                                ),
                                Text(
                                  'OR',
                                ),
                                Divider(
                                  height: 1,
                                  thickness: 1,
                                ),
                              ],
                            ),
                            addVerticalSpace(20),
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton.icon(
                                icon: Icon(
                                  FontAwesomeIcons.google,
                                ),
                                style: buttonOutlined,
                                onPressed: () {},
                                label: Text('Sign up with Google'),
                              ),
                            ),
                            addVerticalSpace(10),
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton.icon(
                                icon: Icon(
                                  FontAwesomeIcons.apple,
                                ),
                                style: buttonOutlined,
                                onPressed: () {},
                                label: Text('Sign up with Google'),
                              ),
                            ),
                            addVerticalSpace(10),
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton.icon(
                                icon: Icon(
                                  FontAwesomeIcons.github,
                                ),
                                style: buttonOutlined,
                                onPressed: () {},
                                label: Text('Sign up with Google'),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
