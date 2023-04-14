import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../misc/txtStyles.dart';
import '../../../misc/widgetSize.dart';

class ProfilePageDetailTile extends StatefulWidget {
  const ProfilePageDetailTile({Key? key}) : super(key: key);

  @override
  State<ProfilePageDetailTile> createState() => _ProfilePageDetailTileState();
}

class _ProfilePageDetailTileState extends State<ProfilePageDetailTile> {
  //firebase variables

  final user = FirebaseAuth.instance.currentUser!;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
          child: Row(
            children: [
              Icon(
                Icons.account_circle,
                size: 40,
                color: Colors.black54,
              ),
              addHorizontalSpace(30),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Username',
                    style: ThemeText.subHeader3Bold,
                  ),
                  Text(
                    user.displayName != null
                        ? user.email!.replaceFirst("@gmail.com", '')
                        : '${user.displayName}',
                    style: ThemeText.paragraph54,
                  ),
                ],
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
          child: Row(
            children: [
              Icon(
                Icons.email_outlined,
                size: 40,
                color: Colors.black54,
              ),
              addHorizontalSpace(30),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Email',
                    style: ThemeText.subHeader3Bold,
                  ),
                  Text(
                    '${user.email}',
                    style: ThemeText.paragraph54,
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}