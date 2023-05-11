import 'package:budget_bud/misc/colors.dart';
import 'package:budget_bud/misc/txtStyles.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../category_page/category_page.dart';

class AddBudget extends StatefulWidget {
  const AddBudget({Key? key}) : super(key: key);

  @override
  State<AddBudget> createState() => _AddBudgetState();
}

class _AddBudgetState extends State<AddBudget> {
  DateTime _dateTime = DateTime.now();
  //controllers
  final newIncomeNameController = TextEditingController();
  final newIncomeDescriptionController = TextEditingController();
  final newIncomeAmountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create a budget'),
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UserCategory()),
                );
              },
              icon: Icon(Icons.category))
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Add new Budget',
              style: ThemeText.headerAuth,
            ),
          ),
          SingleChildScrollView(
            child: Form(
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        'Start Date',
                        style: ThemeText.subHeader2Bold,
                      ),
                      Column(
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
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'End Date',
                        style: ThemeText.subHeader2Bold,
                      ),
                      Column(
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
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
