import 'package:flutter/material.dart';
import '../../misc/colors.dart';
import '../../misc/txtStyles.dart';
import 'components/user_detail_header.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Profile',
            style: ThemeText.appBarTitle,
          ),
        ),
        body: Container(
          color: AppColors.mainColorOne,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              UserImageDetails(),
            ],
          ),
        ),
      ),
    );
  }
}
