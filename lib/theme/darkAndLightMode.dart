import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../misc/colors.dart';

ThemeData lightTheme = ThemeData(
  scaffoldBackgroundColor: AppColors.mainColorThree,
  primaryColor: AppColors.mainColorOne,
  brightness: Brightness.light,
  primarySwatch: Colors.red,
  fontFamily: GoogleFonts.montserrat().fontFamily,
);

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
);
