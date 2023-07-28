import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TransactionSuggestion {
  final double totalIncome;
  final double totalExpense;
  final double balance;
  final double impulsivePercentage;
  final List<String> highestCategories;
  final int expenseTransactionCount;

  TransactionSuggestion({
    required this.totalIncome,
    required this.totalExpense,
    required this.balance,
    required this.impulsivePercentage,
    required this.highestCategories,
    required this.expenseTransactionCount,
  });

  int get transactionCount => highestCategories.length;
}

enum TimePeriod {
  Daily,
  Weekly,
  Monthly,
  Yearly,
  Overall,
}

Future<TransactionSuggestion> summaryForSuggestion(TimePeriod period) async {
  final user = FirebaseAuth.instance.currentUser!;
  final CollectionReference collection =
      FirebaseFirestore.instance.collection('Transactions');

  final QuerySnapshot snapshot =
      await collection.where('UserEmail', isEqualTo: user.email).get();
  final List<DocumentSnapshot> data = snapshot.docs;

  int expenseTransactionCount = 0;

  double totalIncome = 0.0;
  double totalExpense = 0.0;

  final now = DateTime.now();

  final Map<String, double> categoryAmounts = {};

  data.forEach((transaction) {
    final transactionType = transaction['TransactionType'];
    final transactionAmount = transaction['TransactionAmount'];
    final transactionCategory = transaction['TransactionCategory'];
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
        expenseTransactionCount++;

        if (categoryAmounts.containsKey(transactionCategory)) {
          categoryAmounts[transactionCategory] =
              categoryAmounts[transactionCategory]! + transactionAmount;
        } else {
          categoryAmounts[transactionCategory] = transactionAmount;
        }
      }
    }
  });

  final balance = totalIncome - totalExpense;

  double impulsivePercentage = 0.0;

  impulsivePercentage = (balance / totalIncome) - 1;

  impulsivePercentage = (impulsivePercentage.abs() * 100).clamp(0, 100);

  final highestCategories = findHighestCategories(categoryAmounts);

  return TransactionSuggestion(
    totalIncome: totalIncome,
    totalExpense: totalExpense,
    balance: balance,
    impulsivePercentage: impulsivePercentage,
    highestCategories: highestCategories,
    expenseTransactionCount: expenseTransactionCount,
  );
}

List<String> findHighestCategories(Map<String, double> categoryAmounts) {
  final sortedCategories = categoryAmounts.entries.toList()
    ..sort((a, b) => b.value.compareTo(a.value));

  final rankedCategories = sortedCategories.map((entry) => entry.key).toList();

  return rankedCategories;
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
