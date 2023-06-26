import 'dart:convert';

import 'package:budget_bud/api_keys_handler.dart';
import 'package:budget_bud/misc/colors.dart';
import 'package:budget_bud/misc/widgetSize.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:http/http.dart' as http;

import '../../data/suggestion_model.dart';
import '../../data/transaction_data_summary.dart';

class SuggestionPage extends StatefulWidget {
  const SuggestionPage({Key? key}) : super(key: key);

  @override
  State<SuggestionPage> createState() => _SuggestionPageState();
}

class _SuggestionPageState extends State<SuggestionPage> {
  TransactionSummary? summary;
  final List<MachineSuggestions> _suggestions = [];
  String generatedResponse = '';

  bool isGeneratingResponse = false;

  @override
  void initState() {
    super.initState();
    calculateSummary();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> calculateSummary() async {
    final calculatedSummary = await calculateTransactionSummaryByMonth();
    setState(() {
      summary = calculatedSummary;
    });
  }

  Future<void> generateSuggestionResponse(String query) async {
    if (isGeneratingResponse) {
      return; // Do nothing if a response is already being generated
    }

    setState(() {
      isGeneratingResponse = true; // Disable the "Generate" button
    });

    String? key = APIKeys().suggestionsAPI;
    try {
      await Future.delayed(Duration(seconds: 2));

      Uri uri = Uri.parse("https://api.openai.com/v1/chat/completions");

      Map<String, dynamic> body = {
        "model": "gpt-3.5-turbo",
        "messages": [
          {"role": "user", "content": query}
        ],
      };

      final response = await http.post(
        uri,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $key",
        },
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> parsedReponse = json.decode(response.body);
        String generatedText =
            parsedReponse['choices'][0]['message']['content'];

        setState(() {
          generatedResponse = generatedText;
        });
      } else {
        // Handle the API response error
        print('API request failed with status code ${response.statusCode}');
        print(key);
      }
    } catch (e) {
      // Handle any other errors
      print('Error occurred: $e');
    } finally {
      setState(() {
        isGeneratingResponse = false; // Re-enable the "Generate" button
      });
    }
  }

  String percentageMeaning(TransactionSummary? summary) {
    if (summary == null) {
      return ''; // Return an appropriate default value if summary is null
    }

    if (summary.impulsivePercentage < 30.0) {
      return 'Financially disciplined or less impulsive';
    } else if (summary.impulsivePercentage < 50.0) {
      return 'Moderately impulsive';
    } else {
      return 'Highly impulsive';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        title: const Text('Our Suggestions'),
        elevation: 0,
        backgroundColor: AppColors.backgroundWhite,
        foregroundColor: AppColors.blackBtn,
        actions: [
          IconButton(
            onPressed: () {
              // Refresh button pressed
            },
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              width: Adaptive.w(100),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: AppColors.mainColorOne,
              ),
              padding: const EdgeInsets.all(23),
              margin: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Container(
                      width: Adaptive.w(3),
                      child: CircularPercentIndicator(
                        radius: 60,
                        animation: true,
                        animationDuration: 1000,
                        lineWidth: 15,
                        percent: summary?.impulsivePercentage != null
                            ? summary!.impulsivePercentage * .01
                            : 0,
                        progressColor: AppColors.mainColorTwo,
                        backgroundColor: AppColors.mainColorTwo.withOpacity(.3),
                        circularStrokeCap: CircularStrokeCap.round,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          summary?.impulsivePercentage != null
                              ? '${summary!.impulsivePercentage}%'
                              : '',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.sp,
                            color: AppColors.backgroundWhite,
                          ),
                        ),
                        Text(
                          'You are:',
                          style: TextStyle(
                            fontSize: 15.sp,
                            color: AppColors.backgroundWhite,
                          ),
                        ),
                        Text(
                          summary != null ? percentageMeaning(summary) : '',
                          style: TextStyle(
                            fontSize: 18.sp,
                            color: AppColors.mainColorFour,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: Adaptive.w(100),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: AppColors.mainColorOne,
              ),
              padding: const EdgeInsets.all(23),
              margin: const EdgeInsets.symmetric(vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Our Recommendations',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 19.sp,
                            color: AppColors.backgroundWhite,
                          ),
                        ),
                      ),
                      Stack(
                        children: [
                          ElevatedButton(
                            onPressed: isGeneratingResponse
                                ? null // Disable the button if a response is being generated
                                : () {
                                    generateSuggestionResponse('HELLO FLUTTER');
                                  },
                            style: ElevatedButton.styleFrom(
                              primary: AppColors
                                  .mainColorTwo, // Change the button color here
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    25), // Adjust the border radius here
                              ),
                            ),
                            child: Text(
                              'Generate',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.blackBtn),
                            ),
                          ),
                          if (isGeneratingResponse)
                            Positioned.fill(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  color: AppColors.mainColorTwo.withOpacity(.3),
                                ),
                                child: Center(
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      AppColors.mainColorTwo,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                  addVerticalSpace(2),
                  generatedResponse == null
                      ? CircularProgressIndicator() // Display a loading indicator while generating the response
                      : Text(
                          generatedResponse,
                          style: TextStyle(
                            fontSize: 15.sp,
                            color: AppColors.backgroundWhite,
                          ),
                        ),
                ],
              ),
            ),
            Container(
              width: Adaptive.w(100),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: AppColors.mainColorOne,
              ),
              padding: const EdgeInsets.all(23),
              margin: const EdgeInsets.symmetric(vertical: 16),
              child: Text(
                'What we think are the factors',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 19.sp,
                  color: AppColors.backgroundWhite,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
