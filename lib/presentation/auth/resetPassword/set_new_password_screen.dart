import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mega_plus/core/helpers/addons_functions.dart';
import 'package:mega_plus/core/style/app_colors.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<SignUpCubit, SignUpState>(
        listener: (context, state) {
          if (state is SuccessChangePasswordState) {
            context.showSuccessMessage("Password Changed Successfully");
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
                      'Set New Password',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        color: Color(0xff121212),
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      "Create a strong password to secure your account.",
                      style: TextStyle(fontSize: 16, color: Color(0xff606060)),
                    ),
                    SizedBox(height: 40),

                    Text(
                      'Create Password',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: Color(0xff121212),
                      ),
                    ),
                    SizedBox(height: 8),

                    TextFormField(
                      controller: controller,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(11),
                          borderSide: const BorderSide(color: Colors.black12),
                        ),
                        fillColor: Color(0xffFBFBFB),
                        filled: true,
                      ),
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) {
                          return 'Please enter your password';
                        }
                        if (val.length < 8) {
                          return 'Enter a valid password';
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: 16),

                    Text(
                      'Confirm Password',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: Color(0xff121212),
                      ),
                    ),
                    SizedBox(height: 8),

                    TextFormField(
                      controller: confirmController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        hintText: 'Confirm Password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(11),
                          borderSide: const BorderSide(color: Colors.black12),
                        ),
                        fillColor: Color(0xffFBFBFB),
                        filled: true,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please Enter Confirm Password";
                        } else if (value.length < 8) {
                          return "Please enter valid Confirm password";
                        } else if (value != controller.text) {
                          return "Password not same as confirm password";
                        }
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
                            SignUpCubit.get(
                              context,
                            ).changePassword(controller.text);
                          }
                        },
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
