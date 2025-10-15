import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mega_plus/core/helpers/addons_functions.dart';

import '../../core/style/app_colors.dart';
import '../onboarding/onboarding_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 2), () {
      if (context.mounted) context.goOff(OnboardingScreen());
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
                child: SvgPicture.asset("assets/icons/icon_black_word.svg"),
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
