import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mega_plus/core/helpers/addons_functions.dart';
import 'package:mega_plus/core/style/app_colors.dart';

class NavigationScreen extends StatefulWidget {
  final LatLng stationLatLng;
  final String stationName;
  final String stationAddress;

  const NavigationScreen({
    required this.stationLatLng,
    required this.stationName,
    required this.stationAddress,
    super.key,
  });

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  GoogleMapController? mapController;
  Set<Polyline> polylines = {};
  Set<Marker> markers = {};
  LatLng? userLatLng;
  double distanceKm = 0;
  int durationMin = 0;
  double batteryPercent = 45; // for demo

  @override
  void initState() {
    super.initState();
    _initLocationAndRoute();
    Geolocator.getPositionStream().listen((Position pos) {
      setState(() {
        userLatLng = LatLng(pos.latitude, pos.longitude);
      });
      _updateRoute();
    });
  }

  Future<void> _initLocationAndRoute() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.',
      );
    }
    Position pos = await Geolocator.getCurrentPosition();
    setState(() {
      userLatLng = LatLng(pos.latitude, pos.longitude);
    });
    _updateRoute();
  }

  Future<void> _updateRoute() async {
    if (userLatLng == null) return;

    print("Get Data");

    // final apiKey = 'AIzaSyDN_RL4wAIlysTnHLflgdZ5piV82otKeMI';
    // final url =
    //     'https://maps.googleapis.com/maps/api/directions/json?origin=${userLatLng!.latitude},${userLatLng!.longitude}&destination=${widget.stationLatLng.latitude},${widget.stationLatLng.longitude}&mode=driving&key=$apiKey';

    // try {
    //   final response = await http.get(Uri.parse(url));
    //   if (response.statusCode == 200) {
    //     final body = json.decode(response.body);

    //     if (body['routes'].isNotEmpty) {
    //       final points = body['routes'][0]['overview_polyline']['points'];
    //       final polylinePoints = _decodePoly(points);

    //       setState(() {
    //         polylines = {
    //           Polyline(
    //             polylineId: PolylineId('route'),
    //             points: polylinePoints,
    //             color: Colors.green,
    //             width: 6,
    //           ),
    //         };
    //         markers = {
    //           Marker(
    //             markerId: MarkerId('user'),
    //             position: userLatLng!,
    //             icon: BitmapDescriptor.defaultMarkerWithHue(
    //               BitmapDescriptor.hueAzure,
    //             ),
    //           ),
    //           Marker(
    //             markerId: MarkerId('station'),
    //             position: widget.stationLatLng,
    //             icon: BitmapDescriptor.defaultMarkerWithHue(
    //               BitmapDescriptor.hueGreen,
    //             ),
    //           ),
    //         };
    //         final legs = body['routes'][0]['legs'][0];
    //         distanceKm = legs['distance']['value'] / 1000.0;
    //         durationMin = (legs['duration']['value'] / 60.0).round();
    //       });
    //     }
    //   } else {
    //     log(response.body, name: "TAG");
    //   }
    // } catch (e) {
    //   log(e.toString(), name: "TAG");
    // }
  }

  List<LatLng> _decodePoly(String poly) {
    List<LatLng> points = [];
    int index = 0, len = poly.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = poly.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = poly.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      points.add(LatLng(lat / 1E5, lng / 1E5));
    }
    return points;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: userLatLng == null
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                SizedBox(
                  height: 350,
                  child: Stack(
                    children: [
                      GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: userLatLng!,
                          zoom: 14,
                        ),
                        markers: markers,
                        polylines: polylines,
                        onMapCreated: (ctrl) {
                          mapController = ctrl;
                        },
                        myLocationEnabled: true,
                        myLocationButtonEnabled: false,
                        zoomControlsEnabled: false,
                      ),
                      // Positioned(
                      //   top: 40,
                      //   right: 125,
                      //   child: Container(
                      //     padding: EdgeInsets.symmetric(
                      //       horizontal: 14,
                      //       vertical: 7,
                      //     ),
                      //     decoration: BoxDecoration(
                      //       color: Colors.green,
                      //       borderRadius: BorderRadius.circular(16),
                      //     ),
                      //     child: Row(
                      //       children: [
                      //         Icon(
                      //           Icons.ev_station,
                      //           size: 19,
                      //           color: Colors.white,
                      //         ),
                      //         SizedBox(width: 6),
                      //         Text(
                      //           "${batteryPercent.toInt()}%",
                      //           style: TextStyle(
                      //             color: Colors.white,
                      //             fontWeight: FontWeight.bold,
                      //           ),
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                      // Station Name Overlay
                      Positioned(
                        left: 25,
                        bottom: 25,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(color: Colors.black12, blurRadius: 8),
                            ],
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.location_on, color: AppColors.primary),
                              SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Destination",
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    widget.stationName,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 14),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${durationMin} min  (${distanceKm.toStringAsFixed(1)} km)",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(
                        "Fastest Route now due to traffic conditions",
                        style: TextStyle(fontSize: 13),
                      ),
                      SizedBox(height: 22),
                      SizedBox(
                        width: context.width(),
                        height: 30,
                        child: Stack(
                          children: [
                            Align(
                              alignment: AlignmentGeometry.centerLeft,
                              child: Container(
                                width: context.width() * .5,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                            ),
                            Positioned(
                              child: SvgPicture.asset(
                                "assets/icons/naviagtion.svg",
                              ),
                            ),

                            Align(
                              alignment: AlignmentGeometry.centerRight,
                              child: Container(
                                width: context.width() * .5,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(73, 7, 195, 85),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 8),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 22,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Text(
                          "${batteryPercent.toInt()}%",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      _locationTile(
                        icon: Icons.radio_button_checked,
                        label: '10 Almotlqa Alaraby, Sheraton, Cairo',
                      ),
                      _locationTile(
                        icon: Icons.location_on,
                        label: widget.stationAddress,
                        bold: true,
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _locationTile({
    required IconData icon,
    required String label,
    bool bold = false,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 10, top: 3),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.green, size: 21),
          SizedBox(width: 7),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontWeight: bold ? FontWeight.bold : FontWeight.w400,
                color: bold ? Colors.black87 : Colors.grey[900],
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
