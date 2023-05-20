import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

Widget addVerticalSpace(double height) {
  return SizedBox(
    height: Adaptive.h(height),
  );
}

Widget addHorizontalSpace(double width) {
  return SizedBox(
    width: Adaptive.w(width),
  );
}
