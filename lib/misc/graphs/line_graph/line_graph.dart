import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class TransactionData {
  final DateTime date;
  final double amount;

  TransactionData({required this.date, required this.amount});
}

class LineGraph extends StatefulWidget {
  const LineGraph({Key? key}) : super(key: key);

  @override
  _LineGraphState createState() => _LineGraphState();
}

class _LineGraphState extends State<LineGraph> {
  final user = FirebaseAuth.instance.currentUser!;
  List<Color> gradientColors = [
    Colors.cyan,
    Colors.blue,
  ];

  List<FlSpot> transactionSpots = [];

  @override
  void initState() {
    super.initState();
    fetchTransactionData();
  }

  Future<void> fetchTransactionData() async {
    try {
      final QuerySnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance
              .collection('Transactions')
              .where('UserEmail', isEqualTo: user.email)
              .get();

      final List<TransactionData> transactions = snapshot.docs.map((doc) {
        final data = doc.data();
        final DateTime date = DateTime.parse(data['TransactionDate']).toLocal();
        final double amount = data['TransactionAmount'].toDouble();
        return TransactionData(date: date, amount: amount);
      }).toList();

      setState(() {
        transactionSpots = convertTransactionsToSpots(transactions);
      });
    } catch (error) {
      print('Error fetching transaction data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            horizontalInterval: 1,
            verticalInterval: 1,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: Colors.white,
                strokeWidth: 1,
              );
            },
            getDrawingVerticalLine: (value) {
              return FlLine(
                color: Colors.white,
                strokeWidth: 1,
              );
            },
          ),
          titlesData: FlTitlesData(
            show: true,
            rightTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          borderData: FlBorderData(
            show: false,
            border: Border.all(color: const Color(0xFF37434D)),
          ),
          minX: 0,
          maxX: transactionSpots.length.toDouble() - 1,
          minY: 0,
          maxY: getMaxTransactionAmount(),
          lineBarsData: [
            LineChartBarData(
              spots: transactionSpots,
              isCurved: true,
              gradient: LinearGradient(
                colors: gradientColors,
              ),
              barWidth: 5,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: false,
              ),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: gradientColors
                      .map((color) => color.withOpacity(0.3))
                      .toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<FlSpot> convertTransactionsToSpots(List<TransactionData> transactions) {
    return transactions
        .asMap()
        .entries
        .map((entry) => FlSpot(entry.key.toDouble(), entry.value.amount))
        .toList();
  }

  double getMaxTransactionAmount() {
    if (transactionSpots.isEmpty) return 0.0;
    return transactionSpots
        .map((spot) => spot.y)
        .reduce((a, b) => a > b ? a : b);
  }
}
