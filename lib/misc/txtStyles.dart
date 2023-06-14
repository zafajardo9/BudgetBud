import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'colors.dart';

abstract class ThemeText {
  static TextStyle textHeader1 = TextStyle(
    color: Colors.black,
    fontSize: 39.sp,
    fontWeight: FontWeight.bold,
  );

  static TextStyle textHeader2 = TextStyle(
    color: Colors.black,
    fontSize: 29.sp,
    fontWeight: FontWeight.bold,
  );

  static TextStyle textHeader3 = TextStyle(
    color: Colors.black,
    fontSize: 20.sp,
    fontWeight: FontWeight.bold,
  );
  //For APPBAR TITLES
  static TextStyle appBarTitle = TextStyle(
    color: Colors.white,
    fontSize: 20.sp,
    fontWeight: FontWeight.bold,
  );

  //FOR AUTH SCREENS
  static TextStyle headerAuth = TextStyle(
    color: Colors.black,
    fontSize: 20.sp,
    fontWeight: FontWeight.bold,
  );
  static TextStyle subAuth = TextStyle(
    color: Colors.black54,
    fontSize: 13.sp,
    fontWeight: FontWeight.bold,
  );

  //SUB HEADERS

  //Subheader in BLACK
  static TextStyle subHeader1 = TextStyle(
      color: Colors.black87, fontSize: 20.sp, fontWeight: FontWeight.w400);

  static TextStyle subHeader2 = TextStyle(
      color: Colors.black87, fontSize: 16.sp, fontWeight: FontWeight.w400);

  static TextStyle subHeader3 = TextStyle(
      color: Colors.black87, fontSize: 12.sp, fontWeight: FontWeight.w400);

  //Subheader in WHITE
  static TextStyle subHeaderWhite1 = TextStyle(
      color: Colors.white70, fontSize: 18.sp, fontWeight: FontWeight.w800);

  static TextStyle subHeaderWhite2 = TextStyle(
      color: Colors.white70, fontSize: 16.sp, fontWeight: FontWeight.w800);

  static TextStyle subHeaderWhite3 = TextStyle(
      color: Colors.white70, fontSize: 12.sp, fontWeight: FontWeight.w800);

  static TextStyle paragraphWhite = TextStyle(
    color: Colors.white70,
    fontSize: 15.sp,
  );
  //SUBHEADERS BLACK in BOLD
  static TextStyle subHeader1Bold = TextStyle(
      color: Colors.black87, fontSize: 20.sp, fontWeight: FontWeight.bold);

  static TextStyle subHeader2Bold = TextStyle(
      color: Colors.black87, fontSize: 18.sp, fontWeight: FontWeight.bold);

  static TextStyle subHeader3Bold = TextStyle(
      color: Colors.black87, fontSize: 14.sp, fontWeight: FontWeight.bold);

  //PARAGRAPH
  static TextStyle paragraph = TextStyle(
    color: Colors.black,
    fontSize: 15.sp,
  );
  static TextStyle paragraph54 = TextStyle(
    color: Colors.black54,
    fontSize: 15.sp,
  );
  static TextStyle paragraph54Bold = TextStyle(
    color: Colors.black54,
    fontSize: 15.sp,
    fontWeight: FontWeight.bold,
  );
  static TextStyle textfieldInput = TextStyle(
    color: Colors.black54,
    fontSize: 16.sp,
  );

  static TextStyle transactionName = TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.bold,
    fontSize: 17.sp,
  );
  static TextStyle transactionAmount = TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.bold,
    fontSize: 16.sp,
  );
  static TextStyle transactionDetails = TextStyle(
    color: Colors.grey.shade500,
    fontSize: 15.sp,
  );
  static TextStyle transactionDateDetails = TextStyle(
    color: Colors.grey.shade500,
    fontStyle: FontStyle.italic,
    fontSize: 15.sp,
  );

  //DASHBOARDDD=====================================================
  static TextStyle dashboardDetailsHeader = TextStyle(
    color: Colors.white,
    fontSize: 18.sp,
    fontWeight: FontWeight.bold,
  );

  static TextStyle dashboardDetailsSubHeader = TextStyle(
    color: Colors.white60,
    fontSize: 17.sp,
  );

  static TextStyle dashboardNumberLarge = TextStyle(
      color: Colors.black,
      fontStyle: FontStyle.italic,
      fontSize: 21.sp,
      fontWeight: FontWeight.bold);

  static TextStyle dashboardNumberSmall = TextStyle(
      color: Colors.black,
      fontStyle: FontStyle.italic,
      fontSize: 13.sp,
      fontWeight: FontWeight.bold);

  static TextStyle dashboardNumberMedium = TextStyle(
      color: Colors.black,
      fontStyle: FontStyle.italic,
      fontSize: 15.sp,
      fontWeight: FontWeight.bold);

  //CATEGORIES PAGE =========================

  static TextStyle categoriesTitle = GoogleFonts.montserrat(
    color: Colors.black,
    fontSize: 16.sp,
  );

  static TextStyle categoriesDescription = GoogleFonts.montserrat(
    color: Colors.black54,
    fontSize: 14.sp,
  );

  static TextStyle categoriesDescripTitle = GoogleFonts.montserrat(
    color: Colors.black54,
    fontSize: 14.sp,
    fontWeight: FontWeight.bold,
  );
}

//NOT THE BEST WAY TO CODE
