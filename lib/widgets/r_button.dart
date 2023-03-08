import 'package:budget_bud/misc/colors.dart';
import 'package:flutter/widgets.dart';

class ResponsiveButton extends StatelessWidget {
  bool? isResponsive;
  double? width;

  ResponsiveButton({
    super.key,
    this.isResponsive = false,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppColors.mainColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Image.asset("assets/btn-one.png")],
      ),
    );
  }
}
