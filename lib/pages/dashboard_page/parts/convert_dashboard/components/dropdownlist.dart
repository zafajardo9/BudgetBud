import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:responsive_sizer/responsive_sizer.dart';
import 'dart:convert';

import '../../../../../api_keys_handler.dart';
import '../../../../../misc/colors.dart';

class MyDropdown extends StatefulWidget {
  final void Function(String?)? onChanged;
  final String fillValue;
  MyDropdown({this.onChanged, required String value, required this.fillValue});

  @override
  _MyDropdownState createState() => _MyDropdownState();
}

class _MyDropdownState extends State<MyDropdown> {
  String? selectedValue;
  List<String> countries = [];

  @override
  void initState() {
    super.initState();
    fetchCountries();
  }

  Future<void> fetchCountries() async {
    final String? apiKey = APIKeys().currentExchangeAPI;
    final url =
        'https://openexchangerates.org/api/currencies.json?app_id=$apiKey';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final jsonResult = json.decode(response.body);
        setState(() {
          countries = jsonResult.keys.toList();
        });
      } else {
        print('Request failed with status: ${response.statusCode}.');
      }
    } catch (error) {
      print('Error occurred: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: selectedValue ?? widget.fillValue,
      onChanged: (String? newValue) {
        setState(() {
          selectedValue = newValue;
        });

        if (widget.onChanged != null) {
          widget.onChanged!(newValue);
        }
      },
      items: countries.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
