import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mega_plus/core/helpers/addons_functions.dart';
import 'package:mega_plus/core/style/app_colors.dart';
import 'package:mega_plus/presentation/auth/forgetPassword/forget_password_screen.dart';
import 'package:mega_plus/presentation/auth/otp/otp_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var checked = false;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16),
                // Back button
                IconButton(
                  icon: SvgPicture.asset("assets/icons/back.svg"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                SizedBox(height: 12),
                // Title and emoji
                Row(
                  children: [
                    Text(
                      'Hello again',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff121212),
                      ),
                    ),
                    SizedBox(width: 4),
                    Text('👋', style: TextStyle(fontSize: 26)),
                  ],
                ),
                SizedBox(height: 16),
                // Subtitle
                Text(
                  'Welcome back! Log in to continue your charging journey.',
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                ),
                SizedBox(height: 40),
                Text(
                  'Name / E-mail',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: Color(0xff121212),
                  ),
                ),
                SizedBox(height: 8),

                Container(
                  height: 48,
                  width: context.width(),
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Color(0xffEFF0F6)),
                  ),
                  child: TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      errorBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      focusedErrorBorder: InputBorder.none,
                      hintText: 'name or e-mail',
                      hintStyle: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: Color(0xffDCDCDC),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Password',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: Color(0xff121212),
                  ),
                ),
                SizedBox(height: 8),

                Container(
                  height: 48,
                  width: context.width(),
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Color(0xffEFF0F6)),
                  ),
                  child: TextField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      errorBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      focusedErrorBorder: InputBorder.none,
                      hintText: 'xxxxxxxxxxx',
                      hintStyle: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: Color(0xffDCDCDC),
                      ),
                    ),
                  ),
                ),

                // Phone input field
                // Row(
                //   spacing: 8,
                //   children: [
                //     Container(
                //       height: 56,
                //       padding: EdgeInsets.all(16),
                //       decoration: BoxDecoration(
                //         color: Color(0xffFBFBFB),
                //         border: Border.all(color: Colors.grey[300]!),
                //         borderRadius: BorderRadius.circular(10),
                //       ),
                //       child: GestureDetector(
                //         onTap: _changeCountry,
                //         child: Row(
                //           children: [
                //             Text(
                //               countryCode,
                //               style: TextStyle(
                //                 fontSize: 12,
                //                 color: Color(0xff212427),
                //                 fontWeight: FontWeight.w500,
                //               ),
                //             ),
                //             Icon(Icons.arrow_drop_down, size: 24),
                //           ],
                //         ),
                //       ),
                //     ),
                //     Expanded(
                //       child: Container(
                //         height: 56,
                //         padding: EdgeInsets.all(16),
                //         decoration: BoxDecoration(
                //           border: Border.all(color: Colors.grey[300]!),
                //           borderRadius: BorderRadius.circular(10),
                //         ),
                //         child: Row(
                //           children: [
                //             Image.asset(
                //               "assets/images/eg_flag.png",
                //               width: 24,
                //               height: 24,
                //             ),
                //             SizedBox(width: 10),
                //             Expanded(
                //               child: TextField(
                //                 onChanged: (value) {
                //                   if (value.isNotEmpty) {
                //                     conWord = true;
                //                   } else {
                //                     conWord = false;
                //                   }
                //                   setState(() {});
                //                 },
                //                 controller: phoneController,
                //                 keyboardType: TextInputType.number,
                //                 decoration: InputDecoration(
                //                   border: InputBorder.none,
                //                   errorBorder: InputBorder.none,
                //                   enabledBorder: InputBorder.none,
                //                   focusedBorder: InputBorder.none,
                //                   disabledBorder: InputBorder.none,
                //                   focusedErrorBorder: InputBorder.none,
                //                   hintText: 'XXXXXXXXXX',
                //                   hintStyle: TextStyle(
                //                     fontWeight: FontWeight.w500,
                //                     fontSize: 14,
                //                     color: Color(0xffDCDCDC),
                //                   ),
                //                 ),
                //               ),
                //             ),
                //           ],
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () {
                        context.goTo(ForgetPasswordScreen());
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Color(0xff121212)),
                          ),
                        ),
                        child: Text(
                          "Forget Password?",
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xff121212),
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ),
                  ],
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      checked = !checked;
                    });
                  },
                  child: Row(
                    children: [
                      Checkbox(
                        value: checked,
                        onChanged: (_val) {},
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadiusGeometry.circular(4),
                        ),
                      ),
                      Text(
                        "Remember me",
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xff121212),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 32),
                // Sign in button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      context.goTo(
                        OTPVerificationScreen(email: emailController.text),
                      );
                    },
                    child: Text(
                      "Sign in",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Color(0xffE6F9EE),
                      side: BorderSide(color: AppColors.primary),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'Continue as a guest',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onPressed: () {},
                  ),
                ),

                Row(
                  children: [
                    Expanded(child: Divider(color: Color(0xffE7E7E7))),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        "Or",
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xff606060),
                        ),
                      ),
                    ),
                    Expanded(child: Divider(color: Color(0xffE7E7E7))),
                  ],
                ),

                Container(
                  width: context.width(),
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Color(0xffEFF0F6)),
                  ),

                  child: Row(
                    spacing: 10,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset("assets/icons/google.svg"),
                      Text(
                        "Continue with Google",
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xff121212),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                Container(
                  width: context.width(),
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Color(0xffEFF0F6)),
                  ),

                  child: Row(
                    spacing: 10,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset("assets/icons/facebook.svg"),
                      Text(
                        "Continue with Facebook",
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xff121212),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:mega_plus/core/helpers/addons_functions.dart';
// import 'package:mega_plus/core/style/app_colors.dart';
// import 'package:mega_plus/presentation/auth/otp/otp_screen.dart';

// class LoginScreen extends StatefulWidget {
//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   String countryCode = '+20';
//   String flag = '🇪🇬'; // Egypt flag
//   TextEditingController phoneController = TextEditingController();

//   final List<Map<String, String>> countryList = [
//     {'code': '+20', 'flag': '🇪🇬'},
//   ];

//   void _changeCountry() async {
//     // Popup menu for selecting country
//     String? selectedCode = await showModalBottomSheet<String>(
//       backgroundColor: Colors.white,
//       context: context,
//       builder: (context) {
//         return ListView(
//           children: countryList.map((country) {
//             return ListTile(
//               leading: Text(country['flag']!, style: TextStyle(fontSize: 28)),
//               title: Text(country['code']!),
//               onTap: () => Navigator.pop(context, country['code']),
//             );
//           }).toList(),
//         );
//       },
//     );

//     if (selectedCode != null) {
//       setState(() {
//         countryCode = selectedCode;
//         flag = countryList.firstWhere(
//           (c) => c['code'] == selectedCode,
//         )['flag']!;
//       });
//     }
//   }

//   var conWord = false;

//   var checked = false;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Padding(
//           padding: EdgeInsets.symmetric(horizontal: 16),
//           child: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 SizedBox(height: 16),
//                 // Back button
//                 IconButton(
//                   icon: SvgPicture.asset("assets/icons/back.svg"),
//                   onPressed: () {
//                     Navigator.pop(context);
//                   },
//                 ),
//                 SizedBox(height: 12),
//                 // Title and emoji
//                 Row(
//                   children: [
//                     Text(
//                       'Hello again',
//                       style: TextStyle(
//                         fontSize: 32,
//                         fontWeight: FontWeight.bold,
//                         color: Color(0xff121212),
//                       ),
//                     ),
//                     SizedBox(width: 4),
//                     Text('👋', style: TextStyle(fontSize: 26)),
//                   ],
//                 ),
//                 SizedBox(height: 16),
//                 // Subtitle
//                 Text(
//                   'Welcome back! Log in to continue your charging journey.',
//                   style: TextStyle(fontSize: 16, color: Colors.grey[700]),
//                 ),
//                 SizedBox(height: 40),
//                 Text(
//                   'Enter Your Mobile Number',
//                   style: TextStyle(
//                     fontWeight: FontWeight.w500,
//                     fontSize: 14,
//                     color: Color(0xff121212),
//                   ),
//                 ),
//                 SizedBox(height: 8),

//                 // Phone input field
//                 Row(
//                   spacing: 8,
//                   children: [
//                     Container(
//                       height: 56,
//                       padding: EdgeInsets.all(16),
//                       decoration: BoxDecoration(
//                         color: Color(0xffFBFBFB),
//                         border: Border.all(color: Colors.grey[300]!),
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       child: GestureDetector(
//                         onTap: _changeCountry,
//                         child: Row(
//                           children: [
//                             Text(
//                               countryCode,
//                               style: TextStyle(
//                                 fontSize: 12,
//                                 color: Color(0xff212427),
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                             Icon(Icons.arrow_drop_down, size: 24),
//                           ],
//                         ),
//                       ),
//                     ),
//                     Expanded(
//                       child: Container(
//                         height: 56,
//                         padding: EdgeInsets.all(16),
//                         decoration: BoxDecoration(
//                           border: Border.all(color: Colors.grey[300]!),
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         child: Row(
//                           children: [
//                             Image.asset(
//                               "assets/images/eg_flag.png",
//                               width: 24,
//                               height: 24,
//                             ),
//                             SizedBox(width: 10),
//                             Expanded(
//                               child: TextField(
//                                 onChanged: (value) {
//                                   if (value.isNotEmpty) {
//                                     conWord = true;
//                                   } else {
//                                     conWord = false;
//                                   }
//                                   setState(() {});
//                                 },
//                                 controller: phoneController,
//                                 keyboardType: TextInputType.number,
//                                 decoration: InputDecoration(
//                                   border: InputBorder.none,
//                                   errorBorder: InputBorder.none,
//                                   enabledBorder: InputBorder.none,
//                                   focusedBorder: InputBorder.none,
//                                   disabledBorder: InputBorder.none,
//                                   focusedErrorBorder: InputBorder.none,
//                                   hintText: 'XXXXXXXXXX',
//                                   hintStyle: TextStyle(
//                                     fontWeight: FontWeight.w500,
//                                     fontSize: 14,
//                                     color: Color(0xffDCDCDC),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 16),
//                 InkWell(
//                   onTap: () {
//                     setState(() {
//                       checked = !checked;
//                     });
//                   },
//                   child: Row(
//                     children: [
//                       Checkbox(
//                         value: checked,
//                         onChanged: (_val) {},
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadiusGeometry.circular(4),
//                         ),
//                       ),
//                       Text(
//                         "Remember me",
//                         style: TextStyle(
//                           fontSize: 12,
//                           color: Color(0xff121212),
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(height: 32),
//                 // Sign up button
//                 SizedBox(
//                   width: double.infinity,
//                   height: 50,
//                   child: ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: AppColors.primary,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                     ),
//                     onPressed: conWord
//                         ? () {
//                             context.goTo(
//                               OTPVerificationScreen(
//                                 phone: phoneController.text,
//                               ),
//                             );
//                           }
//                         : null,
//                     child: Text(
//                       "Continue",
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 16,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 16),
//                 Row(
//                   children: [
//                     Expanded(child: Divider(color: Color(0xffE7E7E7))),
//                     Padding(
//                       padding: const EdgeInsets.all(16),
//                       child: Text(
//                         "Or",
//                         style: TextStyle(
//                           fontSize: 12,
//                           color: Color(0xff606060),
//                         ),
//                       ),
//                     ),
//                     Expanded(child: Divider(color: Color(0xffE7E7E7))),
//                   ],
//                 ),

//                 Container(
//                   width: context.width(),
//                   padding: EdgeInsets.all(12),
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(10),
//                     border: Border.all(color: Color(0xffEFF0F6)),
//                   ),

//                   child: Row(
//                     spacing: 10,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       SvgPicture.asset("assets/icons/google.svg"),
//                       Text(
//                         "Continue with Google",
//                         style: TextStyle(
//                           fontSize: 14,
//                           color: Color(0xff121212),
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(height: 16),
//                 Container(
//                   width: context.width(),
//                   padding: EdgeInsets.all(12),
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(10),
//                     border: Border.all(color: Color(0xffEFF0F6)),
//                   ),

//                   child: Row(
//                     spacing: 10,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       SvgPicture.asset("assets/icons/facebook.svg"),
//                       Text(
//                         "Continue with Facebook",
//                         style: TextStyle(
//                           fontSize: 14,
//                           color: Color(0xff121212),
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
