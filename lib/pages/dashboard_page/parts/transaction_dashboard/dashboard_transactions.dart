import 'package:budget_bud/misc/colors.dart';
import 'package:budget_bud/misc/txtStyles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../data/transaction_data_summary.dart';
import '../../../../dataModels/transaction_model.dart';
import '../../../../dateTime/date_info.dart';
import 'component/transactions_card.dart';

class DashboardTransactions extends StatefulWidget {
  const DashboardTransactions({super.key});

  @override
  State<DashboardTransactions> createState() => _DashboardTransactionsState();
}

class _DashboardTransactionsState extends State<DashboardTransactions> {
  CollectionReference _reference =
      FirebaseFirestore.instance.collection('Transactions');

  double balance = 0.0;
  double totalIncome = 0.0;
  double totalExpense = 0.0;

  Future<void> fetchBalance() async {
    TransactionSummary summary =
        await calculateTransactionSummary(TimePeriod.Overall);
    setState(() {
      balance = summary.balance;
      totalIncome = summary.totalIncome;
      totalExpense = summary.totalExpense;
    });
  }

  final dateInfo = DateInfo();

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Your Transactions History'),
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            width: Adaptive.w(100),
            height: Adaptive.h(40),
            child: DefaultTabController(
              length: 4,
              initialIndex: 3,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: TabBar(
                      isScrollable: true,
                      physics: ClampingScrollPhysics(),
                      unselectedLabelColor: AppColors.mainColorOneSecondary,
                      labelStyle: GoogleFonts.montserrat(
                        fontSize: 15.sp,
                      ),
                      unselectedLabelStyle: GoogleFonts.montserrat(
                        fontSize: 14.sp,
                      ),
                      padding: EdgeInsets.symmetric(vertical: 16),
                      indicatorSize: TabBarIndicatorSize
                          .tab, // Use TabBarIndicatorSize.tab for fixed-width indicators
                      indicator: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: AppColors.mainColorOne,
                      ),
                      tabs: [
                        Tab(
                          child: Container(
                            height: Adaptive.h(4.5),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text('Daily'),
                            ),
                          ),
                        ),
                        Tab(
                          child: Container(
                            height: Adaptive.h(4.5),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text('Weekly'),
                            ),
                          ),
                        ),
                        Tab(
                          child: Container(
                            height: Adaptive.h(4.5),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text('Monthly'),
                            ),
                          ),
                        ),
                        Tab(
                          child: Container(
                            height: Adaptive.h(4.5),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text('Overall'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: TabBarView(
                      children: [
                        TransactionCardSummary(
                          cardName:
                              '${dateInfo.getCurrentWeekday()} ${dateInfo.getCurrentDay()}',
                          timePeriod: TimePeriod.Daily,
                        ),
                        TransactionCardSummary(
                          cardName: dateInfo.getCurrentWeek(),
                          timePeriod: TimePeriod.Weekly,
                        ),
                        TransactionCardSummary(
                          cardName:
                              dateInfo.getCurrentMonthFromDate(DateTime.now()),
                          timePeriod: TimePeriod.Monthly,
                        ),
                        TransactionCardSummary(
                          cardName: 'Overall',
                          timePeriod: TimePeriod.Overall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadiusDirectional.only(
                  topStart: Radius.circular(25),
                  topEnd: Radius.circular(25),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.mainColorOne.withOpacity(0.3),
                    spreadRadius: 5,
                    blurRadius: 9,
                    offset: Offset(0, 4), // changes the position of the shadow
                  ),
                ],
              ),
              padding: EdgeInsets.symmetric(vertical: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'Transactions',
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: _reference
                          .where('UserEmail', isEqualTo: user.email)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Center(
                            child: Text('Something went wrong'),
                          );
                        }
                        if (snapshot.hasData) {
                          QuerySnapshot querySnapshot = snapshot.data!;
                          List<QueryDocumentSnapshot> documents =
                              querySnapshot.docs;

                          List<TransactionData> transactions = documents
                              .map(
                                (e) => TransactionData(
                                  userEmail: e['UserEmail'],
                                  transactionType: e["TransactionType"],
                                  description: e["TransactionDescription"],
                                  amount: e["TransactionAmount"],
                                  category: e["TransactionCategory"],
                                  transactionDate:
                                      DateTime.parse(e["TransactionDate"])
                                          .toLocal(),
                                  documentId: '',
                                ),
                              )
                              .toList();

                          return _getBody(transactions);
                        } else {
                          return Center(
                              child: LoadingAnimationWidget.fourRotatingDots(
                                  color: AppColors.mainColorOne, size: 50));
                        }
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

Widget _getBody(List<TransactionData> transactions) {
  // Sort transactions by date in descending order
  transactions.sort((a, b) => b.transactionDate.compareTo(a.transactionDate));

  return transactions.isEmpty
      ? Center(
          child: Text('No Transactions Yet'),
        )
      : ListView.builder(
          shrinkWrap: true,
          itemCount: transactions.length,
          itemBuilder: (context, index) => Container(
            child: transactions[index].transactionType == "Income"
                ? ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 20),
                    title: Text(
                      transactions[index].category,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(transactions[index].category),
                    leading: SvgPicture.asset(
                      'assets/pointer/1.svg',
                      width: Adaptive.w(5),
                      height: Adaptive.h(5),
                      semanticsLabel: 'Income',
                    ),
                    trailing: Text(
                      '\₱${transactions[index].amount.toString()}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  )
                : ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 20),
                    title: Text(
                      transactions[index].category,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(transactions[index].category),
                    leading: SvgPicture.asset(
                      'assets/pointer/2.svg',
                      width: Adaptive.w(5),
                      height: Adaptive.h(5),
                      semanticsLabel: 'Expense',
                    ),
                    trailing: Text(
                      '-\₱${transactions[index].amount.toString()}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  ),
          ),
        );
}
