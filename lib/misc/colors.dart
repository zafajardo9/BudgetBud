import 'package:flutter/material.dart';

class AppColors {
  //Color have a a prefix of 0xFF
  //version 1
  static final Color mainColorOne = Color(0xFF4E3EC8);
  static final Color mainColorOneSecondary = Color(0xFF634CFD);
  static final Color mainColorTwo = Color(0xFFffbf3A);
  static final Color mainColorThree = Color(0xFFf0f1fA);
  static final Color mainColorFour = Color(0xFFf68059);

  static final Color mainColorFive = Color(0xFFC6B9B9);
  static final Color mainColorSix = Color(0xFFF0E5E5);

  //version 1
  static final Color one = Color(0xFF0D1853);
  static final Color one2 = Color(0xFFFFBD59);
  static final Color one3 = Color(0xFFF4F3FF);
  static final Color one4 = Color(0xFFB38484);

//version 3
  static final Color three = Color(0xFF091945);
  static final Color three2 = Color(0xFF8916FF);
  static final Color three3 = Color(0xFFFF25C2);
  static final Color three4 = Color(0xFF25DFFF);
//version 2
  static final Color second = Color(0xFF4E3EC8);
  static final Color second2 = Color(0xFFffbf3A);
  static final Color second3 = Color(0xFFf0f1fA);
  static final Color second4 = Color(0xFFf68059);

  //background white
  static final Color backgroundWhite = Color(0xfffcfcff);
//other colors
  static final Color onBoardingColorButton = Color(0xFFf68059);
  static final Color deleteButton = Color(0xFFBD0000);
  static final Color updateButton = Color(0xFF00BD03);
  static final Color blackBtn = Color(0xFF101010);
}

final List<Color> colors = [
  Color(0xFF4E3EC8),
  Color(0xFFffbf3A),
  Color(0xFFf68059),
  Color(0xFF0D1853),
  Color(0xFFFFBD59),
  Color(0xFFB38484),
  Color(0xFF091945),
  Color(0xFF8916FF),
  Color(0xFFFF25C2),
  Color(0xFF25DFFF),
  Color(0xFF634CFD),
  Color(0xFFF4F3FF),
  Color(0xFFC6B9B9),
  Color(0xFFF0E5E5),
  Color(0xFFf0f1fA),
];

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
