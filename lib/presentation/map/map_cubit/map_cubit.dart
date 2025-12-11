import 'dart:math';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:mega_plus/core/helpers/network/dio_helper.dart';
import 'package:mega_plus/core/helpers/network/end_points.dart';
import 'package:mega_plus/presentation/map/models/map_station_response_model.dart';

part 'map_state.dart';

class MapCubit extends Cubit<MapState> {
  MapCubit() : super(MapInitial());

  static MapCubit get(context) => BlocProvider.of(context);

  late GoogleMapController mapController;
  Map<String, BitmapDescriptor>? _icons;

  /// All stations as received from API
  List<MapStationResponseModel> mapStations = [];

  /// Final clustered markers
  Set<Marker> markers = {};

  LatLng? userLatLng;

  // Track camera zoom for clustering
  double currentZoom = 13;

  // -------------------------------------------------------
  // INIT
  // -------------------------------------------------------

  void initState(BuildContext context) async {
    emit(LoadingMapState());
    

    try {
      await _initLocationAndRoute();

      await mapController.animateCamera(CameraUpdate.newLatLng(
          LatLng(userLatLng!.latitude, userLatLng!.longitude)));

      var response = await DioHelper.getData(
          url: EndPoints.getMapStations(
              userLatLng!.latitude, userLatLng!.longitude));

              

      if (response.statusCode == 200 && response.data["success"] == true) {
        var data = response.data["data"] as List;
        mapStations =
            data.map((e) => MapStationResponseModel.fromJson(e)).toList();

        loadMarkerIcons().then((icons) {
          _icons = icons;

          /// Build initial markers without clustering
          _applyClustering();

          emit(UpdatedMapState());
        });
      } else {
        emit(UpdatedMapState());
      }
    } catch (e) {
      emit(UpdatedMapState());
    }
  }

  Future<void> _initLocationAndRoute() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    if (permission == LocationPermission.deniedForever) return;

    Position pos = await Geolocator.getCurrentPosition();
    userLatLng = LatLng(pos.latitude, pos.longitude);
  }

  // -------------------------------------------------------
  // CLUSTERING LOGIC
  // -------------------------------------------------------

  /// Called when map moves
  void onCameraMove(CameraPosition position) {
    currentZoom = position.zoom;
  }

  /// Called when map stops moving
  void onCameraIdle() {
    _applyClustering();
    emit(UpdatedMapState());
  }

  /// Main cluster method
  void _applyClustering() {
    if (_icons == null) return;

    double clusterDistance = _zoomToClusterDistance(currentZoom);
    List<List<MapStationResponseModel>> finalClusters = [];

    for (var station in mapStations) {
      bool added = false;

      for (var cluster in finalClusters) {
        if (_distance(
                station.latitude!, station.longitude!,
                cluster.first.latitude!, cluster.first.longitude!) <
            clusterDistance) {
          cluster.add(station);
          added = true;
          break;
        }
      }

      if (!added) {
        finalClusters.add([station]);
      }
    }

    /// Now build final marker set
    Set<Marker> result = {};

    for (var group in finalClusters) {
      if (group.length == 1) {
        // normal marker
        final s = group.first;
        final icon = _icons![s.status]!;

        result.add(
          Marker(
            markerId: MarkerId("${s.id}"),
            position: LatLng(s.latitude!, s.longitude!),
            icon: icon,
            onTap: () {},
          ),
        );
      } else {
        // cluster marker
        final s = group.first;
        result.add(
          Marker(
            markerId: MarkerId("cluster_${s.id}"),
            position: LatLng(s.latitude!, s.longitude!),
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueAzure),
            infoWindow: InfoWindow(title: "${group.length} stations"),
          ),
        );
      }
    }

    markers = result;
  }

  // Convert zoom → clustering radius
  double _zoomToClusterDistance(double zoom) {
    return 500000 / pow(2, zoom); // tweak to adjust cluster sensitivity
  }

  // Rough distance in meters between two latLngs
  double _distance(double lat1, double lon1, double lat2, double lon2) {
    final dx = lat1 - lat2;
    final dy = lon1 - lon2;
    return sqrt(dx * dx + dy * dy) * 111000;
  }

  // -------------------------------------------------------
  // ICON LOADING
  // -------------------------------------------------------

  Future<Map<String, BitmapDescriptor>> loadMarkerIcons() async {
    Map<String, BitmapDescriptor> data = {};

    for (var element in mapStations) {
      data[element.status!] = await getResizedMarker(
        element.status == "available"
            ? 'assets/icons/ac.png'
            : element.status == "unavailable"
                ? 'assets/icons/unavailable.png'
                : 'assets/icons/use.png',
        110,
        128,
      );
    }

    return data;
  }

  Future<BitmapDescriptor> getResizedMarker(
      String assetPath, int width, int height) async {
    ByteData data = await rootBundle.load(assetPath);
    ui.Codec codec = await ui.instantiateImageCodec(
      data.buffer.asUint8List(),
      targetWidth: width,
      targetHeight: height,
    );
    ui.FrameInfo fi = await codec.getNextFrame();
    final resizedBytes =
        (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
            .buffer
            .asUint8List();
    return BitmapDescriptor.fromBytes(resizedBytes);
  }
}
