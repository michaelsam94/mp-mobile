import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';

import 'package:meta/meta.dart';

part 'map_state.dart';

class MapCubit extends Cubit<MapState> {
  MapCubit() : super(MapInitial());

  static MapCubit get(context) => BlocProvider.of(context);

  late GoogleMapController mapController;
  Map<StationType, BitmapDescriptor>? _icons;
  Set<Marker> markers = {};

  void initState() {
    emit(LoadingMapState());
    loadMarkerIcons().then((icons) {
      _icons = icons;
      markers = _initMarkersWithIcons(icons);
      emit(UpdatedMapState());
    });
  }

  Set<Marker> _initMarkersWithIcons(Map<StationType, BitmapDescriptor> icons) {
    return dummyStations.map((station) {
      final icon = icons[station.type]!;
      return Marker(
        onTap: () {
          print("Hello Tapped");
        },
        markerId: MarkerId(station.id),
        position: station.position,
        icon: icon,
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
}

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
