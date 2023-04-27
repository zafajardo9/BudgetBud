import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

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
        width: Adaptive.w(100),
        height: Adaptive.h(7),
        margin: EdgeInsets.symmetric(horizontal: 25),
        decoration: BoxDecoration(
            color: AppColors.mainColorOne,
            borderRadius: BorderRadius.circular(15)),
        child: Center(
          child: Text(
            btn,
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 14.sp),
          ),
        ),
      ),
    );
  }
}
