import 'package:budget_bud/pages/run.dart';
import 'package:budget_bud/theme/darkAndLightManager.dart';
import 'package:budget_bud/theme/darkAndLightMode.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

//For Dark mode and Light Mode
ThemeManager _themeManager = ThemeManager();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'BudgetBud',
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: _themeManager.themeMode,
        home: Run());
  }
}
