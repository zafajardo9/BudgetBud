import 'package:flutter/material.dart';

import '../../misc/colors.dart';

class UserCategory extends StatelessWidget {
  const UserCategory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainColorOne,
      appBar: AppBar(
        title: Text('Category List'),
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadiusDirectional.only(
                  topStart: Radius.circular(25),
                  topEnd: Radius.circular(25),
                ),
              ),
              child: ListView(
                children: [
                  GestureDetector(
                    onTap: () {
                      print('asdfasdf');
                    },
                    child: ListTile(
                      title: Text('Item 1'),
                      subtitle: Text('Description for Item 1'),
                      leading: Icon(Icons.ac_unit),
                    ),
                  ),
                  ListTile(
                    title: Text('Item 2'),
                    subtitle: Text('Description for Item 2'),
                    leading: Icon(Icons.access_alarm),
                  ),
                  ListTile(
                    title: Text('Item 3'),
                    subtitle: Text('Description for Item 3'),
                    leading: Icon(Icons.accessibility),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
