part of 'map_cubit.dart';

@immutable
sealed class MapState {}

final class MapInitial extends MapState {}

class LoadingMapState extends MapState {}

class LoadedMapState extends MapState {}

class ErrorMapState extends MapState {
  final String message;
  ErrorMapState(this.message);
}

class MarkerTappedState extends MapState {
  final int stationId;
  MarkerTappedState(this.stationId);
}