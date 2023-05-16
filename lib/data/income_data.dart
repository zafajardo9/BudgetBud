import 'dart:convert';

Income incomeFromJson(String str) => Income.fromJson(json.decode(str));

String incomeToJson(Income data) => json.encode(data.toJson());

class Income {
  Income({
    required this.documentId,
    required this.userEmail,
    required this.incomeName,
    required this.incomeDescription,
    required this.incomeAmount,
    required this.incomeDate,
  });
  final String documentId;
  final String userEmail;
  final String incomeName;
  final String incomeDescription;
  final double incomeAmount;
  final DateTime incomeDate;

  factory Income.fromJson(Map<String, dynamic> json) => Income(
        userEmail: json["UserEmail"],
        incomeName: json["IncomeName"],
        incomeDescription: json["IncomeDescription"],
        incomeAmount: json["IncomeAmount"],
        incomeDate: DateTime.parse(json["IncomeDate"]),
        documentId: '',
      );

  Map<String, dynamic> toJson() => {
        "UserEmail": userEmail,
        "IncomeName": incomeName,
        "IncomeDescription": incomeDescription,
        "IncomeAmount": incomeAmount,
        "IncomeDate": incomeDate.toIso8601String(),
      };
}
