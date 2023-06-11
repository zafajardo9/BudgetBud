import 'package:flutter/material.dart';

class KeysToBeInherited extends InheritedWidget {
  final GlobalKey userDisplay;
  final GlobalKey userCard;
  final GlobalKey features;
  final GlobalKey settings;
  final GlobalKey featureNews;
  final GlobalKey featureConvert;
  final GlobalKey transactions;
  final GlobalKey userIncome;
  final GlobalKey userExpense;

  KeysToBeInherited({
    required this.userDisplay,
    required this.userCard,
    required this.features,
    required this.settings,
    required this.featureNews,
    required this.featureConvert,
    required this.transactions,
    required this.userIncome,
    required this.userExpense,
    required Widget child,
  }) : super(child: child);

  static KeysToBeInherited? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<KeysToBeInherited>();
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    // TODO: implement updateShouldNotify
    return true;
  }
}
