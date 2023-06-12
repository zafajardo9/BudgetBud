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

  final now = DateTime.now();

  data.forEach((transaction) {
    final transactionType = transaction['TransactionType'];
    final transactionAmount = transaction['TransactionAmount'];
    final transactionDateStr = transaction['TransactionDate'] as String;
    final transactionDateTime = DateTime.parse(transactionDateStr).toLocal();

    if (transactionType == 'Income') {
      if (period == TimePeriod.Overall ||
          (period == TimePeriod.Daily && isSameDay(transactionDateTime, now)) ||
          (period == TimePeriod.Weekly &&
              isSameWeek(transactionDateTime, now)) ||
          (period == TimePeriod.Monthly &&
              isSameMonth(transactionDateTime, now)) ||
          (period == TimePeriod.Yearly &&
              isSameYear(transactionDateTime, now))) {
        totalIncome += transactionAmount;
      }
    } else if (transactionType == 'Expense') {
      if (period == TimePeriod.Overall ||
          (period == TimePeriod.Daily && isSameDay(transactionDateTime, now)) ||
          (period == TimePeriod.Weekly &&
              isSameWeek(transactionDateTime, now)) ||
          (period == TimePeriod.Monthly &&
              isSameMonth(transactionDateTime, now)) ||
          (period == TimePeriod.Yearly &&
              isSameYear(transactionDateTime, now))) {
        totalExpense += transactionAmount;
      }
    }
  });

  final balance = totalIncome - totalExpense;

  return TransactionSummary(
    totalIncome: totalIncome,
    totalExpense: totalExpense,
    balance: balance,
  );
}

bool isSameDay(DateTime date1, DateTime date2) {
  return date1.year == date2.year &&
      date1.month == date2.month &&
      date1.day == date2.day;
}

bool isSameWeek(DateTime date1, DateTime date2) {
  final week1 = date1.weekday;
  final week2 = date2.weekday;

  final beginningOfWeek1 = date1.subtract(Duration(days: week1));
  final beginningOfWeek2 = date2.subtract(Duration(days: week2));

  return isSameDay(beginningOfWeek1, beginningOfWeek2);
}

bool isSameMonth(DateTime date1, DateTime date2) {
  return date1.year == date2.year && date1.month == date2.month;
}

bool isSameYear(DateTime date1, DateTime date2) {
  return date1.year == date2.year;
}
