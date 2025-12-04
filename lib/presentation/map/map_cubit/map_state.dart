part of 'map_cubit.dart';

@immutable
sealed class MapState {}

final class MapInitial extends MapState {}

class LoadingMapState extends MapState{}
class UpdatedMapState extends MapState{}