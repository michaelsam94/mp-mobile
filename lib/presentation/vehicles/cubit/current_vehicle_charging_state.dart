part of 'current_vehicle_charging_cubit.dart';

abstract class CurrentVehicleChargingState {}

class CurrentVehicleChargingInitial extends CurrentVehicleChargingState {}

class LoadingCurrentVehicleChargingState extends CurrentVehicleChargingState {}

class SuccessCurrentVehicleChargingState extends CurrentVehicleChargingState {}

class ErrorCurrentVehicleChargingState extends CurrentVehicleChargingState {
  final String message;
  ErrorCurrentVehicleChargingState(this.message);
}

