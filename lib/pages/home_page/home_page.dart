import 'package:budget_bud/misc/graphs/dummydata_piegraph.dart';
import 'package:budget_bud/dataModels/transaction_model.dart';
import 'package:budget_bud/misc/graphs/bargraph.dart';
import 'package:budget_bud/misc/colors.dart';
import 'package:budget_bud/misc/widgetSize.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

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
      appBar: AppBar(
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
          addVerticalSpace(20),
          SizedBox(
            height: Adaptive.h(30),
            child: MyBarGraph(
              weeklySummary: weeklySummary,
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
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
                  List<QueryDocumentSnapshot> documents = querySnapshot.docs;

                  List<TransactionData> transactions = documents
                      .map(
                        (e) => TransactionData(
                          userEmail: e['UserEmail'],
                          transactionName: e['TransactionName'],
                          transactionType: e["TransactionType"],
                          description: e["TransactionDescription"],
                          amount: e["TransactionAmount"],
                          category: e["TransactionCategory"],
                          transactionDate: DateTime.parse(e["TransactionDate"]),
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
          itemBuilder: (context, index) => Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(20), // Radius of the card border
              side: BorderSide(
                color: Colors.black12, // Color of the card border
                width: 1, // Width of the card border
              ),
            ),
            child: transactions[index].transactionType == "Income"
                ? ListTile(
                    contentPadding: EdgeInsets.all(20),
                    title: Text(
                      transactions[index].transactionName,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    leading: CircleAvatar(
                      radius: 25,
                      child: Icon(FontAwesomeIcons.arrowDown),
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
                    contentPadding: EdgeInsets.all(20),
                    title: Text(
                      transactions[index].transactionName,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    leading: CircleAvatar(
                      radius: 25,
                      backgroundColor: AppColors.mainColorTwo,
                      child: Icon(FontAwesomeIcons.arrowUp),
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
