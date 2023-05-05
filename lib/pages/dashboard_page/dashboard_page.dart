import 'package:budget_bud/data/income_data.dart';
import 'package:budget_bud/misc/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../data/expense_data.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final user = FirebaseAuth.instance.currentUser!;
  final incomeRef = FirebaseFirestore.instance.collection('Income');
  final expenseRef = FirebaseFirestore.instance.collection('Expense');

  List<Income> incomes = [];
  List<Expense> expenses = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Dashboard'),
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          Text(
            'Income',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          FutureBuilder<QuerySnapshot>(
            future: incomeRef.where('UserEmail', isEqualTo: user.email).get(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text('Something went wrong'),
                );
              }
              if (snapshot.hasData) {
                QuerySnapshot querySnapshot = snapshot.data!;
                List<QueryDocumentSnapshot> documents = querySnapshot.docs;
                incomes = documents
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
                return _buildIncomesList();
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
          Text(
            'Expenses',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          FutureBuilder<QuerySnapshot>(
            future: expenseRef.where('UserEmail', isEqualTo: user.email).get(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text('Something went wrong'),
                );
              }
              if (snapshot.hasData) {
                QuerySnapshot querySnapshot = snapshot.data!;
                List<QueryDocumentSnapshot> documents = querySnapshot.docs;
                expenses = documents
                    .map(
                      (e) => Expense(
                        userEmail: e['UserEmail'],
                        expenseName: e['ExpenseName'],
                        expenseDescription: e['ExpenseDescription'],
                        expenseAmount: e['ExpenseAmount'],
                        expenseDate: DateTime.parse(e['ExpenseDate']),
                      ),
                    )
                    .toList();
                return _buildExpensesList();
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildIncomesList() {
    return incomes.isEmpty
        ? Center(
            child: Text('No Income Yet, pls add some transactions'),
          )
        : ListView.builder(
            shrinkWrap: true,
            itemCount: incomes.length,
            itemBuilder: (context, index) => Card(
              child: ListTile(
                title: Text(
                  incomes[index].incomeName,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        incomes[index].incomeDescription), // income description
                    Text(
                        'Amount: ₱ ${incomes[index].incomeAmount.toString()}'), // income amount
                    Text(
                        'Date: ${incomes[index].incomeDate.toString()}'), // income date
                  ],
                ),
                leading: CircleAvatar(
                  radius: 25,
                  child: Icon(FontAwesomeIcons.arrowDown),
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
                          incomeRef.doc(incomes[index].userEmail).delete();
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

  Widget _buildExpensesList() {
    return expenses.isEmpty
        ? Center(
            child: Text('No Expenses Yet, pls add some transactions'),
          )
        : ListView.builder(
            shrinkWrap: true,
            itemCount: expenses.length,
            itemBuilder: (context, index) => Card(
              child: ListTile(
                title: Text(
                  expenses[index].expenseName,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(expenses[index].expenseDescription),
                    // expense description
                    Text(
                        'Amount: ₱ ${expenses[index].expenseAmount.toString()}'),
                    // expense amount
                    Text('Date: ${expenses[index].expenseDate.toString()}'),
                    // expense date
                  ],
                ),
                leading: CircleAvatar(
                  radius: 25,
                  child: Icon(FontAwesomeIcons.arrowUp),
                  backgroundColor: AppColors.mainColorTwo,
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
//for Deleting an Expense
                          expenseRef.doc(expenses[index].userEmail).delete();
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
