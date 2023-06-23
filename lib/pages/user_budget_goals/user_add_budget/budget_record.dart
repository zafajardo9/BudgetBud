import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../data/budget_goal_data.dart';
import '../../../data/budget_record_data.dart';
import '../../../misc/colors.dart';
import '../../../misc/txtStyles.dart';

class BudgetRecords extends StatefulWidget {
  final String documentId;
  BudgetRecords({super.key, required this.documentId});

  @override
  State<BudgetRecords> createState() => _BudgetRecordsState();
}

class _BudgetRecordsState extends State<BudgetRecords> {
  DateTime _dateTime = DateTime.now();

  //controllers
  final budgetRecordAmountController = TextEditingController();
  late Future<DocumentSnapshot<Map<String, dynamic>>> _budgetGoalFuture;

  @override
  void initState() {
    super.initState();
    _budgetGoalFuture = _fetchBudgetGoal();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> _fetchBudgetGoal() {
    return FirebaseFirestore.instance
        .collection('BudgetGoals')
        .doc(widget.documentId)
        .get();
  }

  void _clearTextFields() {
    budgetRecordAmountController.clear();
  }

  void saveRecord() async {
    String amount = budgetRecordAmountController.text.trim();
    String date = _dateTime.toString(); // Or format it as per your requirement

    if (amount.isNotEmpty && date.isNotEmpty) {
      // Create a Record object
      Record record = Record(
        amount: int.parse(amount),
        date: DateTime.parse(date),
        documentId: '',
      );

      try {
        // Get a reference to the budget goal document
        DocumentReference budgetGoalRef = FirebaseFirestore.instance
            .collection('BudgetGoals')
            .doc(widget
                .documentId); // Use widget.documentId instead of widget.budgetGoal.documentId

        // Add the record to the subcollection 'records' of the budget goal document
        await budgetGoalRef.collection('records').add(record.toJson());

        // Success! Record added to the subcollection
        print(widget.documentId);
        _clearTextFields();
        // You can show a success message or navigate to another screen if needed
      } catch (error) {
        // Error occurred while adding the record
        print('Error: $error');
        // You can show an error message to the user
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      future: _budgetGoalFuture,
      builder: (BuildContext context,
          AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasError) {
          return Center(
            child: Text('Something went wrong'),
          );
        }
        if (!snapshot.hasData) {
          return Center(
            child: Text('No data available'),
          );
        }

        final budgetGoalData = snapshot.data!.data();
        if (budgetGoalData == null) {
          return Center(
            child: Text('Budget goal not found'),
          );
        }

        final budgetGoal = BudgetGoal.fromJson(budgetGoalData);

        return Scaffold(
          backgroundColor: AppColors.backgroundWhite,
          appBar: AppBar(
            title: Text('Budget Details'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    margin: EdgeInsets.all(10),
                    width: Adaptive.w(100),
                    decoration: BoxDecoration(
                      color: AppColors.backgroundWhite,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.mainColorOne.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Text(
                          'Budget Name: ${budgetGoal.budgetName}',
                          style: TextStyle(
                              fontSize: 18.sp, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        Text(
                            'Amount: ₱${budgetGoal.budgetAmount.toStringAsFixed(2)}'),
                        SizedBox(height: 8),
                        Text(
                            '${budgetGoal.getFormattedStartDate()} - ${budgetGoal.getFormattedEndDate()}'),
                      ],
                    )),
                Container(
                    margin: EdgeInsets.all(10),
                    width: Adaptive.w(100),
                    decoration: BoxDecoration(
                      color: AppColors.backgroundWhite,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.mainColorOne.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset(
                          'assets/coins.png',
                          fit: BoxFit.contain,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'We recommend you to save:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text('₱ ${budgetGoal.amountToSave}'),
                          ],
                        ),
                      ],
                    )),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextField(
                        style: ThemeText.textfieldInput,
                        decoration: InputDecoration(
                          hintText: 'Savings amount',
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 1.w, horizontal: 4.h),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(
                              color: Colors.grey.shade400,
                              width: 2,
                            ),
                          ),
                        ),
                        controller: budgetRecordAmountController,
                        keyboardType:
                            TextInputType.number, // Show numeric keyboard
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter
                              .digitsOnly // Only allow digits
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            '${_dateTime.month}/${_dateTime.day}/${_dateTime.year}',
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    20), // Rounded corners
                              ),
                              minimumSize: Size(50.w, 5.h),
                            ),
                            onPressed: () async {
                              DateTime? newDate = await showDatePicker(
                                context: context,
                                initialDate: _dateTime,
                                firstDate: DateTime(1850),
                                lastDate: DateTime.now(),
                              );

                              //if "CANCEL" => null
                              if (newDate == null) return;
                              //if "OK" => DateTime
                              setState(() => _dateTime = newDate);
                            },
                            child: Text('Select a Date'),
                          )
                        ],
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all(CircleBorder()),
                          padding: MaterialStateProperty.all(
                              EdgeInsets.all(2.h)), // <-- Button color
                          overlayColor:
                              MaterialStateProperty.resolveWith<Color?>(
                                  (states) {
                            if (states.contains(MaterialState.pressed)) {
                              return AppColors.mainColorTwo; // <-- Splash color
                            }
                          }),
                        ),
                        onPressed: saveRecord,
                        child: Icon(Icons.arrow_forward),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
