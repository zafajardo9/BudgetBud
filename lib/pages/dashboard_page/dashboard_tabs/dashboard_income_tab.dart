import 'package:budget_bud/misc/txtStyles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../dataModels/transaction_model.dart';
import '../../../misc/colors.dart';

enum TransactionType {
  Income,
  Expense,
}

class DashBoardIncome extends StatefulWidget {
  const DashBoardIncome({Key? key}) : super(key: key);

  @override
  State<DashBoardIncome> createState() => _DashBoardIncomeState();
}

class _DashBoardIncomeState extends State<DashBoardIncome> {
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
            transaction.transactionType == TransactionType.Income);
      });
    } catch (error) {
      print('Failed to delete document: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FutureBuilder<QuerySnapshot>(
          future: collection
              .where('UserEmail', isEqualTo: user.email)
              .where('TransactionType', isEqualTo: 'Income')
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

              // Sort transactions by date in descending order
              transactions.sort(
                  (a, b) => b.transactionDate.compareTo(a.transactionDate));

              return transactions.isEmpty
                  ? Center(
                      child:
                          Text('No Income Yet, please add some transactions'),
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
                                    backgroundColor: AppColors.deleteButton,
                                  ),
                                ],
                              ),
                              child: ListTile(
                                title: Text(
                                    transactions[index].transactionName ?? '',
                                    style: ThemeText.transactionName),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      transactions[index].category ?? '',
                                      style: ThemeText.transactionDetails,
                                    ),
                                    Text(
                                      DateFormat('MMMM d, yyyy').format(
                                          transactions[index].transactionDate),
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
              child: LoadingAnimationWidget.waveDots(
                color: AppColors.mainColorOne,
                size: 40,
              ),
            );
          },
        ),
      ],
    );
  }
}
