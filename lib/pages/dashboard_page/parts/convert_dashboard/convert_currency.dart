import 'package:budget_bud/api_keys_handler.dart';
import 'package:budget_bud/pages/dashboard_page/parts/convert_dashboard/components/dropdownlist.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:responsive_sizer/responsive_sizer.dart';

class CurrencyConverter extends StatefulWidget {
  const CurrencyConverter({Key? key}) : super(key: key);

  @override
  _CurrencyConverterState createState() => _CurrencyConverterState();
}

class _CurrencyConverterState extends State<CurrencyConverter> {
  String _baseCurrency = 'USD'; // Default base currency
  String _targetCurrency = 'EUR'; // Default target currency
  double _amount = 0.0;
  double _result = 0.0;

  void _swapCurrencies() {
    setState(() {
      final temp = _targetCurrency;
      _targetCurrency = _baseCurrency;
      _baseCurrency = temp;
    });
  }

  Future<void> _convertCurrency() async {
    final API_KEY = APIKeys().currentExchangeAPI;
    final url = 'https://openexchangerates.org/api/latest.json?app_id=$API_KEY';
    final response = await http.get(Uri.parse(url));
    final data = json.decode(response.body);

    if (data['error'] != null) {
      // Handle API error
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('An error occurred'),
          content: Text(data['error']),
          actions: [
            ElevatedButton(
              child: Text('OK'),
              onPressed: () => Navigator.of(ctx).pop(),
            ),
          ],
        ),
      );
    } else {
      final rates = data['rates'];
      final baseRate = rates[_baseCurrency];
      final targetRate = rates[_targetCurrency];

      setState(() {
        _result = (_amount / baseRate) * targetRate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Currency Converter'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                height: Adaptive.h(25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyDropdown(
                      fillValue: _targetCurrency,
                      value: _targetCurrency,
                      onChanged: (value) {
                        setState(() {
                          _targetCurrency = value!;
                        });
                      },
                    ),
                    TextField(
                      readOnly: true,
                      keyboardType: TextInputType.number,
                      controller: TextEditingController(
                          text: _result.toStringAsFixed(2)),
                      style: TextStyle(fontSize: 30.sp),
                      decoration: InputDecoration(
                        prefixIcon: Text(_targetCurrency),
                        labelText: 'To be converted',
                        labelStyle: TextStyle(fontSize: 16.sp),
                        hintText: '0.0',
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: _swapCurrencies,
                child: Icon(Icons.swap_horiz_outlined),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
              Container(
                height: Adaptive.h(25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyDropdown(
                      fillValue: _baseCurrency,
                      value: _baseCurrency,
                      onChanged: (value) {
                        setState(() {
                          _baseCurrency = value!;
                        });
                      },
                    ),
                    TextField(
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        setState(() {
                          _amount = double.tryParse(value) ?? 0.0;
                        });
                      },
                      style: TextStyle(fontSize: 30.sp),
                      decoration: InputDecoration(
                        prefixIcon: Text(_baseCurrency),
                        labelText: 'Your currency',
                        labelStyle: TextStyle(fontSize: 16.sp),
                        hintText: '0.0',
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: _convertCurrency,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text('Convert'.toUpperCase()),
              ),
              SizedBox(height: 16.0),
            ],
          ),
        ),
      ),
    );
  }
}
