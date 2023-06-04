import 'package:flutter/material.dart';

class Clipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(-27.4, 400);
    path.cubicTo(
      -27.4,
      335.344,
      -3.935,
      356.71,
      44.157,
      356.71,
    );
    path.cubicTo(
      92.249,
      356.71,
      114.821,
      293.745,
      175.899,
      300.769,
    );
    path.cubicTo(
      236.977,
      307.793,
      255.27,
      327.032,
      311.012,
      327.032,
    );
    path.cubicTo(
      366.754,
      327.032,
      386.6,
      247.758,
      386.6,
      247.758,
    );
    path.cubicTo(
      386.6,
      247.758,
      386.6,
      -6.441,
      386.6,
      -6.441,
    );
    path.cubicTo(
      386.6,
      -6.441,
      -27.4,
      -6.441,
      -27.4,
      -6.441,
    );
    path.cubicTo(
      -27.4,
      -6.441,
      -27.4,
      335.344,
      -27.4,
      335.344,
    );
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
