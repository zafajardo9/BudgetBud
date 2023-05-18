import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PieGraphWidget extends StatelessWidget {
  const PieGraphWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Transactions')
          .where('UserEmail', isEqualTo: user.email)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }

        final documents = snapshot.data!.docs;

        if (documents.isEmpty) {
          return Text('No data available.');
        }

        // Calculate the total amount for each category
        final Map<String, double> categoryAmounts = {};
        for (var doc in documents) {
          final category = doc.get('TransactionCategory') as String;
          final amount = doc.get('TransactionAmount') as double;

          if (categoryAmounts.containsKey(category)) {
            categoryAmounts[category] = categoryAmounts[category]! + amount;
          } else {
            categoryAmounts[category] = amount;
          }
        }

        // Convert the data into a list of PieChartSectionData
        final List<PieChartSectionData> pieChartSections =
            categoryAmounts.entries.map((entry) {
          final category = entry.key;
          final amount = entry.value;

          return PieChartSectionData(
            value: amount,
            title: '$category\n₱${amount.toStringAsFixed(2)}',
            color:
                getRandomColor(), // Generate a random color for each category
            radius: 100,
            titleStyle: TextStyle(
                fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
          );
        }).toList();

        return AspectRatio(
          aspectRatio: 1,
          child: PieChart(
            PieChartData(
              sections: pieChartSections,
              centerSpaceRadius: 0,
              startDegreeOffset: -90,
              borderData: FlBorderData(show: false),
              sectionsSpace: 0,
              //pieTouchData: PieTouchData(touchCallback: (pieTouchResponse) {}),
              // You can customize other properties of the pie chart here
            ),
          ),
        );
      },
    );
  }

  // Helper function to generate a random color
  Color getRandomColor() {
    final random = Random();
    return Color.fromARGB(
      255,
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
    );
  }
}
