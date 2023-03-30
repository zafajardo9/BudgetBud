import 'package:flutter/material.dart';

class UserImageDetails extends StatelessWidget {
  const UserImageDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(),
        Column(children: [
          Text('Name'),
          Text('email@email.com'),
        ]),
      ],
    );
  }
}
