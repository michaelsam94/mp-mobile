import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:mega_plus/core/services/charging_api_service.dart';
import 'package:mega_plus/presentation/vehicles/models/vehicle_charging_response_model.dart';

part 'current_vehicle_charging_state.dart';

class CurrentVehicleChargingCubit extends Cubit<CurrentVehicleChargingState> {
  CurrentVehicleChargingCubit() : super(CurrentVehicleChargingInitial());

  static CurrentVehicleChargingCubit get(context) => BlocProvider.of(context);

  List<VehicleChargingResponseModel> vehicles = [];

  Future<void> getVehiclesCharging() async {
    emit(LoadingCurrentVehicleChargingState());
    try {
      final response = await ChargingApiService.getCurrentCharging();

      if (response.statusCode == 200 && response.data != null) {
        if (response.data['success'] == true) {
          final data = response.data['data'];
          
          if (data is List) {
            vehicles = data
                .map((e) => VehicleChargingResponseModel.fromJson(
                    Map<String, dynamic>.from(e)))
                .toList();
          } else if (data is Map) {
            // If data is a single object, wrap it in a list
            vehicles = [VehicleChargingResponseModel.fromJson(
                Map<String, dynamic>.from(data))];
          } else {
            vehicles = [];
          }
          
          emit(SuccessCurrentVehicleChargingState());
        } else {
          emit(ErrorCurrentVehicleChargingState(
            response.data['message'] ?? 'Failed to load vehicles',
          ));
        }
      } else {
        emit(ErrorCurrentVehicleChargingState('Failed to load vehicles'));
      }
    } on DioException catch (e) {
      if (kDebugMode) {
        print('Error getting vehicles charging: ${e.message}');
      }
      emit(ErrorCurrentVehicleChargingState(
        e.response?.data['message'] ?? 'Failed to load vehicles',
      ));
    } catch (e) {
      if (kDebugMode) {
        print('Error getting vehicles charging: $e');
      }
      emit(ErrorCurrentVehicleChargingState('An error occurred'));
    }
  }
}

