import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesUtils {
  static Future<SharedPreferences> initializeSharedPreferences() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences;
  }

  static void setFinishedShowcaseSteps(SharedPreferences sharedPreferences) {
    sharedPreferences.setBool('finishedShowcaseSteps', true);
  }

  static bool hasFinishedShowcaseSteps(SharedPreferences sharedPreferences) {
    return sharedPreferences.getBool('finishedShowcaseSteps') ?? false;
  }
}
