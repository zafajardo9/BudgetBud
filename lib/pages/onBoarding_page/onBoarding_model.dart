import 'package:flutter/material.dart';

class OnboardModel {
  String img;
  String title;
  String desc;
  Color bg;
  Color fg;
  String counterText;
  double height;

  OnboardModel({
    required this.title,
    required this.desc,
    required this.img,
    required this.bg,
    required this.fg,
    required this.counterText,
    required this.height,
  });
}
