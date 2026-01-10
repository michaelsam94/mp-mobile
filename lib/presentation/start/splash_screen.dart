import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mega_plus/core/helpers/addons_functions.dart';
import 'package:mega_plus/core/helpers/cache/cache_helper.dart';
import 'package:mega_plus/core/helpers/cache/cache_keys.dart';
import 'package:mega_plus/core/helpers/network/dio_helper.dart';
import 'package:mega_plus/presentation/auth/login/login_screen.dart';
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
        // Check if user chose "Remember Me"
        final rememberMe = CacheHelper.getBool(CacheKeys.rememberMe.name) ?? false;

        // If user is logged in but didn't check "Remember Me", force logout
        if (!rememberMe && CacheHelper.checkLogin() != 1) {
          await CacheHelper.logout();
          // Go to login or onboarding based on onboarding status
          if (!CacheHelper.isOnboardingCompleted()) {
            if (context.mounted) {
              context.goOff(
                BlocProvider(
                  create: (context) => OnBoardingCubit(),
                  child: OnboardingScreen(),
                ),
              );
            }
          } else {
            if (context.mounted) context.goOff(LoginScreen());
          }
          return;
        }

        switch (CacheHelper.checkLogin()) {
          case 1:
            // Check if onboarding has been completed
            // Only show onboarding on first install
            if (!CacheHelper.isOnboardingCompleted()) {
              // First time - show onboarding
              context.goOff(
                BlocProvider(
                  create: (context) => OnBoardingCubit(),
                  child: OnboardingScreen(),
                ),
              );
            } else {
              // Onboarding already completed - go to login
              context.goOff(LoginScreen());
            }
            break;
          case 2:
            bool refreshed = await DioHelper.refreshToken();
            if (refreshed) {
              if (context.mounted) context.goOff(MainScreen());
            } else {
              await CacheHelper.logout();
              if (context.mounted) context.goOff(LoginScreen());
            }
            break;
          case 3:
            if (context.mounted) context.goOff(MainScreen());
            break;
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
                child: CircularProgressIndicator(
                  strokeWidth: 7,
                  strokeCap: StrokeCap.round,
                  backgroundColor: AppColors.primary.withValues(alpha: .2),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
