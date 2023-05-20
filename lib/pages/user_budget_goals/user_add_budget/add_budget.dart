import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:budget_bud/misc/colors.dart';
import 'package:budget_bud/misc/txtStyles.dart';
import 'package:budget_bud/misc/widgetSize.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../data/budget_goal_data.dart';
import '../../category_page/category_page.dart';

class AddBudget extends StatefulWidget {
  const AddBudget({Key? key}) : super(key: key);

  @override
  State<AddBudget> createState() => _AddBudgetState();
}

class _AddBudgetState extends State<AddBudget> {
  final user = FirebaseAuth.instance.currentUser!;
  //controllers
  final newBudgetNameController = TextEditingController();
  // final newBudgetDescriptionController = TextEditingController();
  final newBudgetAmountController = TextEditingController();

  DateTimeRange dateTimeRange =
      DateTimeRange(start: DateTime.now(), end: DateTime.now());

  saveBudgetGoal() {
    //getting values
    var budgetName = newBudgetNameController.text.trim();
    //var budgetDescription = newBudgetDescriptionController.text.trim();
    var budgetAmount = double.parse(newBudgetAmountController.text.trim());

    var budgetGoal = BudgetGoal(
      documentId: '',
      budgetName: budgetName,
      budgetAmount: budgetAmount,
      startDate: dateTimeRange.start,
      endDate: dateTimeRange.end,
      userEmail: user.email!,
    );
    FirebaseFirestore.instance
        .collection('BudgetGoals')
        .add(budgetGoal.toJson());

    messageBar();
    _clearTextFields();
  }

  void messageBar() {
    final snackBar = SnackBar(
      /// need to set following properties for best effect of awesome_snackbar_content
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: 'Success',
        message: 'You have successfully recorded a Budget Goal',

        /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
        contentType: ContentType.success,
      ),
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  void _clearTextFields() {
    newBudgetNameController.clear();
    newBudgetAmountController.clear();
  }

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
                addHorizontalSpace(1),
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
                    addVerticalSpace(2),
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
                      controller: newBudgetNameController,
                    ),
                    addVerticalSpace(2),
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
                      controller: newBudgetAmountController,
                    ),
                    addVerticalSpace(2),
                  ],
                ),
              ),
            ),
            addVerticalSpace(2),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton.icon(
                    onPressed: saveBudgetGoal,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(20), // Rounded corners
                      ),
                      minimumSize: Size(40.w, 6.h),
                    ),
                    icon: Icon(Icons.arrow_forward), // Button icon
                    label: Text('Add New Budget Goal'), // Button label
                  ),
                ],
              ),
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
