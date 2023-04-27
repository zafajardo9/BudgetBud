import 'package:budget_bud/data/income_data.dart';
import 'package:budget_bud/misc/colors.dart';
import 'package:budget_bud/misc/txtStyles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DashboardPage extends StatelessWidget {
  final CollectionReference _reference =
      FirebaseFirestore.instance.collection('Income');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Dashboard'),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: _reference.get(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Something went wrong'),
            );
          }
          if (snapshot.hasData) {
            QuerySnapshot querySnapshot = snapshot.data!;
            List<QueryDocumentSnapshot> documents = querySnapshot.docs;

            List<Income> incomes = documents
                .map(
                  (e) => Income(
                    userEmail: e['UserEmail'],
                    incomeName: e['IncomeName'],
                    incomeDescription: e['IncomeDescription'],
                    incomeAmount: e['IncomeAmount'],
                    incomeDate: DateTime.parse(e['IncomeDate']),
                  ),
                )
                .toList();
            return _getBody(incomes);
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

  Widget _getBody(incomes) {
    return incomes.isEmpty
        ? Center(
            child: Text('No Income Yet, pls som transactions'),
          )
        : ListView.builder(
            itemCount: incomes.length,
            itemBuilder: (context, index) => Card(
              child: ListTile(
                title: Text(
                  incomes[index].incomeName,
                  style: ThemeText.subHeader1Bold,
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        incomes[index].incomeDescription), // income description
                    Text(
                        'Amount: \$${incomes[index].incomeAmount.toString()}'), // income amount
                    Text(
                        'Date: ${incomes[index].incomeDate.toString()}'), // income date
                  ],
                ),
                leading: CircleAvatar(
                  radius: 25,
                  child: Icon(FontAwesomeIcons.arrowUp),
                ),
                trailing: SizedBox(
                  width: 60,
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {},
                        child: Icon(Icons.edit),
                      ),
                      InkWell(
                        onTap: () {
//for Deleting an Income
                          _reference.doc(incomes[index].userEmail).delete();
                        },
                        child: Icon(
                          Icons.delete,
                          color: AppColors.mainColorOne,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
