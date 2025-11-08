import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mega_plus/core/style/app_colors.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportAndComplainScreenState();
}

class _SupportAndComplainScreenState extends State<SupportScreen> {
  int selectedTab = 0; // 0 = Support, 1 = Complain
  final Color green = Color(0xFF19C37D);
  final Color bgGreen = Color(0xFFECFDF3);

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

  Widget _buildSupportCard(String label, String value, IconData icon) {
    return Container(
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
    );
  }

  Widget _buildSupportTab() {
    return Column(
      children: [
        _buildSupportCard(
          "Phone Support",
          "+20 123 456 7890",
          Icons.phone_outlined,
        ),
        _buildSupportCard(
          "Email Support",
          "support@megaplug.com",
          Icons.email_outlined,
        ),
        _buildSupportCard("Live Chat", "Available 24/7", Icons.chat_outlined),
        _buildSupportCard(
          "FAQ Section",
          "www.megaplug.com/faq",
          Icons.phone_outlined,
        ),
        _buildSupportCard(
          "Social Media Support",
          "@megaplug on Twitter",
          Icons.email_outlined,
        ),
        _buildSupportCard(
          "Community Forum",
          "forum.megaplug.com",
          Icons.phone_outlined,
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String label,
    required List<String> items,
    String? value,
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
            (e) => DropdownMenuItem(
              value: e,
              child: Text(e, style: TextStyle(fontSize: 12)),
            ),
          )
          .toList(),
      onChanged: (_) {},
      value: value ?? items.first,
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
          _buildDropdown(
            label: "Complaint category *",
            items: ["Complaint category"],
            value: "Complaint category",
          ),
          SizedBox(height: 14),
          Text(
            "Connectors",
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
          ),
          SizedBox(height: 8),
          _buildDropdown(
            label: "Connectors",
            items: ["Select Connectors"],
            value: "Select Connectors",
          ),
          SizedBox(height: 14),
          Text(
            "Media Upload",
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
          ),
          SizedBox(height: 9),
          Container(
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: green,
                width: 1,
                style: BorderStyle.solid,
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.file_upload, color: green, size: 32),
                  SizedBox(height: 6),
                  Text(
                    "Drag your file(s) to start uploading",
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  SizedBox(height: 2),
                  Text("OR", style: TextStyle(fontSize: 16)),
                  SizedBox(height: 2),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      foregroundColor: green,
                      backgroundColor: bgGreen,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text("Open Camera", style: TextStyle(color: green)),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 13),
          Row(
            children: [
              Checkbox(
                value: true,
                onChanged: (_) {},
                activeColor: AppColors.primary,
                shape: CircleBorder(),
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
              onPressed: () {},
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
      body: SafeArea(
        child: Column(
          children: [
            // AppBar
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              height: 57,
              width: double.infinity,
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
      ),
    );
  }
}
