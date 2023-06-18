import 'package:budget_bud/notification_api/firebase_api.dart';
import 'package:budget_bud/steps/shared_pref_steps.dart';
import 'package:camera/camera.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:upgrader/upgrader.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

// ignore: unused_import
import 'firebase_options.dart';
import 'misc/colors.dart';
import 'auth/auth_page.dart';
import 'notification_api/forground_local_notification.dart';
import 'pages/onBoarding_page/onBoarding_screen.dart';

late SharedPreferences prefs;
List<CameraDescription> cameras = [];

const kIsHoney = bool.fromEnvironment('HONEY');

Future<void> main() async {
  // if (kIsHoney) {
  //   HoneyWidgetsBinding.ensureInitialized();
  // }

  //For notification
  AwesomeNotifications().initialize(
    'resource://drawable-hdpi/splash.png',
    [
      NotificationChannel(
        channelKey: 'basic_channel',
        channelName: 'Basic Notifications',
        defaultColor: AppColors.mainColorOne,
        importance: NotificationImportance.High,
        channelShowBadge: true,
        channelDescription: 'Try Notification',
      )
    ],
  );

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
  await FirebaseApi().initNotification();

  //await FlutterConfig.loadEnvVariables();
  await dotenv.load();

  //onboarding screen
  prefs = await SharedPreferences.getInstance();

  // Fetch the available cameras before initializing the app.
  try {
    WidgetsFlutterBinding.ensureInitialized();
    cameras = await availableCameras();
  } on CameraException catch (e) {
    debugPrint('CameraError: ${e.description}');
  }

  final prefsFuture = SharedPreferences.getInstance();

  runApp(MyApp(prefsFuture: prefsFuture));
}

//For Dark mode and Light Mode

class MyApp extends StatelessWidget {
  final Future<SharedPreferences> prefsFuture;

  const MyApp({required this.prefsFuture, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LocalNotification.initialize();
    // For Forground State
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      LocalNotification.showNotification(message);
    });

    return UpgradeAlert(
      child: FutureBuilder<SharedPreferences>(
        future: prefsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final SharedPreferences prefs = snapshot.data!;
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
                    home: ShowCaseWidget(
                      builder: Builder(
                        builder: (_) =>
                            isOnboarded ? AuthPage() : OnboardingScreen(),
                      ),
                    ));
              },
            );
          }

          // Show a loading indicator while waiting for SharedPreferences
          return CircularProgressIndicator();
        },
      ),
    );
  }
}
