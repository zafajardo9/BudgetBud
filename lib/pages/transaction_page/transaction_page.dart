import 'package:budget_bud/misc/colors.dart';
import 'package:budget_bud/pages/transaction_page/tabs/expense_tab.dart';
import 'package:budget_bud/pages/transaction_page/tabs/income_tab.dart';
import 'package:flutter/material.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({Key? key}) : super(key: key);

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Input your Transactions',
          ),
          elevation: 0,
          bottom: TabBar(
              labelColor: AppColors.mainColorOne,
              unselectedLabelColor: Colors.white,
              indicator: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),
                  color: Colors.white),
              tabs: [
                Tab(
                  text: 'Income',
                  icon: Icon(Icons.arrow_back),
                ),
                Tab(
                  text: 'Expense',
                  icon: Icon(Icons.arrow_forward),
                ),
              ]),
        ),
        body: TabBarView(children: [
          IncomeTab(),
          ExpenseTab(),
        ]),
      ),
    );
  }
}
