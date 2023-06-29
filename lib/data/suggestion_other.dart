import 'package:budget_bud/data/transaction_data_suggestion_fomulate.dart';

Future<String> getTransactionDataSummaryQuestion() async {
  final summary = await summaryForSuggestion(TimePeriod.Monthly);

  final totalIncome = summary.totalIncome;
  final totalExpense = summary.totalExpense;
  final balance = summary.balance;
  final impulsivePercentage = summary.impulsivePercentage;
  final highestCategories = summary.highestCategories;

  final categoryList = highestCategories.isNotEmpty
      ? '- ${highestCategories.join('\n- ')}'
      : 'No categories found.';

  final question = '''
  Pretend as a recommendation system and display answer in short sentences and dont include introduction.
Transaction summary for the month:

- Total Income: \₱${totalIncome.toStringAsFixed(2)}
- Total Expense: \₱${totalExpense.toStringAsFixed(2)}
- Balance: \₱${balance.toStringAsFixed(2)}
- Impulsive Percentage: ${impulsivePercentage.toStringAsFixed(2)}%
- Highest Expense Categories:
  $categoryList

Based on your spending habits, would you consider yourself financially disciplined or impulsive? What recommendations can you provide based on my transactions? (Short bullet points)
''';

  return question;
}

Future<String> getFactorsAnswer() async {
  final summary = await summaryForSuggestion(TimePeriod.Monthly);

  final totalIncome = summary.totalIncome;
  final totalExpense = summary.totalExpense;
  final balance = summary.balance;
  final impulsivePercentage = summary.impulsivePercentage;
  final highestCategories = summary.highestCategories;

  final categoryList = highestCategories.isNotEmpty
      ? '- ${highestCategories.join('\n- ')}'
      : 'No categories found.';

  final question = '''
  Pretend as a recommendation system and display answer in short sentences and dont include introduction.
Transaction summary for the month:

- Total Income: \₱${totalIncome.toStringAsFixed(2)}
- Total Expense: \₱${totalExpense.toStringAsFixed(2)}
- Balance: \₱${balance.toStringAsFixed(2)}
- Impulsive Percentage: ${impulsivePercentage.toStringAsFixed(2)}%
- Highest Expense Categories:
  $categoryList

Based on your spending habits, what are the factors why I spend alot? (Short bullet points)
''';

  return question;
}
