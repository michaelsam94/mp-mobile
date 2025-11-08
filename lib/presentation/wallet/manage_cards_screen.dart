import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mega_plus/core/helpers/addons_functions.dart';
import 'package:mega_plus/core/style/app_colors.dart';
import 'package:mega_plus/presentation/wallet/add_card_screen.dart';

class ManageCardsScreen extends StatelessWidget {
  ManageCardsScreen({super.key});

  final Color green = AppColors.primary;
  final Color bgGreen = Color(0xFFECFDF3);
  final Color borderGreen = Color(0xFF19C37D);
  final Color red = Color(0xFFD03534);
  final Color bgRed = Color(0xFFB71C1C);
  final Color blue = Color(0xFF256FEF);

  Widget cardItem({
    bool isDefault = false,
    required String lastDigits,
    required String expiry,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 9),
      padding: EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      decoration: BoxDecoration(
        color: isDefault ? bgGreen : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borderGreen.withOpacity(0.5), width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Visa',
                style: TextStyle(
                  color: green,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              if (isDefault)
                Container(
                  margin: EdgeInsets.only(left: 9),
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                  decoration: BoxDecoration(
                    color: blue,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Default',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 7),
          Text(
            '****  ****  ****  $lastDigits',
            style: TextStyle(
              color: green,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'Expires $expiry',
            style: TextStyle(
              fontSize: 12,
              color: green,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    border: Border.all(color: green.withOpacity(0.7), width: 2),
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.transparent,
                  ),
                  child: TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      foregroundColor: green,
                      backgroundColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      isDefault ? "Deactivate" : "Set as Default",
                      style: TextStyle(
                        color: green,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextButton.icon(
                    onPressed: () {},
                    icon: Icon(
                      Icons.delete_outline,
                      color: Colors.white,
                      size: 24,
                    ),
                    label: Text(
                      "Delete",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      backgroundColor: Color(0xffB71C1C),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF7F7F7),
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
                      "Manage Card",
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
            SizedBox(height: 15),
            cardItem(isDefault: true, lastDigits: "2367", expiry: "08/26"),
            cardItem(isDefault: false, lastDigits: "2367", expiry: "08/26"),
            SizedBox(height: 27),
            // Add New Card Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SizedBox(
                width: double.infinity,
                height: 58,
                child: ElevatedButton.icon(
                  onPressed: () {
                    context.goTo(AddCardScreen());
                  },
                  icon: Icon(Icons.add, size: 27, color: Colors.white),
                  label: Text(
                    'Add New Card',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
