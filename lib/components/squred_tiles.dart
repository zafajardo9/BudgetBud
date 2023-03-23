import 'package:flutter/material.dart';

class SquaredTiles extends StatelessWidget {
  final Function()? onTap;
  final String imageLocation;
  const SquaredTiles({
    super.key,
    required this.imageLocation,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(16),
            color: Colors.white),
        child: Image.asset(
          imageLocation,
          height: 40,
        ),
      ),
    );
  }
}
