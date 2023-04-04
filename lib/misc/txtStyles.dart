import 'package:budget_bud/misc/colors.dart';
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

  // Lato font removed
  //Subheader in BLACK
  static const TextStyle subHeader1 = TextStyle(
      color: Colors.black87, fontSize: 20, fontWeight: FontWeight.w400);

  static const TextStyle subHeader2 = TextStyle(
      color: Colors.black87, fontSize: 16, fontWeight: FontWeight.w400);

  static const TextStyle subHeader3 = TextStyle(
      color: Colors.black87, fontSize: 12, fontWeight: FontWeight.w400);

  //Subheader in WHITE
  static const TextStyle subHeaderWhite1 = TextStyle(
      color: Colors.white70, fontSize: 20, fontWeight: FontWeight.w800);

  static const TextStyle subHeaderWhite2 = TextStyle(
      color: Colors.white70, fontSize: 16, fontWeight: FontWeight.w800);

  static const TextStyle subHeaderWhite3 = TextStyle(
      color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w800);

  static const TextStyle paragraphWhite = TextStyle(
    color: Colors.white70,
    fontSize: 12,
  );
  //SUBHEADERS BLACK in BOLD
  static const TextStyle subHeader1Bold = TextStyle(
      color: Colors.black87, fontSize: 20, fontWeight: FontWeight.bold);

  static const TextStyle subHeader2Bold = TextStyle(
      color: Colors.black87, fontSize: 18, fontWeight: FontWeight.bold);

  static const TextStyle subHeader3Bold = TextStyle(
      color: Colors.black87, fontSize: 14, fontWeight: FontWeight.bold);

  //PARAGRAPH
  static const TextStyle paragraph = TextStyle(
    color: Colors.black,
    fontSize: 12,
  );
  static const TextStyle paragraph54 = TextStyle(
    color: Colors.black54,
    fontSize: 12,
  );
}

//NOT THE BEST WAY TO CODE
