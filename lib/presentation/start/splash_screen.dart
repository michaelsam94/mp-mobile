import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mega_plus/core/helpers/addons_functions.dart';
import 'package:mega_plus/core/helpers/cache/cache_helper.dart';
import 'package:mega_plus/core/helpers/cache/cache_keys.dart';
import 'package:mega_plus/core/helpers/network/dio_helper.dart';
import 'package:mega_plus/presentation/main/main_screen.dart';
import 'package:mega_plus/presentation/onboarding/cubit/on_boarding_cubit.dart';

import '../../core/style/app_colors.dart';
import '../onboarding/onboarding_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 2), () async {
      if (context.mounted) {
        // First, check if there's a token in cache
        final token = CacheHelper.getString(CacheKeys.token.name);
        
        // If token exists, check login status and navigate accordingly
        if (token != null && token.isNotEmpty) {
          switch (CacheHelper.checkLogin()) {
            case 1:
              // Token exists but login data is missing - clear and show onboarding
              await CacheHelper.logout();
              if (context.mounted) {
                context.goOff(
                  BlocProvider(
                    create: (context) => OnBoardingCubit(),
                    child: OnboardingScreen(),
                  ),
                );
              }
              break;
            case 2:
              // Token expired - try to refresh
              bool refreshed = await DioHelper.refreshToken();
              if (refreshed) {
                if (context.mounted) context.goOff(MainScreen());
              } else {
                await CacheHelper.logout();
                // After logout, show onboarding when user is not logged in
                if (context.mounted) {
                  context.goOff(
                    BlocProvider(
                      create: (context) => OnBoardingCubit(),
                      child: OnboardingScreen(),
                    ),
                  );
                }
              }
              break;
            case 3:
              // Valid token - go to home screen
              if (context.mounted) context.goOff(MainScreen());
              break;
          }
        } else {
          // No token in cache - show onboarding
          if (context.mounted) {
            context.goOff(
              BlocProvider(
                create: (context) => OnBoardingCubit(),
                child: OnboardingScreen(),
              ),
            );
          }
        }
      }
    });

    return Scaffold(
      body: SizedBox(
        width: context.width(),
        height: context.height(),
        child: Stack(
          children: [
            Align(
              alignment: AlignmentGeometry.center,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Image.asset("assets/icons/ic_black_word.png"),
              ),
            ),
            Align(
              alignment: AlignmentGeometry.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 50),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(
                      strokeWidth: 7,
                      strokeCap: StrokeCap.round,
                      backgroundColor: AppColors.primary.withValues(alpha: .2),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'powered by Tadafuq',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xff9E9E9E),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
