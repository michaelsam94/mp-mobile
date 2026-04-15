import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mega_plus/core/helpers/addons_functions.dart';
import 'package:mega_plus/core/style/app_colors.dart';
import 'package:mega_plus/l10n/app_localizations.dart';
import 'package:mega_plus/presentation/auth/otp/otp_screen.dart';
import 'package:mega_plus/core/widgets/phone_input_row.dart';
import 'package:mega_plus/presentation/auth/signup/cubit/sign_up_cubit.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final TextEditingController phoneController = TextEditingController();
  bool rememberMe = true;

  final List<Map<String, String>> countryList = [
    {'code': '+20', 'flag': '🇪🇬'},
  ];

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
              OTPVerificationScreen(
                phone: phoneController.text,
                signUp: false,
                resetPassword: true,
              ),
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
                    const SizedBox(height: 28),
                    // Title
                    Text(
                      l10n.forgotPasswordTitle,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff121212),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Subtitle
                    Text(
                      l10n.forgotPasswordSubtitle,
                      style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 28),
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
                      onChanged: (v) =>
                          SignUpCubit.get(context).changeConWord(v.isNotEmpty),
                    ),
                    const SizedBox(height: 12),
                    // Remember me
                    Row(
                      children: [
                        SizedBox(
                          width: 24,
                          height: 24,
                          child: Checkbox(
                            value: rememberMe,
                            activeColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            onChanged: (val) =>
                                setState(() => rememberMe = val ?? false),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          l10n.rememberMe,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xff121212),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Continue button
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
                                      .forgetPassword(phoneController.text)
                                  : null,
                              child: Text(
                                l10n.continueText,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                    ),
                    const SizedBox(height: 32),
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
