import 'package:budget_bud/data/income_data.dart';
import 'package:budget_bud/misc/colors.dart';
import 'package:budget_bud/misc/txtStyles.dart';
import 'package:budget_bud/misc/widgetSize.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../components/btn_icon_circle.dart';
import '../../components/btn_icons_text.dart';
import '../../data/expense_data.dart';
import '../../data/transaction_data_summary.dart';
import '../../misc/custom_clipper/custom_clipper.dart';
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
        title: Text(
          'User Dashboard',
          style: ThemeText.appBarTitle,
        ),
      ),
      body: Column(
        children: [
          Container(
            width: Adaptive.w(100),
            height: Adaptive.h(10),
            color: AppColors.mainColorOne,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    'Hello, ${userName ?? ''}',
                    style: ThemeText.dashboardDetailsHeader,
                  ),
                  Text(
                    'Your Daily Update',
                    style: ThemeText.dashboardDetailsSubHeader,
                  )
                ],
              ),
            ),
          ),
          Container(
            width: Adaptive.w(100),
            height: Adaptive.h(25),
            child: Stack(
              children: [
                ClipPath(
                  clipper: WaveClipperTwo(),
                  child: Container(
                    color: AppColors.mainColorOne,
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: Card(
                    elevation: 0,
                    color: Colors.transparent,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Row(
                            children: [
                              IconButtonCircle(
                                onPressed: () {},
                                icon: Icon(Icons.settings),
                              ),
                              IconButtonCircle(
                                onPressed: () {},
                                icon: Icon(Icons.newspaper),
                              ),
                            ],
                          ),
                          addVerticalSpace(1),
                          Row(
                            children: [
                              IconButtonCircle(
                                onPressed: () {},
                                icon: Icon(Icons.wallet),
                              ),
                              IconButtonCircle(
                                onPressed: () {},
                                icon: Icon(Icons.currency_exchange),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  bottom: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: Adaptive.w(45),
                      decoration: BoxDecoration(
                        color: AppColors.mainColorTwo,
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Balance',
                                  style: ThemeText.paragraph54,
                                ),
                                Text(
                                  '₱$balance',
                                  style: ThemeText.dashboardNumberLarge,
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Transactions',
                                  style: ThemeText.paragraph54,
                                ),
                                Text(
                                  '₱$totalIncome',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.updateButton,
                                    fontSize: 15.sp,
                                  ),
                                ),
                                Text(
                                  '₱$totalExpense',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.deleteButton,
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
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
