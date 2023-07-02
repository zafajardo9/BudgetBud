import 'package:flutter/material.dart';

class WaveLeft extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(0, size.height / 40); // Start at the bottom-left corner

    // Define your modified wave path here
    path.cubicTo(
      size.width * 0,
      size.height * 0.8,
      size.width * 0.4,
      size.height * 0.7,
      size.width * 0.5,
      size.height * 0.9,
    );
    path.cubicTo(
      size.width * .8,
      size.height * 0.75,
      size.width * 0.8,
      size.height * 0.9,
      size.width,
      size.height * 0.85,
    );

    // Connect the ends to complete the shape
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
