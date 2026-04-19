import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mega_plus/core/helpers/addons_functions.dart';
import 'package:mega_plus/core/helpers/egypt_phone_validator.dart';
import 'package:mega_plus/core/style/app_colors.dart';
import 'package:mega_plus/l10n/app_localizations.dart';
import 'package:mega_plus/presentation/auth/otp/otp_screen.dart';
import 'package:mega_plus/presentation/auth/signup/cubit/sign_up_cubit.dart';
import 'package:mega_plus/core/widgets/phone_input_row.dart';
import 'package:mega_plus/presentation/main/main_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController phoneController = TextEditingController();

  final List<Map<String, String>> countryList = [
    {'code': '+20', 'flag': '🇪🇬'},
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      SignUpCubit.get(context).changeConWord(
        EgyptPhoneValidator.isValidLocal11Digits(phoneController.text),
      );
    });
  }

  void _changeCountry(BuildContext context) async {
    String? selectedCode = await showModalBottomSheet<String>(
      backgroundColor: Colors.white,
      context: context,
      builder: (ctx) {
        return ListView(
          children: countryList.map((country) {
            return ListTile(
              leading: Text(country['flag']!, style: const TextStyle(fontSize: 28)),
              title: Text(country['code']!),
              onTap: () => Navigator.pop(ctx, country['code']),
            );
          }).toList(),
        );
      },
    );
    if (selectedCode != null && context.mounted) {
      SignUpCubit.get(context).changeCountryCode(selectedCode);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocConsumer<SignUpCubit, SignUpState>(
        listener: (context, state) {
          if (state is ErrorSignUpState) {
            context.showErrorMessage(state.message);
          } else if (state is SuccessSignUpState) {
            context.showSuccessMessage(l10n.otpSentSuccess);
            context.goTo(
              OTPVerificationScreen(phone: phoneController.text, signUp: true),
            );
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    // Back button
                    IconButton(
                      padding: EdgeInsets.zero,
                      icon: SvgPicture.asset("assets/icons/back.svg"),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(height: 24),
                    // MegaPlug Logo
                    Image.asset(
                      "assets/images/logo.png",
                      height: 36,
                    ),
                    const SizedBox(height: 24),
                    // Subtitle
                    Text(
                      l10n.signUpSubtitle,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 32),
                    // Label
                    Text(
                      l10n.enterMobileNumber,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: Color(0xff121212),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Phone input
                    PhoneInputRow(
                      controller: phoneController,
                      countryCode: SignUpCubit.get(context).countryCode,
                      onCountryTap: () => _changeCountry(context),
                      onChanged: (v) => SignUpCubit.get(context).changeConWord(
                            EgyptPhoneValidator.isValidLocal11Digits(v),
                          ),
                    ),
                    const SizedBox(height: 28),
                    // Sign up button
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: state is LoadingSignUpState
                          ? const Center(child: CircularProgressIndicator())
                          : ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: SignUpCubit.get(context).conWord
                                  ? () => SignUpCubit.get(context)
                                      .sendOTP(phoneController.text)
                                  : null,
                              child: Text(
                                SignUpCubit.get(context).conWord
                                    ? l10n.continueText
                                    : l10n.signUp,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                    ),
                    const SizedBox(height: 12),
                    // Continue as guest
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          backgroundColor: const Color(0xffE6F9EE),
                          side: BorderSide(color: AppColors.primary),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const MainScreen(),
                            ),
                            (route) => false,
                          );
                        },
                        child: Text(
                          l10n.continueAsGuest,
                          style: TextStyle(
                            fontSize: 15,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
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

