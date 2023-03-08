import 'package:budget_bud/widgets/app_large_text.dart';
import 'package:budget_bud/widgets/r_button.dart';
import 'package:flutter/material.dart';
import '../widgets/app_text.dart';
import '../misc/colors.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  List images = [
    "screen1.jpg",
    "screen2.jpg",
    "screen3.jpg",
    "screen4.jpg",
  ];

  List textHeadersOne = [
    "Take control",
    "Revolutionize",
    "User-Friendly",
    "Experience",
  ];

  List textHeadersTwo = [
    "in finances",
    "how you budget",
    "navigation",
    "peace of mind",
  ];

  List textDescriptions = [
    "The ultimate app for managing money and tracking expenses!",
    "Our advanced Machine Learning analyze your spending habits and provide personalized recommendations for better money management.",
    "Designed to be the number one and most user-friendly app on the market. With its intuitive interface and easy-to-use features, managing your money has never been easier!",
    "State-of-the-art security measures ensure your financial information is always safe and secure.",
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
          scrollDirection: Axis.vertical,
          itemCount: images.length,
          itemBuilder: (_, index) {
            return Container(
              width: double.maxFinite,
              height: double.maxFinite,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/" + images[index]),
                    fit: BoxFit.cover),
              ),
              child: Container(
                margin: const EdgeInsets.only(top: 150, left: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppLargeText(text: textHeadersOne[index]),
                        AppText(
                          text: textHeadersTwo[index],
                          size: 30,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          width: 250,
                          child: AppText(
                            text: textDescriptions[index],
                            color: AppColors.textColor2,
                            size: 14,
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        ResponsiveButton(
                          width: 100,
                        )
                      ],
                    ),
                    Column(
                      children: List.generate(4, (indexDots) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 2),
                          width: 8,
                          height: index == indexDots ? 25 : 8,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: index == indexDots
                                ? AppColors.mainColor
                                : AppColors.mainColor.withOpacity(0.3),
                          ),
                        );
                      }),
                    )
                  ],
                ),
              ),
            );
          }),
    );
  }
}
