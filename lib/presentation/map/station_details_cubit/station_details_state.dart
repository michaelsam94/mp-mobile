part of 'station_details_cubit.dart';

@immutable
abstract class StationDetailsState {}

class StationDetailsInitial extends StationDetailsState {}

class StationDetailsLoading extends StationDetailsState {}

class StationDetailsSuccess extends StationDetailsState {
  final StationDetailsModel station;
  StationDetailsSuccess(this.station);
}

class StationDetailsError extends StationDetailsState {
  final String message;
  StationDetailsError(this.message);
}
