import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../data/transaction_data_summary.dart';
import '../../misc/colors.dart';

class SpendingBarGraph extends StatelessWidget {
  final user = FirebaseAuth.instance.currentUser!;
  final TimePeriod period;

  SpendingBarGraph(this.period);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<TransactionSummary>(
      future: calculateTransactionSummary(period),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Padding(
            padding: EdgeInsets.all(100),
            child: LoadingAnimationWidget.fourRotatingDots(
              color: AppColors.mainColorOne,
              size: 50,
            ),
          );
        }

        final TransactionSummary summary = snapshot.data!;

        final double totalIncome = summary.totalIncome;
        final double totalExpense = summary.totalExpense;

        return AspectRatio(
          aspectRatio: 1,
          child: BarChart(
            BarChartData(
              barTouchData: BarTouchData(
                enabled: false,
                touchTooltipData: BarTouchTooltipData(
                  tooltipBgColor: Colors.transparent,
                  tooltipPadding: EdgeInsets.zero,
                  tooltipMargin: 8,
                  getTooltipItem: (
                    BarChartGroupData group,
                    int groupIndex,
                    BarChartRodData rod,
                    int rodIndex,
                  ) {
                    return BarTooltipItem(
                      rod.toY.round().toString(),
                      TextStyle(
                        color: AppColors.mainColorFour,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },
                ),
              ),
              titlesData: FlTitlesData(
                show: true,
                rightTitles:
                    AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles:
                    AxisTitles(sideTitles: SideTitles(showTitles: false)),
                bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                  showTitles: false,
                  // Modify the bottom titles to display only the transaction type
                  // getTitles: (double value) {
                  //   final List<TransactionDataSummary> data = summary.transactionData;
                  //   if (value >= 0 && value < data.length) {
                  //     return data[value.toInt()].transactionType;
                  //   }
                  //   return '';
                  // },
                )),
                leftTitles:
                    AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              borderData: FlBorderData(
                show: true,
                border: Border.all(color: Colors.grey),
              ),
              //barGroups: _buildBarGroups(data),
              gridData: FlGridData(show: false),
              alignment: BarChartAlignment.spaceAround,
              maxY: _calculateMaxY(totalIncome, totalExpense),
            ),
          ),
        );
      },
    );
  }

  List<BarChartGroupData> _buildBarGroups(List<TransactionDataSummary> data) {
    return data
        .asMap()
        .entries
        .map((entry) => BarChartGroupData(
              x: entry.key,
              barRods: [
                BarChartRodData(
                  toY: entry.value.amount,
                  width: 16,
                  color: AppColors.updateButton,
                ),
              ],
              showingTooltipIndicators: [0],
            ))
        .toList();
  }

  double _calculateMaxY(double totalIncome, double totalExpense) {
    return totalIncome > totalExpense ? totalIncome : totalExpense;
  }

  Color _getBarColor(String transactionType) {
    switch (transactionType) {
      case 'Income':
        return AppColors.mainColorOne;
      case 'Expense':
        return AppColors.mainColorTwo;
      default:
        return Colors.transparent;
    }
  }
}
