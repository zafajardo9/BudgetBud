import 'package:flutter/material.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../auth/auth_page.dart';
import '../../misc/colors.dart';
import '../../misc/txtStyles.dart';
import 'onBoarding_model.dart';
import 'onBoarding_pages.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int currentIndex = 0;
  final pageController = LiquidController();

  _storeOnboardInfo() async {
    print("Shared pref called");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isOnboarded', true);
    print(prefs.getInt('onBoard'));
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size;

    final pages = [
      OnBoardingPagesWidget(
        model: OnboardModel(
            title: 'Welcome to Our Financial Budgeting App',
            desc: 'Start Managing Your Money Today',
            img: 'images/onboarding_page/welcome.png',
            bg: AppColors.mainColorOne,
            fg: AppColors.backgroundWhite,
            counterText: '1',
            height: screenWidth.height),
      ),
      OnBoardingPagesWidget(
          model: OnboardModel(
        title: 'Create Your Budget',
        desc: 'Plan Your Finances for Success',
        img: 'images/onboarding_page/create a plan.png',
        bg: AppColors.mainColorTwo,
        fg: Colors.black,
        counterText: '2',
        height: screenWidth.height,
      )),
      OnBoardingPagesWidget(
          model: OnboardModel(
        title: "Make an Account",
        desc: "Login or Signup for your Finances in One Place",
        img: 'images/onboarding_page/make account.png',
        bg: AppColors.mainColorOne,
        fg: AppColors.backgroundWhite,
        counterText: '3',
        height: screenWidth.height,
      )),
      OnBoardingPagesWidget(
          model: OnboardModel(
        title: 'Monitor Your Progress',
        desc: 'Stay on Track and Achieve Your Goals',
        img: 'images/onboarding_page/monitor.png',
        bg: AppColors.mainColorTwo,
        fg: Colors.black,
        counterText: '4',
        height: screenWidth.height,
      )),
      OnBoardingPagesWidget(
          model: OnboardModel(
        title: 'Get Support and Assistance',
        desc: "With our Algorithm, we're Here to Help You Succeed",
        img: 'images/onboarding_page/get support (2).png',
        bg: AppColors.backgroundWhite,
        fg: Colors.black,
        counterText: '5',
        height: screenWidth.height,
      )),
    ];
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          LiquidSwipe(
            pages: pages,
            liquidController: pageController,
            slideIconWidget: Icon(Icons.arrow_back_ios),
            enableSideReveal: true,
            onPageChangeCallback: onPageChangedCallBack,
          ),
          Positioned(
              bottom: 60,
              child: OutlinedButton(
                onPressed: () {
                  if (currentIndex == pages.length - 1) {
                    _storeOnboardInfo();
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => AuthPage()));
                  } else {
                    int nextPage = pageController.currentPage + 1;
                    pageController.animateToPage(page: nextPage);
                  }
                },
                style: ElevatedButton.styleFrom(
                  side: BorderSide(color: Colors.black26),
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(20),
                ),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      color: currentIndex == pages.length - 1
                          ? AppColors.mainColorOne
                          : AppColors.onBoardingColorButton,
                      shape: BoxShape.circle),
                  child: Icon(
                    currentIndex == pages.length - 1
                        ? Icons.check
                        : Icons.arrow_forward_ios,
                    color: AppColors.backgroundWhite,
                  ),
                ),
              )),
          Positioned(
            top: 50,
            right: 20,
            child: TextButton(
              onPressed: () {
                _storeOnboardInfo();
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => AuthPage()));
              },
              child: Text(
                currentIndex == pages.length - 1 ? 'Done' : 'Skip',
                style: ThemeText.paragraph54,
              ),
            ),
          ),
          Positioned(
              bottom: 10,
              child: AnimatedSmoothIndicator(
                activeIndex: pageController.currentPage,
                count: pages.length,
                effect: WormEffect(
                  activeDotColor: Colors.black,
                  dotHeight: 5.0,
                ),
              ))
        ],
      ),
    );
  }

  onPageChangedCallBack(int activePageIndex) {
    setState(() {
      print(currentIndex);
      currentIndex = activePageIndex;
    });
  }
}
