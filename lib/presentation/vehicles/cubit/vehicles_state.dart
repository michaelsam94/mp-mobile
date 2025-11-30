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
