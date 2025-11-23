import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mega_plus/core/helpers/addons_functions.dart';
import 'package:mega_plus/core/style/app_colors.dart';
import 'package:mega_plus/presentation/auth/otp/otp_screen.dart';
import 'package:mega_plus/presentation/auth/signup/cubit/sign_up_cubit.dart';


class SignUpScreen extends StatelessWidget {
  TextEditingController phoneController = TextEditingController();

  final List<Map<String, String>> countryList = [
    {'code': '+2', 'flag': '🇪🇬'},
  ];

  void _changeCountry(BuildContext context) async {
    // Popup menu for selecting country
    String? selectedCode = await showModalBottomSheet<String>(
      backgroundColor: Colors.white,
      context: context,
      builder: (context) {
        return ListView(
          children: countryList.map((country) {
            return ListTile(
              leading: Text(country['flag']!, style: TextStyle(fontSize: 28)),
              title: Text(country['code']!),
              onTap: () => Navigator.pop(context, country['code']),
            );
          }).toList(),
        );
      },
    );

    if (selectedCode != null) {
      SignUpCubit.get(context).changeCountryCode(selectedCode);
      // setState(() {
      //   countryCode = selectedCode;
      //   flag = countryList.firstWhere(
      //     (c) => c['code'] == selectedCode,
      //   )['flag']!;
      // });
    }
  }

  SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<SignUpCubit, SignUpState>(
        listener: (context, state) {
          if (state is ErrorSignUpState) {
            context.showErrorMessage(state.message);
          } else if (state is SuccessSignUpState) {
            context.showSuccessMessage("OTP Sent Successfully");
            context.goTo(
              OTPVerificationScreen(phone: phoneController.text, signUp: true),
            );
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 16),
                    // Back button
                    IconButton(
                      icon: SvgPicture.asset("assets/icons/back.svg"),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    SizedBox(height: 12),
                    // Title and emoji
                    Row(
                      children: [
                        Text(
                          'Hello there',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff121212),
                          ),
                        ),
                        SizedBox(width: 4),
                        Text('👋', style: TextStyle(fontSize: 26)),
                      ],
                    ),
                    SizedBox(height: 16),
                    // Subtitle
                    Text(
                      'Enter your phone number and we’ll send you an OTP code to verify your account.',
                      style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                    ),
                    SizedBox(height: 40),
                    Text(
                      'Enter Your Mobile Number',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: Color(0xff121212),
                      ),
                    ),
                    SizedBox(height: 8),

                    // Phone input field
                    Row(
                      spacing: 8,
                      children: [
                        Container(
                          height: 56,
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Color(0xffFBFBFB),
                            border: Border.all(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: GestureDetector(
                            onTap: () {
                              _changeCountry(context);
                            },
                            child: Row(
                              children: [
                                Text(
                                  SignUpCubit.get(context).countryCode,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xff212427),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Icon(Icons.arrow_drop_down, size: 24),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 56,
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[300]!),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                Image.asset(
                                  "assets/images/eg_flag.png",
                                  width: 24,
                                  height: 24,
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: TextField(
                                    onChanged: (value) {
                                      if (value.isNotEmpty) {
                                        SignUpCubit.get(
                                          context,
                                        ).changeConWord(true);
                                      } else {
                                        SignUpCubit.get(
                                          context,
                                        ).changeConWord(false);
                                      }
                                    },
                                    controller: phoneController,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      errorBorder: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      disabledBorder: InputBorder.none,
                                      focusedErrorBorder: InputBorder.none,
                                      hintText: 'XXXXXXXXXX',
                                      hintStyle: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                        color: Color(0xffDCDCDC),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30),
                    // Sign up button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: state is LoadingSignUpState
                          ? Center(child: CircularProgressIndicator())
                          : ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: SignUpCubit.get(context).conWord
                                  ? () {
                                      SignUpCubit.get(
                                        context,
                                      ).sendOTP(phoneController.text);
                                    }
                                  : null,
                              child: Text(
                                SignUpCubit.get(context).conWord
                                    ? "Continue"
                                    : 'Sign up',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                    ),
                    SizedBox(height: 16),
                    // Continue as guest button
                    if (!SignUpCubit.get(context).conWord)
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Color(0xffE6F9EE),
                            side: BorderSide(color: AppColors.primary),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            'Continue as a guest',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          onPressed: () {},
                        ),
                      ),
                    SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
