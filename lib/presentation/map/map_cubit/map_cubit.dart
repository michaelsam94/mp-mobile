import 'dart:math';
import 'dart:ui' as ui;
import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mega_plus/core/helpers/network/dio_helper.dart';
import 'package:mega_plus/core/helpers/network/end_points.dart';
import 'package:mega_plus/presentation/map/map_screen.dart';
import 'package:mega_plus/presentation/map/models/map_station_response_model.dart';

part 'map_state.dart';

class MapCubit extends Cubit<MapState> {
  MapCubit() : super(MapInitial());

  static MapCubit get(context) => BlocProvider.of(context);
  @override
  Future<void> close() {
    clusterIconCache.clear();
    iconCache.clear();
    mapController?.dispose();
    return super.close();
  }

  Future<void> refreshStationsByCurrentLocation(BuildContext context) async {
    if (state is LoadingMapState) return;

    emit(RefreshingMapState());

    try {
      await initLocationAndRoute();

      if (userLatLng == null || mapController == null) {
        emit(LoadedMapState());
        return;
      }
      if (mapController != null) {
        await mapController!.animateCamera(
          CameraUpdate.newLatLngZoom(userLatLng!, max(currentZoom, 14)),
        );
      }

      mapStations.clear();
      markers.clear();

      await _fetchStations(context);

      emit(LoadedMapState());
    } catch (e) {
      emit(ErrorMapState(e.toString()));
    }
  }

  double _lastClusterZoom = -1;

  GoogleMapController? mapController;
  List<MapStationResponseModel> mapStations = [];
  Set<Marker> markers = {};
  LatLng? userLatLng;
  double currentZoom = 3.0; // بدأنا بـ zoom صغير لأن الداتا منتشرة

  Map<String, BitmapDescriptor> iconCache = {};
  bool isIconsLoaded = false;
  Map<int, BitmapDescriptor> clusterIconCache = {};
  Future<BitmapDescriptor> _getClusterIcon(int count) async {
    if (clusterIconCache.containsKey(count)) {
      return clusterIconCache[count]!;
    }

    final icon = await _createClusterIcon(count);
    clusterIconCache[count] = icon;
    return icon;
  }

  Future<void> initData(BuildContext context) async {
    if (state is LoadingMapState) return;

    emit(LoadingMapState());

    try {
      await initLocationAndRoute();

      if (!isIconsLoaded) {
        await _loadIcons();
        isIconsLoaded = true;
      }

      await _fetchStations(context);

      emit(LoadedMapState());
    } catch (e) {
      print("Error in initData: $e");
      emit(ErrorMapState(e.toString()));
    }
  }

