import 'package:budget_bud/misc/colors.dart';
import 'package:budget_bud/misc/txtStyles.dart';
import 'package:budget_bud/misc/widgetSize.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../data/transaction_data_summary.dart';
import '../../misc/graphs/pie_graph/pie_graph.dart';
import '../graph_screen/graph_screen.dart';
import '../on_working_feature/progress_alert.dart';
import '../user_budget_goals/survey/step_survey.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CollectionReference _reference =
      FirebaseFirestore.instance.collection('Transactions');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainColorOne,
      appBar: AppBar(
        elevation: 0,
        title: Text('Analytics'),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {
                WorkInProgressAlert.show(context);
              },
              child: Icon(Icons.sort),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(20),
              child: FutureBuilder<TransactionSummary>(
                future: calculateTransactionSummary(TimePeriod.Overall),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // While waiting for the data, you can display a loading indicator
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    // If there's an error in fetching the data, display an error message
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData) {
                    // If no data is available, display an empty container or a placeholder
                    return Container();
                  }

                  final summary = snapshot.data!;

                  return Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Container(
                              width: Adaptive.w(15),
                              height: Adaptive.h(15),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.mainColorTwo,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(5),
                                child: SvgPicture.asset(
                                  'assets/pointer/1.svg',
                                  fit: BoxFit.contain,
                                  semanticsLabel: 'Income',
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Text(
                              'Income',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.black54,
                              ),
                            ),
                            Text(
                              '₱${NumberFormat('#,##0.00').format(summary.totalIncome)}',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 18.sp,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Container(
                              width: Adaptive.w(15),
                              height: Adaptive.h(15),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.mainColorFour,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(5),
                                child: SvgPicture.asset(
                                  'assets/pointer/2.svg',
                                  fit: BoxFit.contain,
                                  semanticsLabel: 'Expense',
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Text(
                              'Expense',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.black54,
                              ),
                            ),
                            Text(
                              '₱${NumberFormat('#,##0.00').format(summary.totalExpense)}',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 18.sp,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
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
                child: GraphScreen(),
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
                      'Your Top Expenses',
                      style: ThemeText.transactionAmount,
                      //style
                    ),
                    Text(
                      'Chart showing top expenses by category',
                      style: ThemeText.paragraph54,
                    ),
                    SizedBox(
                      width: Adaptive.w(100),
                      height: Adaptive.h(40),
                      child: PieGraphWidget(
                        transactionType: TransactionType.expense,
                      ),
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
                      'Your Top Income',
                      style: ThemeText.transactionAmount,
                      //style
                    ),
                    Text(
                      'Chart showing top income by category',
                      style: ThemeText.paragraph54,
                    ),
                    SizedBox(
                      width: Adaptive.w(100),
                      height: Adaptive.h(40),
                      child: PieGraphWidget(
                        transactionType: TransactionType.income,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            addVerticalSpace(20),
          ],
        ),
      ),
    );
  }
}
