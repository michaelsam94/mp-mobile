import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mega_plus/core/style/app_colors.dart';

class HistoryScreen extends StatelessWidget {
  HistoryScreen({super.key});

  final green = Color(0xFF19C37D);
  final bgGreen = Color(0xFFECFDF3);

  Widget buildCard(String icon, String title, String value) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Color(0xFFE9E9E9), width: 1),
        color: Colors.white,
      ),
      margin: EdgeInsets.all(4),
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(icon),
          SizedBox(height: 20),
          Text(title, style: TextStyle(color: Colors.grey[700], fontSize: 15)),
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSessionCard() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Color(0xFFE9E9E9)),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SvgPicture.asset("assets/icons/card_history.svg"),
              SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Cost',
                    style: TextStyle(color: Colors.grey[700], fontSize: 15),
                  ),
                  Row(
                    children: [
                      Text(
                        '115',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 32,
                        ),
                      ),
                      SizedBox(width: 2),
                      Text(
                        'egp',
                        style: TextStyle(color: Colors.grey[700], fontSize: 17),
                      ),
                    ],
                  ),
                ],
              ),
              Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                decoration: BoxDecoration(
                  color: Color(0xffE6F9EE),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Row(
                  children: [
                    Icon(Icons.flash_on, size: 17, color: AppColors.primary),
                    SizedBox(width: 4),
                    Text(
                      'DC Fast',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Text(
            'Sep 22, 2025 /  1h 45m • 26.8 kWh',
            style: TextStyle(color: Color(0xffB6B6B6), fontSize: 15),
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Icon(
                Icons.add_location_alt_outlined,
                color: AppColors.primary,
                size: 21,
              ),
              SizedBox(width: 3),
              Text(
                'QuickCharge Point, Heliopolis',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
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
      backgroundColor: Color(0xFFFFFFFF),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                width: double.infinity,
                height: 57,
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Color(0xffF2F4F8))),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: SvgPicture.asset("assets/icons/back.svg"),
                    ),
                    Text(
                      "Charging History",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff212121),
                      ),
                    ),
                    SvgPicture.asset(
                      "assets/icons/search.svg",
                      colorFilter: ColorFilter.mode(
                        Colors.black,
                        BlendMode.srcIn,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              GridView.count(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 0,
                crossAxisSpacing: 0,
                childAspectRatio: 1.2,
                children: [
                  buildCard(
                    "assets/icons/total_energy.svg",
                    'Total Energy',
                    '132 kWh',
                  ),
                  buildCard(
                    "assets/icons/total_cost.svg",
                    'Total Cost',
                    '560 EGP',
                  ),
                  buildCard(
                    "assets/icons/total_time.svg",
                    'Total Time',
                    '14h 35m',
                  ),
                  buildCard(
                    "assets/icons/total_sessions.svg",
                    'Total Sessions',
                    '12',
                  ),
                ],
              ),
              SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Color(0xFFE9E9E9)),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: DropdownButton<String>(
                        value: 'All',
                        underline: SizedBox(),
                        isExpanded: true,
                        items: ['All']
                            .map(
                              (e) => DropdownMenuItem(
                                value: e,
                                child: Text(
                                  e,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xff606060),
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (v) {},
                      ),
                    ),
                  ),
                  SizedBox(width: 11),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Color(0xFFE9E9E9)),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 17, vertical: 12),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          "assets/icons/lets-icons_sort-arrow-light.svg",
                        ),
                        SizedBox(width: 4),
                        Text(
                          'Newest',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: 5,
                itemBuilder: (context, index) => buildSessionCard(),
              ),
              SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: Icon(
                    Icons.file_download_outlined,
                    color: Colors.white,
                    size: 27,
                  ),
                  label: Text(
                    'Download Report (PDF)',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 19,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 17),
                  ),
                  onPressed: () {},
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
