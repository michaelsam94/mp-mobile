import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mega_plus/core/helpers/addons_functions.dart';
import 'package:mega_plus/core/style/app_colors.dart';
import 'package:mega_plus/core/widgets/shimmer_widget.dart';
import 'package:mega_plus/l10n/app_localizations.dart';
import 'package:mega_plus/presentation/auth/completeProfile/complete_profile_screen.dart';
import 'package:mega_plus/presentation/auth/resetPassword/set_new_password_screen.dart';
import 'package:mega_plus/presentation/auth/signup/cubit/sign_up_cubit.dart';

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
  static const int _otpLength = 5;

  final List<TextEditingController> controllers =
      List.generate(_otpLength, (_) => TextEditingController());
  final List<FocusNode> focusNodes =
      List.generate(_otpLength, (_) => FocusNode());

  String _phoneLastDigits() {
    final p = widget.phone;
    if (p == null || p.isEmpty) return '';
    return p.length >= 3 ? p.substring(p.length - 3) : p;
  }

  String _maskedEmail() {
    final e = widget.email;
    if (e == null || e.isEmpty) return '';
    final prefix = e.length >= 2 ? e.substring(0, 2) : e;
    final suffix = e.length >= 3 ? e.substring(e.length - 3) : '';
    return '${prefix}XXXXXXX$suffix';
  }

  @override
  void initState() {
    super.initState();
    _startResendTimer();
  }

  void _startResendTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      if (SignUpCubit.get(context).resendSeconds > 0) {
        setState(() => SignUpCubit.get(context).resendSeconds--);
        _startResendTimer();
      }
    });
  }

  bool get _isOtpComplete =>
      controllers.every((c) => c.text.length == 1);

  void _handleInputChange(int index, String value) {
    if (value.isNotEmpty) {
      controllers[index].text = value[value.length - 1];
      if (index < _otpLength - 1) {
        FocusScope.of(context).requestFocus(focusNodes[index + 1]);
      }
    } else if (index > 0) {
      FocusScope.of(context).requestFocus(focusNodes[index - 1]);
    }
    setState(() {});
  }

  @override
  void dispose() {
    for (final c in controllers) { c.dispose(); }
    for (final f in focusNodes) { f.dispose(); }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocConsumer<SignUpCubit, SignUpState>(
      listener: (context, state) {
        if (state is ErrorVerifyOTPSignUpState) {
          context.showErrorMessage(state.message);
        } else if (state is SuccessVerifyOTPSignUpState) {
          context.showSuccessMessage(l10n.otpVerifiedSuccess);
          if (widget.signUp) {
            context.goTo(CompleteProfileScreen());
          } else {
            context.goTo(SetNewPasswordScreen());
          }
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: state is LoadingSignUpState
                ? Center(
                    child: ShimmerWidget(
                      width: 50,
                      height: 50,
                      borderRadius: BorderRadius.circular(25),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
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
                        const SizedBox(height: 16),
                        Text(
                          l10n.otpVerificationTitle,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: Color(0xff121212),
                          ),
                          textAlign: TextAlign.start,
                        ),
                        const SizedBox(height: 12),
                        // Subtitle (localized; follows app text direction)
                        Text(
                          widget.phone != null
                              ? l10n.otpSentToPhone(_phoneLastDigits())
                              : l10n.otpSentToEmail(_maskedEmail()),
                          style: const TextStyle(
                            fontSize: 15,
                            color: Color(0xff606060),
                          ),
                          textAlign: TextAlign.start,
                        ),
                        const SizedBox(height: 36),
                        // OTP boxes: always LTR so digits flow left → right
                        Directionality(
                          textDirection: TextDirection.ltr,
                          child: Row(
                            children: List.generate(_otpLength, (i) {
                              return Expanded(
                                child: Container(
                                  height: 60,
                                  margin: EdgeInsetsDirectional.only(
                                    end: i < _otpLength - 1 ? 10 : 0,
                                  ),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.grey.shade300,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                    color: controllers[i].text.isNotEmpty
                                        ? const Color(0xFFB2ECCA)
                                        : Colors.transparent,
                                  ),
                                  child: TextField(
                                    controller: controllers[i],
                                    focusNode: focusNodes[i],
                                    textDirection: TextDirection.ltr,
                                    textAlign: TextAlign.center,
                                    keyboardType: TextInputType.number,
                                    maxLength: 1,
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xff121212),
                                    ),
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      errorBorder: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      disabledBorder: InputBorder.none,
                                      focusedErrorBorder: InputBorder.none,
                                      counterText: "",
                                    ),
                                    onChanged: (v) => _handleInputChange(i, v),
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),
                        const SizedBox(height: 28),
                        // Continue button
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: _isOtpComplete
                                ? () {
                                    final code =
                                        controllers.map((c) => c.text).join();
                                    SignUpCubit.get(context).verifyCode(code);
                                  }
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
                        const SizedBox(height: 16),
                        // Resend timer / resend link
                        Center(
                          child: SignUpCubit.get(context).resendSeconds == 0
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      l10n.resendCodeNow,
                                      style: const TextStyle(
                                        color: Color(0xff606060),
                                        fontSize: 15,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        if (widget.resetPassword) {
                                          SignUpCubit.get(context)
                                              .forgetPassword(
                                                  widget.phone ?? "");
                                        } else {
                                          SignUpCubit.get(context)
                                              .sendOTP(widget.phone ?? "");
                                        }
                                      },
                                      child: Text(
                                        l10n.resend,
                                        style: TextStyle(
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.w600,
                                          decoration:
                                              TextDecoration.underline,
                                          decorationColor: AppColors.primary,
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        l10n.resendCodeIn,
                                        style: const TextStyle(
                                          color: Color(0xff606060),
                                          fontSize: 15,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Directionality(
                                      textDirection: TextDirection.ltr,
                                      child: Text(
                                        "${SignUpCubit.get(context).resendSeconds}s",
                                        style: TextStyle(
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ],
                    ),
                  ),
          ),
        );
      },
    );
  }
}
