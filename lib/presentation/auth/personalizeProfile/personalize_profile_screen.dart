import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mega_plus/core/helpers/addons_functions.dart';
import 'package:mega_plus/core/style/app_colors.dart';
import 'package:mega_plus/presentation/main/main_screen.dart';

import '../../vehicles/vehicle_setup_screen.dart';

class PersonalizeProfileScreen extends StatelessWidget {
  const PersonalizeProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                icon: SvgPicture.asset("assets/icons/back.svg"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 10),
              const Text(
                'Personalize your charging with your vehicle info',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 32,
                  color: Color(0xff121212),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Adding your car ensures accurate charging station recommendations.',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xff606060),
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 40),
              Image.asset("assets/images/personalize.png"),
              Spacer(),
              Row(
                spacing: 16,
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 52,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xffE6F9EE),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(11),
                            side: BorderSide(color: AppColors.primary),
                          ),
                          elevation: 0,
                        ),
                        onPressed: () {
                          context.goOffAll(MainScreen());
                        },
                        child: const Text(
                          'Add Later',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: SizedBox(
                      height: 52,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(11),
                          ),
                          elevation: 0,
                        ),
                        onPressed: () {
                          context.goTo(VehicleSetupScreen(isFromSignUp: true));
                        },
                        child: const Text(
                          'Add Vehicle',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
