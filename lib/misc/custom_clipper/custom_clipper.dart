import 'package:flutter/material.dart';

class Clipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    final double xScaling = size.width / 414;
    final double yScaling = size.height / 896;
    path.lineTo(-27.4 * xScaling, 335.344 * yScaling);
    path.cubicTo(
      -27.4 * xScaling,
      335.344 * yScaling,
      -3.935 * xScaling,
      356.71 * yScaling,
      44.157 * xScaling,
      356.71 * yScaling,
    );
    path.cubicTo(
      92.249 * xScaling,
      356.71 * yScaling,
      114.821 * xScaling,
      293.745 * yScaling,
      175.899 * xScaling,
      300.769 * yScaling,
    );
    path.cubicTo(
      236.977 * xScaling,
      307.793 * yScaling,
      255.26999999999998 * xScaling,
      327.032 * yScaling,
      311.012 * xScaling,
      327.032 * yScaling,
    );
    path.cubicTo(
      366.754 * xScaling,
      327.032 * yScaling,
      386.6 * xScaling,
      247.758 * yScaling,
      386.6 * xScaling,
      247.758 * yScaling,
    );
    path.cubicTo(
      386.6 * xScaling,
      247.758 * yScaling,
      386.6 * xScaling,
      -6.441 * yScaling,
      386.6 * xScaling,
      -6.441 * yScaling,
    );
    path.cubicTo(
      386.6 * xScaling,
      -6.441 * yScaling,
      -27.399999999999977 * xScaling,
      -6.441 * yScaling,
      -27.399999999999977 * xScaling,
      -6.441 * yScaling,
    );
    path.cubicTo(
      -27.399999999999977 * xScaling,
      -6.441 * yScaling,
      -27.4 * xScaling,
      335.344 * yScaling,
      -27.4 * xScaling,
      335.344 * yScaling,
    );
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    throw UnimplementedError();
  }
}
