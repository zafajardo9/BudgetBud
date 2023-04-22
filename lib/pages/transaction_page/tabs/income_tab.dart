import 'package:budget_bud/misc/widgetSize.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../misc/colors.dart';
import '../../../misc/txtStyles.dart';

class IncomeTab extends StatefulWidget {
  const IncomeTab({Key? key}) : super(key: key);

  @override
  State<IncomeTab> createState() => _IncomeTabState();
}

class _IncomeTabState extends State<IncomeTab> {
  //controllers
  final newIncomeNameController = TextEditingController();
  final newIncomeDescriptionController = TextEditingController();
  final newIncomeAmountController = TextEditingController();

  //save
  void saveExpense() {}
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
                      ],
                    ),
                    addVerticalSpace(30),
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
                          onPressed: saveExpense,
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
