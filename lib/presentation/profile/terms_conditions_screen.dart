import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});

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
                      "Terms and condition",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 17,
                        color: Color(0xff212121),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Terms and Conditions",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 19,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      "Last updated: 30 May 2024",
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 11),
                    Text(
                      "Please read these Terms and Conditions carefully before creating an account or using the Electric Vehicle (EV) Charging Service.",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 14),
                    _section("1. About the Service", [
                      "When you create an account, you must provide accurate, complete, and up-to-date information.",
                      "You are responsible for safeguarding your password and any activity that occurs under your account.",
                      "Notify us immediately if you suspect unauthorized access or any security breach.",
                    ]),
                    _section("3. Charging Sessions", [
                      "Charging sessions depend on the availability and condition of the selected charging station.",
                      "Session time, energy delivered, and pricing may vary based on the station or operator.",
                      "In case of technical issues (e.g., power outage, connector failure, or network problem), we will assist you but cannot guarantee uninterrupted service.",
                    ]),
                    _section("4. Payments and Cancellations", [
                      "All charging and service fees are processed through your registered payment method within the app.",
                      "Cancellation or refund policies depend on the station operator or company policy, displayed before you confirm a session or purchase.",
                      "If you dispute any transaction, you may contact support for investigation; decisions will be based on charging records and payment logs.",
                    ]),
                    _section("5. User Responsibilities", [
                      "Ensure your vehicle is compatible with the charging station before starting a session.",
                      "Follow all on-site safety instructions and cooperate with station personnel if applicable.",
                      "Do not misuse, damage, or interfere with charging equipment or the mobile application.",
                    ]),
                    _section("6. Safety and Technical Compliance", [
                      "Some stations are operated by third parties. We do not control their maintenance or safety directly.",
                      "We are not liable for any vehicle damage or malfunction resulting from third-party station use, except where negligence from our side is proven.",
                    ]),
                    _section("7. Account Termination or Suspension", [
                      "We may suspend or terminate your account immediately if you violate these Terms or if fraudulent or harmful activity is detected.",
                      "You may delete your account at any time from the app settings. Refunds or outstanding balances will be handled according to our payment policy.",
                    ]),
                    _section("8. Limitation of Liability", [
                      "To the maximum extent permitted by law, we shall not be liable for indirect, incidental, or consequential damages (including loss of data, profits, or vehicle functionality) arising from your use of the Service.",
                      "You agree to indemnify and hold us harmless from any claims arising from your misuse of the Service or breach of these Terms.",
                    ]),
                    _section("9. Privacy and Data Protection", [
                      "We collect and process your data in accordance with our Privacy Policy, which explains what information we collect, how we use it, and how it is stored securely.",
                      "By using the app, you consent to the processing of your data for operational and support purposes (e.g., managing sessions, payments, and support requests).",
                    ]),
                    _section("10. Modifications to the Terms", [
                      "We may update or revise these Terms from time to time. If significant changes are made, we will notify you before they take effect.",
                      "Continued use of the Service after such updates means you agree to the revised Terms.",
                    ]),
                    _section("10. Modifications to the Terms", [
                      "These Terms shall be governed by and interpreted in accordance with the laws of the country or region where the company operates. Any disputes will be subject to the jurisdiction of the appropriate courts in that region.",
                    ]),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _section(String title, List<String> bullets) {
    return Padding(
      padding: EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 11),
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.black,
            ),
          ),
          ...bullets.map(
            (b) => Padding(
              padding: const EdgeInsets.only(left: 17, top: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text("• ", style: TextStyle(fontSize: 15)),
                  ),
                  Expanded(child: Text(b, style: TextStyle(fontSize: 15))),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
