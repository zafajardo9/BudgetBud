import 'package:budget_bud/misc/colors.dart';
import 'package:budget_bud/misc/txtStyles.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'dialog/policy_dialog.dart';

class TermsOfUse extends StatelessWidget {
  TermsOfUse({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          text: "By creating an account, you are agreeing to our\n",
          style: ThemeText.paragraph54,
          children: [
            TextSpan(
              text: "Terms & Conditions ",
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: AppColors.deleteButton),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return PolicyDialog(
                        mdFileName: 'terms_and_conditions.md',
                      );
                    },
                  );
                },
            ),
            TextSpan(text: "and "),
            TextSpan(
              text: "Privacy Policy! ",
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: AppColors.deleteButton),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return PolicyDialog(mdFileName: 'privacy_policy.md');
                    },
                  );
                },
            ),
          ],
        ),
      ),
    );
  }
}
