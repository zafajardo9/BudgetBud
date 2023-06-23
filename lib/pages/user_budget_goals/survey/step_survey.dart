import 'package:budget_bud/pages/user_budget_goals/survey/survey_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../misc/txtStyles.dart';
import '../user_budgets.dart';

class StepSurvey extends StatefulWidget {
  const StepSurvey({super.key});

  @override
  State<StepSurvey> createState() => _StepSurveyState();
}

class _StepSurveyState extends State<StepSurvey> {
  //applying one time survey logic
  bool showSurveyScreen = false;

  @override
  void initState() {
    super.initState();
    checkSurveyScreenStatus();
  }

  void checkSurveyScreenStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool alreadyShown = prefs.getBool('surveyScreenShown') ?? false;
    setState(() {
      showSurveyScreen = !alreadyShown;
    });
  }

  void markSurveyScreenAsShown() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('surveyScreenShown', true);
  }

  //end of logic and checking

  int currentStep = 0;

  List<String> budgetScheduleOptions = [
    'Weekly',
    'Monthly',
    'Paychecks received'
  ];
  String selectedBudgetSched = '';

  final budgetGoalKey = GlobalKey<FormState>();
  final budgetBreakdown = GlobalKey<FormState>();

  final _amountController = TextEditingController();
  final firstValue = TextEditingController();
  final secondValue = TextEditingController();
  final thirdValue = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    firstValue.dispose();
    secondValue.dispose();
    thirdValue.dispose();
    super.dispose();
  }

  String? _validateAmount(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a budget amount';
    }

    final amountRegex = r'^\d+(\.\d{1,2})?$';
    final isValidAmount = RegExp(amountRegex).hasMatch(value);
    if (!isValidAmount) {
      return 'Please enter a valid amount';
    }

    return null;
  }

  List<Step> getSteps() => [
        Step(
          state: currentStep > 0 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 0,
          title: Text(
            'Budget \nSchedule',
            style: TextStyle(fontSize: 13.sp),
            maxLines: 2,
          ),
          content: Container(
            child: Column(
              children: [
                Text(
                  'What is your budget schedule?',
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 18.sp,
                  ),
                ),
                RadioListTile<String>(
                  title: Text('Weekly'),
                  value: budgetScheduleOptions[0],
                  groupValue: selectedBudgetSched,
                  onChanged: (value) {
                    setState(() {
                      selectedBudgetSched = value!;
                    });
                  },
                ),
                RadioListTile<String>(
                  title: Text('Monthly'),
                  value: budgetScheduleOptions[1],
                  groupValue: selectedBudgetSched,
                  onChanged: (value) {
                    setState(() {
                      selectedBudgetSched = value!;
                    });
                  },
                ),
                RadioListTile<String>(
                  title: Text('Paychecks received'),
                  value: budgetScheduleOptions[2],
                  groupValue: selectedBudgetSched,
                  onChanged: (value) {
                    setState(() {
                      selectedBudgetSched = value!;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
        Step(
          state: currentStep > 1 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 1,
          title: Text(
            'Total \nBudget',
            style: TextStyle(fontSize: 13.sp),
            maxLines: 2,
          ),
          content: Container(
            child: Form(
              key: budgetGoalKey,
              autovalidateMode:
                  AutovalidateMode.always, // Enable automatic validation
              child: Column(
                children: [
                  Text(
                    'What is your total budget for your monthly expenses?',
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 18.sp,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: TextFormField(
                      controller: _amountController,
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^\d+\.?\d{0,2}')),
                      ],
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
                      onChanged: (value) {
                        budgetGoalKey.currentState
                            ?.validate(); // Trigger validation on input change
                      },
                      validator: _validateAmount,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Step(
          isActive: currentStep >= 2,
          title: Text(
            'Budget \nBreakdown',
            style: TextStyle(fontSize: 13.sp),
            maxLines: 2,
          ),
          content: Container(
            child: Form(
              child: Column(
                children: [
                  Text(
                    'Your Budget breakdown!!',
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 18.sp,
                    ),
                  ),
                  Text(
                    'We need your data on how you save',
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    style: TextStyle(
                      fontSize: 15.sp,
                    ),
                  ),
                  Text(
                    'so that we can help',
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    style: TextStyle(
                      fontSize: 15.sp,
                    ),
                  ),
                  Container(),
                  Text(
                    'The Budget Schedule you picked: ${selectedBudgetSched}',
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    style: TextStyle(
                      fontSize: 15.sp,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: TextFormField(
                      controller: firstValue,
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^\d+\.?\d{0,2}')),
                      ],
                      style: ThemeText.textfieldInput,
                      decoration: InputDecoration(
                        hintText: 'Wants',
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 1.w, horizontal: 4.h),
                        prefixIcon: Icon(
                          FontAwesomeIcons.ring,
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
                      onChanged: (value) {
                        budgetBreakdown.currentState
                            ?.validate(); // Trigger validation on input change
                      },
                      validator: _validateAmount,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: TextFormField(
                      controller: secondValue,
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^\d+\.?\d{0,2}')),
                      ],
                      style: ThemeText.textfieldInput,
                      decoration: InputDecoration(
                        hintText: 'Need',
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 1.w, horizontal: 4.h),
                        prefixIcon: Icon(
                          FontAwesomeIcons.bowlFood,
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
                      onChanged: (value) {
                        budgetBreakdown.currentState
                            ?.validate(); // Trigger validation on input change
                      },
                      validator: _validateAmount,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: TextFormField(
                      controller: thirdValue,
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^\d+\.?\d{0,2}')),
                      ],
                      style: ThemeText.textfieldInput,
                      decoration: InputDecoration(
                        hintText: 'Savings',
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 1.w, horizontal: 4.h),
                        prefixIcon: Icon(
                          FontAwesomeIcons.piggyBank,
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
                      onChanged: (value) {
                        budgetBreakdown.currentState
                            ?.validate(); // Trigger validation on input change
                      },
                      validator: _validateAmount,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ];

  @override
  Widget build(BuildContext context) {
    if (!showSurveyScreen) {
      return UserBudgetGoals();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Questions For you'),
        elevation: 0,
      ),
      body: Stepper(
        type: StepperType.horizontal,
        steps: getSteps(),
        currentStep: currentStep,
        onStepTapped: (step) {
          setState(() => currentStep = step);
        },
        onStepContinue: () {
          final isLastStep = currentStep == getSteps().length - 1;
          if (isLastStep) {
            print('Completed');
            //function to send data to database
            addSurveyDataToFirestore(
              budgetSchedule: selectedBudgetSched,
              totalBudget: double.parse(_amountController.text),
              wantsValue: double.parse(firstValue.text),
              needsValue: double.parse(secondValue.text),
              savingsValue: double.parse(thirdValue.text),
            );
            //send to the main screen
            markSurveyScreenAsShown(); // Mark survey screen as shown
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => UserBudgetGoals()),
            );
          } else {
            setState(() => currentStep += 1);
          }
        },
        //onStepTapped: (step) => setState(() => currentStep = step),
        onStepCancel: () {
          if (currentStep > 0) {
            setState(() => currentStep -= 1);
          }
        },
        controlsBuilder: (BuildContext context, ControlsDetails details) {
          final isLastStep = currentStep == getSteps().length - 1;
          return Row(
            children: [
              if (currentStep != 0)
                Expanded(
                  child: TextButton(
                    onPressed: details.onStepCancel,
                    child: Text('Back'),
                  ),
                ),
              SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: details.onStepContinue,
                  child: Text(isLastStep ? 'Confirm' : 'Next'),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          25), // Adjust the value as needed
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
