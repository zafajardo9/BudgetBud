import 'package:budget_bud/misc/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../dataModels/transaction_model.dart';

class DashboardTransactions extends StatefulWidget {
  const DashboardTransactions({super.key});

  @override
  State<DashboardTransactions> createState() => _DashboardTransactionsState();
}

class _DashboardTransactionsState extends State<DashboardTransactions> {
  CollectionReference _reference =
      FirebaseFirestore.instance.collection('Transactions');

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Transactions History'),
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            width: Adaptive.w(100),
            height: Adaptive.h(40),
            color: AppColors.mainColorFour,
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
                      transactions[index].transactionName,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    leading: RotatedBox(
                      quarterTurns: 3,
                      child: SvgPicture.asset(
                        'assets/pointer/dark.svg',
                        width: Adaptive.w(5),
                        height: Adaptive.h(5),
                        semanticsLabel: 'Income',
                      ),
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
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    leading: SvgPicture.asset(
                      'assets/pointer/dark.svg',
                      width: Adaptive.w(5),
                      height: Adaptive.h(5),
                      semanticsLabel: 'Expense',
                    ),
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
