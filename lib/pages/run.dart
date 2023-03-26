import 'package:budget_bud/pages/dashboard_page.dart';
import 'package:budget_bud/pages/profile_page.dart';
import 'package:dot_navigation_bar/dot_navigation_bar.dart';
import 'package:flutter/material.dart';

import 'home_page.dart';

class Run extends StatefulWidget {
  const Run({super.key});

  @override
  State<Run> createState() => _RunState();
}

// int _currentIndex = 0;

//===================
class _RunState extends State<Run> {
  var _selectedTab = _SelectedTab.home;

  void _handleIndexChanged(int i) {
    setState(() {
      _selectedTab = _SelectedTab.values[i];
    });
  }

  final navigation = [HomePage(), DashboardPage(), ProfilePage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: navigation[_selectedTab.index],
      bottomNavigationBar: DotNavigationBar(
        paddingR: EdgeInsets.all(10),
        backgroundColor: Colors.red[700],
        margin: EdgeInsets.only(bottom: 10),
        dotIndicatorColor: Colors.white,
        currentIndex: _SelectedTab.values.indexOf(_selectedTab),
        unselectedItemColor: Colors.grey[300],
        onTap: _handleIndexChanged,
        items: [
          /// Home
          DotNavigationBarItem(
            icon: Icon(Icons.home),
            selectedColor: Colors.white,
          ),

          /// Dashboard
          DotNavigationBarItem(
            icon: Icon(Icons.bar_chart_rounded),
            selectedColor: Colors.white,
          ),

          /// Profile
          DotNavigationBarItem(
            icon: Icon(Icons.account_circle),
            selectedColor: Colors.white,
          ),
        ],
      ),
    );
  }
}

enum _SelectedTab { home, barchart, person }
