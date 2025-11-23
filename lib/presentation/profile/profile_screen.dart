import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mega_plus/core/helpers/addons_functions.dart';
import 'package:mega_plus/core/helpers/cache/cache_helper.dart';
import 'package:mega_plus/presentation/profile/cubit/profile_cubit.dart';
import 'package:mega_plus/presentation/profile/rfid_cards_screen.dart';
import 'package:mega_plus/presentation/profile/settings_screen.dart';
import 'package:mega_plus/presentation/profile/support_screen.dart';
import 'package:mega_plus/presentation/profile/terms_conditions_screen.dart';
import 'package:mega_plus/presentation/start/splash_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileCubit(),
      child: ProfileScreenUI(),
    );
  }
}

class ProfileScreenUI extends StatelessWidget {
  ProfileScreenUI({super.key});

  final Color green = Color(0xFF19C37D);
  final Color bgGreen = Color(0xFFECFDF3);

  Widget infoCard({
    required String title,
    required String value,
    required IconData icon,
    Color? iconColor,
  }) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 8),
        margin: EdgeInsets.symmetric(horizontal: 6),
        child: Column(
          children: [
            Icon(icon, color: iconColor ?? green, size: 23),
            SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(color: Colors.grey[700], fontSize: 15),
            ),
            SizedBox(height: 5),
            Text(
              value,
              style: TextStyle(
                color: green,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget profileMenu({
    required IconData icon,
    required String text,
    Color? iconColor,
    VoidCallback? onTap,
    bool isLogout = false,
  }) => Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: Color(0xFFF2F4F8), width: 1),
    ),
    margin: EdgeInsets.symmetric(vertical: 7, horizontal: 8),
    child: ListTile(
      onTap: onTap,
      leading: Icon(
        icon,
        color: isLogout ? Colors.red : iconColor ?? Colors.black,
        size: 24,
      ),
      title: Text(
        text,
        style: TextStyle(
          color: isLogout ? Colors.red : Colors.black,
          fontWeight: FontWeight.w500,
          fontSize: 17,
        ),
      ),
      trailing: isLogout
          ? null
          : SvgPicture.asset("assets/icons/go_forward.svg"),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocConsumer<ProfileCubit, ProfileState>(
          listener: (context, state) {
            if (state is SuccessLogoutProfileState) {
              CacheHelper.logout().then((_) {
                if (context.mounted) {
                  context.goOffAll(SplashScreen());
                }
              });
            }
          },
          builder: (context, state) {
            if (state is LoadingLogoutProfileState) {
              return Center(child: CircularProgressIndicator());
            }
            return ListView(
              children: [
                // AppBar
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  width: double.infinity,
                  height: 57,
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
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: SvgPicture.asset("assets/icons/back.svg"),
                        ),
                      ),
                      Center(
                        child: Text(
                          "Profile",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff212121),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 17),
                // Profile Card
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xffE6F9EE),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 22, horizontal: 18),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundImage: AssetImage(
                                'assets/images/user.png',
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Ali Maged',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(height: 3),
                                  Text(
                                    'ali********@gmail.com',
                                    style: TextStyle(
                                      color: Colors.grey[700],
                                      fontSize: 13,
                                    ),
                                  ),
                                  Text(
                                    '+201********51',
                                    style: TextStyle(
                                      color: Colors.grey[700],
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 5),
                            ElevatedButton.icon(
                              onPressed: () {},
                              icon: Icon(
                                Icons.mode_edit_outlined,
                                color: green,
                                size: 18,
                              ),
                              label: Text(
                                'Edit',
                                style: TextStyle(
                                  color: green,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xffB2ECCA),
                                elevation: 0,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 13,
                                  vertical: 8,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                  side: BorderSide(color: bgGreen, width: 2),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 17),
                        Row(
                          children: [
                            // Total Charges
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(13),
                                ),
                                padding: EdgeInsets.symmetric(vertical: 14),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(width: 12),
                                    SvgPicture.asset(
                                      "assets/icons/total_energy.svg",
                                    ),
                                    SizedBox(width: 12),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Total Charges',
                                          style: TextStyle(
                                            color: Colors.grey[700],
                                            fontSize: 13,
                                          ),
                                        ),
                                        SizedBox(height: 2),
                                        Text(
                                          '45',
                                          style: TextStyle(
                                            color: green,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 21,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(width: 12),
                            // Points
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(13),
                                ),
                                padding: EdgeInsets.symmetric(vertical: 14),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(width: 12),
                                    SvgPicture.asset(
                                      "assets/icons/points_profile.svg",
                                    ),
                                    SizedBox(width: 12),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Points',
                                          style: TextStyle(
                                            color: Colors.grey[700],
                                            fontSize: 13,
                                          ),
                                        ),
                                        SizedBox(height: 2),
                                        Text(
                                          '850',
                                          style: TextStyle(
                                            color: green,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 21,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 17),
                // Menu Items
                profileMenu(
                  icon: Icons.credit_card_rounded,
                  text: "RFID Cards",
                  onTap: () {
                    context.goTo(RFIDCardsScreen());
                  },
                ),
                profileMenu(
                  icon: Icons.settings_outlined,
                  text: "Setting",
                  onTap: () {
                    context.goTo(SettingsScreen());
                  },
                ),
                profileMenu(
                  icon: Icons.support_agent,
                  text: "Support/complain",
                  onTap: () {
                    context.goTo(SupportScreen());
                  },
                ),
                profileMenu(
                  icon: Icons.assignment_outlined,
                  text: "Terms and conditions",
                  onTap: () {
                    context.goTo(TermsConditionsScreen());
                  },
                ),
                // Logout
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xFFF2F4F8), width: 1),
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  margin: EdgeInsets.symmetric(vertical: 7, horizontal: 8),
                  child: ListTile(
                    onTap: () {
                      showLogoutBottomSheet(context, () {
                        ProfileCubit.get(context).logout();
                      });
                    },
                    leading: Icon(
                      Icons.logout,
                      color: Color(0xffB71C1C),
                      size: 24,
                    ),
                    title: Text(
                      "Log out",
                      style: TextStyle(
                        color: Color(0xffB71C1C),
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 18),
                Center(
                  child: Text(
                    "Version 4.4.2 (102)",
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                ),
                SizedBox(height: 10),
              ],
            );
          },
        ),
      ),
    );
  }

  void showLogoutBottomSheet(
    BuildContext context,
    VoidCallback onConfirmLogout,
  ) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      backgroundColor: Colors.white,
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 18, 24, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.exit_to_app, color: Colors.redAccent, size: 42),
            SizedBox(height: 16),
            Text(
              'Are you sure you want to log out?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.grey[300]!),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () => Navigator.of(ctx).pop(),
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(ctx).pop();
                      onConfirmLogout();
                    },
                    child: Text(
                      'Logout',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
