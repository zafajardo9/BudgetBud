import 'dart:math';

import 'package:budget_bud/misc/txtStyles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../colors.dart';
import '../graphs_widget/graph_indicator.dart';

class PieGraphWidget extends StatelessWidget {
  final TransactionType transactionType;

  const PieGraphWidget({Key? key, required this.transactionType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    late Query<Map<String, dynamic>> query;

    if (transactionType != TransactionType.all) {
      query = FirebaseFirestore.instance
          .collection('Transactions')
          .where('UserEmail', isEqualTo: user.email)
          .where('TransactionType',
              isEqualTo: transactionTypeToString(transactionType));
    } else {
      query = FirebaseFirestore.instance
          .collection('Transactions')
          .where('UserEmail', isEqualTo: user.email);
    }

    return StreamBuilder<QuerySnapshot>(
      stream: query.snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }

        final documents = snapshot.data!.docs;

        if (documents.isEmpty) {
          return SvgPicture.asset(
            'assets/no_data_found/nd1.1 (2).svg', // Replace with your actual image path
            fit: BoxFit.cover,
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        // Calculate the total amount for all categories
        double totalAmount = 0;
        for (var doc in documents) {
          final amount = doc.get('TransactionAmount') as double;
          totalAmount += amount;
        }

        // Calculate the percentage for each category
        final Map<String, double> categoryPercentages = {};
        for (var doc in documents) {
          final category = doc.get('TransactionCategory') as String;
          final amount = doc.get('TransactionAmount') as double;
          final percentage = (amount / totalAmount) * 100;

          if (categoryPercentages.containsKey(category)) {
            categoryPercentages[category] =
                categoryPercentages[category]! + percentage;
          } else {
            categoryPercentages[category] = percentage;
          }
        }

        // Convert the data into a list of PieChartSectionData
        final List<PieChartSectionData> pieChartSections =
            categoryPercentages.entries.map((entry) {
          final percentage = entry.value;

          return PieChartSectionData(
            value: percentage,
            title:
                '${percentage.toStringAsFixed(1)}%', // Display the percentage
            color: colors[categoryPercentages.keys.toList().indexOf(entry.key) %
                colors.length],
            radius: 40,
            titleStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          );
        }).toList();

// Sort the legends based on percentage in descending order
        final List<MapEntry<String, double>> sortedEntries =
            categoryPercentages.entries.toList()
              ..sort((a, b) => b.value.compareTo(a.value));

        final List<Widget> legends = sortedEntries.map((entry) {
          final category = entry.key;
          final percentage = entry.value;

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Indicator(
              color: colors[
                  categoryPercentages.keys.toList().indexOf(entry.key) %
                      colors.length],
              text: '$category (${percentage.toStringAsFixed(1)}%)',
              isSquare: false,
            ),
          );
        }).toList();

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: PieChart(
                  PieChartData(
                    sections: pieChartSections,
                    centerSpaceRadius: 50,
                    startDegreeOffset: -90,
                    borderData: FlBorderData(show: false),
                    sectionsSpace: 0,
                    //pieTouchData: PieTouchData(touchCallback: (pieTouchResponse) {}),
                    // You can customize other properties of the pie chart here
                  ),
                ),
              ),
              Icon(Icons.arrow_downward_rounded),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: legends,
              ),
            ],
          ),
        );
      },
    );
  }

  // Helper function to generate a random color
  Color getRandomColor() {
    final random = Random();
    final baseColor = Color(0xFFF68059); // Specify your base color here
    final redOffset = random.nextInt(51) -
        25; // Generate a random offset within the range of -25 to 25
    final greenOffset = random.nextInt(51) - 25;
    final blueOffset = random.nextInt(51) - 25;

    final red = (baseColor.red + redOffset).clamp(0, 255);
    final green = (baseColor.green + greenOffset).clamp(0, 255);
    final blue = (baseColor.blue + blueOffset).clamp(0, 255);

    return Color.fromARGB(255, red, green, blue);
  }

  // Helper function to convert TransactionType enum to string
  String transactionTypeToString(TransactionType type) {
    switch (type) {
      case TransactionType.expense:
        return 'Expense';
      case TransactionType.income:
        return 'Income';
      case TransactionType.all:
      default:
        return '';
    }
  }
}

enum TransactionType {
  expense,
  income,
  all,
}
