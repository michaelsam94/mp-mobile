import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';

final dummyStations = [
  Station(
    id: '1',
    type: StationType.available,
    position: LatLng(30.0444, 31.2357),
    slots: '1/4',
  ),
  Station(
    id: '2',
    type: StationType.unavailable,
    position: LatLng(30.0450, 31.2370),
    slots: '0/4',
  ),
  Station(
    id: '3',
    type: StationType.inUse,
    position: LatLng(30.0434, 31.2337),
    slots: '2/4',
  ),
  // ... add more as you wish
];

enum StationType { available, unavailable, inUse }

class Station {
  final String id;
  final StationType type;
  final LatLng position;
  final String slots;
  Station({
    required this.id,
    required this.type,
    required this.position,
    required this.slots,
  });
}

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController _mapController;
  Map<StationType, BitmapDescriptor>? _icons;
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    loadMarkerIcons().then((icons) {
      setState(() {
        _icons = icons;
        _markers = _initMarkersWithIcons(icons);
      });
    });
  }

  Set<Marker> _initMarkersWithIcons(Map<StationType, BitmapDescriptor> icons) {
    return dummyStations.map((station) {
      final icon = icons[station.type]!;
      return Marker(
        markerId: MarkerId(station.id),
        position: station.position,
        icon: icon,
        infoWindow: InfoWindow(title: station.slots),
      );
    }).toSet();
  }

  Future<BitmapDescriptor> getResizedMarker(
    String assetPath,
    int width,
    int height,
  ) async {
    ByteData data = await rootBundle.load(assetPath);
    ui.Codec codec = await ui.instantiateImageCodec(
      data.buffer.asUint8List(),
      targetWidth: width,
      targetHeight: height,
    );
    ui.FrameInfo fi = await codec.getNextFrame();
    final resizedBytes = (await fi.image.toByteData(
      format: ui.ImageByteFormat.png,
    ))!.buffer.asUint8List();
    return BitmapDescriptor.fromBytes(resizedBytes);
  }

  Future<Map<StationType, BitmapDescriptor>> loadMarkerIcons() async {
    return {
      StationType.available: await getResizedMarker(
        'assets/icons/ac.png',
        110,
        128,
      ),
      StationType.unavailable: await getResizedMarker(
        'assets/icons/unavailable.png',
        110,
        128,
      ),

      StationType.inUse: await getResizedMarker(
        'assets/icons/use.png',
        110,
        128,
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsetsGeometry.symmetric(
                horizontal: 16,
                vertical: 20,
              ),
              child: Row(
                children: [
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
                          suffixIcon: Container(
                            padding: EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 6,
                            ),
                            decoration: BoxDecoration(
                              border: BorderDirectional(
                                start: BorderSide(color: Color(0xffDCDCDC)),
                              ),
                              borderRadius: BorderRadiusDirectional.only(
                                bottomEnd: Radius.circular(11),
                                topEnd: Radius.circular(11),
                              ),
                            ),
                            child: SvgPicture.asset("assets/icons/filter.svg"),
                          ),
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(12),
                            child: SvgPicture.asset("assets/icons/search.svg"),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(11),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          filled: true,
                          fillColor: Color(0xffFBFBFB),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  SvgPicture.asset("assets/icons/notifications.svg"),
                ],
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  GoogleMap(
                    padding: const EdgeInsets.only(top: 120, bottom: 0),
                    initialCameraPosition: const CameraPosition(
                      target: LatLng(30.0444, 31.2357),
                      zoom: 13,
                    ),
                    markers: _markers,
                    onMapCreated: (ctrl) => _mapController = ctrl,
                    myLocationEnabled: true,
                    myLocationButtonEnabled: false,
                    buildingsEnabled: false,
                    compassEnabled: false,
                  ),

                  // Status Container
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      width: 170,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 15,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 16,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Station Status",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: Color(0xff242426),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              _Dot(color: Colors.green),
                              const SizedBox(width: 6),
                              const Text(
                                "Available",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xff606060),
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              _Dot(color: Colors.red),
                              const SizedBox(width: 6),
                              const Text(
                                "Unavailable",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xff606060),
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              _Dot(color: Colors.blue),
                              const SizedBox(width: 6),
                              const Text(
                                "In Use",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xff606060),
                                  fontWeight: FontWeight.w400,
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
          ],
        ),
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  final Color color;
  const _Dot({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
