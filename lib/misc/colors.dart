import 'package:flutter/material.dart';

class AppColors {
  //Color have a a prefix of 0xFF
  static final Color mainColorOne = Color(0xFF6A0D0D);
  static final Color mainColorTwo = Color(0xFFFFBD59);
  static final Color mainColorThree = Color(0xFFF4F3FF);
  static final Color mainColorFour = Color(0xFFB38484);

  //background white
  static final Color backgroundWhite = Color(0xFFf9f9f9);
}

MaterialColor buildMaterialColor(Color color) {
  List strengths = <double>[.05];
  Map<int, Color> swatch = {};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  for (var strength in strengths) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  }
  return MaterialColor(color.value, swatch);
}
