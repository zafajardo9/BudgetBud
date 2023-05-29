import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionHeatModel {
  final DateTime date;
  final double amount;
  final String name;
  late int heatLevel;

  TransactionHeatModel({
    required this.date,
    required this.amount,
    required this.name,
  }) {
    heatLevel = _calculateHeatLevel();
  }

  factory TransactionHeatModel.fromFirestore(DocumentSnapshot document) {
    final data = document.data() as Map<String, dynamic>;
    final timestamp = data['TransactionDate'] as Timestamp;
    final amount = data['TransactionAmount'] as double;
    final name = data['TransactionName'] as String;

    return TransactionHeatModel(
      date: timestamp.toDate(),
      amount: amount,
      name: name,
    );
  }

  int _calculateHeatLevel() {
    if (amount >= 1000) {
      return 5; // High heat level
    } else if (amount >= 500) {
      return 3; // Medium heat level
    } else {
      return 1; // Low heat level
    }
  }
}
