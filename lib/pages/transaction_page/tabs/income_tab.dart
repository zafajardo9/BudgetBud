import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:budget_bud/misc/widgetSize.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../dataModels/transaction_model.dart';
import '../../../misc/colors.dart';
import '../../../misc/txtStyles.dart';
import '../../category_page/category_list/category_lists.dart';
import '../transaction_components/item_selection_modal.dart';

const COLLECTION_NAME = 'Income';

class IncomeTab extends StatefulWidget {
  const IncomeTab({Key? key}) : super(key: key);

  @override
  State<IncomeTab> createState() => _IncomeTabState();
}

class _IncomeTabState extends State<IncomeTab> {
  ValueNotifier<String> selectedItemNotifier = ValueNotifier<String>('');
  //userEmail
  final user = FirebaseAuth.instance.currentUser!;

  DateTime _dateTime = DateTime.now();
  //controllers
  final newIncomeNameController = TextEditingController();
  final newIncomeDescriptionController = TextEditingController();
  final newIncomeAmountController = TextEditingController();
  String selectedItem = '';

//save
  saveIncome() {
    //getting values
    var incomeDescription = newIncomeDescriptionController.text.trim();
    var incomeAmount = double.parse(newIncomeAmountController.text.trim());

    if (selectedItem.isNotEmpty && incomeAmount > 0) {
      var transaction = TransactionData(
        userEmail: user.email!,
        transactionType: 'Income',
        description: incomeDescription,
        amount: incomeAmount,
        category: selectedItem,
        transactionDate: _dateTime,
        documentId: '',
      );
      FirebaseFirestore.instance
          .collection('Transactions')
          .add(transaction.toJson());

      FocusScope.of(context).unfocus();

      messageBar();
      _clearTextFields();
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Missing Information'),
            content: Text(
                'Please fill in all the required fields and select a category.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
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
    newIncomeDescriptionController.clear();
    newIncomeAmountController.clear();
    selectedItem == '';
  }

  //For dropdown modal
  void onTextFieldTap() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        // <-- SEE HERE
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Select Item',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Expanded(
                    child: ListView.builder(
                      itemCount: incomeCategories.length,
                      itemBuilder: (BuildContext context, int index) {
                        final item = incomeCategories[index];
                        final isSelected = selectedItem == item;

                        return ListTile(
                          title: Text(
                            item,
                            style: TextStyle(
                              color:
                                  isSelected ? AppColors.mainColorFour : null,
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              selectedItemNotifier.value = item;
                              selectedItem = item;
                            });
                          },
                          trailing: isSelected
                              ? Icon(Icons.check_circle,
                                  color: AppColors.mainColorFour)
                              : null,
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: AppColors.mainColorFour,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      minimumSize: Size(50.w, 5.h),
                    ),
                    onPressed: () {
                      Navigator.pop(context, selectedItem);
                    },
                    child: Text('Done'),
                  ),
                ],
              ),
            );
          },
        );
      },
    ).then((value) {
      if (value != null) {
        // Handle selected item
        String selectedItem = value as String;
        print(selectedItem);
      }
    });
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
          addVerticalSpace(3),
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
                            borderRadius: BorderRadius.circular(25),
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
                      addVerticalSpace(2),
                      Text(
                        'Income Description (Optional)',
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
                            borderRadius: BorderRadius.circular(25),
                            borderSide: BorderSide(
                              color: Colors.grey.shade400,
                              width: 2,
                            ),
                          ),
                        ),
                        controller: newIncomeDescriptionController,
                      ),
                      addVerticalSpace(2),
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
                  addVerticalSpace(2.5),
                  Column(
                    children: [
                      ElevatedButton.icon(
                        onPressed: onTextFieldTap,
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(25), // Rounded corners
                          ),
                          minimumSize: Size(100.w, 6.h),
                        ),
                        icon: Icon(Icons.category), // Button icon
                        label: ValueListenableBuilder<String>(
                          valueListenable: selectedItemNotifier,
                          builder: (BuildContext context, String value,
                              Widget? child) {
                            return Text(
                              value.isNotEmpty ? value : 'Categories',
                            );
                          },
                        ), // // Button label
                      ),
                      addVerticalSpace(2.5),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.mainColorFour,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(25), // Rounded corners
                          ),
                          minimumSize: Size(100.w, 6.h),
                        ),
                        onPressed: saveIncome,
                        child: Text(
                          'Save',
                          style: TextStyle(fontWeight: FontWeight.w800),
                        ),
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
