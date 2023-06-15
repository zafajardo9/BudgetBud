import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:budget_bud/misc/txtStyles.dart';
import 'package:budget_bud/misc/widgetSize.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../data/budget_goal_data.dart';
import '../../../misc/colors.dart';
import '../../category_page/category_budget_goal.dart';
import '../../category_page/category_list/category_lists.dart';
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

  ///Validation
  saveBudgetGoal() async {
    if (selectedBudgetcategory.isEmpty) {
      error('Please select a budget category.');
      return;
    }

    var budgetName = newBudgetNameController.text.trim();
    if (budgetName.isEmpty) {
      error('Please enter a budget name.');
      return;
    }

    // var budgetDescription = newBudgetDescriptionController.text.trim();
    // Add validation for budget description if needed

    var budgetAmountText = newBudgetAmountController.text.trim();
    if (budgetAmountText.isEmpty) {
      error('Please enter a budget amount.');
      return;
    }
    var budgetAmount = double.tryParse(budgetAmountText);
    if (budgetAmount == null || budgetAmount <= 0) {
      error('Please enter a valid budget amount.');
      return;
    }

    // Rest of the code for creating and saving the budget goal
    var budgetGoal = BudgetGoal(
      documentId: '', // Remove the empty string here
      budgetName: budgetName,
      budgetAmount: budgetAmount,
      budgetFrequency: _selectedFrequency,
      budgetCategory: selectedBudgetcategory,
      startDate: dateTimeRange.start,
      endDate: dateTimeRange.end,
      userEmail: user.email!,
    );

    var documentReference = await FirebaseFirestore.instance
        .collection('BudgetGoals')
        .add(budgetGoal.toJson());

// Store the document ID
    var documentId = documentReference.id;
    budgetGoal.documentId = documentId;

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

  void error(String message) {
    final snackBar = SnackBar(
      /// need to set following properties for best effect of awesome_snackbar_content
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: 'Error',
        message: message,

        /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
        contentType: ContentType.failure,
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

  List<String> _frequency = [
    'Daily',
    'Weekly',
    'Monthly',
  ]; // Option 2
  String _selectedFrequency = "Daily";

  String selectedBudgetcategory = '';
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    final startDate = dateTimeRange.start;
    final endDate = dateTimeRange.end;
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        title: Text('Create a budget'),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CategoriesBudget()),
              );
            },
            icon: Icon(FontAwesomeIcons.circleQuestion),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Choose Category',
                style: ThemeText.subHeader2,
              ),
            ),
            Container(
              height: Adaptive.h(20),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: budgetingGoals.asMap().entries.map((entry) {
                    final index = entry.key;
                    final goal = entry.value;
                    final category = goal['category'];
                    bool isPressed = selectedBudgetcategory == category;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedBudgetcategory = isPressed ? '' : category!;
                          print(selectedBudgetcategory);
                        });
                      },
                      child: Container(
                        width: Adaptive.w(30),
                        margin: EdgeInsets.all(8.0),
                        padding: EdgeInsets.all(17),
                        decoration: BoxDecoration(
                          color: isPressed
                              ? AppColors.mainColorOne
                              : AppColors.backgroundWhite,
                          borderRadius: BorderRadius.circular(25),
                          border: isPressed
                              ? Border.all(
                                  color: AppColors.mainColorOne,
                                  width: 2,
                                )
                              : null,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.mainColorOne.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SvgPicture.asset(
                              'assets/budgetCategory/${index + 1}.svg',
                              height: 3.5.h,
                              color: isPressed ? Colors.white : Colors.black54,
                            ),
                            Text(
                              category ?? '',
                              style: TextStyle(
                                color:
                                    isPressed ? Colors.white : Colors.black54,
                                fontSize: 15.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'How Long?',
                style: ThemeText.subHeader2,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: SizedBox(
                      height: Adaptive.h(10),
                      child: ElevatedButton(
                        onPressed: pickDateRange,
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
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
                      height: Adaptive.h(10),
                      child: ElevatedButton(
                        onPressed: pickDateRange,
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
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
                    Text(
                      'Frequency',
                      style: ThemeText.paragraph54,
                    ),
                    Container(
                      width: Adaptive.w(100),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(color: Colors.grey),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: DropdownButton(
                        underline: Container(),
                        isExpanded: true,
                        hint:
                            Text('Please choose'), // Not necessary for Option 1
                        value: _selectedFrequency,
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedFrequency = newValue ?? '';
                          });
                        },

                        items: _frequency.map((location) {
                          return DropdownMenuItem(
                            child: new Text(location),
                            value: location,
                          );
                        }).toList(),
                      ),
                    ),
                    addVerticalSpace(2),
                  ],
                ),
              ),
            ),
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
