import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mega_plus/core/helpers/addons_functions.dart';
import 'package:mega_plus/core/helpers/cache/cache_helper.dart';
import 'package:mega_plus/l10n/app_localizations.dart';
import 'package:mega_plus/presentation/profile/cubit/profile_cubit.dart';
import 'package:mega_plus/presentation/start/splash_screen.dart';

class DeleteAccountPasswordScreen extends StatefulWidget {
  final String reason;

  const DeleteAccountPasswordScreen({super.key, required this.reason});

  @override
  State<DeleteAccountPasswordScreen> createState() =>
      _DeleteAccountPasswordScreenState();
}

class _DeleteAccountPasswordScreenState
    extends State<DeleteAccountPasswordScreen> {
  final TextEditingController passwordController = TextEditingController();
  bool obscurePassword = true;

  @override
  void dispose() {
    passwordController.dispose();
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
          AppLocalizations.of(context)!.deleteAccountTitle,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF212121),
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        AppLocalizations.of(context)!.enterYourPassword,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF212121),
                        ),
                      ),
                      SizedBox(height: 16),

                      // Description
                      Text(
                        AppLocalizations.of(context)!.deleteAccountPasswordDesc,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF757575),
                          height: 1.5,
                        ),
                      ),
                      SizedBox(height: 32),

                      // Password Label
                      Text(
                        AppLocalizations.of(context)!.password,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF212121),
                        ),
                      ),
                      SizedBox(height: 8),

                      // Password Field
                      Container(
                        height: 56,
                        decoration: BoxDecoration(
                          color: Color(0xFFF5F5F5),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Color(0xFFE0E0E0), width: 1),
                        ),
                        child: TextField(
                          controller: passwordController,
                          obscureText: obscurePassword,
                          style: TextStyle(fontSize: 14, color: Color(0xFF212121)),
                          decoration: InputDecoration(
                            hintText: '••••••••••••',
                            hintStyle: TextStyle(
                              fontSize: 14,
                              color: Color(0xFFBDBDBD),
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  obscurePassword = !obscurePassword;
                                });
                              },
                              icon: Icon(
                                obscurePassword
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: Color(0xFFBDBDBD),
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 24),

              // Delete Account Button
              BlocConsumer<ProfileCubit, ProfileState>(
                listener: (context, state) async {
                  if (state is SuccessLogoutProfileState) {
                    await CacheHelper.logout();
                    if (context.mounted) {
                      context.showSuccessMessage(
                        AppLocalizations.of(context)!.accountDeletedSuccessfully,
                      );
                      context.goOffAll(SplashScreen());
                    }
                  }
                },
                builder: (context, state) {
                  if (state is LoadingLogoutProfileState) {
                    return Center(child: CircularProgressIndicator());
                  }
                  return SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        if (passwordController.text.isEmpty) {
                          context.showErrorMessage(
                            AppLocalizations.of(context)!.pleaseEnterOldPassword,
                          );
                          return;
                        }

                        // Show confirmation dialog
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text(AppLocalizations.of(context)!.deleteAccountTitle),
                            content: Text(AppLocalizations.of(context)!.areYouSureDeleteAccount),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text(AppLocalizations.of(context)!.cancel),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  ProfileCubit.get(context).deleteAccount(widget.reason);
                                },
                                child: Text(
                                  AppLocalizations.of(context)!.delete,
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFB71C1C),
                        disabledBackgroundColor: Colors.grey[300],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.deleteAccountTitle,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
