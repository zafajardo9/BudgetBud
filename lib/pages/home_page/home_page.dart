import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser!;

  //sign out
  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  //add new expense
  void addNewExpense() {}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text('TODO LIST'),
          ),
        ),
        body: Scaffold(
          floatingActionButton: FloatingActionButton.small(
            onPressed: addNewExpense,
            child: Icon(Icons.add),
          ),
        ));
  }
}
