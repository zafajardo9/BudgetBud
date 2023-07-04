import 'dart:convert';

TransactionData incomeFromJson(String str) =>
    TransactionData.fromJson(json.decode(str));

String incomeToJson(TransactionData data) => json.encode(data.toJson());

class TransactionData {
  final String documentId;
  final String userEmail;
  final String transactionType;
  final double amount;
  final String description;
  final String category;
  final DateTime transactionDate;

  TransactionData({
    required this.documentId,
    required this.userEmail,
    required this.transactionType,
    required this.amount,
    required this.description,
    required this.category,
    required this.transactionDate,
  });

  factory TransactionData.fromJson(Map<String, dynamic> json) =>
      TransactionData(
        userEmail: json["UserEmail"],
        transactionType: json["TransactionType"],
        description: json["TransactionDescription"],
        amount: json["TransactionAmount"],
        category: json["TransactionCategory"],
        transactionDate: DateTime.parse(json["TransactionDate"]).toLocal(),
        documentId: '',
      );

  Map<String, dynamic> toJson() => {
        "UserEmail": userEmail,
        "TransactionType": transactionType,
        "TransactionDescription": description,
        "TransactionAmount": amount,
        "TransactionCategory": category,
        "TransactionDate": transactionDate.toIso8601String(),
      };
}
