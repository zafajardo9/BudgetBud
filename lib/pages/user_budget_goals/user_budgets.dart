import 'package:budget_bud/misc/colors.dart';
import 'package:budget_bud/misc/txtStyles.dart';
import 'package:budget_bud/pages/user_budget_goals/user_add_budget/add_budget.dart';
import 'package:budget_bud/pages/user_budget_goals/user_add_budget/budget_record.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../data/budget_goal_data.dart';
import '../../data/budget_record_data.dart';
import '../../data/transaction_data_summary.dart';

class UserBudgetGoals extends StatefulWidget {
  const UserBudgetGoals({Key? key}) : super(key: key);

  @override
  State<UserBudgetGoals> createState() => _UserBudgetGoalsState();
}

class _UserBudgetGoalsState extends State<UserBudgetGoals> {
  CollectionReference _budgetGoalsRef =
      FirebaseFirestore.instance.collection('BudgetGoals');
  final user = FirebaseAuth.instance.currentUser!;

  List<QueryDocumentSnapshot> budgetGoals = [];

  @override
  void initState() {
    super.initState();
    fetchBalance();
    reloadScreen();
  }

  double balance = 0.0;
  double totalIncome = 0.0;
  double totalExpense = 0.0;
  double totalBudgetAmount = 0.0;
  double totalRecordAmount = 0.0;

  Future<void> fetchBalance() async {
    TransactionSummary summary =
        await calculateTransactionSummary(TimePeriod.Overall);
    setState(() {
      balance = summary.balance;
      totalIncome = summary.totalIncome;
      totalExpense = summary.totalExpense;
    });

    if (user != null) {
      String userEmail = user.email ?? '';

// Fetch budgetGoals data
      QuerySnapshot? snapshot =
          await _budgetGoalsRef.where('UserEmail', isEqualTo: userEmail).get();
      if (snapshot != null) {
        setState(() {
          budgetGoals = snapshot.docs;
        });
      }

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
  }

// Fetch total recorded amount from the BudgetRecords collection of the current budget goal
  Future<double> getTotalRecordedAmount(String documentId) async {
    double totalAmount = 0;

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('BudgetGoals')
        .doc(documentId)
        .collection('records')
        .get();

    List<QueryDocumentSnapshot> records = querySnapshot.docs;

    records.forEach((record) {
      Record recordData =
          Record.fromJson(record.data() as Map<String, dynamic>);
      totalAmount += recordData.amount;
    });

    return totalAmount;
  }

// Calculate progress bar text based on the total recorded amount and budget amount
  Future<String> calculateProgressBarText(int index) async {
    double totalRecordedAmount =
        await getTotalRecordedAmount(budgetGoals[index].id);
    double budgetAmount =
        (budgetGoals[index].data() as Map<String, dynamic>)['BudgetAmount'] ??
            0.0;

    String formattedRecordedAmount =
        '\₱${totalRecordedAmount.toStringAsFixed(2)}';
    String formattedBudgetAmount = '\₱${budgetAmount.toStringAsFixed(2)}';

    return '$formattedRecordedAmount / $formattedBudgetAmount';
  }

  Future<void> reloadScreen() async {
    await fetchBalance();
    setState(() {}); // Trigger rebuild
  }

  void deleteBudgetGoal(String documentId) async {
    print(documentId);
    try {
      await FirebaseFirestore.instance
          .collection('BudgetGoals')
          .doc(documentId)
          .delete();
      print('BudgetGoal deleted successfully');
    } catch (e) {
      print('Error deleting budgetGoal: $e');
    }
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
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: StreamBuilder<QuerySnapshot>(
                stream: _budgetGoalsRef
                    .where('UserEmail', isEqualTo: user?.email ?? '')
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Something went wrong'),
                    );
                  }
                  final documents = snapshot.data?.docs ?? [];

                  if (documents.isEmpty) {
                    return SvgPicture.asset(
                      'assets/no_data_found/nd1.1 (2).svg', // Replace with your actual image path
                      fit: BoxFit.scaleDown,
                    );
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
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

                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => BudgetRecords(
                              documentId: budgetGoals[index].id,
                            ),
                          ));
                        },
                        onLongPress: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Delete Confirmation'),
                                content: Text(
                                    'Are you sure you want to delete this budget goal?'),
                                actions: [
                                  TextButton(
                                    child: Text('Cancel'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  TextButton(
                                    child: Text('Delete'),
                                    onPressed: () {
                                      deleteBudgetGoal(budgetGoals[index].id);
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.backgroundWhite,
                            borderRadius: BorderRadius.circular(25),
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
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                title,
                                style: TextStyle(
                                    fontSize: 17.sp,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 8),
                              Text('Amount: \₱$amount'),
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: FutureBuilder<double>(
                                  future: getTotalRecordedAmount(
                                      budgetGoals[index].id),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      double recordedAmount = snapshot.data!;
                                      return Container(
                                        height:
                                            10, // Adjust the height of the progress bar
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: AppColors.mainColorFour
                                              .withOpacity(
                                                  .2), // Set the background color of the progress bar
                                        ),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          child: LinearProgressIndicator(
                                            value: recordedAmount /
                                                amount, // Replace with your desired progress value
                                            backgroundColor: Colors
                                                .transparent, // Set the background color of the indicator (transparent to see the container's background color)
                                            valueColor: AlwaysStoppedAnimation<
                                                    Color>(
                                                AppColors
                                                    .mainColorFour), // Set the color of the indicator
                                          ),
                                        ),
                                      );
                                    } else if (snapshot.hasError) {
                                      return Text(
                                          'Error fetching recorded amount');
                                    } else {
                                      return CircularProgressIndicator();
                                    }
                                  },
                                ),
                              ),
                              FutureBuilder<double>(
                                future: getTotalRecordedAmount(
                                    budgetGoals[index].id),
                                builder: (BuildContext context,
                                    AsyncSnapshot<double> snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return CircularProgressIndicator();
                                  } else if (snapshot.hasError) {
                                    return Text('Error: ${snapshot.error}');
                                  } else {
                                    double recordedAmount = snapshot.data!;
                                    return Text(
                                      "${recordedAmount.toStringAsFixed(2)} / $amount",
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
