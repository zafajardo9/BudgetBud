import 'package:budget_bud/data/income_data.dart';
import 'package:budget_bud/misc/colors.dart';
import 'package:budget_bud/misc/txtStyles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../components/btn_icons_text.dart';
import '../../data/expense_data.dart';
import '../../data/transaction_data_summary.dart';
import 'dashboard_tabs/dashboard_expense_tab.dart';
import 'dashboard_tabs/dashboard_income_tab.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage>
    with TickerProviderStateMixin {
  final user = FirebaseAuth.instance.currentUser!;
  final incomeRef = FirebaseFirestore.instance.collection('Income');
  final expenseRef = FirebaseFirestore.instance.collection('Expense');

  List<Income> incomes = [];
  List<Expense> expenses = [];

  onDelete(String documentId, CollectionReference collectionRef) async {
    try {
      await collectionRef.doc(documentId).delete();
      print('ID is $documentId');
      print('Document deleted successfully.');
    } catch (e) {
      print('Error deleting document: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    getUserName();
    fetchBalance();
  }

  String? userName;

  Future<void> getUserName() async {
    final userEmail = FirebaseAuth.instance.currentUser?.email;

    if (userEmail == null) {
      // Handle the case when the user is not signed in.
      return;
    }

    final querySnapshot = await FirebaseFirestore.instance
        .collection('User')
        .where('UserEmail', isEqualTo: userEmail)
        .get();

    if (querySnapshot.size > 0) {
      final data = querySnapshot.docs.first.data();
      setState(() {
        print(data);
        userName = data['UserName'];
      });
    } else {
      setState(() {
        userName = FirebaseAuth.instance.currentUser?.displayName;
      });
    }

    print(userName);
  }

  double balance = 0.0;
  double totalIncome = 0.0;
  double totalExpense = 0.0;

  Future<void> fetchBalance() async {
    TransactionSummary summary = await calculateTransactionSummary();
    setState(() {
      balance = summary.balance;
      totalIncome = summary.totalIncome;
      totalExpense = summary.totalExpense;
    });
  }

  @override
  Widget build(BuildContext context) {
    TabController tabController = TabController(length: 2, vsync: this);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
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
        title: Text(
          'User Dashboard',
          style: ThemeText.appBarTitle,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ClipPath(
              clipper: WaveClipperOne(),
              child: Container(
                color: AppColors.mainColorOne,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hello, ${userName ?? ''}',
                              style: ThemeText.headerAuth,
                            ),
                            Text(
                              'Your Daily Update',
                              style: ThemeText.paragraph54,
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text(
                          '₱$balance',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Your total Income',
                          style: ThemeText.paragraph54,
                        ),
                        Text(
                          '₱$totalIncome',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.updateButton,
                          ),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Your total Expenses',
                          style: ThemeText.paragraph54,
                        ),
                        Text(
                          '₱$totalExpense',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.deleteButton,
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 16),
                    Card(
                      color: AppColors.mainColorOne,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            IconButtonWithText(
                              onPressed: () {
                                // Button 1 action
                              },
                              icon: Icon(
                                FontAwesomeIcons.moneyBillTransfer,
                                size: 17.sp,
                              ),
                              label: 'Transactions',
                            ),
                            IconButtonWithText(
                              onPressed: () {
                                // Button 1 action
                              },
                              icon: Icon(
                                FontAwesomeIcons.robot,
                                size: 17.sp,
                              ),
                              label: 'Suggestions',
                            ),
                            IconButtonWithText(
                              onPressed: () {
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (context) => HeatMapCalendarExample(),
                                //   ),
                                // );
                              },
                              icon: Icon(
                                FontAwesomeIcons.newspaper,
                                size: 17.sp,
                              ),
                              label: 'News',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          //---------HEADER DASHBOARD-------
          //---------BODY DASHBOARD-------
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 3,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.13),
                borderRadius: BorderRadius.circular(15),
              ),
              child: TabBar(
                labelColor: AppColors.backgroundWhite,
                unselectedLabelColor: AppColors.mainColorOne,
                indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: AppColors.mainColorOne),
                controller: tabController,
                isScrollable: true,
                tabs: [
                  Tab(
                    child: Text(
                      'Income',
                    ),
                  ),
                  Tab(
                    child: Text(
                      'Expense',
                    ),
                  ),
                ],
              ),
            ),
          ),

          Expanded(
            child: TabBarView(
              controller: tabController,
              children: [
                DashBoardIncome(),
                DashBoardExpense(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