  Future<void> initLocationAndRoute() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      userLatLng = LatLng(30.0444, 31.2357);
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        userLatLng = LatLng(30.0444, 31.2357);
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      userLatLng = LatLng(30.0444, 31.2357);
      return;
    }

    try {
      Position pos = await Geolocator.getCurrentPosition(
        timeLimit: Duration(seconds: 5),
      );
      userLatLng = LatLng(pos.latitude, pos.longitude);
    } catch (e) {
      userLatLng = LatLng(30.0444, 31.2357);
    }
  }

  Future<void> _loadIcons() async {
    try {
      iconCache['available'] = await getResizedMarker(
        'assets/icons/ac.png',
        110,
        128,
      );
      iconCache['unavailable'] = await getResizedMarker(
        'assets/icons/unavailable.png',
        110,
        128,
      );
      iconCache['inUse'] = await getResizedMarker(
        'assets/icons/use.png',
        110,
        128,
      );
    } catch (e) {
      print("Error loading icons: $e");
      iconCache['available'] = BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueGreen,
      );
      iconCache['unavailable'] = BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueRed,
      );
      iconCache['inUse'] = BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueBlue,
      );
    }
  }

  Future<void> _fetchStations(BuildContext context) async {
    if (userLatLng == null) return;

    try {
      var response = await DioHelper.getData(
        url: EndPoints.getMapStations(
          userLatLng!.latitude,
          userLatLng!.longitude,
        ),
      ).timeout(Duration(seconds: 10));

      print("-" * 25);
      print(response.data);

      if (response.statusCode == 200 && response.data["success"] == true) {
        var data = response.data["data"] as List;
        mapStations = data
            .map((e) => MapStationResponseModel.fromJson(e))
            .toList();

        // Create initial clustered markers
        await _updateClusters(context);
      }
    } catch (e) {
      print("Error fetching stations: $e");
    }
  }

  bool _didSetInitialCamera = false;

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;

    if (!_didSetInitialCamera && userLatLng != null) {
      _didSetInitialCamera = true;

      mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(
          userLatLng!,
          14, // الزوم اللي انت عاوزه
        ),
      );
    }
  }

  // void _fitBoundsToStations() {
  //   if (mapStations.isEmpty || mapController == null) return;

  //   double minLat = double.parse(mapStations.first.latitude!);
  //   double maxLat = userLatLng!.latitude;
  //   double minLng = double.parse(mapStations.first.longitude!);
  //   double maxLng = userLatLng!.longitude;

  //   // for (var station in mapStations) {
  //   //   if (double.parse(station.latitude!) < minLat)
  //   //     minLat = double.parse(station.latitude!);
  //   //   if (double.parse(station.latitude!) > maxLat)
  //   //     maxLat = double.parse(station.latitude!);
  //   //   if (double.parse(station.longitude!) < minLng)
  //   //     minLng = double.parse(station.longitude!);
  //   //   if (double.parse(station.longitude!) > maxLng)
  //   //     maxLng = double.parse(station.longitude!);
  //   // }

  //   mapController!
  //       .animateCamera(
  //         CameraUpdate.newLatLngBounds(
  //           LatLngBounds(
  //             southwest: LatLng(minLat, minLng),
  //             northeast: LatLng(maxLat, maxLng),
  //           ),
  //           50, // padding
  //         ),
  //       )
  //       .then((_) {
  //         mapController!.animateCamera(CameraUpdate.zoomBy(12));
  //       });
  // }

  // -------------------------------------------------------
  // CLUSTERING
  // -------------------------------------------------------

  void onCameraMove(CameraPosition position) {
    currentZoom = position.zoom;
  }

  void onCameraIdle(BuildContext context) async {
    if ((currentZoom - _lastClusterZoom).abs() < 0.3) return;

    _lastClusterZoom = currentZoom;
    await _updateClusters(context);
    emit(LoadedMapState());
  }

  Future<void> _updateClusters(BuildContext context) async {
    if (mapStations.isEmpty) return;

    // الـ clustering radius بناءً على الـ zoom
    double clusterRadiusInKm = _getClusterRadiusInKm(currentZoom);

    print("Current zoom: $currentZoom, Cluster radius: $clusterRadiusInKm km");

    List<_StationCluster> clusters = [];

    for (var station in mapStations) {
      bool addedToCluster = false;

      for (var cluster in clusters) {
        double distance = _calculateDistanceInKm(
          double.parse(station.latitude!),
          double.parse(station.longitude!),
          cluster.centerLat,
          cluster.centerLon,
        );

        if (distance <= clusterRadiusInKm) {
          cluster.stations.add(station);
          // Update cluster center to average
          cluster.updateCenter();
          addedToCluster = true;
          break;
        }
      }

      if (!addedToCluster) {
        clusters.add(
          _StationCluster(
            centerLat: double.parse(station.latitude!),
            centerLon: double.parse(station.longitude!),
            stations: [station],
          ),
        );
      }
    }

    print("Total clusters: ${clusters.length}");

    // إنشاء الـ markers
    Set<Marker> newMarkers = {};

    for (int i = 0; i < clusters.length; i++) {
      var cluster = clusters[i];

      if (cluster.stations.length == 1) {
        // Single marker
        var station = cluster.stations.first;
        newMarkers.add(
          Marker(
            markerId: MarkerId('station_${station.id}'),
            position: LatLng(
              double.parse(station.latitude!),
              double.parse(station.longitude!),
            ),
            icon: iconCache[station.status] ?? BitmapDescriptor.defaultMarker,
            infoWindow: InfoWindow(
              title: station.name,
              snippet:
                  '${station.totalGunsFormat} - ${double.parse(station.distance ?? "0").toStringAsFixed(0)} km',
            ),
            onTap: () {
              showStationBottomSheet(station,context);
            },
          ),
        );
      } else {
        // Cluster marker
        newMarkers.add(
          Marker(
            markerId: MarkerId('cluster_$i'),
            position: LatLng(cluster.centerLat, cluster.centerLon),
            icon: await _getClusterIcon(cluster.stations.length),
            infoWindow: InfoWindow(
              title: '${cluster.stations.length} Stations',
              snippet: 'Tap to zoom in',
            ),
            onTap: () async {
              // Zoom in to the cluster
              if (mapController != null) {
                await mapController!.animateCamera(
                  CameraUpdate.newLatLngZoom(
                    LatLng(cluster.centerLat, cluster.centerLon),
                    min(currentZoom + 3, 20), // زود الـ zoom بـ 3
                  ),
                );
              }
            },
          ),
        );
      }
    }

    markers = newMarkers;
  }

  // Todo if  near
  double _getClusterRadiusInKm(double zoom) {
    if (zoom >= 18) return 0.01; // 10 متر
    if (zoom >= 16) return 0.05; // 50 متر
    if (zoom >= 14) return 0.2; // 200 متر
    if (zoom >= 12) return 1; // 1 كم
    if (zoom >= 10) return 5; // 5 كم
    if (zoom >= 8) return 20; // 20 كم
    if (zoom >= 6) return 80; // 80 كم
    if (zoom >= 4) return 250; // 250 كم
    return 500; // 500 كم للـ zoom البعيد جداً
  }

  //Todo if mid far
  // double _getClusterRadiusInKm(double zoom) {
  //   // كلما زاد الـ zoom، قل الـ clustering
  //   if (zoom >= 18) return 0.02; // 20 متر فقط
  //   if (zoom >= 16) return 0.1; // 100 متر
  //   if (zoom >= 14) return 0.5; // 500 متر
  //   if (zoom >= 12) return 2; // 2 كم (بدل 10)
  //   if (zoom >= 10) return 10; // 10 كم (بدل 50)
  //   if (zoom >= 8) return 50; // 50 كم (بدل 200)
  //   if (zoom >= 6) return 150; // 150 كم (بدل 500)
  //   if (zoom >= 4) return 500; // 500 كم (بدل 1500)
  //   return 1000; // 1000 كم (بدل 3000)
  // }

  //Todo if so far
  // double _getClusterRadiusInKm(double zoom) {
  //   // كلما زاد الـ zoom، قل الـ clustering
  //   if (zoom >= 18) return 0.05; // 50 متر
  //   if (zoom >= 16) return 0.2; // 200 متر
  //   if (zoom >= 14) return 1; // 1 كم
  //   if (zoom >= 12) return 10; // 10 كم
  //   if (zoom >= 10) return 50; // 50 كم
  //   if (zoom >= 8) return 200; // 200 كم
  //   if (zoom >= 6) return 500; // 500 كم
  //   if (zoom >= 4) return 1500; // 1500 كم
  //   return 3000; // 3000 كم للـ zoom الصغير جداً
  // }

  double _calculateDistanceInKm(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    // Haversine formula
    const double earthRadiusKm = 6371;

    double dLat = _toRadians(lat2 - lat1);
    double dLon = _toRadians(lon2 - lon1);

    double a =
        sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRadians(lat1)) *
            cos(_toRadians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);

    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadiusKm * c;
  }

  double _toRadians(double degree) {
    return degree * pi / 180;
  }

  Future<BitmapDescriptor> _createClusterIcon(int count) async {
    final PictureRecorder pictureRecorder = PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final double size = 90.0;

    // رسم الدائرة
    final Paint circlePaint = Paint()
      ..color = Color(0xFF2196F3)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(size / 2, size / 2), size / 2, circlePaint);

    // رسم الحدود
    final Paint borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10.0;

    canvas.drawCircle(Offset(size / 2, size / 2), size / 2 - 5, borderPaint);

    // رسم النص
    TextPainter textPainter = TextPainter(textDirection: ui.TextDirection.ltr);
    textPainter.text = TextSpan(
      text: count.toString(),
      style: TextStyle(
        fontSize: size / 2.2,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    );

    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        size / 2 - textPainter.width / 2,
        size / 2 - textPainter.height / 2,
      ),
    );

    final img = await pictureRecorder.endRecording().toImage(
      size.toInt(),
      size.toInt(),
    );
    final data = await img.toByteData(format: ui.ImageByteFormat.png);

    return BitmapDescriptor.fromBytes(data!.buffer.asUint8List());
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
}

// -------------------------------------------------------
// HELPER CLASS
// -------------------------------------------------------

class _StationCluster {
  double centerLat;
  double centerLon;
  List<MapStationResponseModel> stations;

  _StationCluster({
    required this.centerLat,
    required this.centerLon,
    required this.stations,
  });

  void updateCenter() {
    // احسب متوسط الموقع لكل الـ stations في الـ cluster
    double sumLat = 0;
    double sumLon = 0;

    for (var station in stations) {
      sumLat += double.parse(station.latitude!);
      sumLon += double.parse(station.longitude!);
    }

    centerLat = sumLat / stations.length;
    centerLon = sumLon / stations.length;
  }
}
