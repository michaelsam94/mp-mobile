import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mega_plus/core/helpers/addons_functions.dart';
import 'package:mega_plus/core/style/app_colors.dart';
import 'package:mega_plus/l10n/app_localizations.dart';
import 'package:mega_plus/presentation/profile/cubit/profile_cubit.dart';
import 'package:url_launcher/url_launcher.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportAndComplainScreenState();
}

class _SupportAndComplainScreenState extends State<SupportScreen> {
  int selectedTab = 0; // 0 = Support, 1 = Complain
  final Color green = Color(0xFF19C37D);
  final Color bgGreen = Color(0xFFECFDF3);

  final titleController = TextEditingController();
  final descController = TextEditingController();

  @override
  void initState() {
    super.initState();
    ProfileCubit.get(context).getcomplaintsCategories();
    ProfileCubit.get(context).getSettings();
  }

  Widget _buildTabBar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      padding: EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: Color(0xffF6F6F6),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Color(0xFFE9E9E9)),
      ),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              borderRadius: BorderRadius.circular(11),
              onTap: () => setState(() => selectedTab = 0),
              child: Container(
                alignment: Alignment.center,
                height: 50,
                decoration: BoxDecoration(
                  color: selectedTab == 0 ? Colors.white : Color(0xFFF6F6F6),
                  border: selectedTab == 0
                      ? Border.all(color: Color(0xFFE9E9E9), width: 2)
                      : null,
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Text(
                  AppLocalizations.of(context)!.support,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 19,
                    color: selectedTab == 0 ? Colors.black : Colors.grey[500],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              borderRadius: BorderRadius.circular(11),
              onTap: () => setState(() => selectedTab = 1),
              child: Container(
                alignment: Alignment.center,
                height: 50,
                decoration: BoxDecoration(
                  color: selectedTab == 1 ? Colors.white : Color(0xFFF6F6F6),
                  border: selectedTab == 1
                      ? Border.all(color: Color(0xFFE9E9E9), width: 2)
                      : null,
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Text(
                  AppLocalizations.of(context)!.complain,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 19,
                    color: selectedTab == 1 ? Colors.black : Colors.grey[500],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSupportCard(
    String label,
    String value,
    IconData icon, {
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(19),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        padding: EdgeInsets.symmetric(horizontal: 14, vertical: 17),
        decoration: BoxDecoration(
          color: Color(0xffF6F6F6),
          borderRadius: BorderRadius.circular(19),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.white, size: 27),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                  // SizedBox(height: 5),
                  // Text(
                  //   value,
                  //   style: TextStyle(
                  //     fontWeight: FontWeight.bold,
                  //     fontSize: 17,
                  //     color: AppColors.primary,
                  //   ),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatSettingLabel(String key) {
    if (key.isEmpty) return key;
    final lower = key.toLowerCase();
    return lower.length > 1
        ? '${lower[0].toUpperCase()}${lower.substring(1)}'
        : key.toUpperCase();
  }

  IconData _iconForSettingKey(String key) {
    final k = key.toLowerCase();
    if (k.contains('phone') || k.contains('tel')) return Icons.phone_outlined;
    if (k.contains('email') || k.contains('mail')) return Icons.email_outlined;
    return Icons.link;
  }

  Future<void> _openSupportLink(
    BuildContext context,
    String key,
    String value,
  ) async {
    try {
      final k = key.toLowerCase();
      final v = value.trim();
      Uri uri;
      if (k.contains('phone') || k.contains('tel')) {
        uri = Uri.parse('tel:$v');
        await launchUrl(uri);
      } else if (k.contains('email') || k.contains('mail')) {
        uri = Uri.parse('mailto:$v');
        await launchUrl(uri);
      } else {
        String url = v;
        if (!url.startsWith('http://') && !url.startsWith('https://')) {
          url = 'https://$url';
        }
        uri = Uri.parse(url);
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not open ${_formatSettingLabel(key)}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Widget _buildSupportTab() {
    final cubit = ProfileCubit.get(context);

    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        if (state is LoadingGetSettingsState) {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (state is ErrorGetSettingsState) {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                AppLocalizations.of(context)!.failedToLoadSettings,
                style: TextStyle(color: Colors.grey),
              ),
            ),
          );
        }

        // Build support cards from all settings (key-value pairs)
        List<Widget> supportCards = [];

        for (final setting in cubit.settings) {
          final key = setting.key?.trim() ?? '';
          final value = setting.value?.trim() ?? '';
          if (key.isEmpty || value.isEmpty) continue;

          final label = _formatSettingLabel(key);
          final icon = _iconForSettingKey(key);
          supportCards.add(
            _buildSupportCard(
              label,
              value,
              icon,
              onTap: () => _openSupportLink(context, key, value),
            ),
          );
        }

        if (supportCards.isEmpty) {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                AppLocalizations.of(context)!.noSupportInfoAvailable,
                style: TextStyle(color: Colors.grey),
              ),
            ),
          );
        }

        return SingleChildScrollView(child: Column(children: supportCards));
      },
    );
  }

  Widget _buildDropdown({
    required String label,
    required List<String> items,
    String? value,
    void Function(String?)? onChanged,
  }) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        filled: true,
        fillColor: Color(0xFFF7F7F7),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: BorderSide(color: Color(0xFFE9E9E9)),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 17, vertical: 5),
      ),
      items: items
          .map(
            (e) => DropdownMenuItem<String>(
              value: e,
              child: Text(e, style: TextStyle(fontSize: 12)),
            ),
          )
          .toList(),
      onChanged: onChanged,
      initialValue: value ?? items.first,
    );
  }

  Widget _buildComplaintTab() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 5),
          Text(
            "Complaint Title *",
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
          ),
          SizedBox(height: 5),
          TextField(
            controller: titleController,
            decoration: InputDecoration(
              hintText: AppLocalizations.of(context)!.complaintTitle,
              filled: true,
              fillColor: Color(0xFFF7F7F7),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(13),
                borderSide: BorderSide(color: Color(0xFFE9E9E9)),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 17,
                vertical: 17,
              ),
            ),
          ),
          SizedBox(height: 14),
          Text(
            "Description of the complaint *",
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
          ),
          SizedBox(height: 5),
          TextField(
            maxLines: 5,
            controller: descController,

            decoration: InputDecoration(
              hintText: AppLocalizations.of(context)!.complaintDescription,
              filled: true,
              fillColor: Color(0xFFF7F7F7),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(13),
                borderSide: BorderSide(color: Color(0xFFE9E9E9)),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 17,
                vertical: 17,
              ),
            ),
          ),
          SizedBox(height: 14),
          Text(
            AppLocalizations.of(context)!.complaintCategory,
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
          ),
          SizedBox(height: 8),
          BlocBuilder<ProfileCubit, ProfileState>(
            builder: (context, state) {
              return ProfileCubit.get(context).complaintsCategories.isEmpty
                  ? Text(AppLocalizations.of(context)!.loading)
                  : _buildDropdown(
                      label: AppLocalizations.of(context)!.complaintCategory,
                      items: ProfileCubit.get(context).complaintsCategories,
                      value: ProfileCubit.get(context).selectedCategory,
                      onChanged: (val) {
                        ProfileCubit.get(context).editCategory(val);
                      },
                    );
            },
          ),
          // SizedBox(height: 14),
          // Text(
          //   "Connectors",
          //   style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
          // ),
          // SizedBox(height: 8),
          // _buildDropdown(
          //   label: "Connectors",
          //   items: ["Select Connectors"],
          //   value: "Select Connectors",
          // ),
          SizedBox(height: 14),
          // Text(
          //   "Media Upload",
          //   style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
          // ),
          // SizedBox(height: 9),
          // Container(
          //   height: 200,
          //   decoration: BoxDecoration(
          //     borderRadius: BorderRadius.circular(14),
          //     border: Border.all(
          //       color: green,
          //       width: 1,
          //       style: BorderStyle.solid,
          //     ),
          //   ),
          //   child: Center(
          //     child: Column(
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       children: [
          //         Icon(Icons.file_upload, color: green, size: 32),
          //         SizedBox(height: 6),
          //         Text(
          //           "Drag your file(s) to start uploading",
          //           style: TextStyle(fontSize: 16, color: Colors.black),
          //         ),
          //         SizedBox(height: 2),
          //         Text("OR", style: TextStyle(fontSize: 16)),
          //         SizedBox(height: 2),
          //         ElevatedButton(
          //           onPressed: () {},
          //           style: ElevatedButton.styleFrom(
          //             foregroundColor: green,
          //             backgroundColor: bgGreen,
          //             shape: RoundedRectangleBorder(
          //               borderRadius: BorderRadius.circular(8),
          //             ),
          //           ),
          //           child: Text("Open Camera", style: TextStyle(color: green)),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
          // SizedBox(height: 13),
          Row(
            children: [
              BlocBuilder<ProfileCubit, ProfileState>(
                builder: (context, state) {
                  return Checkbox(
                    value: ProfileCubit.get(context).agreePrivacy,
                    onChanged: (value) {
                      ProfileCubit.get(
                        context,
                      ).editAgreePriivacy(value ?? false);
                    },
                    activeColor: AppColors.primary,
                    shape: CircleBorder(),
                  );
                },
              ),
              Expanded(
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: AppLocalizations.of(context)!.iAcknowledgePrivacy,
                        style: const TextStyle(fontSize: 15),
                      ),
                      TextSpan(
                        text: AppLocalizations.of(context)!.privacyPolicy,
                        style: TextStyle(
                          fontSize: 15,
                          color: green,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      TextSpan(
                        text: " *",
                        style: TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: () {
                if (!ProfileCubit.get(context).agreePrivacy) {
                  context.showErrorMessage(AppLocalizations.of(context)!.pleaseAgreePrivacy);
                  return;
                }
                if (ProfileCubit.get(context).selectedCategory == null) {
                  context.showErrorMessage(AppLocalizations.of(context)!.pleaseSelectCategory);
                  return;
                }
                if (titleController.text.isEmpty) {
                  context.showErrorMessage(AppLocalizations.of(context)!.pleaseEnterTitle);
                  return;
                }
                if (descController.text.isEmpty) {
                  context.showErrorMessage(AppLocalizations.of(context)!.pleaseEnterDescription);
                  return;
                }

                ProfileCubit.get(
                  context,
                ).makeComplaint(titleController.text, descController.text);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: Text(
                AppLocalizations.of(context)!.sendComplain,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 19,
                ),
              ),
            ),
          ),
          SizedBox(height: 14),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is SuccessMakeComplaintsState) {
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          if (state is LoadingMakeComplaintsState) {
            return Center(child: CircularProgressIndicator());
          }
          return SafeArea(
            child: Column(
              children: [
                // AppBar
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  height: 57,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Color(0xffF2F4F8)),
                    ),
                    color: Colors.white,
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: InkWell(
                          onTap: () => Navigator.pop(context),
                          child: SvgPicture.asset("assets/icons/back.svg"),
                        ),
                      ),
                      Center(
                        child: Text(
                          AppLocalizations.of(context)!.supportAndComplain,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff212121),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                _buildTabBar(),
                // Main Tab View
                Expanded(
                  child: SingleChildScrollView(
                    child: selectedTab == 0
                        ? _buildSupportTab()
                        : _buildComplaintTab(),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
