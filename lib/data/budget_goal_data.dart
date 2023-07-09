import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

BudgetGoal goalFromJson(String str) => BudgetGoal.fromJson(json.decode(str));

String goalToJson(BudgetGoal data) => json.encode(data.toJson());

class BudgetGoal {
  final String documentId;
  final String budgetName;
  final double budgetAmount;
  final String budgetFrequency;
  final String budgetCategory;
  final DateTime startDate;
  final DateTime endDate;
  final String userEmail;
  final double amountToSave;
  bool accomplished;

  BudgetGoal({
    required this.amountToSave,
    required this.documentId,
    required this.budgetName,
    required this.budgetFrequency,
    required this.budgetAmount,
    required this.budgetCategory,
    required this.startDate,
    required this.endDate,
    required this.userEmail,
    this.accomplished = false,
  });

  factory BudgetGoal.fromJson(Map<String, dynamic> json) => BudgetGoal(
        documentId: '',
        budgetName: json["BudgetName"],
        budgetAmount: json["BudgetAmount"],
        budgetFrequency: json["BudgetFrequency"],
        budgetCategory: json['BudgetCategory'],
        amountToSave: json['AmountToSave'],
        startDate: parseDateTime(json["StartDate"]),
        endDate: parseDateTime(json["EndDate"]),
        userEmail: json["UserEmail"],
      );

  Map<String, dynamic> toJson() => {
        "UserEmail": userEmail,
        "BudgetName": budgetName,
        "BudgetAmount": budgetAmount,
        "BudgetFrequency": budgetFrequency,
        "BudgetCategory": budgetCategory,
        "AmountToSave": amountToSave,
        "StartDate": startDate.toIso8601String(),
        "EndDate": endDate.toIso8601String(),
      };

  static DateTime parseDateTime(String dateString) {
    try {
      final dateTime = DateTime.parse(dateString);
      return dateTime;
    } catch (error) {
      print('Error parsing date: $error');
      return DateTime.now(); // Default value if parsing fails
    }
  }

  String getFormattedStartDate() {
    final startMonth = startDate.month;
    final startDay = startDate.day;
    final startYear = startDate.year;

    final monthName = _getMonthName(startMonth);

    return '$monthName $startDay, $startYear';
  }

  String getFormattedEndDate() {
    final endMonth = endDate.month;
    final endDay = endDate.day;
    final endYear = endDate.year;

    final monthName = _getMonthName(endMonth);

    return '$monthName $endDay, $endYear';
  }

  String _getMonthName(int month) {
    switch (month) {
      case 1:
        return 'January';
      case 2:
        return 'February';
      case 3:
        return 'March';
      case 4:
        return 'April';
      case 5:
        return 'May';
      case 6:
        return 'June';
      case 7:
        return 'July';
      case 8:
        return 'August';
      case 9:
        return 'September';
      case 10:
        return 'October';
      case 11:
        return 'November';
      case 12:
        return 'December';
      default:
        return '';
    }
  }
}
