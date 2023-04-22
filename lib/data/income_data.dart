import 'dart:convert';

Income incomeFromJson(String str) => Income.fromJson(json.decode(str));

String incomeToJson(Income data) => json.encode(data.toJson());

class Income {
  Income({
    required this.incomeName,
    required this.incomeDescription,
    required this.incomeAmount,
    required this.incomeDate,
  });

  final String incomeName;
  final String incomeDescription;
  final int incomeAmount;
  final DateTime incomeDate;

  factory Income.fromJson(Map<String, dynamic> json) => Income(
        incomeName: json["IncomeName"],
        incomeDescription: json["IncomeDescription"],
        incomeAmount: json["IncomeAmount"],
        incomeDate: DateTime.parse(json["IncomeDate"]),
      );

  Map<String, dynamic> toJson() => {
        "IncomeName": incomeName,
        "IncomeDescription": incomeDescription,
        "IncomeAmount": incomeAmount,
        "IncomeDate": incomeDate.toIso8601String(),
      };
}
