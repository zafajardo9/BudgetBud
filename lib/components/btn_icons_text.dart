import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class IconButtonWithText extends StatelessWidget {
  final VoidCallback? onPressed;
  final Icon icon;
  final String label;

  const IconButtonWithText({
    Key? key,
    this.onPressed,
    required this.icon,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
          onPressed: onPressed,
          icon: icon,
          color: Colors.white,
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: 15.sp,
          ),
        ),
      ],
    );
  }
}
