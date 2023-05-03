class Transaction {
  String id;
  String userId;
  double amount;
  String description;
  String category;
  DateTime date;

  Transaction({
    required this.id,
    required this.userId,
    required this.amount,
    required this.description,
    required this.category,
    required this.date,
  });
}