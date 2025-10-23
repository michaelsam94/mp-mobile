import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mega_plus/core/helpers/addons_functions.dart';
import 'package:mega_plus/core/style/app_colors.dart';
import 'package:mega_plus/presentation/auth/resetPassword/set_new_password_screen.dart';
import 'package:mega_plus/presentation/main/main_screen.dart';

import '../completeProfile/complete_profile_screen.dart';

class OTPVerificationScreen extends StatefulWidget {
  final String? phone;
  final String? email;
  final bool resetPassword;
  final bool signUp;
  const OTPVerificationScreen({
    super.key,
    this.phone,
    this.email,
    this.resetPassword = false,
    this.signUp = false,
  });

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  // One controller for each field
  final List<TextEditingController> controllers = List.generate(
    5,
    (_) => TextEditingController(),
  );
  final List<FocusNode> focusNodes = List.generate(5, (_) => FocusNode());

  int resendSeconds = 60;

  @override
  void initState() {
    super.initState();
    startResendTimer();
  }

  void startResendTimer() {
    Future.delayed(Duration(seconds: 1), () {
      if (resendSeconds > 0) {
        setState(() {
          resendSeconds--;
        });
        startResendTimer();
      }
    });
  }

  bool get isOtpComplete =>
      controllers.every((controller) => controller.text.length == 1);

  void handleInputChange(int index, String value) {
    // Only accept one character per box, then jump to next
    if (value.isNotEmpty) {
      controllers[index].text = value[value.length - 1];
      if (index < 4) FocusScope.of(context).requestFocus(focusNodes[index + 1]);
    }
    // If cleared, move focus back
    if (value.isEmpty && index > 0) {
      FocusScope.of(context).requestFocus(focusNodes[index - 1]);
    }
    setState(() {});
  }

  @override
  void dispose() {
    controllers.forEach((c) => c.dispose());
    focusNodes.forEach((f) => f.dispose());
    super.dispose();
  }

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
                'OTP code verification',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: Color(0xff121212),
                ),
              ),
              SizedBox(height: 16),
              Text(
                "We've sent a 6-digit code to your ${widget.phone != null ? "mobile\nnumber +20 XXXXX X${widget.phone?.substring(8)}" : "email \n ${widget.email?.substring(0, 2)}XXXXXXX${widget.email![widget.email!.length - 3]}${widget.email![widget.email!.length - 2]}${widget.email![widget.email!.length - 1]}"} ",
                style: TextStyle(fontSize: 16, color: Color(0xff606060)),
              ),
              SizedBox(height: 40),
              // OTP fields
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (i) {
                  return Expanded(
                    child: Container(
                      width: 62,
                      height: 56,
                      margin: EdgeInsets.symmetric(horizontal: 4),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                        color: controllers[i].text.isNotEmpty
                            ? Color(0xFFB2ECCA)
                            : Colors.transparent,
                      ),
                      child: TextField(
                        controller: controllers[i],
                        focusNode: focusNodes[i],
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        maxLength: 1,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff121212),
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          counterText: "",
                          hintText: '',
                          hintStyle: TextStyle(
                            fontSize: 24,
                            color: Color(0xffDCDCDC),
                          ),
                        ),
                        onChanged: (value) => handleInputChange(i, value),
                      ),
                    ),
                  );
                }),
              ),
              SizedBox(height: 28),
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
                  onPressed: isOtpComplete
                      ? () {
                          if (widget.resetPassword) {
                            // Reset Password
                            context.goTo(SetNewPasswordScreen());
                          } else if (widget.signUp) {
                            // continue Profile
                            context.goTo(CompleteProfileScreen());
                          } else {
                            // login
                            context.goOffAll(MainScreen());
                          }
                        }
                      : null,
                  child: Text(
                    'Continue',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Center(
                child: RichText(
                  text: TextSpan(
                    text: "You can resend code in ",
                    style: TextStyle(color: Color(0xff606060), fontSize: 15),
                    children: [
                      TextSpan(
                        text: "${resendSeconds}s",
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
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
