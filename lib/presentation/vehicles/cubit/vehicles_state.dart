part of 'vehicles_cubit.dart';

@immutable
sealed class VehiclesState {}

final class VehiclesInitial extends VehiclesState {}

class LoadingGetBrandsVehiclesState extends VehiclesState {}

class SuccessGetBrandsVehiclesState extends VehiclesState {}

class ErrorGetBrandsVehiclesState extends VehiclesState {}

class LoadingGetModelsVehiclesState extends VehiclesState {}

class SuccessGetModelsVehiclesState extends VehiclesState {}

class ErrorGetModelsVehiclesState extends VehiclesState {}

class StartSelectModelVehiclesState extends VehiclesState {}

class EndSelectModelVehiclesState extends VehiclesState {}

class StartChoosePlateImageVehiclesState extends VehiclesState {}

class EndChoosePlateImageVehiclesState extends VehiclesState {}

class LoadingAddVehiclesState extends VehiclesState {}

class SuccessAddVehiclesState extends VehiclesState {}

class ErrorAddVehiclesState extends VehiclesState {
  final String message;
  ErrorAddVehiclesState(this.message);
}

class LoadingGetVehiclesState extends VehiclesState {}

class SuccessGetVehiclesState extends VehiclesState {}

class ErrorGetVehiclesState extends VehiclesState {
  
}

class LoadingDeleteVehiclesState extends VehiclesState {}

class SuccessDeleteVehiclesState extends VehiclesState {}

class ErrorDeleteVehiclesState extends VehiclesState {
  final String message;
  ErrorDeleteVehiclesState(this.message);
}

class LoadingUpdateVehiclesState extends VehiclesState {}

class SuccessUpdateVehiclesState extends VehiclesState {}

class ErrorUpdateVehiclesState extends VehiclesState {
  final String message;
  ErrorUpdateVehiclesState(this.message);
}