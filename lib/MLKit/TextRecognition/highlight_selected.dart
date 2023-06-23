import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class HighlightPainter extends CustomPainter {
  final List<Rect> rects;

  HighlightPainter(this.rects);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..color = Colors.red;

    for (final Rect rect in rects) {
      canvas.drawRect(rect, paint);
    }
  }

  @override
  bool shouldRepaint(HighlightPainter oldDelegate) {
    return oldDelegate.rects != rects;
  }
}
