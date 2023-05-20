import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TransactionData {
  final String transactionType;
  final double amount;

  TransactionData({required this.transactionType, required this.amount});
}

class TransactionSummary {
  final double totalIncome;
  final double totalExpense;
  final double balance;

  TransactionSummary(
      {required this.totalIncome,
      required this.totalExpense,
      required this.balance});
}

Future<TransactionSummary> calculateTransactionSummary() async {
  final user = FirebaseAuth.instance.currentUser!;
  final CollectionReference collection =
      FirebaseFirestore.instance.collection('Transactions');

  final QuerySnapshot snapshot =
      await collection.where('UserEmail', isEqualTo: user.email).get();
  final List<DocumentSnapshot> data = snapshot.docs;

  double totalIncome = 0.0;
  double totalExpense = 0.0;

  data.forEach((transaction) {
    final transactionType = transaction['TransactionType'];
    final transactionAmount = transaction['TransactionAmount'];

    if (transactionType == 'Income') {
      totalIncome += transactionAmount;
    } else if (transactionType == 'Expense') {
      totalExpense += transactionAmount;
    }
  });

  final balance = totalIncome - totalExpense;

  return TransactionSummary(
    totalIncome: totalIncome,
    totalExpense: totalExpense,
    balance: balance,
  );
}
