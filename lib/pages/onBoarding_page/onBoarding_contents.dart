import 'package:flutter/material.dart';

class OnboardModel {
  String img;
  String text;
  String desc;
  Color bg;
  Color button;

  OnboardModel({
    required this.img,
    required this.text,
    required this.desc,
    required this.bg,
    required this.button,
  });
}

// List<OnboardingContents> contents = [
//   OnboardingContents(
//     title: "Track Your work and get the result",
//     image: "assets/bbLogo.png",
//     desc: "Remember to keep track of your professional accomplishments.",
//   ),
//   OnboardingContents(
//     title: "Stay organized with team",
//     image: "assets/other/2.jpg",
//     desc:
//         "But understanding the contributions our colleagues make to our teams and companies.",
//   ),
//   OnboardingContents(
//     title: "Get notified when work happens",
//     image: "assets/other/8.jpg",
//     desc:
//         "Take control of notifications, collaborate live or on your own time.",
//   ),
// ];
