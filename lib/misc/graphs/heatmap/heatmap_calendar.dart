import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'heatmap_data_model.dart';

class HeatMapCalendarExample extends StatefulWidget {
  const HeatMapCalendarExample({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HeatMapCalendarExample();
}

class _HeatMapCalendarExample extends State<HeatMapCalendarExample> {
  final TextEditingController dateController = TextEditingController();
  final TextEditingController heatLevelController = TextEditingController();

  bool isOpacityMode = true;

  List<TransactionHeatModel> transactions = [];

  @override
  void dispose() {
    super.dispose();
    dateController.dispose();
    heatLevelController.dispose();
  }

  Widget _textField(final String hint, final TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 20, top: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xffe7e7e7), width: 1.0)),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF20bca4), width: 1.0)),
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.grey),
          isDense: true,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Heatmap Calendar'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),

                // HeatMapCalendar
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('Transactions')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }

                    // Process transaction data
                    transactions = snapshot.data!.docs
                        .map((document) =>
                            TransactionHeatModel.fromFirestore(document))
                        .toList();

                    final heatMapDatasets = {
                      for (final transaction in transactions)
                        transaction.date: transaction.heatLevel,
                    };

                    return HeatMapCalendar(
                      flexible: true,
                      datasets: heatMapDatasets,
                      colorMode:
                          isOpacityMode ? ColorMode.opacity : ColorMode.color,
                      colorsets: const {
                        1: Colors.red,
                        3: Colors.orange,
                        5: Colors.yellow,
                        7: Colors.green,
                        9: Colors.blue,
                        11: Colors.indigo,
                        13: Colors.purple,
                      },
                    );
                  },
                ),
              ),
              _textField('YYYYMMDD', dateController),
              _textField('Heat Level', heatLevelController),
              ElevatedButton(
                child: const Text('COMMIT'),
                onPressed: () {
                  setState(() {
                    final date = DateTime.parse(dateController.text);
                    final heatLevel = int.parse(heatLevelController.text);

                    final newTransaction = TransactionHeatModel(
                      date: date,
                      amount: 0, // Set the amount based on your requirements
                      name: '', // Set the name based on your requirements
                    );
                    newTransaction.heatLevel = heatLevel;

                    transactions.add(newTransaction);
                  });
                },
              ),

              // ColorMode/OpacityMode Switch.
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text('Color Mode'),
                  CupertinoSwitch(
                    value: isOpacityMode,
                    onChanged: (value) {
                      setState(() {
                        isOpacityMode = value;
                      });
                    },
                  ),
                  const Text('Opacity Mode'),
                ],
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}