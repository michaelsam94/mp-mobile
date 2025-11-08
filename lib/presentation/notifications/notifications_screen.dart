import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NotificationsScreen extends StatelessWidget {
  NotificationsScreen({super.key});

  final Color green = Color(0xFF19C37D);
  final Color bgGreen = Color(0xFFECFDF3);

  final List<Map<String, String>> notifications = [
    {
      'title': 'Suspicious activity on your account',
      'body': 'Review recent logins',
    },
    {
      'title': 'vehicle registration detected',
      'body':
          'Vehicle registration request [Plate: XXXX]. Confirm ownership transfer?',
    },
    {'title': 'Charging completed', 'body': 'Your session has completed.'},
    {
      'title': 'Charging failure',
      'body': 'Session failed. Reconnect or start a new session.',
    },
    {
      'title': 'Payment Summary',
      'body': 'Total cost calculated. View receipt for details.',
    },
    {
      'title': 'New Update Available',
      'body': 'Version 2.3.1 is ready to install. Click to update now.',
    },
  ];

  Widget buildNotification(Map<String, String> item) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 13, vertical: 7),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset("assets/icons/material-symbols-light_call.svg"),
          SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['title'] ?? '',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 15,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  item['body'] ?? '',
                  style: TextStyle(color: Colors.grey[700], fontSize: 15),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
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
                        "Notifications",
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
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.only(top: 20),
                itemCount: notifications.length,
                itemBuilder: (context, i) =>
                    buildNotification(notifications[i]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
