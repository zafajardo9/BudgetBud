import 'package:budget_bud/misc/txtStyles.dart';
import 'package:flutter/material.dart';

flashMessage(BuildContext context) {
  var title = "Success";
  var details = 'Your Income Transaction has been recorded';
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Container(
        padding: EdgeInsets.all(8.0),
        height: 80,
        decoration: BoxDecoration(
            color: Colors.green.shade500,
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Row(
          children: [
            Icon(
              Icons.check,
              color: Colors.white,
              size: 40,
            ),
            SizedBox(
              width: 20,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: ThemeText.subHeader1Bold,
                  ),
                  Spacer(),
                  Text(
                    details,
                    style: ThemeText.paragraph54,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      elevation: 3,
    ),
  );
}
