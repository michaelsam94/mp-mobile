import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mega_plus/core/helpers/addons_functions.dart';
import 'package:mega_plus/core/helpers/cache/cache_helper.dart';
import 'package:mega_plus/core/style/app_colors.dart';
import 'package:mega_plus/core/widgets/shimmer_widget.dart';
import 'package:mega_plus/presentation/auth/login/login_screen.dart';
import 'package:mega_plus/presentation/onboarding/cubit/on_boarding_cubit.dart';

class OnboardingScreen extends StatelessWidget {
  OnboardingScreen({super.key});
  
  void _goNext(BuildContext context, int currentIndex, int totalTips) {
    if (currentIndex < totalTips - 1) {
      OnBoardingCubit.get(context).changeIndex(++currentIndex);
    } else {
      // Mark onboarding as completed when user finishes
      CacheHelper.setOnboardingCompleted();
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
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ShimmerWidget(
                      width: 50,
                      height: 50,
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ],
                ),
              );
            }
            if (cubit.tips.isEmpty) {
              return Center(
                child: Text(
                  'No onboarding data available',
                  style: TextStyle(color: Colors.grey),
                ),
              );
            }

            final currentTip = cubit.tips[cubit.currentIndex];
            
            return SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Images
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: currentTip.imageUrl != null
                        ? Image.network(
                            currentTip.imageUrl!,
                            width: context.width(),
                            height: 260,
                            fit: BoxFit.fitHeight,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: context.width(),
                                height: 260,
                                color: Colors.grey[200],
                                child: Icon(
                                  Icons.image_not_supported,
                                  size: 50,
                                  color: Colors.grey[400],
                                ),
                              );
                            },
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Container(
                                width: context.width(),
                                height: 260,
                                color: Colors.grey[200],
                                child: Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes != null
                                        ? loadingProgress.cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                        : null,
                                  ),
                                ),
                              );
                            },
                          )
                        : Container(
                            width: context.width(),
                            height: 260,
                            color: Colors.grey[200],
                            child: Icon(
                              Icons.image_not_supported,
                              size: 50,
                              color: Colors.grey[400],
                            ),
                          ),
                  ),
                  // Titles & Subtitles
                  SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      children: [
                        Text(
                          currentTip.title ?? "",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          currentTip.description ?? "",
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
                    children: List.generate(cubit.tips.length, (index) {
                      return AnimatedContainer(
                        duration: Duration(milliseconds: 200),
                        margin: EdgeInsets.symmetric(horizontal: 4),
                        width: index == cubit.currentIndex ? 76 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: index == cubit.currentIndex
                              ? AppColors.primary // Green indicator
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
                          _goNext(context, cubit.currentIndex, cubit.tips.length);
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          backgroundColor: AppColors.primary,
                          elevation: 0,
                        ),
                        child: Text(
                          cubit.currentIndex < cubit.tips.length - 1 ? 'Next' : 'Get Started',
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
