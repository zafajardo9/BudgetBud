import 'package:budget_bud/misc/colors.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SuggestionPage extends StatefulWidget {
  const SuggestionPage({super.key});

  @override
  State<SuggestionPage> createState() => _SuggestionPageState();
}

class _SuggestionPageState extends State<SuggestionPage> {
  final int percentage = 40;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        title: Text('Our Suggestions'),
        elevation: 0,
        backgroundColor: AppColors.backgroundWhite,
        foregroundColor: AppColors.blackBtn,
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.refresh_rounded))
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                width: Adaptive.w(100),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: AppColors.mainColorOne,
                ),
                padding: EdgeInsets.all(23),
                margin: EdgeInsets.symmetric(vertical: 16),
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
                          percent: percentage * .01,
                          progressColor: AppColors.mainColorTwo,
                          backgroundColor:
                              AppColors.mainColorTwo.withOpacity(.3),
                          circularStrokeCap: CircularStrokeCap.round,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            '${percentage}%',
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
                            'Pure Impulsive',
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
                padding: EdgeInsets.all(23),
                margin: EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  'Our Recommendations',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 19.sp,
                    color: AppColors.backgroundWhite,
                  ),
                ),
              ),
              Container(
                width: Adaptive.w(100),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: AppColors.mainColorOne,
                ),
                padding: EdgeInsets.all(23),
                margin: EdgeInsets.symmetric(vertical: 16),
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
      ),
    );
  }
}
