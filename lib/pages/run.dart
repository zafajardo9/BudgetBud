import 'package:budget_bud/pages/login_page.dart';
import 'package:dot_navigation_bar/dot_navigation_bar.dart';
import 'package:flutter/material.dart';

import 'home_page.dart';

class Run extends StatefulWidget {
  const Run({super.key});

  @override
  State<Run> createState() => _RunState();
}

int _currentIndex = 0;

//===================
class _RunState extends State<Run> {
  var _selectedTab = _SelectedTab.home;

  void _handleIndexChanged(int i) {
    setState(() {
      _selectedTab = _SelectedTab.values[i];
    });
  }

  final navigation = [HomePage(), LoginPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: navigation[_selectedTab.index],
      bottomNavigationBar: DotNavigationBar(
        backgroundColor: Colors.redAccent.shade200,
        margin: EdgeInsets.only(bottom: 10),
        dotIndicatorColor: Colors.black,
        currentIndex: _SelectedTab.values.indexOf(_selectedTab),
        unselectedItemColor: Colors.grey[300],
        onTap: _handleIndexChanged,
        items: [
          /// Home
          DotNavigationBarItem(
            icon: Icon(Icons.home),
            selectedColor: Colors.white,
          ),

          /// Likes
          DotNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            selectedColor: Colors.white,
          ),
        ],
      ),
    );
  }
}

enum _SelectedTab { home, favorite, search, person }
