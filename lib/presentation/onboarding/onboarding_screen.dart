import 'package:flutter/material.dart';
import 'package:mega_plus/core/helpers/addons_functions.dart';
import 'package:mega_plus/core/style/app_colors.dart';
import 'package:mega_plus/presentation/auth/signup/sign_up_screen.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _currentIndex = 0;

  final List<String> images = [
    'assets/images/onboarding1.png',
    'assets/images/onboarding2.png',
    'assets/images/onboarding3.png',
  ];
  final List<String> titles = [
    'Find Charging Stations\n Around You',
    'Plan Routes With\n Confidence',
    'Track Every Charging\n Session',
  ];
  final List<String> subtitles = [
    'Quickly discover the closest EV chargers so you can drive without worrying about running out of power.',
    'Let the app suggest the best charging stops along your journey for a smoother, stress-free trip.',
    'Watch your charging speed, battery level, and remaining time all in real time',
  ];

  void _goNext() {
    setState(() {
      if (_currentIndex < 2) {
        _currentIndex++;
      } else {
        context.goTo(SignUpScreen());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Images
            Padding(
              padding: const EdgeInsets.all(16),
              child: Image.asset(
                images[_currentIndex],
                width: context.width(),
                height: 260,
                fit: BoxFit.fitHeight,
              ),
            ),
            // Titles & Subtitles
            SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  Text(
                    titles[_currentIndex],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    subtitles[_currentIndex],
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Color(0xff606060)),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            // Indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) {
                return AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  margin: EdgeInsets.symmetric(horizontal: 4),
                  width: index == _currentIndex ? 76 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: index == _currentIndex
                        ? AppColors
                              .primary // Green indicator
                        : Color(0xFFE2E7EF),
                  ),
                );
              }),
            ),
            SizedBox(height: 30),
            // Next Button
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 18.0,
                vertical: 8,
              ),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _goNext,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    backgroundColor: AppColors.primary,
                    elevation: 0,
                  ),
                  child: Text(
                    'Next',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
