import 'package:budget_bud/misc/widgetSize.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'onBoarding_model.dart';

class onBoarding_Pages extends StatelessWidget {
  const onBoarding_Pages({
    super.key,
    required this.model,
  });

  final OnboardModel model;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(30),
      color: model.bg,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        children: [
          Image(
            image: AssetImage(model.img),
            height: model.height * 0.5,
          ),
          Column(
            children: [
              Text(
                model.title,
                style: TextStyle(
                    fontSize: 20.sp,
                    color: model.fg,
                    fontWeight: FontWeight.bold),
              ),
              addVerticalSpace(Adaptive.h(1.5)),
              Text(
                model.desc,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: model.fg,
                ),
              ),
            ],
          ),
          Text(
            model.counterText,
            style: TextStyle(
                fontSize: 14.sp, color: model.fg, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 50.0,
          ),
        ],
      ),
    );
  }
}
