import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mega_plus/core/helpers/addons_functions.dart';
import 'package:mega_plus/core/helpers/cache/cache_helper.dart';
import 'package:mega_plus/core/style/app_colors.dart';
import 'package:mega_plus/core/widgets/shimmer_widget.dart';
import 'package:mega_plus/l10n/app_localizations.dart';
import 'package:mega_plus/presentation/profile/cubit/profile_cubit.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  File? _imageFile;
  String? _cachedImageUrl;
  final _picker = ImagePicker();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _birthdayController = TextEditingController();
  String? _selectedGender;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    // Fetch latest profile data to ensure cache is up to date
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ProfileCubit.get(context).getProfile();
    });
  }

  void _loadUserData() {
    final userData = CacheHelper.getUserData()?.user;
    if (userData != null) {
      _nameController.text = userData.fullName ?? '';
      _emailController.text = userData.email ?? '';
      _birthdayController.text = userData.birthday ?? '';
      _selectedGender = userData.gender;
      // Load image from cache if available - use media_url (new format) or fallback to media array
      if (userData.mediaUrl != null && userData.mediaUrl!.isNotEmpty) {
        _cachedImageUrl = userData.mediaUrl;
      } else if (userData.media != null && userData.media!.isNotEmpty) {
        _cachedImageUrl = userData.media!.first;
      }
    }
  }

  ImageProvider _getProfileImage() {
    if (_imageFile != null) {
      return FileImage(_imageFile!);
    } else if (_cachedImageUrl != null && _cachedImageUrl!.isNotEmpty) {
      return NetworkImage(_cachedImageUrl!);
    }
    return AssetImage("assets/images/user.png");
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        // Format date as yyyy-MM-dd
        final year = picked.year.toString();
        final month = picked.month.toString().padLeft(2, '0');
        final day = picked.day.toString().padLeft(2, '0');
        _birthdayController.text = '$year-$month-$day';
      });
    }
  }

  void _submit() {
    final l10n = AppLocalizations.of(context)!;
    if (_formKey.currentState!.validate()) {
      if (_selectedGender == null) {
        context.showErrorMessage(l10n.pleaseSelectGender);
        return;
      }
      ProfileCubit.get(context).updateProfile(
        fullName: _nameController.text.trim(),
        email: _emailController.text.trim(),
        birthday: _birthdayController.text,
        gender: _selectedGender!,
        imageFile: _imageFile,
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _birthdayController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is SuccessUpdateProfileState) {
            context.showSuccessMessage(AppLocalizations.of(context)!.profileUpdatedSuccessfully);
            // Profile will be reloaded automatically by ProfileCubit
            Navigator.pop(context);
          } else if (state is ErrorUpdateProfileState) {
            context.showErrorMessage(state.message);
          } else if (state is ProfileReloadedState) {
            // Reload user data from cache after profile is fetched
            _loadUserData();
            setState(() {
              // Update cached image URL if profile was reloaded
              final userData = CacheHelper.getUserData()?.user;
              if (userData?.media != null && userData!.media!.isNotEmpty) {
                _cachedImageUrl = userData.media!.first;
              }
            });
          }
        },
        builder: (context, state) {
          final l10n = AppLocalizations.of(context)!;
          if (state is LoadingUpdateProfileState) {
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
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(height: 10),
                  Text(
                    l10n.editProfile,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 32,
                      color: Color(0xff121212),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.profileDataProtected,
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
                          backgroundImage: _getProfileImage(),
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
                        Text(
                          l10n.fullName,
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
                            hintText: l10n.fullNameHint,
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
                              ? l10n.pleaseEnterFullName
                              : null,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          l10n.email,
                          style: TextStyle(
                            color: Color(0xff121212),
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            hintText: l10n.emailHint,
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
                              return l10n.pleaseEnterEmail;
                            }
                            final emailRegex = RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                            );
                            if (!emailRegex.hasMatch(val)) {
                              return l10n.enterValidEmail;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        Text(
                          l10n.birthday,
                          style: TextStyle(
                            color: Color(0xff121212),
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _birthdayController,
                          readOnly: true,
                          onTap: _selectDate,
                          decoration: InputDecoration(
                            hintText: l10n.selectYourBirthday,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(11),
                              borderSide: const BorderSide(
                                color: Colors.black12,
                              ),
                            ),
                            fillColor: Color(0xffFBFBFB),
                            filled: true,
                            suffixIcon: Icon(Icons.calendar_today, color: Colors.grey),
                          ),
                          validator: (val) =>
                              (val == null || val.isEmpty)
                              ? l10n.pleaseSelectBirthday
                              : null,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          l10n.gender,
                          style: TextStyle(
                            color: Color(0xff121212),
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    _selectedGender = 'male';
                                  });
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                                  decoration: BoxDecoration(
                                    color: _selectedGender == 'male'
                                        ? Color(0xFFD1FADF)
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(11),
                                    border: Border.all(
                                      color: _selectedGender == 'male'
                                          ? AppColors.primary
                                          : Colors.black12,
                                      width: 1.5,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      if (_selectedGender == 'male')
                                        Icon(Icons.check, color: AppColors.primary, size: 18),
                                      if (_selectedGender == 'male') SizedBox(width: 6),
                                      Text(
                                        l10n.male,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: _selectedGender == 'male'
                                              ? AppColors.primary
                                              : Color(0xFF757575),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    _selectedGender = 'female';
                                  });
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                                  decoration: BoxDecoration(
                                    color: _selectedGender == 'female'
                                        ? Color(0xFFD1FADF)
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(11),
                                    border: Border.all(
                                      color: _selectedGender == 'female'
                                          ? AppColors.primary
                                          : Colors.black12,
                                      width: 1.5,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      if (_selectedGender == 'female')
                                        Icon(Icons.check, color: AppColors.primary, size: 18),
                                      if (_selectedGender == 'female') SizedBox(width: 6),
                                      Text(
                                        l10n.female,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: _selectedGender == 'female'
                                              ? AppColors.primary
                                              : Color(0xFF757575),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
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
                              l10n.save,
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

