import 'package:flutter/material.dart';
import 'package:mega_plus/core/style/app_colors.dart';
import 'delete_account_password_screen.dart';

class DeleteAccountReasonScreen extends StatefulWidget {
  const DeleteAccountReasonScreen({super.key});

  @override
  State<DeleteAccountReasonScreen> createState() =>
      _DeleteAccountReasonScreenState();
}

class _DeleteAccountReasonScreenState extends State<DeleteAccountReasonScreen> {
  final TextEditingController reasonController = TextEditingController();

  @override
  void dispose() {
    reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Color(0xFF212121),
            size: 20,
          ),
        ),
        title: Text(
          'Delete account',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF212121),
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                'Delete Your account ?',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF212121),
                ),
              ),
              SizedBox(height: 16),

              // Description
              Text(
                'Can you please share to us what was not working? We are fixing bugs as soon as we spot them. If something slipped through our fingers, we\'d be so grateful to be aware of it and fix it.',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF757575),
                  height: 1.5,
                ),
              ),
              SizedBox(height: 24),

              // Text Field
              Container(
                height: 200,
                decoration: BoxDecoration(
                  color: Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Color(0xFFE0E0E0), width: 1),
                ),
                child: TextField(
                  controller: reasonController,
                  maxLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                  style: TextStyle(fontSize: 14, color: Color(0xFF212121)),
                  decoration: InputDecoration(
                    hintText: 'Your explanation is entirely optional...',
                    hintStyle: TextStyle(
                      fontSize: 14,
                      color: Color(0xFFBDBDBD),
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(16),
                  ),
                ),
              ),

              Spacer(),

              // Continue Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to password screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DeleteAccountPasswordScreen(
                          reason: reasonController.text,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Continue',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
