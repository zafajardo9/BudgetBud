import 'dart:convert';

import 'package:budget_bud/pages/suggestions/webviewTips.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:http/http.dart' as http;

import '../../api_keys_handler.dart';
import '../../data/suggestion_other.dart';
import '../../data/transaction_data_suggestion_fomulate.dart';
import '../../misc/colors.dart';
import '../../misc/widgetSize.dart';

class SuggestionPage extends StatefulWidget {
  const SuggestionPage({Key? key}) : super(key: key);

  @override
  State<SuggestionPage> createState() => _SuggestionPageState();
}

class _SuggestionPageState extends State<SuggestionPage> {
  final user = FirebaseAuth.instance.currentUser!;

  TransactionSuggestion? summary;
  String generatedResponse = '';
  String generatedFactors = '';
  int minimumTransactionCount = 10;
  bool isGeneratingResponse = false;
  bool isGeneratingFactors = false;

  double impulsivePercentage = 0.0;

  @override
  void initState() {
    super.initState();
    calculateSummary();
  }

  Future<void> calculateSummary() async {
    final calculatedSummary = await summaryForSuggestion(TimePeriod.Monthly);
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
      final Uri uri = Uri.parse("https://api.openai.com/v1/chat/completions");

      final Map<String, dynamic> body = {
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
        final Map<String, dynamic> parsedResponse = json.decode(response.body);
        final String generatedText =
            parsedResponse['choices'][0]['message']['content'];

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

  Future<void> generateFactorsResponse(String query) async {
    if (isGeneratingFactors) {
      return; // Do nothing if a response is already being generated
    }

    setState(() {
      isGeneratingFactors = true; // Disable the "Generate" button
    });

    String? key = APIKeys().suggestionsAPI;
    try {
      final Uri uri = Uri.parse("https://api.openai.com/v1/chat/completions");

      final Map<String, dynamic> body = {
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
        final Map<String, dynamic> parsedResponse = json.decode(response.body);
        final String generatedText =
            parsedResponse['choices'][0]['message']['content'];

        setState(() {
          generatedFactors = generatedText;
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
        isGeneratingFactors = false; // Re-enable the "Generate" button
      });
    }
  }

  String percentageMeaning(TransactionSuggestion? summary) {
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

  void updateExceedsLimit(String userEmail, bool exceedsLimit) {
    FirebaseFirestore.instance.collection('Users').doc(userEmail).update({
      'exceedsLimit': exceedsLimit,
    }).then((value) {
      print('User data updated successfully');
    }).catchError((error) {
      print('Failed to update user data: $error');
    });
  }

  Future<int> countTransactions() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('Transactions')
        .where('UserEmail', isEqualTo: user.email)
        .get();

    return querySnapshot.docs.length;
  }

  // bool get isButtonDisabled =>
  //     isGeneratingResponse ||
  //     (countTransactions().then((value) => value ?? 0)) <
  //         minimumTransactionCount;

  Future<bool> isButtonDisabled() async {
    final transactionCount = await countTransactions();
    return transactionCount < minimumTransactionCount;
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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => WebViewTips()),
              );
            },
            icon: const Icon(Icons.tips_and_updates),
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
                              ? '${summary!.impulsivePercentage.toStringAsFixed(2)}%'
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
                      if (isGeneratingResponse)
                        LoadingAnimationWidget.beat(
                          color: AppColors.mainColorFour,
                          size: 10,
                        ),
                      if (!isGeneratingResponse)
                        FutureBuilder<bool>(
                          future: isButtonDisabled(),
                          builder: (context, snapshot) {
                            final bool? isDisabled = snapshot.data;
                            return ElevatedButton(
                              onPressed: isDisabled == true
                                  ? null
                                  : () async {
                                      final question =
                                          await getTransactionDataSummaryQuestion();
                                      print(question);
                                      generateSuggestionResponse(question);
                                      print(await countTransactions());
                                    },
                              style: ElevatedButton.styleFrom(
                                primary: AppColors.mainColorTwo,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                              ),
                              child: Text(
                                'Generate',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.blackBtn,
                                ),
                              ),
                            );
                          },
                        ),
                    ],
                  ),
                  addVerticalSpace(2),
                  if (isGeneratingResponse)
                    Center(
                      child: LoadingAnimationWidget.beat(
                        color: AppColors.mainColorFour,
                        size: 20,
                      ),
                    )
                  else
                    Text(
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
              child: Column(
                children: [
                  Text(
                    'What we think are the factors',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 19.sp,
                      color: AppColors.backgroundWhite,
                    ),
                  ),
                  if (isGeneratingFactors)
                    LoadingAnimationWidget.beat(
                      color: AppColors.mainColorFour,
                      size: 10,
                    ),
                  if (!isGeneratingFactors)
                    FutureBuilder<bool>(
                      future: isButtonDisabled(),
                      builder: (context, snapshot) {
                        final bool? isDisabled = snapshot.data;
                        return ElevatedButton(
                          onPressed: isDisabled == true
                              ? null
                              : () async {
                                  final factorsQuestion =
                                      await getFactorsAnswer();
                                  generateFactorsResponse(factorsQuestion);
                                },
                          style: ElevatedButton.styleFrom(
                            primary: AppColors.mainColorTwo,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          child: Text(
                            'Generate',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.blackBtn,
                            ),
                          ),
                        );
                      },
                    ),
                  addVerticalSpace(2),
                  if (isGeneratingFactors)
                    Center(
                      child: LoadingAnimationWidget.beat(
                          color: AppColors.mainColorFour, size: 20),
                    )
                  else
                    Text(
                      generatedFactors,
                      style: TextStyle(
                        fontSize: 15.sp,
                        color: AppColors.backgroundWhite,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
