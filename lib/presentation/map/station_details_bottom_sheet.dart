import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mega_plus/core/helpers/addons_functions.dart';
import 'package:mega_plus/core/style/app_colors.dart';
import 'package:mega_plus/presentation/map/navigation_screen.dart';
import 'package:mega_plus/presentation/map/qr_code_scanner_screen.dart';

class StationDetailsSheet extends StatelessWidget {
  final Map<String, dynamic> station;

  const StationDetailsSheet({required this.station, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // If you want rounded top corners
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 8),
            Text(
              'Station Details',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 18),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                "assets/images/onboarding1.png", // Replace with your station-details image
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 18),
            Row(
              children: [
                _statusBadge('Available'),
                SizedBox(width: 12),
                Text(
                  'Opens 24 hours',
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Row(
              children: [
                SvgPicture.asset(
                  "assets/icons/charger.svg",
                  width: 32,
                  color: AppColors.primary,
                ),
                SizedBox(width: 6),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      station['name'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        color: AppColors.primary,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      station['address'],
                      style: TextStyle(color: Colors.grey[800], fontSize: 14),
                    ),
                    SizedBox(height: 2),
                    Row(
                      children: [
                        SvgPicture.asset("assets/icons/car.svg", height: 14),
                        SizedBox(width: 3),
                        Text(station['mins'], style: TextStyle(fontSize: 13)),
                        SizedBox(width: 12),
                        SvgPicture.asset(
                          "assets/icons/distance.svg",
                          height: 14,
                        ),
                        SizedBox(width: 3),
                        Text(
                          station['distance'],
                          style: TextStyle(fontSize: 13),
                        ),
                      ],
                    ),
                  ],
                ),
                Spacer(),
                InkWell(
                  onTap: () {
                    context.goTo(
                      NavigationScreen(
                        stationLatLng: LatLng(30.049112, 31.239674),
                        stationName: "Cillout Mansoura",
                        stationAddress: "15 Tahrir Street, Downtown, Cairo",
                      ),
                    );
                  },
                  child: SvgPicture.asset(
                    "assets/icons/navigation.svg",
                    width: 32,
                  ),
                ),
              ],
            ),
            SizedBox(height: 18),
            Divider(height: 1, color: Color(0xffE6ECEF)),
            SizedBox(height: 18),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Connectors Types',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            SizedBox(height: 12),
            Column(
              children: (station['connectors'] as List)
                  .map<Widget>(
                    (connector) => ConnectorCard(connector: connector),
                  )
                  .toList(),
            ),
          ],
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
        colorBG = Color(0xffE6F9EE);
        break;
      case 'In Use':
        colorText = Color(0xff1261FF);
        colorBG = Color(0xffE8EFFF);
        break;
      case 'Unavailable':
        colorText = Color(0xffC31D07);
        colorBG = Color(0xffFFEAE7);
        break;
      default:
        colorText = Colors.grey.shade300;
        colorBG = Colors.grey.shade300;
    }
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: colorBG,
        borderRadius: BorderRadius.circular(12),
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

class ConnectorCard extends StatelessWidget {
  final Map connector;

  const ConnectorCard({required this.connector, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          Column(
            children: [
              SvgPicture.asset("assets/icons/charger.svg"),
              SizedBox(height: 2),
              Text(
                '${connector['kw']}kw',
                style: TextStyle(fontSize: 13, color: Colors.grey),
              ),
            ],
          ),
          SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                connector['type'],
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 2),
              Text(
                "Connector no/name",
                style: TextStyle(fontSize: 13, color: Colors.grey[700]),
              ),
              Text(
                "25 EGP/KW",
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.green[700],
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          Spacer(),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF24C064),
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 0,
            ),
            onPressed: () {
              context.goTo(QrCodeScannerScreen());
            },
            child: Text(
              "Click to charge",
              style: TextStyle(fontSize: 13, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

void showStationDetails(BuildContext context, Map<String, dynamic> station) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => StationDetailsSheet(station: station),
  );
}
