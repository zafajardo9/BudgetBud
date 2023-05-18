import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

import '../../../dataModels/transaction_model.dart';
import '../../../misc/colors.dart';
import '../../../misc/txtStyles.dart';

enum TransactionType {
  Income,
  Expense,
}

class DashBoardExpense extends StatefulWidget {
  const DashBoardExpense({Key? key}) : super(key: key);

  @override
  State<DashBoardExpense> createState() => _DashBoardExpenseState();
}

class _DashBoardExpenseState extends State<DashBoardExpense> {
  final user = FirebaseAuth.instance.currentUser!;
  final CollectionReference collection =
      FirebaseFirestore.instance.collection('Transactions');

  Future<List<DocumentSnapshot>> fetchData() async {
    final QuerySnapshot snapshot = await collection.get();
    return snapshot.docs;
  }

  String collectionName = 'Transactions';
  List<TransactionData> transactions = [];

  Future<void> deleteDocument(BuildContext context, String documentId) async {
    try {
      await FirebaseFirestore.instance
          .collection(collectionName)
          .doc(documentId)
          .delete();
      print('Document deleted successfully $documentId');
      // Refresh the list after deletion
      setState(() {
        transactions.removeWhere((transaction) =>
            transaction.documentId == documentId &&
            transaction.transactionType == TransactionType.Expense);
      });
    } catch (error) {
      print('Failed to delete document: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        children: [
          Text(
            'Expense',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          FutureBuilder<QuerySnapshot>(
            future: collection
                .where('UserEmail', isEqualTo: user.email)
                .where('TransactionType', isEqualTo: 'Expense')
                .get(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text('Something went wrong'),
                );
              }

              if (snapshot.hasData) {
                final data = snapshot.data!.docs;
                transactions = data
                    .map(
                      (e) => TransactionData(
                        documentId: e.id,
                        userEmail: e['UserEmail'],
                        transactionName: e['TransactionName'],
                        transactionType: e['TransactionType'],
                        description: e['TransactionDescription'],
                        amount: e['TransactionAmount'],
                        category: e['TransactionCategory'],
                        transactionDate:
                            DateTime.parse(e['TransactionDate']).toLocal(),
                      ),
                    )
                    .toList();

                return transactions.isEmpty
                    ? Center(
                        child: Text(
                            'No Expense Yet, please add some transactions'),
                      )
                    : Expanded(
                        child: SingleChildScrollView(
                          child: ListView.separated(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: transactions.length,
                            separatorBuilder: (context, index) => SizedBox(
                              height: 10, // Adjust the gap height as needed
                            ),
                            itemBuilder: (context, index) {
                              return Slidable(
                                endActionPane: ActionPane(
                                  motion: StretchMotion(),
                                  children: [
                                    SlidableAction(
                                      onPressed: ((context) {
                                        deleteDocument(context,
                                            transactions[index].documentId);
                                      }),
                                      icon: Icons.delete,
                                      backgroundColor: AppColors.mainColorOne,
                                    ),
                                  ],
                                ),
                                child: ListTile(
                                  title: Text(
                                      transactions[index].transactionName ?? '',
                                      style: ThemeText.transactionName),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        transactions[index].category ?? '',
                                        style: ThemeText.transactionDetails,
                                      ),
                                      Text(
                                        DateFormat('MMMM d, yyyy').format(
                                            transactions[index]
                                                .transactionDate),
                                        style: ThemeText.transactionDateDetails,
                                      ),
                                    ],
                                  ),
                                  trailing: Text(
                                    '₱ ${transactions[index].amount.toString()}',
                                    style: ThemeText.transactionAmount,
                                  ),
                                  // Customize the list tile as per your data
                                ),
                              );
                            },
                          ),
                        ),
                      );
              }

              return Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ],
      ),
    );
  }
}
