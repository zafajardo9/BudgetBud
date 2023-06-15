import 'package:budget_bud/misc/colors.dart';
import 'package:budget_bud/pages/user_budget_goals/user_add_budget/add_budget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../data/budget_goal_data.dart';
import '../../data/transaction_data_summary.dart';

class UserBudgetGoals extends StatefulWidget {
  const UserBudgetGoals({Key? key}) : super(key: key);

  @override
  State<UserBudgetGoals> createState() => _UserBudgetGoalsState();
}

class _UserBudgetGoalsState extends State<UserBudgetGoals> {
  CollectionReference _budgetGoalsRef =
      FirebaseFirestore.instance.collection('BudgetGoals');

  List<QueryDocumentSnapshot> budgetGoals = [];

  @override
  void initState() {
    super.initState();
    fetchBalance();
  }

  double balance = 0.0;
  double totalIncome = 0.0;
  double totalExpense = 0.0;
  double totalBudgetAmount = 0.0;

  Future<void> fetchBalance() async {
    TransactionSummary summary =
        await calculateTransactionSummary(TimePeriod.Overall);
    setState(() {
      balance = summary.balance;
      totalIncome = summary.totalIncome;
      totalExpense = summary.totalExpense;
    });

    // Fetch budgetGoals data
    QuerySnapshot snapshot = await _budgetGoalsRef.get();
    setState(() {
      budgetGoals = snapshot.docs;
    });

    // Calculate total budget amount
    double calculatedTotalBudgetAmount = budgetGoals
        .map((snapshot) =>
            BudgetGoal.fromJson(snapshot.data() as Map<String, dynamic>))
        .map((goal) => goal.budgetAmount)
        .fold(0, (sum, amount) => sum + amount);

    setState(() {
      totalBudgetAmount = calculatedTotalBudgetAmount;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.mainColorOne, AppColors.mainColorOneSecondary],
              stops: [
                0.1,
                1,
              ],
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
            ),
          ),
        ),
        title: Text('Budget Goals'),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            width: double.infinity,
            height: Adaptive.h(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Total Balance'),
                Text(
                  balance.toString(),
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 20.sp),
                ),
              ],
            ),
          ),
          SizedBox(
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('My Budgets'),
                      Text(
                        '\₱$totalBudgetAmount',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20.sp),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AddBudget()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      shape: CircleBorder(),
                      padding: EdgeInsets.all(10),
                    ),
                    child: Icon(Icons.add, color: Colors.white),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _budgetGoalsRef.snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Something went wrong'),
                  );
                }

                if (!snapshot.hasData) {
                  return Center(
                    child: LoadingAnimationWidget.waveDots(
                      size: 200,
                      color: AppColors.mainColorOne,
                    ),
                  );
                }

                List<QueryDocumentSnapshot> budgetGoals = snapshot.data!.docs;

                return GridView.builder(
                  itemCount: budgetGoals.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12.0,
                    mainAxisSpacing: 12.0,
                    childAspectRatio: 1,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    Map<String, dynamic> goalData =
                        budgetGoals[index].data() as Map<String, dynamic>;
                    BudgetGoal goal = BudgetGoal.fromJson(goalData);
                    String title = goal.budgetName;
                    double amount = goal.budgetAmount;
                    String startDate = goal.getFormattedStartDate();
                    String endDate = goal.getFormattedEndDate();

                    if (snapshot.hasError) {
                      return Center(
                        child: Text('Something went wrong'),
                      );
                    }

                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                        side:
                            BorderSide(width: 1, color: AppColors.mainColorOne),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(title),
                          SizedBox(height: 8),
                          Text('Amount: \₱$amount'),
                          SizedBox(height: 8),
                          Text(
                              '${startDate.toString()} - ${endDate.toString()}'),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
