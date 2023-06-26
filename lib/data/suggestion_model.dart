import 'package:flutter/material.dart';

class MachineSuggestions extends StatelessWidget {
  const MachineSuggestions(
      {super.key, required this.text, required this.query});

  final String text;
  final String query;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(query),
        Text(text),
      ],
    );
  }
}
