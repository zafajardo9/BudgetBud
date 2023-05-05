import 'package:budget_bud/dateTime/date_time_helper.dart';

import '../dataModels/expense_item.dart';

class Expense {
  Expense({
    required this.userEmail,
    required this.expenseName,
    required this.expenseDescription,
    required this.expenseAmount,
    required this.expenseDate,
  });
  final String userEmail;
  final String expenseName;
  final String expenseDescription;
  final double expenseAmount;
  final DateTime expenseDate;

  factory Expense.fromJson(Map<String, dynamic> json) => Expense(
        userEmail: json["UserEmail"],
        expenseName: json["ExpenseName"],
        expenseDescription: json["ExpenseDescription"],
        expenseAmount: json["ExpenseAmount"],
        expenseDate: DateTime.parse(json["ExpenseDate"]),
      );

  Map<String, dynamic> toJson() => {
        "UserEmail": userEmail,
        "ExpenseName": expenseName,
        "ExpenseDescription": expenseDescription,
        "ExpenseAmount": expenseAmount,
        "ExpenseDate": expenseDate.toIso8601String(),
      };
}

//for displaying in a yyyy/mm/dd
class ExpenseData {
  List<ExpenseItem> overallExpenseList = [];

  List<ExpenseItem> getAllExpenseList() {
    return overallExpenseList;
  }

  void addNewExpense(ExpenseItem newExpense) {
    overallExpenseList.add(newExpense);
  }

  //deleting expense

  void deleteExpense(ExpenseItem expense) {
    overallExpenseList.remove(expense);
  }
//convert to a weekday name from a datetime format

  String getDayName(DateTime dateTime) {
    switch (dateTime.weekday) {
      case 1:
        return 'Mon';
      case 2:
        return 'Tue';
      case 3:
        return 'Wed';
      case 4:
        return 'Thu';
      case 5:
        return 'Fri';
      case 6:
        return 'Sat';
      case 7:
        return 'Sun';
        break;
      default:
        return '';
    }
  }

  DateTime startOfTheWeekDate() {
    DateTime? startOfWeek;
    DateTime today = DateTime.now();

    for (int i = 0; i < 7; i++) {
      if (getDayName(today.subtract(Duration(days: i))) == 'Sun') {
        startOfWeek = today.subtract(Duration(days: i));
      }
    }
    return startOfWeek!;
  }

  Map<String, double> calculateDailyExpenseSummary() {
    Map<String, double> dailyExpenseSummary = {};
    for (var expense in overallExpenseList) {
      String date = convertDateTimeToString(expense.dateTime);
      double amount = double.parse(expense.amount);

      if (dailyExpenseSummary.containsKey(date)) {
        double currentAmount = dailyExpenseSummary[date]!;
        currentAmount += amount;
        dailyExpenseSummary[date] = currentAmount;
      } else {
        dailyExpenseSummary.addAll({date: amount});
      }
    }

    return dailyExpenseSummary;
  }
}
