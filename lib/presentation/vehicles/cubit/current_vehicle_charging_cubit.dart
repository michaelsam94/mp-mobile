import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mega_plus/core/helpers/network/dio_helper.dart';
import 'package:mega_plus/core/helpers/network/end_points.dart';
import 'package:mega_plus/presentation/vehicles/models/vehicle_charging_response_model.dart';
import 'package:meta/meta.dart';

part 'current_vehicle_charging_state.dart';

class CurrentVehicleChargingCubit extends Cubit<CurrentVehicleChargingState> {
  CurrentVehicleChargingCubit() : super(CurrentVehicleChargingInitial());

  static CurrentVehicleChargingCubit get(context) => BlocProvider.of(context);

  List<VehicleChargingResponseModel> vehicles = [];

  Future<void> getVehiclesCharging() async {
    emit(LoadingCurrentVehicleChargingState());
    try {
      var response = await DioHelper.getData(
        url: EndPoints.vehiclesCharging,
        auth: true,
      );

      if (response.statusCode == 200 && response.data["success"] == true) {
        var data = response.data["data"] as List;
        if (kDebugMode) {
          print("Parsing ${data.length} vehicles from API");
        }
        vehicles = data
            .map((e) {
              if (kDebugMode) {
                print("Vehicle data: $e");
                print("Charging session type: ${e['charging_session'].runtimeType}");
              }
              return VehicleChargingResponseModel.fromJson(e);
            })
            .toList();
        if (kDebugMode) {
          print("Parsed ${vehicles.length} vehicles successfully");
          for (var vehicle in vehicles) {
            print("Vehicle ${vehicle.id}: isCharging=${vehicle.isCharging}, chargingSession=${vehicle.chargingSession != null}");
          }
        }
        emit(SuccessCurrentVehicleChargingState());
      } else {
        emit(ErrorCurrentVehicleChargingState(
          response.data["message"] ?? "Failed to load vehicles",
        ));
      }
    } catch (e) {
      emit(ErrorCurrentVehicleChargingState("Please try again"));
    }
  }
}

