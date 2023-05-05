import 'dart:convert';

TransactionData incomeFromJson(String str) =>
    TransactionData.fromJson(json.decode(str));

String incomeToJson(TransactionData data) => json.encode(data.toJson());

class TransactionData {
  final String userEmail;
  final String transactionName;
  final String transactionType;
  final double amount;
  final String description;
  final String category;
  final DateTime transactionDate;

  TransactionData({
    required this.userEmail,
    required this.transactionName,
    required this.transactionType,
    required this.amount,
    required this.description,
    required this.category,
    required this.transactionDate,
  });

  factory TransactionData.fromJson(Map<String, dynamic> json) =>
      TransactionData(
        userEmail: json["UserEmail"],
        transactionName: json["TransactionName"],
        transactionType: json["TransactionType"],
        description: json["TransactionDescription"],
        amount: json["TransactionAmount"],
        category: json["TransactionCategory"],
        transactionDate: DateTime.parse(json["TransactionDate"]),
      );

  Map<String, dynamic> toJson() => {
        "UserEmail": userEmail,
        "TransactionName": transactionName,
        "TransactionType": transactionType,
        "TransactionDescription": description,
        "TransactionAmount": amount,
        "TransactionCategory": category,
        "TransactionDate": transactionDate.toIso8601String(),
      };
}
