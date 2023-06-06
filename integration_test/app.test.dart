import 'package:budget_bud/auth/auth_page.dart';
import 'package:budget_bud/auth/login_page.dart';
import 'package:budget_bud/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:budget_bud/main.dart' as app;
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('Login Test', () {
    IntegrationTestWidgetsFlutterBinding.ensureInitialized();
    testWidgets("Introductory Screen", (tester) async {
      // Create a new instance of SharedPreferences
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool("isOnboarded", true); // Set isOnboarded to true

      await tester
          .pumpWidget(MyApp(prefsFuture: Future.value(prefs))); // Run the app

      // Wait for the onboarding screen to load
      await tester.pumpAndSettle();

      final btn = find.byType(OutlinedButton);

      for (int i = 0; i < 5; i++) {
        await tester.tap(btn);
        await tester.pumpAndSettle();
      }
    });

    testWidgets("Button Test", (tester) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.pumpWidget(LoginPage(
        onTap: () {},
      ));

      final button = find.byWidgetPredicate(
        (widget) => widget is GestureDetector && widget.child is Text,
      );

      await tester.tap(button);
      await tester.pumpAndSettle();
    });

    testWidgets("Login Test Try", (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // await Future.delayed(Duration(minutes: 1));

      final expectedText = 'Welcome Back';
      final textWidget = find.text(expectedText);

      expect(textWidget, findsOneWidget);

      final emailTextField = find.bySemanticsLabel('Email');
      final passwordTextField = find.bySemanticsLabel('Password');
      final loginButton = find.byType(GestureDetector);

      await tester.enterText(emailTextField, "zack@gmail.com");
      await tester.enterText(passwordTextField, "zackery1234");
      await tester.pumpAndSettle();

      await tester.tap(loginButton);
      await tester.pumpAndSettle();
    });
  });
}
