import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mega_plus/core/services/charging_api_service.dart';
import 'package:mega_plus/core/helpers/network/dio_helper.dart';
import 'package:mega_plus/core/helpers/network/end_points.dart';
import 'package:mega_plus/presentation/vehicles/models/vehicle_charging_response_model.dart';

part 'current_vehicle_charging_state.dart';

class CurrentVehicleChargingCubit extends Cubit<CurrentVehicleChargingState> {
  CurrentVehicleChargingCubit() : super(CurrentVehicleChargingInitial());

  static CurrentVehicleChargingCubit get(context) => BlocProvider.of(context);

  List<VehicleChargingResponseModel> vehicles = [];

  Future<void> getVehiclesCharging() async {
    emit(LoadingCurrentVehicleChargingState());
    try {
      var response = await DioHelper.getData(
        url: EndPoints.currentCharging,
        auth: true,
      );

      if (response.statusCode == 200 && response.data["success"] == true) {
        var data = response.data["data"] as List;
        vehicles = data
            .map((e) => VehicleChargingResponseModel.fromJson(e))
            .toList();
        
        emit(SuccessCurrentVehicleChargingState());
        
        // For active charging sessions, fetch current session data to get real-time percentage
        // Do this after emitting success so UI can show loading state first
        await _updateActiveSessionsData();
        
        // Emit success again to refresh UI with updated percentage data
        emit(SuccessCurrentVehicleChargingState());
      } else {
        emit(ErrorCurrentVehicleChargingState(
          response.data["message"] ?? "Failed to load vehicles charging status",
        ));
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching vehicles charging: $e");
      }
      emit(ErrorCurrentVehicleChargingState("Failed to load vehicles charging status"));
    }
  }

  // Fetch current session data for active charging sessions to get real-time percentage
  Future<void> _updateActiveSessionsData() async {
    for (var vehicle in vehicles) {
      // Only fetch for active sessions (not stopped)
      if (vehicle.isCharging && vehicle.chargingSession?.id != null) {
        try {
          final sessionResponse = await ChargingApiService.getCurrentChargingBySession(
            vehicle.chargingSession!.id!,
          );
          
          if (sessionResponse.statusCode == 200 && 
              sessionResponse.data != null &&
              sessionResponse.data['success'] == true) {
            // Update battery percentage from current session data
            final currentBatteryPercentage = sessionResponse.data['data']?['current_battery_percentage'];
            if (currentBatteryPercentage != null && vehicle.chargingSession != null) {
              vehicle.chargingSession!.currentBatteryPercentage = currentBatteryPercentage.toString();
            }
          }
        } catch (e) {
          if (kDebugMode) {
            print("Error fetching current session data for vehicle ${vehicle.id}: $e");
          }
          // Continue with other vehicles even if one fails
        }
      }
    }
  }
}

