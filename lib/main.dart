import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

// ignore: unused_import
import 'firebase_options.dart';
import 'misc/colors.dart';
import 'auth/auth_page.dart';
import 'pages/onBoarding_page/onBoarding_screen.dart';

late SharedPreferences prefs;
List<CameraDescription> cameras = [];
Future<void> main() async {
  // Check for internet connectivity before running the app
  WidgetsFlutterBinding.ensureInitialized();

  final connectivityResult = await Connectivity().checkConnectivity();
  if (connectivityResult == ConnectivityResult.none) {
    // If there's no internet connectivity, stop the app
    return runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.dark,
      home: Scaffold(
        body: Center(
          child: Text('No internet connection.'),
        ),
      ),
    ));
  }

  //for onboarding screen
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  //onboarding screen
  prefs = await SharedPreferences.getInstance();

  // Fetch the available cameras before initializing the app.
  try {
    WidgetsFlutterBinding.ensureInitialized();
    cameras = await availableCameras();
  } on CameraException catch (e) {
    debugPrint('CameraError: ${e.description}');
  }

  runApp(const MyApp());
}

//For Dark mode and Light Mode

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    bool isOnboarded = prefs.getBool("isOnboarded") ?? false;
    return ResponsiveSizer(
      builder: (context, orientation, screenType) {
        return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'BudgetBud',
            theme: ThemeData(
              scaffoldBackgroundColor: AppColors.mainColorThree,
              primaryColor: AppColors.mainColorOne,
              brightness: Brightness
                  .light, //part for switching dark to light mode theme
              primarySwatch: buildMaterialColor(Color(0xFF4E3EC8)),
              fontFamily: GoogleFonts.montserrat().fontFamily,
            ),
            home: isOnboarded ? AuthPage() : OnboardingScreen());
      },
    );
  }
}
