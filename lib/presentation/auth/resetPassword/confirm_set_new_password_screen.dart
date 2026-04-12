import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mega_plus/core/helpers/addons_functions.dart';
import 'package:mega_plus/core/style/app_colors.dart';
import 'package:mega_plus/l10n/app_localizations.dart';
import 'package:mega_plus/presentation/start/splash_screen.dart';

class ConfirmSetNewPasswordScreen extends StatefulWidget {
  const ConfirmSetNewPasswordScreen({super.key});

  @override
  State<ConfirmSetNewPasswordScreen> createState() =>
      _ConfirmSetNewPasswordScreenState();
}

class _ConfirmSetNewPasswordScreenState
    extends State<ConfirmSetNewPasswordScreen> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16),
              IconButton(
                icon: SvgPicture.asset("assets/icons/back.svg"),
                onPressed: () => Navigator.pop(context),
              ),
              SizedBox(height: 32),
              Text(
                AppLocalizations.of(context)!.confirmPasswordLabel,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: Color(0xff121212),
                ),
              ),
              SizedBox(height: 16),
              Text(
                AppLocalizations.of(context)!.createStrongPassword,
                style: TextStyle(fontSize: 16, color: Color(0xff606060)),
              ),
              SizedBox(height: 40),

              Text(
                AppLocalizations.of(context)!.confirmPasswordLabel,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: Color(0xff121212),
                ),
              ),
              SizedBox(height: 8),

              Container(
                height: 48,
                width: context.width(),
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Color(0xffEFF0F6)),
                ),
                child: TextField(
                  controller: controller,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    errorBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    focusedErrorBorder: InputBorder.none,
                    hintText: 'xxxxxxxxxxx',
                    hintStyle: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: Color(0xffDCDCDC),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    context.goOffAll(SplashScreen());
                  },
                  child: Text(
                    AppLocalizations.of(context)!.continueText,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
