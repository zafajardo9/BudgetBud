import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> addSurveyDataToFirestore({
  required String budgetSchedule,
  required double totalBudget,
  required double wantsValue,
  required double needsValue,
  required double savingsValue,
}) async {
  try {
    // Get the current user
    final User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Get a Firestore instance
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Create a new document in the "surveys" collection
      final DocumentReference surveyRef = firestore.collection('surveys').doc();

      // Set the survey data along with the user information
      await surveyRef.set({
        'userId': user.uid,
        'email': user.email,
        'budgetSchedule': budgetSchedule,
        'totalBudget': totalBudget,
        'wantsValue': wantsValue,
        'needsValue': needsValue,
        'savingsValue': savingsValue,
      });

      print('Survey data added to Firestore');
    } else {
      print('No user logged in');
    }
  } catch (error) {
    print('Error adding survey data to Firestore: $error');
  }
}
