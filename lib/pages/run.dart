import 'package:budget_bud/pages/dashboard_page/dashboard_page.dart';
import 'package:budget_bud/pages/profile_page/profile_page.dart';
import 'package:budget_bud/pages/user_budget_goals/user_budgets.dart';
import 'package:budget_bud/pages/user_wallet/wallet.dart';
import 'package:dot_navigation_bar/dot_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../misc/colors.dart';

import 'home_page/home_page.dart';
import 'transaction_page/transaction_page.dart';

class Run extends StatefulWidget {
  const Run({super.key});

  @override
  State<Run> createState() => _RunState();
}

// int _currentIndex = 0;

//===================
class _RunState extends State<Run> {
  var _selectedTab = _SelectedTab.homePage;

  void _handleIndexChanged(int i) {
    setState(() {
      _selectedTab = _SelectedTab.values[i];
    });
  }

  final navigation = [
    DashboardPage(),
    HomePage(),
    TransactionPage(),
    UserBudgetGoals(),
    ProfilePage(),
  ];

  final int iconValue = 20;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBody: true,
      body: navigation[_selectedTab.index],
      bottomNavigationBar: DotNavigationBar(
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white.withOpacity(0.4),
        paddingR: EdgeInsets.all(4),
        margin: EdgeInsets.only(bottom: 20),
        borderRadius: 15,
        dotIndicatorColor: Colors.transparent,
        backgroundColor: AppColors.mainColorOne,
        currentIndex: _SelectedTab.values.indexOf(_selectedTab),
        onTap: _handleIndexChanged,
        enableFloatingNavBar: true,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 4,
            offset: Offset(0, 3),
          ),
        ],
        items: [
          /// Dashboard
          DotNavigationBarItem(
            icon: Icon(
              Icons.home,
              size: iconValue.sp,
            ),
            selectedColor: Colors.white,
          ),

          /// Analytics
          DotNavigationBarItem(
            icon: Icon(
              Icons.bar_chart_rounded,
              size: iconValue.sp,
            ),
            selectedColor: Colors.white,
          ),

          ///Input Expense & Income
          DotNavigationBarItem(
            icon: Icon(
              Icons.add,
              size: iconValue.sp,
            ),
            selectedColor: Colors.white,
          ),

          //Wallet of user and budget Goal
          DotNavigationBarItem(
            icon: Icon(
              //when using fontawesome you should minus it to 5
              FontAwesomeIcons.calculator,
              size: iconValue - 5.sp,
            ),
            selectedColor: Colors.white,
          ),

          /// Profile
          DotNavigationBarItem(
            icon: Icon(
              Icons.account_circle,
              size: iconValue.sp,
            ),
            selectedColor: Colors.white,
          ),
        ],
      ),
    );
  }
}

enum _SelectedTab {
  homePage,
  dashboardPage,
  transactionPage,
  userBudget,
  profilePage
}
