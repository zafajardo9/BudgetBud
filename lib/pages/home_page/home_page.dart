import 'package:budget_bud/misc/graphs/dummydata_piegraph.dart';
import 'package:budget_bud/dataModels/transaction_model.dart';
import 'package:budget_bud/misc/graphs/bargraph.dart';
import 'package:budget_bud/misc/colors.dart';
import 'package:budget_bud/misc/txtStyles.dart';
import 'package:budget_bud/misc/widgetSize.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../misc/graphs/pie_graph/pie_graph.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CollectionReference _reference =
      FirebaseFirestore.instance.collection('Transactions');

  List<double> weeklySummary = [
    4.40,
    25.1,
    16.18,
    15.1,
    13,
    3.40,
    10.3,
  ];

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;

    return Scaffold(
      backgroundColor: AppColors.mainColorOne,
      appBar: AppBar(
        elevation: 0,
        title: Center(
          child: Text('Analytics'),
        ),
        actions: [
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {},
                child: Icon(Icons.sort),
              )),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(20),
            child: Container(
              height: Adaptive.h(30),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: MyBarGraph(
                weeklySummary: weeklySummary,
              ),
            ),
          ),
          Container(
            height: Adaptive.h(25),
            child: PieGraphWidget(),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadiusDirectional.only(
                    topStart: Radius.circular(25),
                    topEnd: Radius.circular(25),
                  )),
              padding: EdgeInsets.symmetric(vertical: 20.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text('Transactions',
                          style: TextStyle(
                              fontSize: 15.sp, fontWeight: FontWeight.bold)),
                    ),
                    StreamBuilder<QuerySnapshot>(
                      stream: _reference
                          .where('UserEmail', isEqualTo: user.email)
                          .snapshots(),
                      //.snapshots()
                      // .where('UserEmail', isEqualTo: user.email).get(),
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
                                  transactionName: e['TransactionName'],
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
                          //loader
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _getBody(transactions) {
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
                      transactions[index].transactionName,
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    leading: RotatedBox(
                      quarterTurns: 3,
                      child: SvgPicture.asset('assets/pointer/dark.svg',
                          width: Adaptive.w(5),
                          height: Adaptive.h(5),
                          semanticsLabel: 'Income'),
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
                      transactions[index].transactionName,
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    leading: SvgPicture.asset('assets/pointer/dark.svg',
                        width: Adaptive.w(5),
                        height: Adaptive.h(5),
                        semanticsLabel: 'Expense'),
                    trailing: Text(
                      '\₱${transactions[index].amount.toString()}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  ),
          ),
        );
}
