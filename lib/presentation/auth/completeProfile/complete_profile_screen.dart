import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mega_plus/core/helpers/addons_functions.dart';
import 'package:mega_plus/core/style/app_colors.dart';
import 'package:mega_plus/core/widgets/shimmer_widget.dart';
import 'package:mega_plus/l10n/app_localizations.dart';
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
  bool _obscurePassword = true;

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() { _imageFile = File(pickedFile.path); });
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      SignUpCubit.get(context).createAccount(
        _emailController.text,
        _nameController.text,
        _passwordController.text,
        imageFile: _imageFile,
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
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocConsumer<SignUpCubit, SignUpState>(
        listener: (context, state) {
          if (state is SuccessCreateAccountState) {
            context.showSuccessMessage(l10n.createdAccountSuccessfully);
            context.goTo(PersonalizeProfileScreen());
          } else if (state is ErrorCreateAccountState) {
            context.showErrorMessage(state.message);
          }
        },
        builder: (context, state) {
          if (state is LoadingCreateAccountState) {
            return Center(
              child: ShimmerWidget(
                width: 50,
                height: 50,
                borderRadius: BorderRadius.circular(25),
              ),
            );
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
                    onPressed: () { Navigator.pop(context); },
                  ),
                  const SizedBox(height: 10),
                  Text(
                    l10n.completeProfile,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 32,
                      color: Color(0xff121212),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.profileDataProtected,
                    style: const TextStyle(
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
                            child: SvgPicture.asset("assets/icons/edit_image.svg"),
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
                        Text(
                          l10n.fullName,
                          style: const TextStyle(
                            color: Color(0xff121212),
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            hintText: l10n.fullNameHint,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(11),
                              borderSide: const BorderSide(color: Colors.black12),
                            ),
                            fillColor: Color(0xffFBFBFB),
                            filled: true,
                          ),
                          validator: (val) =>
                              (val == null || val.trim().isEmpty) ? l10n.pleaseEnterFullName : null,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          l10n.email,
                          style: const TextStyle(
                            color: Color(0xff121212),
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            hintText: l10n.emailHint,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(11),
                              borderSide: const BorderSide(color: Colors.black12),
                            ),
                            fillColor: Color(0xffFBFBFB),
                            filled: true,
                          ),
                          validator: (val) {
                            if (val == null || val.isEmpty) return l10n.pleaseEnterEmail;
                            final emailRegex = RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                            );
                            if (!emailRegex.hasMatch(val)) return l10n.enterValidEmail;
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        Text(
                          l10n.password,
                          style: const TextStyle(
                            color: Color(0xff121212),
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          keyboardType: TextInputType.text,
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
                                _obscurePassword ? Icons.visibility_off : Icons.visibility,
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                setState(() { _obscurePassword = !_obscurePassword; });
                              },
                            ),
                          ),
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) return l10n.pleaseEnterPassword;
                            if (val.length < 6) return l10n.passwordMustBe6Digits;
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
                            child: Text(
                              l10n.continueText,
                              style: const TextStyle(
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
