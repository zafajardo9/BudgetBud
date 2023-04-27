import 'package:budget_bud/misc/colors.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SquaredTiles extends StatelessWidget {
  final Function()? onTap;
  final String imageLocation;
  final String btnName;

  const SquaredTiles({
    super.key,
    required this.imageLocation,
    required this.onTap,
    required this.btnName,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: Adaptive.w(30),
        height: Adaptive.w(10),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
            border: Border.all(color: AppColors.mainColorFour),
            borderRadius: BorderRadius.circular(15),
            color: Colors.white),
        child: Row(
          children: [
            Image.asset(
              imageLocation,
              height: Adaptive.w(40),
            ),
            Text(
              btnName,
              style: TextStyle(fontSize: 15.sp),
            ),
          ],
        ),
      ),
    );
  }
}
