import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mega_plus/core/helpers/addons_functions.dart';
import 'package:mega_plus/core/style/app_colors.dart';
import 'package:mega_plus/presentation/auth/forgetPassword/forget_password_screen.dart';
import 'package:mega_plus/presentation/auth/login/cubit/login_cubit.dart';
import 'package:mega_plus/presentation/auth/signup/sign_up_screen.dart';
import 'package:mega_plus/presentation/main/main_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: LoginScreenUI(),
    );
  }
}

class LoginScreenUI extends StatefulWidget {
  const LoginScreenUI({super.key});

  @override
  State<LoginScreenUI> createState() => _LoginScreenUIState();
}

class _LoginScreenUIState extends State<LoginScreenUI> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    final cubit = LoginCubit.get(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16),
                  SizedBox(height: 12),
                  Image.asset(
                    "assets/icons/ic_black_word.png",
                    width: 400,
                    height: 50,
                  ),
                  SizedBox(height: 30),
                  Text(
                    'Welcome! ',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff121212),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Welcome to Mega Plug charging journey.',
                    style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                  ),
                  SizedBox(height: 40),

                  // Email / Phone
                  Text(
                    'Phone / E-mail',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: Color(0xff121212),
                    ),
                  ),
                  SizedBox(height: 8),

                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: 'Phone or e-mail',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(11),
                        borderSide: const BorderSide(color: Colors.black12),
                      ),
                      fillColor: Color(0xffFBFBFB),
                      filled: true,
                    ),
                    validator: (value) {
                      final text = value?.trim() ?? '';
                      if (text.isEmpty) {
                        return 'Please enter your phone or email';
                      }
                      if (text.contains('@')) {
                        // Email validation
                        final emailRegex = RegExp(
                          r'^[\w\.\-]+@([\w\-]+\.)+[a-zA-Z]{2,4}$',
                        );
                        if (!emailRegex.hasMatch(text)) {
                          return 'Please enter a valid email';
                        }
                      } else {
                        // Phone number validation
                        // Remove any non-digit characters for validation
                        final digitsOnly = text.replaceAll(RegExp(r'[^\d]'), '');
                        
                        // Check if it's exactly 11 digits
                        if (digitsOnly.length != 11) {
                          return 'Enter valid number';
                        }
                        
                        // Check if it starts with 010, 012, 015, or 011
                        final validPrefixes = ['010', '012', '015', '011'];
                        final prefix = digitsOnly.substring(0, 3);
                        if (!validPrefixes.contains(prefix)) {
                          return 'Enter valid number';
                        }
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: 16),

                  // Password
                  Text(
                    'Password',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: Color(0xff121212),
                    ),
                  ),
                  SizedBox(height: 8),

                  TextFormField(
                    controller: passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      hintText: 'xxxxxxxxxxx',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(11),
                        borderSide: const BorderSide(color: Colors.black12),
                      ),
                      fillColor: Color(0xffFBFBFB),
                      filled: true,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      final text = value ?? '';
                      if (text.isEmpty) {
                        return 'Please enter your password';
                      }
                      if (text.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),

                  // باقي الكود كما هو...
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          context.goTo(ForgetPasswordScreen());
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Color(0xff121212)),
                            ),
                          ),
                          child: Text(
                            "Forget Password?",
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xff121212),
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.end,
                          ),
                        ),
                      ),
                    ],
                  ),
                  BlocBuilder<LoginCubit, LoginState>(
                    builder: (context, state) {
                      return InkWell(
                        onTap: () {
                          cubit.changeChecked();
                        },
                        child: Row(
                          children: [
                            Checkbox(
                              value: cubit.checked,
                              onChanged: (_) {
                                cubit.changeChecked();
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadiusGeometry.circular(4),
                              ),
                            ),
                            Text(
                              "Remember me",
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xff121212),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 32),
                  // Sign in button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: BlocConsumer<LoginCubit, LoginState>(
                      listener: (context, state) {
                        if (state is ErrorLoginState) {
                          context.showErrorMessage(state.message);
                        } else if (state is SuccessLoginState) {
                          context.showSuccessMessage("Login Successfully");
                          context.goOffAll(MainScreen());
                        }
                      },
                      builder: (context, state) {
                        if (state is LoadingLoginState) {
                          return Center(child: CircularProgressIndicator());
                        }
                        return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              cubit.login(
                                emailController.text,
                                passwordController.text,
                              );
                            }

                            // context.goTo(
                            //   OTPVerificationScreen(email: emailController.text),
                            // );
                          },
                          child: Text(
                            "Sign in",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 16),
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
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MainScreen(),
                          ),
                          (route) => false,
                        );
                      },
                    ),
                  ),

                  Row(
                    children: [
                      Expanded(child: Divider(color: Color(0xffE7E7E7))),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          "Or",
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xff606060),
                          ),
                        ),
                      ),
                      Expanded(child: Divider(color: Color(0xffE7E7E7))),
                    ],
                  ),

                  Center(
                    child: TextButton(
                      child: Text(
                        "Sign up",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      onPressed: () {
                        context.goTo(SignUpScreen());
                      },
                    ),
                  ),

                  SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
