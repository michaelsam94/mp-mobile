import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:mega_plus/l10n/app_localizations.dart';

import 'cubit/profile_cubit.dart';

class TermsConditionsScreen extends StatefulWidget {
  const TermsConditionsScreen({super.key});

  @override
  State<TermsConditionsScreen> createState() => _TermsConditionsScreenState();
}

class _TermsConditionsScreenState extends State<TermsConditionsScreen> {
  @override
  void initState() {
    super.initState();
    ProfileCubit.get(context).getTermsConditions();
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
                      AppLocalizations.of(context)!.termsAndConditions,
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
              child: BlocBuilder<ProfileCubit, ProfileState>(
                builder: (context, state) {
                  if (state is LoadingGetTermsState) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (state is ErrorGetTermsState) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 60,
                            color: Colors.red,
                          ),
                          SizedBox(height: 16),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 32),
                            child: Text(
                              state.message,
                              style: TextStyle(fontSize: 16, color: Colors.red),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              ProfileCubit.get(context).getTermsConditions();
                            },
                            child: Text(AppLocalizations.of(context)!.retry),
                          ),
                        ],
                      ),
                    );
                  }

                  var cubit = ProfileCubit.get(context);

                  if (cubit.termsConditions.isEmpty) {
                    return Center(
                      child: Text(
                        AppLocalizations.of(context)!.noTermsAvailable,
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    );
                  }

                  return SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Text(
                        //   "Terms and Conditions",
                        //   style: TextStyle(
                        //     fontWeight: FontWeight.bold,
                        //     fontSize: 19,
                        //     color: Colors.black,
                        //   ),
                        // ),
                        // SizedBox(height: 3),
                        // Text(
                        //   "Last updated: ${DateTime.now().day} ${_getMonthName(DateTime.now().month)} ${DateTime.now().year}",
                        //   style: TextStyle(
                        //     color: Colors.grey[600],
                        //     fontSize: 13,
                        //     fontWeight: FontWeight.w400,
                        //   ),
                        // ),
                        SizedBox(height: 20),
                        // Dynamic content from API with HTML support
                        ...cubit.termsConditions.map((term) {
                          return _buildTermSection(
                            term.title,
                            term.description,
                          );
                        }),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTermSection(String title, String htmlDescription) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 8),
          HtmlWidget(
            htmlDescription,
            textStyle: TextStyle(
              fontSize: 15,
              color: Colors.black87,
              fontWeight: FontWeight.w400,
              height: 1.5,
            ),
            // Customize link handling
            onTapUrl: (url) {
              // Handle link taps here
              print('Tapped on: $url');
              return true; // Return true to prevent default behavior
            },
            // Customize rendering
            customStylesBuilder: (element) {
              // Add custom styles for specific HTML elements
              if (element.localName == 'p') {
                return {'margin': '0', 'padding': '0'};
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[month - 1];
  }
}
