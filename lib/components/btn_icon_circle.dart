import 'package:budget_bud/misc/colors.dart';
import 'package:flutter/material.dart';

class IconButtonCircle extends StatelessWidget {
  final VoidCallback? onPressed;
  final ElevatedButton? button;
  final Icon icon;

  const IconButtonCircle({
    Key? key,
    this.onPressed,
    required this.icon,
    this.button,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: CircleBorder(),
        padding: EdgeInsets.all(16),
        primary: AppColors.blackBtn
            .withOpacity(0.2), // Set the desired opacity background color
        elevation: 0, // Remove the shadow by setting the elevation to 0
      ),
      child: Icon(
        icon.icon,
        size: icon.size,
        color: icon.color, // Set the desired opacity color for the icon
      ),
    );
  }
}
