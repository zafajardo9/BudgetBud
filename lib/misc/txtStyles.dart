import 'package:flutter/material.dart';

abstract class ThemeText {
  static const TextStyle textHeader1 = TextStyle(
    color: Colors.black,
    fontSize: 40,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle textHeader2 = TextStyle(
    color: Colors.black,
    fontSize: 30,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle textHeader3 = TextStyle(
    color: Colors.black,
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );
  //For APPBAR TITLES
  static const TextStyle appBarTitle = TextStyle(
    color: Colors.white,
    fontSize: 30,
    fontWeight: FontWeight.bold,
  );

  //FOR AUTH SCREENS
  static const TextStyle headerAuth = TextStyle(
    color: Colors.black,
    fontSize: 25,
    fontWeight: FontWeight.bold,
  );
  static const TextStyle subAuth = TextStyle(
    color: Colors.black54,
    fontSize: 15,
    fontWeight: FontWeight.bold,
  );

  //SUB HEADERS

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
