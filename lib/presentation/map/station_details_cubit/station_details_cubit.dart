import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mega_plus/core/helpers/cache/cache_helper.dart';
import 'package:mega_plus/core/helpers/network/dio_helper.dart';
import 'package:mega_plus/core/helpers/network/end_points.dart';
import 'package:mega_plus/presentation/map/map_cubit/map_cubit.dart';
import 'package:mega_plus/presentation/map/models/station_response_model.dart';
import 'package:mega_plus/presentation/map/search_cubit/search_cubit.dart';
import 'package:meta/meta.dart';

part 'station_details_state.dart';

class StationDetailsCubit extends Cubit<StationDetailsState> {
  StationDetailsCubit() : super(StationDetailsInitial());

  static StationDetailsCubit get(context) => BlocProvider.of(context);

  StationResponseModel? currentStation;

  void getStationDetails(int stationId) async {
    emit(LoadingStationDetailsState());
    try {
      var response = await DioHelper.getData(
        url: EndPoints.getStationDetails(stationId),
        auth: CacheHelper.checkLogin() == 3, // Add token if user is logged in
      );

      if (response.statusCode == 200 && response.data["success"] == true) {
        var data = response.data["data"];
        var station = StationResponseModel.fromJson(data);
        currentStation = station;
        emit(SuccessStationDetailsState(station));
      } else {
        emit(ErrorStationDetailsState(
          response.data["message"] ?? "Failed to load station details",
        ));
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching station details: $e");
      }
      emit(ErrorStationDetailsState("Failed to load station details"));
    }
  }

  // Add/remove station from favorites
  Future<bool> favStation(bool isFav, int id, {BuildContext? context}) async {
    try {
      bool success = false;
      if (isFav) {
        // Add to favorites - POST request
        var response = await DioHelper.postData(
          url: "/api/stations/$id/favourite",
        );
        if (response.statusCode! >= 200 && response.statusCode! <= 300) {
          success = true;
        }
      } else {
        // Remove from favorites - DELETE request
        var response = await DioHelper.deleteData(
          url: "/api/stations/$id/favourite",
        );
        if (response.statusCode! >= 200 && response.statusCode! <= 300) {
          success = true;
        }
      }

      if (success) {
        // Update local state
        if (currentStation != null && currentStation!.id == id) {
          currentStation!.isFavourite = isFav;
          emit(SuccessStationDetailsState(currentStation!));
        }

        // Update cached lists in MapCubit and SearchCubit if context is provided
        if (context != null) {
          try {
            MapCubit.get(context).updateStationFavorite(id, isFav);
          } catch (e) {
            // MapCubit might not be available, ignore
          }
          try {
            SearchCubit.get(context).updateStationFavorite(id, isFav);
          } catch (e) {
            // SearchCubit might not be available, ignore
          }
        }

        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  // Normalize OCPP status to app format
  String _normalizeOcppStatus(String status) {
    final statusLower = status.toLowerCase();

    // Map OCPP statuses to app format
    switch (statusLower) {
      case 'available':
        return 'available';
      case 'charging':
      case 'preparing':
      case 'finishing':
        return 'inUse';
      case 'unavailable':
      case 'faulted':
      case 'suspendedevse':
      case 'suspendedev':
      case 'reserved':
        return 'unavailable';
      default:
        return statusLower;
    }
  }

  // Update station and connector status from WebSocket
  void updateFromWebSocket(int stationId, String stationStatus, int connectorId, String connectorStatus) {
    if (currentStation != null && currentStation!.id == stationId) {
      // Normalize and update station status
      currentStation!.status = _normalizeOcppStatus(stationStatus);

      // Update connector (gun) status
      if (currentStation!.guns != null) {
        for (var gun in currentStation!.guns!) {
          if (gun.id == connectorId) {
            gun.status = _normalizeOcppStatus(connectorStatus);
            break;
          }
        }
      }

      // Emit updated state
      emit(SuccessStationDetailsState(currentStation!));
    }
  }
}

