import 'package:budget_bud/data/income_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../../misc/colors.dart';

class DashBoardIncome extends StatefulWidget {
  const DashBoardIncome({Key? key}) : super(key: key);

  @override
  State<DashBoardIncome> createState() => _DashBoardIncomeState();
}

class _DashBoardIncomeState extends State<DashBoardIncome> {
  final user = FirebaseAuth.instance.currentUser!;
  final CollectionReference collection =
      FirebaseFirestore.instance.collection('Income');

  Future<List<DocumentSnapshot>> fetchData() async {
    final QuerySnapshot snapshot = await collection.get();
    return snapshot.docs;
  }

  String collectionName = 'Income';
  List<Income> incomes = [];

  void deleteData(BuildContext context, String documentId) {
    FirebaseFirestore.instance
        .collection(collectionName)
        .doc(documentId)
        .delete()
        .then((_) {
      print('Document deleted successfully $documentId');
      // Refresh the list after deletion
      setState(() {
        incomes.removeWhere((income) => income.documentId == documentId);
      });
    }).catchError((error) {
      print('Failed to delete document: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        children: [
          Text(
            'Income',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          FutureBuilder<QuerySnapshot>(
            future: collection.where('UserEmail', isEqualTo: user.email).get(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text('Something went wrong'),
                );
              }

              if (snapshot.hasData) {
                final data = snapshot.data!.docs;
                incomes = data
                    .map(
                      (e) => Income(
                        documentId: e.id,
                        userEmail: e['UserEmail'],
                        incomeName: e['IncomeName'],
                        incomeDescription: e['IncomeDescription'],
                        incomeAmount: e['IncomeAmount'],
                        incomeDate: DateTime.parse(e['IncomeDate']),
                      ),
                    )
                    .toList();

                return incomes.isEmpty
                    ? Center(
                        child:
                            Text('No Income Yet, please add some transactions'),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: incomes.length,
                        itemBuilder: (context, index) {
                          return Slidable(
                            endActionPane: ActionPane(
                              motion: StretchMotion(),
                              children: [
                                SlidableAction(
                                  onPressed: ((context) {
                                    deleteData(
                                        context, incomes[index].documentId);
                                  }),
                                  icon: Icons.delete,
                                  backgroundColor: AppColors.mainColorOne,
                                ),
                              ],
                            ),
                            child: ListTile(
                              title: Text(incomes[index].incomeName ?? ''),
                              subtitle:
                                  Text(incomes[index].incomeDescription ?? ''),
                              trailing: Text(
                                '₱ ${incomes[index].incomeAmount.toString()}',
                              ),
                              // Customize the list tile as per your data
                            ),
                          );
                        },
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
