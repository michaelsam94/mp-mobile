import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:mega_plus/core/helpers/network/dio_helper.dart';
import 'package:mega_plus/core/helpers/network/end_points.dart';
import 'package:mega_plus/presentation/map/models/map_station_response_model.dart';
import 'package:mega_plus/presentation/map/station_details_bottom_sheet.dart';

import 'package:meta/meta.dart';

part 'map_state.dart';

class MapCubit extends Cubit<MapState> {
  MapCubit() : super(MapInitial());

  static MapCubit get(context) => BlocProvider.of(context);

  late GoogleMapController mapController;
  Map<String, BitmapDescriptor>? _icons;
  Set<Marker> markers = {};

  List<MapStationResponseModel> mapStations = [];

  void initState(BuildContext context) async {
    emit(LoadingMapState());

    try {
      var response = await DioHelper.getData(url: EndPoints.getMapStations);
      if (response.statusCode == 200 && response.data["success"] == true) {
        var data = response.data["data"] as List;
        mapStations = data
            .map((e) => MapStationResponseModel.fromJson(e))
            .toList();
        loadMarkerIcons().then((icons) {
          _icons = icons;
          markers = _initMarkersWithIcons(icons, context);
          emit(UpdatedMapState());
        });
      } else {
        emit(UpdatedMapState());
      }
    } catch (e) {
      emit(UpdatedMapState());
    }
  }

  Set<Marker> _initMarkersWithIcons(
    Map<String, BitmapDescriptor> icons,
    BuildContext context,
  ) {
    return mapStations.map((station) {
      final icon = icons[station.status]!;
      return Marker(
        onTap: () {
          // final station = {
          //   'name': 'Cillout Mansoura',
          //   'address': '15 Tahrir Street, Downtown, Cairo',
          //   'mins': '7 Mins',
          //   'distance': '2.6 km',
          //   'status': 'Available',
          //   'isOpen': true,
          //   'openHours': '24 hours',
          //   'image': 'assets/images/onboarding1.png',
          //   'connectors': [
          //     {
          //       'type': 'Type 2',
          //       'kw': 22,
          //       'pricePerKw': 25,
          //       'description': 'Connector no/name',
          //       'actionText': 'Click to charge',
          //       'actionColor': 0xFF24C064,
          //     },
          //     {
          //       'type': 'Type 2',
          //       'kw': 50,
          //       'pricePerKw': 25,
          //       'description': 'Connector no/name',
          //       'actionText': 'Click to charge',
          //       'actionColor': 0xFF24C064,
          //     },
          //   ],
          // };
          // showStationDetails(context, station);
        },
        markerId: MarkerId("${station.id}"),
        position: LatLng(station.latitude!, station.longitude!),
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

  Future<Map<String, BitmapDescriptor>> loadMarkerIcons() async {
    Map<String, BitmapDescriptor> data = {};

    for (var element in mapStations) {
      data.addAll({
        element.status!: await getResizedMarker(
          element.status == "available"
              ? 'assets/icons/ac.png'
              : element.status == "unavailable"
              ? 'assets/icons/unavailable.png'
              : 'assets/icons/use.png',
          110,
          128,
        ),
      });
    }

    //  {
    // StationType.available: await getResizedMarker(
    //   'assets/icons/ac.png',
    //   110,
    //   128,
    // ),
    //   StationType.unavailable: await getResizedMarker(
    //     'assets/icons/unavailable.png',
    //     110,
    //     128,
    //   ),
    //   StationType.inUse: await getResizedMarker(
    //     'assets/icons/use.png',
    //     110,
    //     128,
    //   ),
    // };
    return data;
  }
}

// final dummyStations = [
//   Station(
//     id: '1',
//     type: StationType.available,
//     position: LatLng(30.0444, 31.2357),
//     slots: '1/4',
//   ),
//   Station(
//     id: '2',
//     type: StationType.unavailable,
//     position: LatLng(30.0450, 31.2370),
//     slots: '0/4',
//   ),
//   Station(
//     id: '3',
//     type: StationType.inUse,
//     position: LatLng(30.0434, 31.2337),
//     slots: '2/4',
//   ),
//   // ... add more as you wish
// ];

// enum StationType { available, unavailable, inUse }

// class Station {
//   final String id;
//   final StationType type;
//   final LatLng position;
//   final String slots;
//   Station({
//     required this.id,
//     required this.type,
//     required this.position,
//     required this.slots,
//   });
// }
