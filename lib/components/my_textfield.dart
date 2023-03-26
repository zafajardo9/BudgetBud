import 'package:flutter/material.dart';

import '../misc/colors.dart';

class MyTextField extends StatelessWidget {
  final controller;
  final String hintText;
  final bool obscureText;

  const MyTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.mainColorOne)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.mainColorOne)),
            fillColor: AppColors.mainColorFour,
            filled: true,
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey[400])),
      ),
    );
  }
}
