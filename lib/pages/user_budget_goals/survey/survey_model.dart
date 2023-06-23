import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> addSurveyDataToFirestore({
  required String budgetSchedule,
  required double totalBudget,
  double? wantsValue, // Make the wantsValue parameter nullable
  double? needsValue, // Make the needsValue parameter nullable
  double? savingsValue, // Make the savingsValue parameter nullable
}) async {
  try {
    // Get the current user
    final User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Get a Firestore instance
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Create a new document in the "surveys" collection
      final DocumentReference surveyRef = firestore.collection('surveys').doc();

      // Prepare the survey data
      final Map<String, dynamic> surveyData = {
        'userId': user.uid,
        'email': user.email,
        'budgetSchedule': budgetSchedule,
        'totalBudget': totalBudget,
      };

      // Include the wants, needs, and savings values only if provided
      if (wantsValue != null) {
        surveyData['wantsValue'] = wantsValue;
      }
      if (needsValue != null) {
        surveyData['needsValue'] = needsValue;
      }
      if (savingsValue != null) {
        surveyData['savingsValue'] = savingsValue;
      }

      // Set the survey data in the Firestore document
      await surveyRef.set(surveyData);

      print('Survey data added to Firestore');
    } else {
      print('No user logged in');
    }
  } catch (error) {
    print('Error adding survey data to Firestore: $error');
  }
}
