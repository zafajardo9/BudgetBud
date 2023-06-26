//get all the data

//make it to text

import 'package:budget_bud/data/transaction_data_summary.dart';

Future<String> generateTransactionSummaryQuestion() async {
  // Get the transaction summary by month
  final transactionSummaryByMonth = await calculateTransactionSummaryByMonth();

  // Get the transaction summary overall
  final transactionSummaryOverall =
      await calculateTransactionSummary(TimePeriod.Overall);

  // Form the sentence based on the transaction summary data
  String question = "Based on your transactions in the past month:\n";
  question += "Total income: \$${transactionSummaryByMonth.totalIncome}\n";
  question += "Total expense: \$${transactionSummaryByMonth.totalExpense}\n";
  question += "Balance: \$${transactionSummaryByMonth.balance}\n";
  question +=
      "Impulsive percentage: ${transactionSummaryByMonth.impulsivePercentage}%\n\n";
  question += "And overall:\n";
  question += "Total income: \$${transactionSummaryOverall.totalIncome}\n";
  question += "Total expense: \$${transactionSummaryOverall.totalExpense}\n";
  question += "Balance: \$${transactionSummaryOverall.balance}\n";
  question +=
      "Impulsive percentage: ${transactionSummaryOverall.impulsivePercentage}%\n";

  return question;
}
