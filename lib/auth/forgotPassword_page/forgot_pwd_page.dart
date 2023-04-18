import 'package:budget_bud/misc/txtStyles.dart';
import 'package:budget_bud/misc/widgetSize.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../misc/colors.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final userEmailController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    userEmailController.dispose();
    super.dispose();
  }

  Future passwordResetBtn() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: userEmailController.text.trim());
      // using a BuildContext is bad practice in async
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text('Password link has been sent! Check your email.'),
          );
        },
      );
    } on FirebaseAuthException catch (e) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(e.message.toString()),
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reset Your Password'),
        elevation: 0,
      ),
      body: Column(
        children: [
          addVerticalSpace(40),
          Text(
            'Enter your Email',
            style: ThemeText.subHeader1Bold,
          ),
          addVerticalSpace(10),
          Text(
            'Enter your Email and we will send you a password reset link',
            style: ThemeText.paragraph54,
          ),
          addVerticalSpace(60),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: TextFormField(
              controller: userEmailController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.email),
                hintText: 'Email',
                contentPadding: EdgeInsets.zero,
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: AppColors.mainColorOne)),
              ),
              keyboardType: TextInputType.visiblePassword,
              textInputAction: TextInputAction.done,
            ),
          ),
          addVerticalSpace(60),
          GestureDetector(
            onTap: passwordResetBtn,
            child: Container(
              padding: EdgeInsets.all(20),
              margin: EdgeInsets.symmetric(horizontal: 25),
              decoration: BoxDecoration(
                  color: AppColors.mainColorOne,
                  borderRadius: BorderRadius.circular(15)),
              child: Center(
                child: Text(
                  'Reset Password',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
