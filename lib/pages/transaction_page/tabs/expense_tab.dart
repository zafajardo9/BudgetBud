import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../data/expense_data.dart';
import '../../../dataModels/transaction_model.dart';
import '../../../misc/colors.dart';
import '../../../misc/txtStyles.dart';
import '../../../misc/widgetSize.dart';

const COLLECTION_NAME = 'Expense';

class ExpenseTab extends StatefulWidget {
  const ExpenseTab({Key? key}) : super(key: key);

  @override
  State<ExpenseTab> createState() => _ExpenseTabState();
}

class _ExpenseTabState extends State<ExpenseTab> {
  final user = FirebaseAuth.instance.currentUser!;

  DateTime _dateTime = DateTime.now();
//controllers
  final newExpenseNameController = TextEditingController();
  final newExpenseDescriptionController = TextEditingController();
  final newExpenseAmountController = TextEditingController();

  saveExpense() {
    //getting values
    var expenseName = newExpenseNameController.text.trim();
    var expenseDescription = newExpenseDescriptionController.text.trim();
    var expenseAmount = double.parse(newExpenseAmountController.text.trim());

    var expenseTransaction = Expense(
        userEmail: user.email!,
        expenseName: expenseName,
        expenseDescription: expenseDescription,
        expenseAmount: expenseAmount,
        expenseDate: _dateTime);
    FirebaseFirestore.instance
        .collection(COLLECTION_NAME)
        .add(expenseTransaction.toJson());

    var transaction = TransactionData(
      userEmail: user.email!,
      transactionName: expenseName,
      transactionType: 'Expense',
      description: expenseDescription,
      amount: expenseAmount,
      category: 'any',
      transactionDate: _dateTime,
      documentId: '',
    );
    FirebaseFirestore.instance
        .collection('Transactions')
        .add(transaction.toJson());

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
        message: 'You have successfully recorded an Income',

        /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
        contentType: ContentType.success,
      ),
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  void _clearTextFields() {
    newExpenseNameController.clear();
    newExpenseDescriptionController.clear();
    newExpenseAmountController.clear();
  }

  //Widget ITSELF
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            color: AppColors.mainColorTwo,
          ),
          addVerticalSpace(30),
          Text(
            'Input your Expense',
            style: ThemeText.subHeader1Bold,
          ),
          Form(
            child: SizedBox(
              width: Adaptive.w(90),
              child: Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // gagawa ng categories dito
                      Text(
                        'Expense Name',
                        style: ThemeText.paragraph54,
                      ),
                      TextField(
                        controller: newExpenseNameController,
                        style: ThemeText.textfieldInput,
                        decoration: InputDecoration(
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
                      ),
                      addVerticalSpace(20),

                      Text(
                        'Amount',
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
                        controller: newExpenseAmountController,
                      ),
                      addVerticalSpace(20),
                      Text(
                        'Expense Description (Optional)',
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
                        controller: newExpenseDescriptionController,
                      ),
                      addVerticalSpace(20),
                      //FOR DATETIME
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
                      )
                    ],
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
                              MaterialStateProperty.resolveWith<Color?>(
                                  (states) {
                            if (states.contains(MaterialState.pressed)) {
                              return AppColors.mainColorTwo; // <-- Splash color
                            }
                          }),
                        ),
                        onPressed: saveExpense,
                        child: Icon(Icons.arrow_forward),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
