import 'package:budget_bud/misc/colors.dart';
import 'package:budget_bud/misc/txtStyles.dart';
import 'package:budget_bud/misc/widgetSize.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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

  DateTimeRange dateTimeRange =
      DateTimeRange(start: DateTime.now(), end: DateTime.now());

  @override
  Widget build(BuildContext context) {
    final startDate = dateTimeRange.start;
    final endDate = dateTimeRange.end;
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Add new Budget',
                style: ThemeText.headerAuth,
              ),
            ),
            Text('Pick your dates!'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: SizedBox(
                    height: Adaptive.h(20),
                    child: ElevatedButton(
                      onPressed: pickDateRange,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            'Your Start Date',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17.sp,
                            ),
                          ),
                          Text(
                              '${startDate.month}/${startDate.day}/${startDate.year}'),
                        ],
                      ),
                    ),
                  ),
                ),
                addHorizontalSpace(10),
                Expanded(
                  child: SizedBox(
                    height: Adaptive.h(20),
                    child: ElevatedButton(
                      onPressed: pickDateRange,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            'Your End Date',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17.sp,
                            ),
                          ),
                          Text(
                              '${endDate.month}/${endDate.day}/${endDate.year}'),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
            Form(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    addVerticalSpace(20),
                    Text(
                      'Goal Name',
                      style: ThemeText.paragraph54,
                    ),
                    TextField(
                      style: ThemeText.textfieldInput,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 1.w, horizontal: 4.h),
                        prefixIcon: Icon(
                          FontAwesomeIcons.penToSquare,
                          size: 15,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(
                            color: Colors.grey.shade400,
                            width: 2,
                          ),
                        ),
                      ),
                      controller: newIncomeDescriptionController,
                    ),
                    addVerticalSpace(20),
                    Text(
                      'Goal Amount to save',
                      style: ThemeText.paragraph54,
                    ),
                    TextField(
                      style: ThemeText.textfieldInput,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 1.w, horizontal: 4.h),
                        prefixIcon: Icon(
                          FontAwesomeIcons.pesoSign,
                          size: 15,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(
                            color: Colors.grey.shade400,
                            width: 2,
                          ),
                        ),
                      ),
                      keyboardType:
                          TextInputType.number, // Show numeric keyboard
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter
                            .digitsOnly // Only allow digits
                      ],
                      controller: newIncomeAmountController,
                    ),
                    addVerticalSpace(20),
                    Text(
                      'Description (Optional)',
                      style: ThemeText.paragraph54,
                    ),
                    TextField(
                      style: ThemeText.textfieldInput,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 1.w, horizontal: 4.h),
                        prefixIcon: Icon(
                          FontAwesomeIcons.penToSquare,
                          size: 15,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(
                            color: Colors.grey.shade400,
                            width: 2,
                          ),
                        ),
                      ),
                      controller: newIncomeDescriptionController,
                    ),
                    addVerticalSpace(20),
                  ],
                ),
              ),
            ),
            addVerticalSpace(25),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    // Do something when the button is pressed
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(20), // Rounded corners
                    ),
                    minimumSize: Size(40.w, 6.h),
                  ),
                  icon: Icon(Icons.category), // Button icon
                  label: Text('Categories'), // Button label
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(CircleBorder()),
                    padding: MaterialStateProperty.all(
                        EdgeInsets.all(2.h)), // <-- Button color
                    overlayColor:
                        MaterialStateProperty.resolveWith<Color?>((states) {
                      if (states.contains(MaterialState.pressed)) {
                        return AppColors.mainColorTwo; // <-- Splash color
                      }
                    }),
                  ),
                  onPressed: () {},
                  child: Icon(Icons.arrow_forward),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Future pickDateRange() async {
    DateTimeRange? newDateRange = await showDateRangePicker(
      context: context,
      initialDateRange: dateTimeRange,
      firstDate: DateTime.now(),
      lastDate: DateTime(2111),
    );
    if (newDateRange == null) return;

    setState(() => dateTimeRange = newDateRange);
  }
}
