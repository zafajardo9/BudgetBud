import 'package:flutter/material.dart';

class WaveLeftTwo extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint0 = Paint()
      ..color = const Color.fromARGB(255, 33, 150, 243)
      ..style = PaintingStyle.fill
      ..strokeWidth = 1.0;

    Path path0 = Path();
    path0.moveTo(0, size.height * 0.4029600);
    path0.quadraticBezierTo(size.width * 0.0939300, size.height * 0.8014800,
        size.width * 0.2404400, size.height * 0.8148600);
    path0.cubicTo(
        size.width * 0.4987800,
        size.height * 0.8334600,
        size.width * 0.6596000,
        size.height * 0.2141400,
        size.width * 0.7906000,
        size.height * 0.1724400);
    path0.quadraticBezierTo(size.width * 0.8919400, size.height * 0.1381200,
        size.width, size.height * 0.2717800);
    path0.lineTo(size.width, 0);
    path0.lineTo(0, 0);

    canvas.drawPath(path0, paint0);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
