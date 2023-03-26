import 'package:flutter/material.dart';
import '../misc/colors.dart';

class MyButton extends StatelessWidget {
  final Function()? onTap;
  final String btn;
  const MyButton({
    super.key,
    required this.onTap,
    required this.btn,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(20),
        margin: EdgeInsets.symmetric(horizontal: 25),
        decoration: BoxDecoration(
            color: AppColors.mainColorOne,
            borderRadius: BorderRadius.circular(15)),
        child: Center(
          child: Text(
            btn,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}
