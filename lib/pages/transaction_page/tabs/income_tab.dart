import 'package:flutter/material.dart';

import '../../../misc/colors.dart';
import '../../../misc/txtStyles.dart';

class IncomeTab extends StatefulWidget {
  const IncomeTab({Key? key}) : super(key: key);

  @override
  State<IncomeTab> createState() => _IncomeTabState();
}

class _IncomeTabState extends State<IncomeTab> {
  //controllers
  final newBudgetNameController = TextEditingController();
  final newBudgetAmountController = TextEditingController();

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
          Text('Add budget'),
          Form(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // gagawa ng categories dito
                      Text(
                        'Budget Name',
                        style: ThemeText.paragraph54,
                      ),
                      TextField(
                        controller: newBudgetNameController,
                      ),
                      Text(
                        'Enter your budget',
                        style: ThemeText.paragraph54,
                      ),
                      TextField(
                        controller: newBudgetAmountController,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all(CircleBorder()),
                          padding: MaterialStateProperty.all(
                              EdgeInsets.all(15)), // <-- Button color
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
