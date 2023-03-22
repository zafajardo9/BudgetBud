import 'package:flutter/material.dart';

abstract class ThemeText {
  static const TextStyle textHeader1 = TextStyle(
      fontFamily: 'Montserrat',
      color: Colors.black,
      fontSize: 40,
      fontWeight: FontWeight.w600);

  static const TextStyle textHeader2 = TextStyle(
      fontFamily: 'Montserrat',
      color: Colors.black,
      fontSize: 30,
      fontWeight: FontWeight.w600);

  static const TextStyle textHeader3 = TextStyle(
      fontFamily: 'Montserrat',
      color: Colors.black,
      fontSize: 20,
      fontWeight: FontWeight.w600);

  static const TextStyle subHeader1 = TextStyle(
      fontFamily: 'Lato',
      color: Colors.black87,
      fontSize: 20,
      fontWeight: FontWeight.w400);

  static const TextStyle subHeader2 = TextStyle(
      fontFamily: 'Lato',
      color: Colors.black87,
      fontSize: 16,
      fontWeight: FontWeight.w400);

  static const TextStyle subHeader3 = TextStyle(
      fontFamily: 'Lato',
      color: Colors.black87,
      fontSize: 12,
      fontWeight: FontWeight.w400);

  static const TextStyle paragraph = TextStyle(
    fontFamily: 'Lato',
    color: Colors.black,
    fontSize: 12,
  );
}
