import 'dart:convert';

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

  BudgetGoal({
    required this.documentId,
    required this.budgetName,
    required this.budgetFrequency,
    required this.budgetAmount,
    required this.budgetCategory,
    required this.startDate,
    required this.endDate,
    required this.userEmail,
  });

  factory BudgetGoal.fromJson(Map<String, dynamic> json) => BudgetGoal(
        documentId: '',
        budgetName: json["BudgetName"],
        budgetAmount: json["BudgetAmount"],
        budgetFrequency: json["BudgetFrequency"],
        budgetCategory: json['BudgetCategory'],
        startDate: json["StartDate"],
        endDate: json["EndDate"],
        userEmail: json["UserEmail"],
      );

  Map<String, dynamic> toJson() => {
        "UserEmail": userEmail,
        "BudgetName": budgetName,
        "BudgetAmount": budgetAmount,
        "BudgetFrequency": budgetFrequency,
        "BudgetCategory": budgetCategory,
        "StartDate": startDate.toIso8601String(),
        "EndDate": endDate.toIso8601String(),
      };
}
