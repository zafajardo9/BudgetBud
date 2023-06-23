import 'dart:convert';

Record goalFromJson(String str) => Record.fromJson(json.decode(str));

String goalToJson(Record data) => json.encode(data.toJson());

class Record {
  final String documentId;
  final int amount;
  final DateTime date;

  Record({
    required this.documentId,
    required this.amount,
    required this.date,
  });

  factory Record.fromJson(Map<String, dynamic> json) {
    return Record(
      amount: json["RecordAmount"],
      date: DateTime.parse(json["RecordDate"]),
      documentId: '',
    );
  }

  Map<String, dynamic> toJson() => {
        'RecordAmount': amount,
        'RecordDate': date.toIso8601String(),
      };
}
