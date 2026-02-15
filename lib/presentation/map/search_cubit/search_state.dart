part of 'search_cubit.dart';

@immutable
sealed class SearchState {}

final class SearchInitial extends SearchState {}

class LoadingGetStationsSearchState extends SearchState {}

class SuccessGetStationsSearchState extends SearchState {}

class ErrorGetStationsSearchState extends SearchState {}

class SearchUpdatedState extends SearchState {}
