import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

// ignore: unused_import
import 'firebase_options.dart';
import 'misc/colors.dart';
import 'auth/auth_page.dart';
import 'pages/onBoarding_page/onBoarding_page.dart';

int? isviewed;
void main() async {
  // Check for internet connectivity before running the app
  WidgetsFlutterBinding.ensureInitialized();
  final connectivityResult = await Connectivity().checkConnectivity();
  if (connectivityResult == ConnectivityResult.none) {
    // If there's no internet connectivity, stop the app
    return runApp(
      const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Center(
            child: Text('No internet connection.'),
          ),
        ),
      ),
    );
  }

  //for onboarding screen
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  //onboarding screen
  SharedPreferences prefs = await SharedPreferences.getInstance();
  isviewed = prefs.getInt('onBoard');

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
        home: isviewed != 0 ? OnboardingScreen() : AuthPage());
  }
}
