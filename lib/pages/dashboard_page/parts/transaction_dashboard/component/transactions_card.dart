import 'package:flutter/material.dart';

import '../../../../../data/transaction_data_summary.dart';
import '../../../../../misc/colors.dart';
import '../../../../../misc/txtStyles.dart';

class TransactionCardSummary extends StatefulWidget {
  final TimePeriod timePeriod;
  final String cardName;

  TransactionCardSummary({required this.timePeriod, required this.cardName});

  @override
  _TransactionCardSummaryState createState() => _TransactionCardSummaryState();
}

class _TransactionCardSummaryState extends State<TransactionCardSummary> {
  double balance = 0.0;
  double totalIncome = 0.0;
  double totalExpense = 0.0;

  @override
  void initState() {
    super.initState();
    fetchBalance();
  }

  Future<void> fetchBalance() async {
    TransactionSummary summary =
        await calculateTransactionSummary(widget.timePeriod);
    setState(() {
      balance = summary.balance;
      totalIncome = summary.totalIncome;
      totalExpense = summary.totalExpense;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: AppColors.mainColorOne.withOpacity(0.3),
              spreadRadius: 5,
              blurRadius: 9,
              offset: Offset(3, 4), // changes the position of the shadow
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              widget.cardName,
              style: ThemeText.transactionName,
            ),
            Text(
              'Balance',
              style: ThemeText.transactionDetails,
            ),
            Text(
              balance.toString(),
              style: ThemeText.transactionAmount,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text('Expense'),
                    Text(
                      totalExpense.toString(),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.deleteButton),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text('Income'),
                    Text(
                      totalIncome.toString(),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.updateButton),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
