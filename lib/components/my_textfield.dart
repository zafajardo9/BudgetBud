import 'package:flutter/material.dart';

import '../misc/colors.dart';

class MyTextField extends StatelessWidget {
  final controller;
  final String hintText;
  final String kbType;
  // final String preIcon;
  // final String lastIcon;
  final bool obscureText;

  const MyTextField({
    super.key,
    required this.kbType,
    required this.controller,
    required this.hintText,
    required this.obscureText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.email), // kulang sa focus border color
          hintText: 'Email',
          contentPadding: EdgeInsets.zero,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),

          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: AppColors.mainColorOne)),
        ),
      ),
    );
  }
}
