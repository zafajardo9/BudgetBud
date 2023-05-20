import 'package:budget_bud/misc/widgetSize.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../colors.dart';

class BarGraphWidget extends StatelessWidget {
  final user = FirebaseAuth.instance.currentUser!;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance
          .collection('Transactions')
          .where('UserEmail', isEqualTo: user.email)
          .where('TransactionType', isEqualTo: 'Income')
          .get(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        final List<DocumentSnapshot> documents = snapshot.data!.docs;

        // Create a map to store the total amount per day
        final Map<int, double> totalAmountPerDay = {};

        // Iterate over the documents and calculate the total amount per day
        for (final document in documents) {
          final DateTime transactionDate =
              DateTime.parse(document['TransactionDate']).toLocal();
          final double amount = document['TransactionAmount'];

          final int dayOfWeek = transactionDate.weekday;

          if (totalAmountPerDay.containsKey(dayOfWeek)) {
            totalAmountPerDay[dayOfWeek] =
                totalAmountPerDay[dayOfWeek]! + amount;
            print(totalAmountPerDay[dayOfWeek]);
          } else {
            totalAmountPerDay[dayOfWeek] = amount;
          }
        }

        // Create a list of BarChartGroupData objects for each day
        final List<BarChartGroupData> barChartData = totalAmountPerDay.entries
            .map((entry) => BarChartGroupData(
                  x: entry.key.round(),
                  barRods: [
                    BarChartRodData(
                      color: AppColors.mainColorOne,
                      toY: entry.value,
                      width: 15,
                      borderRadius: BorderRadius.circular(4),
                      backDrawRodData: BackgroundBarChartRodData(
                          show: true, color: Colors.grey[300]),
                    ),
                  ],
                ))
            .toList();

        return AspectRatio(
          aspectRatio: 1,
          child: BarChart(
            BarChartData(
              gridData: FlGridData(show: false),
              barGroups: barChartData,
              titlesData: FlTitlesData(
                show: true,
                rightTitles:
                    AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles:
                    AxisTitles(sideTitles: SideTitles(showTitles: false)),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    reservedSize: 50,
                    showTitles: true,
                    getTitlesWidget: (double value, TitleMeta meta) {
                      const style = TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      );
                      Widget text;
                      switch (value.toInt()) {
                        case 0:
                          text = const Text('M', style: style);
                          break;
                        case 1:
                          text = const Text('T', style: style);
                          break;
                        case 2:
                          text = const Text('W', style: style);
                          break;
                        case 3:
                          text = const Text('T', style: style);
                          break;
                        case 4:
                          text = const Text('F', style: style);
                          break;
                        case 5:
                          text = const Text('S', style: style);
                          break;
                        case 6:
                          text = const Text('S', style: style);
                          break;
                        default:
                          text = const Text('', style: style);
                          break;
                      }
                      return SideTitleWidget(
                        axisSide: meta.axisSide,
                        space: 12,
                        child: text,
                      );
                    },
                  ),
                ),
                leftTitles:
                    AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              borderData: FlBorderData(
                show: true,
                border: Border.all(color: Colors.grey),
              ),
            ),
          ),
        );
      },
    );
  }
}
