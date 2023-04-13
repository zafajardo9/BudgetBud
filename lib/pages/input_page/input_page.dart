import 'package:budget_bud/misc/colors.dart';
import 'package:flutter/material.dart';

import '../../misc/txtStyles.dart';

class InputPage extends StatefulWidget {
  const InputPage({Key? key}) : super(key: key);

  @override
  State<InputPage> createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  //controllers
  final newBudgetNameController = TextEditingController();
  final newBudgetAmountController = TextEditingController();

  //Methods
  //save
  void saveExpense() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottomOpacity: 0.0,
        elevation: 0.0,
        title: const Text(
          'Create Budget',
          style: ThemeText.appBarTitle,
        ),
        // actions: [
        //   IconButton(onPressed: () {}, icon: const Icon(Icons.settings))
        // ],
      ),
      body: Column(
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
