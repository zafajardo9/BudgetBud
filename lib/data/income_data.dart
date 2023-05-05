import 'dart:convert';

Income incomeFromJson(String str) => Income.fromJson(json.decode(str));

String incomeToJson(Income data) => json.encode(data.toJson());

class Income {
  Income({
    required this.userEmail,
    required this.incomeName,
    required this.incomeDescription,
    required this.incomeAmount,
    required this.incomeDate,
  });
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
      );

  Map<String, dynamic> toJson() => {
        "UserEmail": userEmail,
        "IncomeName": incomeName,
        "IncomeDescription": incomeDescription,
        "IncomeAmount": incomeAmount,
        "IncomeDate": incomeDate.toIso8601String(),
      };

  //getting and displaying

  // factory Income.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
  //   final data = document.data()!;
  //   return Income(
  //     userEmail: data["UserEmail"],
  //     incomeName: data["IncomeName"],
  //     incomeDescription: data["IncomeDescription"],
  //     incomeAmount: data["IncomeAmount"],
  //     incomeDate: data["IncomeDate"],
  //   );
  // }
}
