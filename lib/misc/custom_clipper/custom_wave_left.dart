import 'package:flutter/material.dart';

class WaveLeft extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    final double xScaling = size.width / 0;
    final double yScaling = size.height / 0;
    path.lineTo(0 * xScaling, 32 * yScaling);
    path.cubicTo(
      0 * xScaling,
      32 * yScaling,
      48 * xScaling,
      80 * yScaling,
      48 * xScaling,
      80 * yScaling,
    );
    path.cubicTo(
      96 * xScaling,
      128 * yScaling,
      192 * xScaling,
      224 * yScaling,
      288 * xScaling,
      245.3 * yScaling,
    );
    path.cubicTo(
      384 * xScaling,
      267 * yScaling,
      480 * xScaling,
      213 * yScaling,
      576 * xScaling,
      181.3 * yScaling,
    );
    path.cubicTo(
      672 * xScaling,
      149 * yScaling,
      768 * xScaling,
      139 * yScaling,
      864 * xScaling,
      144 * yScaling,
    );
    path.cubicTo(
      960 * xScaling,
      149 * yScaling,
      1056 * xScaling,
      171 * yScaling,
      1152 * xScaling,
      154.7 * yScaling,
    );
    path.cubicTo(
      1248 * xScaling,
      139 * yScaling,
      1344 * xScaling,
      85 * yScaling,
      1392 * xScaling,
      58.7 * yScaling,
    );
    path.cubicTo(
      1392 * xScaling,
      58.7 * yScaling,
      1440 * xScaling,
      32 * yScaling,
      1440 * xScaling,
      32 * yScaling,
    );
    path.cubicTo(
      1440 * xScaling,
      32 * yScaling,
      1440 * xScaling,
      0 * yScaling,
      1440 * xScaling,
      0 * yScaling,
    );
    path.cubicTo(
      1440 * xScaling,
      0 * yScaling,
      1392 * xScaling,
      0 * yScaling,
      1392 * xScaling,
      0 * yScaling,
    );
    path.cubicTo(
      1344 * xScaling,
      0 * yScaling,
      1248 * xScaling,
      0 * yScaling,
      1152 * xScaling,
      0 * yScaling,
    );
    path.cubicTo(
      1056 * xScaling,
      0 * yScaling,
      960 * xScaling,
      0 * yScaling,
      864 * xScaling,
      0 * yScaling,
    );
    path.cubicTo(
      768 * xScaling,
      0 * yScaling,
      672 * xScaling,
      0 * yScaling,
      576 * xScaling,
      0 * yScaling,
    );
    path.cubicTo(
      480 * xScaling,
      0 * yScaling,
      384 * xScaling,
      0 * yScaling,
      288 * xScaling,
      0 * yScaling,
    );
    path.cubicTo(
      192 * xScaling,
      0 * yScaling,
      96 * xScaling,
      0 * yScaling,
      48 * xScaling,
      0 * yScaling,
    );
    path.cubicTo(
      48 * xScaling,
      0 * yScaling,
      0 * xScaling,
      0 * yScaling,
      0 * xScaling,
      0 * yScaling,
    );
    path.cubicTo(
      0 * xScaling,
      0 * yScaling,
      0 * xScaling,
      32 * yScaling,
      0 * xScaling,
      32 * yScaling,
    );
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    throw UnimplementedError();
  }
}
