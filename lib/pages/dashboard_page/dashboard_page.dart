import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:budget_bud/data/income_data.dart';
import 'package:budget_bud/misc/colors.dart';
import 'package:budget_bud/misc/txtStyles.dart';
import 'package:budget_bud/misc/widgetSize.dart';
import 'package:budget_bud/pages/dashboard_page/parts/news_dashboard/dashboard_news.dart';
import 'package:budget_bud/pages/dashboard_page/parts/transaction_dashboard/dashboard_transactions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_toggle_tab/flutter_toggle_tab.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loop_page_view/loop_page_view.dart';
import 'package:page_view_dot_indicator/page_view_dot_indicator.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../components/btn_icon_circle.dart';
import '../../components/btn_icons_text.dart';
import '../../data/expense_data.dart';
import '../../data/transaction_data_summary.dart';
import '../../misc/custom_clipper/custom_clipper.dart';
import '../../misc/custom_clipper/custom_wave_left.dart';
import '../../misc/custom_clipper/custom_wave_left_two.dart';
import 'component/carousel_display.dart';
import 'dashboard_tabs/dashboard_expense_tab.dart';
import 'dashboard_tabs/dashboard_income_tab.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

enum TransactionMode {
  monthly,
  overall,
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
    //FOR NOTIFICATIONS++++++++++++++++++++++++

    AwesomeNotifications().isNotificationAllowed().then((isAllowed) => {
          if (!isAllowed)
            {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Allow Notification'),
                  content: Text(
                      'Our App would like to send you notifications so that we can help.'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Close',
                        style: TextStyle(color: AppColors.deleteButton),
                      ),
                    ),
                    TextButton(
                      onPressed: () => AwesomeNotifications()
                          .requestPermissionToSendNotifications()
                          .then((_) => Navigator.pop(context)),
                      child: Text(
                        'Allow',
                        style: TextStyle(
                            color: AppColors.updateButton,
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
              )
            }
        });
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

  final PageController _pageController = PageController();
  final _currentPageNotifier = ValueNotifier<int>(0);
  int currentPageIndex = 0;

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
          Expanded(
            child: Stack(
              children: [
                ClipPath(
                  clipper: WaveLeft() /*WaveClipperTwo()*/,
                  child: Container(
                    color: AppColors.mainColorOne,
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  bottom: 0,
                  child: Column(
                    children: [
                      Container(
                        height: Adaptive.h(10),
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
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.mainColorTwo,
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 16),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
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
                Positioned(
                  top: 0,
                  right: 0,
                  bottom: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            IconButtonCircle(
                              onPressed: () {},
                              icon: Icon(Icons.settings),
                            ),
                            IconButtonCircle(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const DashBoardNews()),
                                );
                              },
                              icon: Icon(Icons.newspaper),
                            ),
                          ],
                        ),
                        addVerticalSpace(1),
                        Row(
                          children: [
                            IconButtonCircle(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const DashboardTransactions()),
                                );
                              },
                              icon: Icon(Icons.history),
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
