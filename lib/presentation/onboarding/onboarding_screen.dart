import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mega_plus/core/helpers/addons_functions.dart';
import 'package:mega_plus/core/style/app_colors.dart';
import 'package:mega_plus/presentation/auth/login/login_screen.dart';
import 'package:mega_plus/presentation/onboarding/cubit/on_boarding_cubit.dart';

class OnboardingScreen extends StatelessWidget {
  final List<String> images = [
    'assets/images/onboarding1.png',
    'assets/images/onboarding2.png',
    'assets/images/onboarding3.png',
  ];

  OnboardingScreen({super.key});
  void _goNext(BuildContext context, int currentIndex) {
    if (currentIndex < 2) {
      OnBoardingCubit.get(context).changeIndex(++currentIndex);
    } else {
      context.goTo(LoginScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    final cubit = OnBoardingCubit.get(context);
    cubit.getData();
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<OnBoardingCubit, OnBoardingState>(
          builder: (context, state) {
            if (state is LoadingOnBoardingState) {
              return Center(child: CircularProgressIndicator());
            }
            return SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Images
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Image.asset(
                      images[cubit.currentIndex],
                      width: context.width(),
                      height: 260,
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                  // Titles & Subtitles
                  SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      children: [
                        Text(
                          cubit.tips[cubit.currentIndex].title ?? "",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          cubit.tips[cubit.currentIndex].description ?? "",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xff606060),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  // Indicator
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(3, (index) {
                      return AnimatedContainer(
                        duration: Duration(milliseconds: 200),
                        margin: EdgeInsets.symmetric(horizontal: 4),
                        width: index == cubit.currentIndex ? 76 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: index == cubit.currentIndex
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
                        onPressed: () {
                          _goNext(context, cubit.currentIndex);
                        },
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
            );
          },
        ),
      ),
    );
  }
}
