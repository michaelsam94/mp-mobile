import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mega_plus/core/helpers/addons_functions.dart';
import 'package:mega_plus/core/style/app_colors.dart';
import 'package:mega_plus/presentation/profile/cubit/profile_cubit.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool obscureOldPassword = true;
  bool obscureNewPassword = true;
  bool obscureConfirmPassword = true;

  @override
  void dispose() {
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Color(0xFF212121),
            size: 20,
          ),
        ),
        title: Text(
          'Change password',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF212121),
          ),
        ),
        centerTitle: true,
      ),
      body: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is SuccessChangePasswordState) {
            context.showSuccessMessage("Password changed successfully");
            Navigator.pop(context);
          } else if (state is ErrorChangePasswordState) {
            context.showErrorMessage(
              state.message ?? "Failed to change password",
            );
          }
        },
        builder: (context, state) {
          bool isLoading = state is LoadingChangePasswordState;

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    'Change password',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF212121),
                    ),
                  ),
                  SizedBox(height: 8),

                  // Description
                  Text(
                    'Create a strong password to secure your account.',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF757575),
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: 32),

                  // Enter old password
                  Text(
                    'Enter old password',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF212121),
                    ),
                  ),
                  SizedBox(height: 8),
                  _buildPasswordField(
                    controller: oldPasswordController,
                    obscureText: obscureOldPassword,
                    onToggle: () {
                      setState(() {
                        obscureOldPassword = !obscureOldPassword;
                      });
                    },
                  ),
                  SizedBox(height: 20),

                  // Create Password
                  Text(
                    'Create Password',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF212121),
                    ),
                  ),
                  SizedBox(height: 8),
                  _buildPasswordField(
                    controller: newPasswordController,
                    obscureText: obscureNewPassword,
                    onToggle: () {
                      setState(() {
                        obscureNewPassword = !obscureNewPassword;
                      });
                    },
                  ),
                  SizedBox(height: 20),

                  // Confirm Password
                  Text(
                    'Confirm Password',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF212121),
                    ),
                  ),
                  SizedBox(height: 8),
                  _buildPasswordField(
                    controller: confirmPasswordController,
                    obscureText: obscureConfirmPassword,
                    onToggle: () {
                      setState(() {
                        obscureConfirmPassword = !obscureConfirmPassword;
                      });
                    },
                  ),
                  SizedBox(height: 40),

                  // Change Password Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: isLoading
                          ? null
                          : () {
                              // Validation
                              if (oldPasswordController.text.isEmpty) {
                                context.showErrorMessage(
                                  "Please enter your old password",
                                );
                                return;
                              }

                              if (newPasswordController.text.isEmpty) {
                                context.showErrorMessage(
                                  "Please enter new password",
                                );
                                return;
                              }

                              if (newPasswordController.text.length < 6) {
                                context.showErrorMessage(
                                  "Password must be at least 6 characters",
                                );
                                return;
                              }

                              if (newPasswordController.text !=
                                  confirmPasswordController.text) {
                                context.showErrorMessage(
                                  "Passwords do not match",
                                );
                                return;
                              }

                              // Call API
                              ProfileCubit.get(context).changePassword(
                                oldPassword: oldPasswordController.text,
                                newPassword: newPasswordController.text,
                                confirmationPassword: confirmPasswordController.text,
                              );
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        disabledBackgroundColor: Colors.grey[300],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: isLoading
                          ? SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation(
                                  Colors.white,
                                ),
                              ),
                            )
                          : Text(
                              'Change Password',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required bool obscureText,
    required VoidCallback onToggle,
  }) {
    return SizedBox(
      height: 56,

      child: TextField(
        controller: controller,
        obscureText: obscureText,
        style: TextStyle(fontSize: 14, color: Color(0xFF212121)),
        decoration: InputDecoration(
          hintText: '••••••••••••',
          hintStyle: TextStyle(fontSize: 14, color: Color(0xFFBDBDBD)),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          suffixIcon: IconButton(
            onPressed: onToggle,
            icon: Icon(
              obscureText
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: Color(0xFFBDBDBD),
              size: 20,
            ),
          ),
        ),
      ),
    );
  }
}
