import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mega_plus/core/helpers/addons_functions.dart';
import 'package:mega_plus/core/style/app_colors.dart';
import 'package:mega_plus/l10n/app_localizations.dart';
import 'package:mega_plus/presentation/auth/login/login_screen.dart';
import 'package:mega_plus/presentation/auth/signup/cubit/sign_up_cubit.dart';

class SetNewPasswordScreen extends StatefulWidget {
  const SetNewPasswordScreen({super.key});

  @override
  State<SetNewPasswordScreen> createState() => _SetNewPasswordScreenState();
}

class _SetNewPasswordScreenState extends State<SetNewPasswordScreen> {
  final controller = TextEditingController();
  final confirmController = TextEditingController();

  final _globalKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: BlocConsumer<SignUpCubit, SignUpState>(
        listener: (context, state) {
          if (state is SuccessChangePasswordState) {
            context.showSuccessMessage(l10n.passwordChangedSuccessfully);
            context.goOffAll(LoginScreen());
          } else if (state is ErrorChangePasswordState) {
            context.showErrorMessage(state.message);
          }
        },
        builder: (context, state) {
          if (state is LoadingChangePasswordState) {
            return Center(child: CircularProgressIndicator());
          }
          return SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Form(
                  key: _globalKey,
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
                      l10n.setNewPassword,
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        color: Color(0xff121212),
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      l10n.createStrongPassword,
                      style: TextStyle(fontSize: 16, color: Color(0xff606060)),
                    ),
                    SizedBox(height: 40),

                    Text(
                      l10n.createPassword,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: Color(0xff121212),
                      ),
                    ),
                    SizedBox(height: 8),

                    TextFormField(
                      controller: controller,
                      keyboardType: TextInputType.text,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        hintText: l10n.password,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(11),
                          borderSide: const BorderSide(color: Colors.black12),
                        ),
                        fillColor: Color(0xffFBFBFB),
                        filled: true,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() { _obscurePassword = !_obscurePassword; });
                          },
                        ),
                      ),
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) return l10n.pleaseEnterPassword;
                        if (val.length < 8) return l10n.enterValidPassword;
                        return null;
                      },
                    ),

                    SizedBox(height: 16),

                    Text(
                      l10n.confirmPasswordLabel,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: Color(0xff121212),
                      ),
                    ),
                    SizedBox(height: 8),

                    TextFormField(
                      controller: confirmController,
                      keyboardType: TextInputType.text,
                      obscureText: _obscureConfirmPassword,
                      decoration: InputDecoration(
                        hintText: l10n.confirmPasswordLabel,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(11),
                          borderSide: const BorderSide(color: Colors.black12),
                        ),
                        fillColor: Color(0xffFBFBFB),
                        filled: true,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirmPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() { _obscureConfirmPassword = !_obscureConfirmPassword; });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) return l10n.pleaseEnterConfirmPassword;
                        if (value.length < 8) return l10n.pleaseEnterValidConfirmPassword;
                        if (value != controller.text) return l10n.passwordNotSame;
                        return null;
                      },
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
                          if (_globalKey.currentState!.validate()) {
                            SignUpCubit.get(context).resetPassword(controller.text);
                          }
                        },
                        child: Text(
                          l10n.continueText,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        );
        },
      ),
    );
  }
}
