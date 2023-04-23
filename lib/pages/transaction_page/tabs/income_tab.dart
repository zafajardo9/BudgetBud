import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:budget_bud/misc/widgetSize.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../data/income_data.dart';
import '../../../misc/colors.dart';
import '../../../misc/txtStyles.dart';

const COLLECTION_NAME = 'Income';

class IncomeTab extends StatefulWidget {
  const IncomeTab({Key? key}) : super(key: key);

  @override
  State<IncomeTab> createState() => _IncomeTabState();
}

// class FirebaseService {
//   final _database = FirebaseDatabase.instance.reference();
//
//   Future<void> addIncome(Income income) async {
//     await _database.child('incomes').push().set({
//       'incomeName': income.incomeName,
//       'incomeDescription': income.incomeDescription,
//       'incomeAmount': income.incomeAmount,
//       'incomeDate': income.incomeDate.toIso8601String(),
//     });
//   }
// }

class _IncomeTabState extends State<IncomeTab> {
  //userEmail
  final user = FirebaseAuth.instance.currentUser!;

  DateTime _dateTime = DateTime.now();
  //controllers
  final newIncomeNameController = TextEditingController();
  final newIncomeDescriptionController = TextEditingController();
  final newIncomeAmountController = TextEditingController();

  //save
  saveIncome() {
    //getting values
    var incomeName = newIncomeNameController.text.trim();
    var incomeDescription = newIncomeDescriptionController.text.trim();
    var incomeAmount = int.parse(newIncomeAmountController.text.trim());

    var incomeTransaction = Income(
        userEmail: user.email!,
        incomeName: incomeName,
        incomeDescription: incomeDescription,
        incomeAmount: incomeAmount,
        incomeDate: _dateTime);
    FirebaseFirestore.instance
        .collection(COLLECTION_NAME)
        .add(incomeTransaction.toJson());

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
    newIncomeNameController.clear();
    newIncomeDescriptionController.clear();
    newIncomeAmountController.clear();
  }

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
            'Input your Income',
            style: ThemeText.subHeader1Bold,
          ),
          SingleChildScrollView(
            child: Form(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // gagawa ng categories dito
                        Text(
                          'Income Name',
                          style: ThemeText.paragraph54,
                        ),
                        TextField(
                          controller: newIncomeNameController,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 20, horizontal: 30),
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
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 20, horizontal: 30),
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
                          'Income Description (Optional)',
                          style: ThemeText.paragraph54,
                        ),
                        TextField(
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 20, horizontal: 30),
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
                        //FOR DATETIME
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              '${_dateTime.month}/${_dateTime.day}/${_dateTime.year}',
                            ),
                            ElevatedButton(
                              child: Text('Select a Date'),
                              onPressed: () async {
                                DateTime? newDate = await showDatePicker(
                                    context: context,
                                    initialDate: _dateTime,
                                    firstDate: DateTime(1900),
                                    lastDate: DateTime(2100));

                                //if "CANCEL" => null
                                if (newDate == null) return;
                                //if "OK" => DateTime
                                setState(() => _dateTime = newDate);
                              },
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
                            minimumSize: Size(150, 50),
                          ),
                          icon: Icon(Icons.category), // Button icon
                          label: Text('Categories'), // Button label
                        ),
                        ElevatedButton(
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all(CircleBorder()),
                            padding: MaterialStateProperty.all(
                                EdgeInsets.all(15)), // <-- Button color
                            overlayColor:
                                MaterialStateProperty.resolveWith<Color?>(
                                    (states) {
                              if (states.contains(MaterialState.pressed)) {
                                return AppColors
                                    .mainColorTwo; // <-- Splash color
                              }
                            }),
                          ),
                          onPressed: saveIncome,
                          child: Icon(Icons.arrow_forward),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
