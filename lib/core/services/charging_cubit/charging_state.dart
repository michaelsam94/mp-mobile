part of 'charging_cubit.dart';

@immutable
sealed class ChargingState {}

final class ChargingInitial extends ChargingState {}

final class ChargingLoading extends ChargingState {}

final class ChargingSuccess extends ChargingState {
  final bool data;
  // final Map<String, dynamic> data;
  ChargingSuccess(this.data);
}

final class ChargingError extends ChargingState {
  final String message;
  ChargingError(this.message);
}
