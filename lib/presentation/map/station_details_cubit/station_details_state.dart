part of 'station_details_cubit.dart';

@immutable
sealed class StationDetailsState {}

final class StationDetailsInitial extends StationDetailsState {}

class LoadingStationDetailsState extends StationDetailsState {}

class SuccessStationDetailsState extends StationDetailsState {
  final StationResponseModel station;
  SuccessStationDetailsState(this.station);
}

class ErrorStationDetailsState extends StationDetailsState {
  final String message;
  ErrorStationDetailsState(this.message);
}

