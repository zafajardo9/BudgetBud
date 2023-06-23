import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:budget_bud/pages/dashboard_page/dashboard_page.dart';
import 'package:budget_bud/pages/profile_page/profile_page.dart';
import 'package:budget_bud/pages/user_budget_goals/survey/step_survey.dart';
import 'package:budget_bud/pages/user_budget_goals/user_budgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
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
    StepSurvey(),
    ProfilePage(),
  ];

  ShapeBorder? bottomBarShape = const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(20)),
  );
  SnakeBarBehaviour snakeBarStyle = SnakeBarBehaviour.floating;
  EdgeInsets padding = const EdgeInsets.all(12);

  SnakeShape snakeShape = SnakeShape.circle;

  bool showSelectedLabels = false;
  bool showUnselectedLabels = false;

  Color selectedColor = AppColors.mainColorOne;
  Color unselectedColor = Colors.black.withOpacity(.4);

  final int iconValue = 20;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBody: true,
      body: navigation[_selectedTab.index] /**DashboardPage() **/,
      bottomNavigationBar: SnakeNavigationBar.color(
        height: Adaptive.h(7),
        backgroundColor: AppColors.mainColorTwo,
        behaviour: snakeBarStyle,
        snakeShape: snakeShape,
        shape: bottomBarShape,
        padding: padding,
        elevation: 2,

        ///configuration for SnakeNavigationBar.color
        snakeViewColor: selectedColor,
        selectedItemColor:
            snakeShape == SnakeShape.indicator ? selectedColor : null,
        unselectedItemColor: unselectedColor,

        ///configuration for SnakeNavigationBar.gradient
        // snakeViewGradient: selectedGradient,
        // selectedItemGradient: snakeShape == SnakeShape.indicator ? selectedGradient : null,
        // unselectedItemGradient: unselectedGradient,

        showUnselectedLabels: showUnselectedLabels,
        showSelectedLabels: showSelectedLabels,

        currentIndex: _SelectedTab.values.indexOf(_selectedTab),
        onTap: _handleIndexChanged,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '1'),
          BottomNavigationBarItem(
              icon: Icon(Icons.auto_graph_outlined), label: '2'),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: '3'),
          BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.piggyBank, size: 19.sp), label: '4'),
          BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.user, size: 19.sp), label: '5')
        ],
        selectedLabelStyle: const TextStyle(fontSize: 14),
        unselectedLabelStyle: const TextStyle(fontSize: 10),
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
