import 'package:budget_bud/dataModels/transaction_model.dart';
import 'package:budget_bud/misc/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CollectionReference _reference =
      FirebaseFirestore.instance.collection('Transactions');

  @override
  Widget build(BuildContext context) {
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
      body: StreamBuilder<QuerySnapshot>(
        stream: _reference.snapshots(),
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
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // transaction description
                        Text(
                            'Amount: \$${transactions[index].amount.toString()}'), // transaction amount
                      ],
                    ),
                    leading: CircleAvatar(
                      radius: 25,
                      child: Icon(FontAwesomeIcons.arrowDown),
                    ))
                : ListTile(
                    contentPadding: EdgeInsets.all(20),
                    title: Text(
                      transactions[index].transactionName,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // transaction description
                        Text(
                            'Amount: \$${transactions[index].amount.toString()}'), // transaction amount
                      ],
                    ),
                    leading: CircleAvatar(
                      radius: 25,
                      backgroundColor: AppColors.mainColorTwo,
                      child: Icon(FontAwesomeIcons.arrowUp),
                    ),
                  ),
          ),
        );
}
