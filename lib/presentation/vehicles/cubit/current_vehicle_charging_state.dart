part of 'current_vehicle_charging_cubit.dart';

@immutable
sealed class CurrentVehicleChargingState {}

final class CurrentVehicleChargingInitial extends CurrentVehicleChargingState {}

final class LoadingCurrentVehicleChargingState extends CurrentVehicleChargingState {}

final class SuccessCurrentVehicleChargingState extends CurrentVehicleChargingState {}

final class ErrorCurrentVehicleChargingState extends CurrentVehicleChargingState {
  final String message;
  ErrorCurrentVehicleChargingState(this.message);
}

