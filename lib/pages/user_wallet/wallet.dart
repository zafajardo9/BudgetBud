import 'package:budget_bud/misc/txtStyles.dart';
import 'package:budget_bud/misc/widgetSize.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../data/budget_goal_data.dart';
import '../../data/transaction_data_summary.dart';
import '../../misc/colors.dart';
import 'graphMonthSpend.dart';

class UserWallet extends StatefulWidget {
  const UserWallet({Key? key}) : super(key: key);

  @override
  State<UserWallet> createState() => _UserWalletState();
}

class _UserWalletState extends State<UserWallet> {
  CollectionReference _budgetGoalsRef =
      FirebaseFirestore.instance.collection('BudgetGoals');
  final user = FirebaseAuth.instance.currentUser!;

  double balance = 0.0;
  double totalIncome = 0.0;
  double totalExpense = 0.0;
  double totalBudgetAmount = 0.0;
  double totalRecordAmount = 0.0;
  List<QueryDocumentSnapshot> budgetGoals = [];

  double currentMonthIncome = 0.0;
  double pastMonthIncome = 0.0;

  double currentMonthExpense = 0.0;
  double pastMonthExpense = 0.0;

  @override
  void initState() {
    super.initState();
    fetchIncomeData();
    fetchExpenseData();
    fetchBalance();
  }

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

  Future<void> fetchIncomeData() async {
    final now = DateTime.now();
    final currentIncome = await getIncomeForMonth(now);

    final pastMonth = DateTime(now.year, now.month - 1, now.day);
    final pastIncome = await getIncomeForMonth(pastMonth);

    setState(() {
      currentMonthIncome = currentIncome;
      pastMonthIncome = pastIncome;
    });
  }

  Future<void> fetchExpenseData() async {
    final now = DateTime.now();
    final currentIncome = await getIncomeForMonth(now);

    final pastMonth = DateTime(now.year, now.month - 1, now.day);
    final pastIncome = await getIncomeForMonth(pastMonth);

    setState(() {
      currentMonthExpense = currentIncome;
      pastMonthExpense = pastIncome;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainColorOne,
      appBar: AppBar(
        title: Text('Wallet'),
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              width: double.infinity,
              height: Adaptive.h(25),
              decoration: BoxDecoration(
                color: AppColors.backgroundWhite,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Total Balance'),
                  Text(
                    '\₱${balance.toString()}',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20.sp),
                  ),
                  Text('Monthly Budget'),
                  Text(
                    '\₱$totalBudgetAmount',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20.sp),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your Transactions',
                    style: ThemeText.transactionAmount,
                    //style
                  ),
                  Text(
                    'Know difference of your spendings',
                    style: ThemeText.paragraph54,
                  ),
                  addVerticalSpace(3),
                  // Text(
                  //   'Income',
                  //   style: ThemeText.paragraph54,
                  // ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                  //   children: [
                  //     Column(
                  //       children: [
                  //         Text(
                  //           'Past Month',
                  //           style: ThemeText.transactionAmount,
                  //         ),
                  //         Text(
                  //           '\₱${pastMonthIncome.toStringAsFixed(2)}',
                  //         ),
                  //       ],
                  //     ),
                  //     Column(
                  //       children: [
                  //         Text(
                  //           'Current Month',
                  //           style: ThemeText.transactionAmount,
                  //         ),
                  //         Text(
                  //           '\₱${currentMonthIncome.toStringAsFixed(2)}',
                  //         ),
                  //       ],
                  //     ),
                  //   ],
                  // ),
                  // Text(
                  //   'Expense',
                  //   style: ThemeText.paragraph54,
                  // ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Text(
                            'Past Month',
                            style: ThemeText.transactionAmount,
                          ),
                          Text(
                            '\₱${pastMonthExpense.toStringAsFixed(2)}',
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            'Current Month',
                            style: ThemeText.transactionAmount,
                          ),
                          Text(
                            '\₱${currentMonthExpense.toStringAsFixed(2)}',
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          addVerticalSpace(3),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  color: AppColors.backgroundWhite,
                  borderRadius: BorderRadiusDirectional.only(
                    topStart: Radius.circular(25),
                    topEnd: Radius.circular(25),
                  )),
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
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
                          return Transform.scale(
                            scale: Adaptive.px(.5),
                            child: Opacity(
                              opacity: 0.5,
                              child: SvgPicture.asset(
                                'assets/Pie Graph/7.svg',
                                fit: BoxFit.scaleDown,
                              ),
                            ),
                          );
                        }

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        }

                        List<BudgetGoal> budgetGoals = documents
                            .map((doc) => BudgetGoal.fromJson(
                                doc.data() as Map<String, dynamic>))
                            .toList();

                        return GridView.builder(
                          itemCount: budgetGoals.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12.0,
                            mainAxisSpacing: 12.0,
                            childAspectRatio: 1,
                          ),
                          itemBuilder: (BuildContext context, int index) {
                            final budgetGoal = budgetGoals[index];

                            return Container(
                              decoration: BoxDecoration(
                                color: AppColors.mainColorFour,
                                borderRadius: BorderRadius.circular(25),
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        AppColors.mainColorOne.withOpacity(0.2),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: DefaultTextStyle(
                                style: GoogleFonts.montserrat(
                                    color: AppColors.backgroundWhite),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      budgetGoal.budgetName,
                                      style: TextStyle(
                                        fontSize: 17.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                        '₱${budgetGoal.budgetAmount.toStringAsFixed(2)}'),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
