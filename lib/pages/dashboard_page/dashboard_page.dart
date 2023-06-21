import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:budget_bud/data/income_data.dart';
import 'package:budget_bud/misc/colors.dart';
import 'package:budget_bud/misc/txtStyles.dart';
import 'package:budget_bud/misc/widgetSize.dart';
import 'package:budget_bud/pages/dashboard_page/parts/convert_dashboard/convert_currency.dart';
import 'package:budget_bud/pages/dashboard_page/parts/news_dashboard/dashboard_news.dart';
import 'package:budget_bud/pages/dashboard_page/parts/transaction_dashboard/dashboard_transactions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';

import '../../components/btn_icon_circle.dart';
import '../../data/expense_data.dart';
import '../../data/transaction_data_summary.dart';
import '../../misc/custom_clipper/custom_wave_left.dart';
import '../../steps/shared_pref_steps.dart';
import 'dashboard_tabs/dashboard_expense_tab.dart';
import 'dashboard_tabs/dashboard_income_tab.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage>
    with TickerProviderStateMixin {
  bool isLoading = true;
  final user = FirebaseAuth.instance.currentUser!;
  final incomeRef = FirebaseFirestore.instance.collection('Income');
  final expenseRef = FirebaseFirestore.instance.collection('Expense');

  List<Income> incomes = [];
  List<Expense> expenses = [];

  SharedPreferences? sharedPreferences;

  onDelete(String documentId, CollectionReference collectionRef) async {
    try {
      await collectionRef.doc(documentId).delete();
      print('ID is $documentId');
      print('Document deleted successfully.');
    } catch (e) {
      print('Error deleting document: $e');
    }
  }

  GlobalKey userDisplay = GlobalKey();
  GlobalKey userCard = GlobalKey();
  GlobalKey features = GlobalKey();
  GlobalKey suggestions = GlobalKey();
  GlobalKey featureNews = GlobalKey();
  GlobalKey featureConvert = GlobalKey();
  GlobalKey transactions = GlobalKey();
  GlobalKey userTransactions = GlobalKey();

  @override
  void initState() {
    super.initState();

    getUserName().then((_) {
      // Call fetchBalance() here if needed
      setState(() {
        isLoading = false; // Set isLoading to false once data is fetched
      });
    });

//fetchBalance();

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

  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    TabController tabController = TabController(length: 2, vsync: this);

    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(), // Show a loading indicator
      );
    } else {
      return ShowCaseWidget(
        builder: Builder(
          builder: (context) => Scaffold(
              appBar: AppBar(
                elevation: 0,
                title: Text(
                  'User Dashboard',
                  style: ThemeText.appBarTitle,
                ),
                actions: [
                  IconButton(
                    onPressed: () => setState(() {
                      ShowCaseWidget.of(context)!.startShowCase([
                        userDisplay,
                        userCard,
                        features,
                        suggestions,
                        featureNews,
                        featureConvert,
                        transactions,
                        userTransactions,
                      ]);
                    }),
                    icon: const Icon(
                      Icons.help_rounded,
                    ),
                  ),
                ],
              ),
              body: Column(
                children: [
                  Flexible(
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
                              Showcase(
                                key: userDisplay,
                                title: 'You!',
                                description: 'User Details on the Go!',
                                child: Container(
                                  height: Adaptive.h(10),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Text(
                                          'Hello, ${userName ?? ''}',
                                          style:
                                              ThemeText.dashboardDetailsHeader,
                                        ),
                                        Text(
                                          'Your Daily Update',
                                          style: ThemeText
                                              .dashboardDetailsSubHeader,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              StreamBuilder<TransactionSummary>(
                                stream: Stream.fromFuture(
                                    calculateTransactionSummary(
                                        TimePeriod.Overall)),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    final transactionSummary = snapshot.data!;

                                    return Expanded(
                                      child: Showcase(
                                        key: userCard,
                                        description:
                                            'Your Balance and Transactions',
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 16),
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 16),
                                            decoration: BoxDecoration(
                                              color: AppColors.mainColorTwo,
                                              borderRadius:
                                                  BorderRadius.circular(25),
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      'Balance',
                                                      style:
                                                          ThemeText.paragraph54,
                                                    ),
                                                    Text(
                                                      '₱${transactionSummary.balance}',
                                                      style: ThemeText
                                                          .dashboardNumberLarge,
                                                    ),
                                                  ],
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      'Transactions',
                                                      style:
                                                          ThemeText.paragraph54,
                                                    ),
                                                    Text(
                                                      '₱${transactionSummary.totalIncome}',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: AppColors
                                                            .updateButton,
                                                        fontSize: 15.sp,
                                                      ),
                                                    ),
                                                    Text(
                                                      '₱${transactionSummary.totalExpense}',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: AppColors
                                                            .deleteButton,
                                                        fontSize: 15.sp,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  } else if (snapshot.hasError) {
// Handle error case
                                    return Text('Error: ${snapshot.error}');
                                  } else {
// Display loading state
                                    return CircularProgressIndicator();
                                  }
                                },
                              )
                            ],
                          ),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          bottom: 0,
                          child: Showcase(
                            key: features,
                            title: 'Features on the go',
                            description: 'More features to help you!',
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      Showcase(
                                        key: suggestions,
                                        description:
                                            'Know various suggestions for you to increase your savings and organize your expenditures',
                                        targetShapeBorder: const CircleBorder(),
                                        targetPadding: EdgeInsets.all(8),
                                        child: IconButtonCircle(
                                          onPressed: () {},
                                          icon: Icon(
                                              Icons.lightbulb_outline_rounded),
                                        ),
                                      ),
                                      Showcase(
                                        key: featureNews,
                                        description:
                                            'Browse some hot topics about Finance and Budgeting around the world!',
                                        targetShapeBorder: const CircleBorder(),
                                        targetPadding: EdgeInsets.all(8),
                                        child: IconButtonCircle(
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
                                      ),
                                    ],
                                  ),
                                  addVerticalSpace(1),
                                  Row(
                                    children: [
                                      Showcase(
                                        key: transactions,
                                        description:
                                            'Now your Transactions History more!',
                                        targetShapeBorder: const CircleBorder(),
                                        targetPadding: EdgeInsets.all(8),
                                        child: IconButtonCircle(
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
                                      ),
                                      Showcase(
                                        key: featureConvert,
                                        description:
                                            'Know the latest exhange rate in your country',
                                        targetShapeBorder: const CircleBorder(),
                                        targetPadding: EdgeInsets.all(8),
                                        child: IconButtonCircle(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const CurrencyConverter()),
                                            );
                                          },
                                          icon: Icon(Icons.currency_exchange),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
//---------HEADER DASHBOARD-------

//---------BODY DASHBOARD-------
                  Showcase(
                    key: userTransactions,
                    description:
                        'Know your recent Income and Expenses Transactions, just click and we\'ll display your recent transactions',
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
              )),
        ),
      );
    }
  }
}
