@echo off

set FLUTTER_HOME=<path-to-flutter-sdk>
set FLUTTER_BIN=%FLUTTER_HOME%\bin\flutter.bat

set DRIVER_FILE=test_driver\integration+test_driver.dart
set TEST_FILE=integration_test\app_test.dart

%FLUTTER_BIN% drive ^
  --driver=%DRIVER_FILE% ^
  --target=%TEST_FILE%
