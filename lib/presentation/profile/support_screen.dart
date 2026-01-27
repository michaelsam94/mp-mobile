import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mega_plus/core/helpers/addons_functions.dart';
import 'package:mega_plus/core/style/app_colors.dart';
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
                  "Support",
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
                  "Complain",
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

  Widget _buildSupportCard(String label, String value, IconData icon, {VoidCallback? onTap}) {
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
                  SizedBox(height: 5),
                  Text(
                    value,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
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
                'Failed to load settings',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          );
        }
        
        // Build support cards from API data
        List<Widget> supportCards = [];
        
        // Phone Support
        final phone = cubit.getSettingValue('phone');
        if (phone != null && phone.isNotEmpty) {
          supportCards.add(
            _buildSupportCard(
              "Phone Support",
              phone,
              Icons.phone_outlined,
              onTap: () async {
                try {
                  final uri = Uri.parse('tel:${phone.trim()}');
                  await launchUrl(uri);
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Could not open phone dialer'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
            ),
          );
        }
        
        // Email Support
        final email = cubit.getSettingValue('email');
        if (email != null && email.isNotEmpty) {
          supportCards.add(
            _buildSupportCard(
              "Email Support",
              email,
              Icons.email_outlined,
              onTap: () async {
                try {
                  final uri = Uri.parse('mailto:${email.trim()}');
                  await launchUrl(uri);
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Could not open email app'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
            ),
          );
        }
        
        // Facebook
        final facebook = cubit.getSettingValue('facebook');
        if (facebook != null && facebook.isNotEmpty) {
          supportCards.add(
            _buildSupportCard(
              "Facebook",
              facebook,
              Icons.link,
              onTap: () async {
                try {
                  String url = facebook.trim();
                  if (!url.startsWith('http://') && !url.startsWith('https://')) {
                    url = 'https://$url';
                  }
                  final uri = Uri.parse(url);
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Could not open Facebook'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
            ),
          );
        }
        
        // TikTok
        final tiktok = cubit.getSettingValue('tiktok');
        if (tiktok != null && tiktok.isNotEmpty) {
          supportCards.add(
            _buildSupportCard(
              "TikTok",
              tiktok,
              Icons.video_library_outlined,
              onTap: () async {
                try {
                  String url = tiktok.trim();
                  if (!url.startsWith('http://') && !url.startsWith('https://')) {
                    url = 'https://$url';
                  }
                  final uri = Uri.parse(url);
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Could not open TikTok'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
            ),
          );
        }
        
        // Twitter
        final twitter = cubit.getSettingValue('twitter');
        if (twitter != null && twitter.isNotEmpty) {
          supportCards.add(
            _buildSupportCard(
              "Twitter",
              twitter,
              Icons.link,
              onTap: () async {
                try {
                  String url = twitter.trim();
                  if (!url.startsWith('http://') && !url.startsWith('https://')) {
                    url = 'https://$url';
                  }
                  final uri = Uri.parse(url);
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Could not open Twitter'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
            ),
          );
        }
        
        if (supportCards.isEmpty) {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                'No support information available',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          );
        }
        
        return SingleChildScrollView(
          child: Column(
            children: supportCards,
          ),
        );
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
              hintText: "Complaint Title",
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
              hintText: "Description of the complaint",
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
            "Complaint category *",
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
          ),
          SizedBox(height: 8),
          BlocBuilder<ProfileCubit, ProfileState>(
            builder: (context, state) {
              return ProfileCubit.get(context).complaintsCategories.isEmpty
                  ? Text("Loading....")
                  : _buildDropdown(
                      label: "Complaint category *",
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
                        text:
                            "I acknowledge the accuracy of the information and agree to the ",
                        style: TextStyle(fontSize: 15),
                      ),
                      TextSpan(
                        text: "privacy policy",
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
                  context.showErrorMessage("Please agree on privacy first");
                  return;
                }
                if (ProfileCubit.get(context).selectedCategory == null) {
                  context.showErrorMessage("Please select cateogry");
                  return;
                }
                if (titleController.text.isEmpty) {
                  context.showErrorMessage("Please enter title");
                  return;
                }
                if (descController.text.isEmpty) {
                  context.showErrorMessage("Please enter description");
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
                "Send Complain",
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
                          "Support and complain",
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
