import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
// ignore: unused_import
import 'firebase_options.dart';
import 'misc/colors.dart';
import 'auth/auth_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

//For Dark mode and Light Mode

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'BudgetBud',
        theme: ThemeData(
          scaffoldBackgroundColor: AppColors.mainColorThree,
          primaryColor: AppColors.mainColorOne,
          brightness: Brightness.light,
          primarySwatch: buildMaterialColor(Color(0xFF6A0D0D)),
          fontFamily: GoogleFonts.montserrat().fontFamily,
        ),
        home: AuthPage());
  }
}
