import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mega_plus/core/helpers/addons_functions.dart';
import 'package:mega_plus/core/style/app_colors.dart';
import 'package:mega_plus/presentation/auth/signup/cubit/sign_up_cubit.dart';

import '../personalizeProfile/personalize_profile_screen.dart';

class CompleteProfileScreen extends StatefulWidget {
  const CompleteProfileScreen({super.key});

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  File? _imageFile;
  final _picker = ImagePicker();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      // Success: All data is valid
      // context.goTo(PersonalizeProfileScreen());
      SignUpCubit.get(context).createAccount(
        _emailController.text,
        _nameController.text,
        _passwordController.text,
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocConsumer<SignUpCubit, SignUpState>(
        listener: (context, state) {
          if (state is SuccessCreateAccountState) {
            context.showSuccessMessage("Created Account Successfully");
            context.goTo(PersonalizeProfileScreen());
          } else if (state is ErrorCreateAccountState) {
            context.showErrorMessage(state.message);
          }
        },
        builder: (context, state) {
          if (state is LoadingCreateAccountState) {
            return Center(child: CircularProgressIndicator());
          }
          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16),
                  IconButton(
                    icon: SvgPicture.asset("assets/icons/back.svg"),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Complete your profile',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 32,
                      color: Color(0xff121212),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Only you have access to your personal data,\nit’s fully protected.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xff606060),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Center(
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 54,
                          backgroundColor: Colors.grey[200],
                          backgroundImage: _imageFile != null
                              ? FileImage(_imageFile!)
                              : AssetImage("assets/images/user.png"),
                        ),
                        Positioned(
                          bottom: 10,
                          right: 0,
                          child: InkWell(
                            onTap: _pickImage,
                            child: SvgPicture.asset(
                              "assets/icons/edit_image.svg",
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Full Name',
                          style: TextStyle(
                            color: Color(0xff121212),
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            hintText: 'Full name',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(11),
                              borderSide: const BorderSide(
                                color: Colors.black12,
                              ),
                            ),
                            fillColor: Color(0xffFBFBFB),
                            filled: true,
                          ),
                          validator: (val) =>
                              (val == null || val.trim().isEmpty)
                              ? 'Please enter your full name'
                              : null,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Email',
                          style: TextStyle(
                            color: Color(0xff121212),
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            hintText: 'email',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(11),
                              borderSide: const BorderSide(
                                color: Colors.black12,
                              ),
                            ),
                            fillColor: Color(0xffFBFBFB),
                            filled: true,
                          ),
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return 'Please enter your email';
                            }
                            final emailRegex = RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                            );
                            if (!emailRegex.hasMatch(val)) {
                              return 'Enter a valid email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Password',
                          style: TextStyle(
                            color: Color(0xff121212),
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _passwordController,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            hintText: 'Password',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(11),
                              borderSide: const BorderSide(
                                color: Colors.black12,
                              ),
                            ),
                            fillColor: Color(0xffFBFBFB),
                            filled: true,
                          ),
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) {
                              return 'Please enter your password';
                            }
                            if (val.length < 6) {
                              return 'Enter a valid password';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 34),
                        SizedBox(
                          height: 52,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(11),
                              ),
                              elevation: 0,
                            ),
                            onPressed: _submit,
                            child: const Text(
                              'Continue',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
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
}
