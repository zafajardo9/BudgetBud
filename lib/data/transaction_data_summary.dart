import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TransactionDataSummary {
  final String transactionType;
  final double amount;

  TransactionDataSummary({required this.transactionType, required this.amount});
}

class TransactionSummary {
  final double totalIncome;
  final double totalExpense;
  final double balance;

  TransactionSummary({
    required this.totalIncome,
    required this.totalExpense,
    required this.balance,
  });
}

enum TimePeriod {
  Daily,
  Weekly,
  Monthly,
  Yearly,
  Overall,
}

Future<TransactionSummary> calculateTransactionSummary(
    TimePeriod period) async {
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

  // Apply period-specific filtering if not "Overall"
  if (period != TimePeriod.Overall) {
    final now = DateTime.now();

    data.retainWhere((transaction) {
      final transactionDateStr = transaction['TransactionDate'] as String;
      final transactionDateTime = DateTime.parse(transactionDateStr).toLocal();

      switch (period) {
        case TimePeriod.Daily:
          return isSameDay(transactionDateTime, now);
        case TimePeriod.Weekly:
          return isSameWeek(transactionDateTime, now);
        case TimePeriod.Monthly:
          return isSameMonth(transactionDateTime, now);
        case TimePeriod.Yearly:
          return isSameYear(transactionDateTime, now);
        default:
          return false;
      }
    });
  }

  return TransactionSummary(
    totalIncome: totalIncome,
    totalExpense: totalExpense,
    balance: balance,
  );
}

bool isSameDay(DateTime dateTime1, DateTime dateTime2) {
  return dateTime1.year == dateTime2.year &&
      dateTime1.month == dateTime2.month &&
      dateTime1.day == dateTime2.day;
}

bool isSameWeek(DateTime dateTime1, DateTime dateTime2) {
  final startOfWeek = dateTime2.subtract(Duration(days: dateTime2.weekday - 1));
  final endOfWeek = startOfWeek.add(Duration(days: 6));
  return dateTime1.isAfter(startOfWeek) && dateTime1.isBefore(endOfWeek);
}

bool isSameMonth(DateTime dateTime1, DateTime dateTime2) {
  return dateTime1.year == dateTime2.year && dateTime1.month == dateTime2.month;
}

bool isSameYear(DateTime dateTime1, DateTime dateTime2) {
  return dateTime1.year == dateTime2.year;
}
