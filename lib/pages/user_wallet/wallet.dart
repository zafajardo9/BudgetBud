import 'package:budget_bud/misc/txtStyles.dart';
import 'package:budget_bud/misc/widgetSize.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../data/transaction_data_summary.dart';
import '../../misc/colors.dart';
import 'graphMonthSpend.dart';

class UserWallet extends StatefulWidget {
  const UserWallet({Key? key}) : super(key: key);

  @override
  State<UserWallet> createState() => _UserWalletState();
}

class _UserWalletState extends State<UserWallet> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainColorOne,
      appBar: AppBar(
        title: Text('Wallet'),
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              width: double.infinity,
              height: Adaptive.h(25),
              decoration: BoxDecoration(
                color: AppColors.backgroundWhite,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Total Balance'),
                  Text(
                    '1,000',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20.sp),
                  ),
                  Text('Monthly Budget'),
                  Text(
                    '1,000',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20.sp),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your Transactions',
                    style: ThemeText.transactionAmount,
                    //style
                  ),
                  Text(
                    'Know difference of your spendings',
                    style: ThemeText.paragraph54,
                  ),
                ],
              ),
            ),
          ),
          addVerticalSpace(3),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadiusDirectional.only(
                    topStart: Radius.circular(25),
                    topEnd: Radius.circular(25),
                  )),
              child: Stack(
                children: [
                  Text('Your Budget'),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: GridView(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12.0,
                        mainAxisSpacing: 12.0,
                      ),
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.mainColorOne,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 4,
                                blurRadius: 10,
                                offset: Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.ac_unit,
                                size: 10.w,
                                color: AppColors.backgroundWhite,
                              ),
                              Text(
                                'Budget One',
                                style: ThemeText.subHeaderWhite2,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.mainColorOne,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 4,
                                blurRadius: 10,
                                offset: Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.ac_unit,
                                size: 10.w,
                                color: AppColors.backgroundWhite,
                              ),
                              Text(
                                'Budget One',
                                style: ThemeText.subHeaderWhite2,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.mainColorOne,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 4,
                                blurRadius: 10,
                                offset: Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.ac_unit,
                                size: 10.w,
                                color: AppColors.backgroundWhite,
                              ),
                              Text(
                                'Budget One',
                                style: ThemeText.subHeaderWhite2,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
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
