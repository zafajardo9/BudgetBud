import 'package:budget_bud/data/income_data.dart';
import 'package:budget_bud/misc/colors.dart';
import 'package:budget_bud/misc/txtStyles.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  List<Income> income = [
    Income(
      incomeName: 'Paypal',
      incomeDescription: 'Client Payment',
      incomeAmount: 300,
      incomeDate: DateTime(2012, 4, 23),
    ),
    Income(
      incomeName: 'Bank',
      incomeDescription: 'App Payment',
      incomeAmount: 400,
      incomeDate: DateTime(2012, 7, 29),
    ),
    Income(
      incomeName: 'Wallet',
      incomeDescription: 'Convert from gcash',
      incomeAmount: 1000,
      incomeDate: DateTime(2012, 5, 3),
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Dashboard'),
      ),
      body: income.isEmpty
          ? Center(
              child: Text('No Income Yet, pls add Income'),
            )
          : ListView.builder(
              itemCount: income.length,
              itemBuilder: (context, index) => Card(
                child: ListTile(
                  title: Text(
                    income[index].incomeName,
                    style: ThemeText.subHeader1Bold,
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(income[index]
                          .incomeDescription), // income description
                      Text(
                          'Amount: \$${income[index].incomeAmount.toString()}'), // income amount
                      Text(
                          'Date: ${income[index].incomeDate.toString()}'), // income date
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
                          onTap: () {},
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
            ),
    );
  }
}
