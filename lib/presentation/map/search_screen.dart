import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mega_plus/core/style/app_colors.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final stations = [
      {
        'name': 'Cillout Mansoura',
        'address': '15 Tahrir Street, Downtown, Cairo',
        'mins': '7 Mins',
        'distance': '2.6 km',
        'connectors': [
          {'type': 'Type 2', 'kw': 22, 'status': 'Available'},
          {'type': 'Combo CCS', 'kw': 50, 'status': 'Available'},
        ],
      },
      {
        'name': 'Cillout Mansoura',
        'address': '15 Tahrir Street, Downtown, Cairo',
        'mins': '7 Mins',
        'distance': '2.6 km',
        'connectors': [
          {'type': 'Type 2', 'kw': 22, 'status': 'Available'},
          {'type': 'Combo CCS', 'kw': 50, 'status': 'Available'},
        ],
      },
      {
        'name': 'Cillout Mansoura',
        'address': '15 Tahrir Street, Downtown, Cairo',
        'mins': '7 Mins',
        'distance': '2.6 km',
        'connectors': [
          {'type': 'Type 2', 'kw': 22, 'status': 'In Use'},
          {'type': 'Combo CCS', 'kw': 50, 'status': 'In Use'},
        ],
      },
      {
        'name': 'Cillout Mansoura',
        'address': '15 Tahrir Street, Downtown, Cairo',
        'mins': '7 Mins',
        'distance': '2.6 km',
        'connectors': [
          {'type': 'Type 2', 'kw': 22, 'status': 'Available'},
          {'type': 'Combo CCS', 'kw': 50, 'status': 'Unavailable'},
        ],
      },
    ];

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    BackButton(),
                    Expanded(
                      child: Container(
                        height: 46,
                        decoration: BoxDecoration(
                          color: Color(0xffFBFBFB),
                          borderRadius: BorderRadius.circular(11),
                        ),
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Search your Model',
                            hintStyle: const TextStyle(
                              fontSize: 14,
                              color: Color(0xffB6B6B6),
                            ),
                            contentPadding: const EdgeInsets.all(16),

                            prefixIcon: Padding(
                              padding: const EdgeInsets.all(12),
                              child: SvgPicture.asset(
                                "assets/icons/search.svg",
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(11),
                              borderSide: BorderSide(
                                color: Colors.grey.shade300,
                              ),
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(11),
                              borderSide: BorderSide(
                                color: Colors.grey.shade300,
                              ),
                            ),
                            filled: true,
                            fillColor: Color(0xffFBFBFB),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Container(
                      width: 48,
                      height: 48,
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: SvgPicture.asset(
                        "assets/icons/filter.svg",
                        colorFilter: ColorFilter.mode(
                          Colors.white,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 12),
                itemCount: stations.length,
                itemBuilder: (context, index) {
                  final station = stations[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 2,
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _statusBadge('Available'),
                              Icon(
                                Icons.star_border,
                                color: AppColors.primary,
                                size: 24,
                              ),
                            ],
                          ), // main badge at top
                          SizedBox(height: 16),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(width: 8),
                              Image.asset(
                                "assets/icons/ac.png",
                                height: 48,
                                width: 39,
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      station['name'].toString(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                    Text(
                                      station['address'].toString(),
                                      style: TextStyle(
                                        color: Colors.grey[700],
                                        fontSize: 15,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        SvgPicture.asset(
                                          "assets/icons/car.svg",
                                        ),
                                        SizedBox(width: 3),
                                        Text(
                                          station['mins'].toString(),
                                          style: TextStyle(fontSize: 13),
                                        ),
                                        SizedBox(width: 12),
                                        SvgPicture.asset(
                                          "assets/icons/distance.svg",
                                        ),

                                        SizedBox(width: 3),
                                        Text(
                                          station['distance'].toString(),
                                          style: TextStyle(fontSize: 13),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SvgPicture.asset("assets/icons/navigation.svg"),
                            ],
                          ),
                          SizedBox(height: 16),
                          Divider(color: Color(0xffE6ECEF)),
                          SizedBox(height: 16),
                          Text(
                            'Connectors Types',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          SizedBox(height: 16),
                          Column(
                            children: (station['connectors'] as List)
                                .map<Widget>((connector) {
                                  return Container(
                                    margin: EdgeInsets.only(bottom: 12),
                                    child: Row(
                                      children: [
                                        Column(
                                          children: [
                                            SvgPicture.asset(
                                              "assets/icons/charger.svg",
                                            ),
                                            Text(
                                              '${connector['kw']}kw',
                                              style: TextStyle(
                                                fontSize: 13,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(width: 16),
                                        Container(
                                          width: 1,
                                          color: Color(0xffE6ECEF),
                                          height: 30,
                                        ),
                                        SizedBox(width: 16),
                                        SvgPicture.asset(
                                          "assets/icons/comboccs.svg",
                                        ),
                                        SizedBox(width: 4),
                                        Text(
                                          '${connector['type']}',
                                          style: TextStyle(fontSize: 15),
                                        ),
                                        SizedBox(width: 8),
                                        Spacer(),
                                        _statusBadge(connector['status']),
                                      ],
                                    ),
                                  );
                                })
                                .toList(),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statusBadge(String status) {
    Color colorBG;
    Color colorText;
    switch (status) {
      case 'Available':
        colorText = Color(0xff058A3C);
        break;
      case 'In Use':
        colorText = Color(0xff1261FF);
        break;
      case 'Unavailable':
        colorText = Color(0xffC31D07);
        break;
      default:
        colorText = Colors.grey.shade300;
    }
    switch (status) {
      case 'Available':
        colorBG = Color(0xffE6F9EE);
        break;
      case 'In Use':
        colorBG = Color(0xffE8EFFF);
        break;
      case 'Unavailable':
        colorBG = Color(0xffFFEAE7);
        break;
      default:
        colorBG = Colors.grey.shade300;
    }
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: colorBG,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 12,
          color: colorText,
        ),
      ),
    );
  }
}
