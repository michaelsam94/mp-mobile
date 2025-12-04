import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mega_plus/core/helpers/addons_functions.dart';
import 'package:mega_plus/presentation/vehicles/my_vehicles_screen.dart';
import 'package:mega_plus/presentation/wallet/manage_cards_screen.dart';

class SettingsScreen extends StatelessWidget {
  SettingsScreen({super.key});

  final Color green = Color(0xFF19C37D);
  final Color bgGreen = Color(0xFFECFDF3);

  Widget settingsItem({
    required IconData icon,
    required String title,
    String? subtitle,
    Color? iconColor,
    Color? textColor,
    bool isDanger = false,
    VoidCallback? onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Color(0xFFE9E9E9)),
      ),
      margin: EdgeInsets.symmetric(vertical: 7, horizontal: 12),
      child: ListTile(
        dense: true,
        onTap: onTap,
        leading: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor != null ? bgGreen : Colors.transparent,
            borderRadius: BorderRadius.circular(7),
          ),
          child: Icon(
            icon,
            color: iconColor ?? (isDanger ? Colors.red : Colors.black),
            size: 23,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isDanger ? Colors.red : textColor ?? Colors.black,
            fontWeight: FontWeight.w500,
            fontSize: 17,
          ),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w400,
                ),
              )
            : null,
        trailing: SvgPicture.asset("assets/icons/go_forward.svg"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            // AppBar
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              width: double.infinity,
              height: 57,
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Color(0xffF2F4F8))),
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
                      "Settings",
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

            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.only(left: 21.0, top: 7, bottom: 1),
              child: Text(
                "My Account",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Colors.black,
                ),
              ),
            ),
            settingsItem(
              icon: Icons.directions_car,
              title: "My Vehicle",
              subtitle: "Tesla Model 3 • ABC 1234",
              iconColor: green,
              onTap: () {
                context.goTo(MyVehiclesScreen());
              },
            ),
            // settingsItem(
            //   icon: Icons.credit_card,
            //   title: "Payment Methods",
            //   subtitle: "2 cards • ************9909",
            //   iconColor: green,
            //   onTap: () {
            //     context.goTo(ManageCardsScreen());
            //   },
            // ),
            // settingsItem(
            //   icon:
            //       Icons.military_tech, // Use medallion or gift icon for loyalty
            //   title: "Loyalty Points 🏅",
            //   subtitle: "850 Points • Gold Member",
            //   iconColor: green,
            // ),
            Padding(
              padding: const EdgeInsets.only(left: 21.0, top: 14, bottom: 3),
              child: Text(
                "Security",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Colors.black,
                ),
              ),
            ),
            settingsItem(icon: Icons.lock_outline, title: "Change Password"),
            settingsItem(
              icon: Icons.delete_outline,
              title: "Delete Account",
              isDanger: true,
              textColor: Colors.red,
            ),
            SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}
