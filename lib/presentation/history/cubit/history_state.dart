part of 'history_cubit.dart';

@immutable
sealed class HistoryState {}

final class HistoryInitial extends HistoryState {}

final class HistoryLoading extends HistoryState {}

final class HistorySuccess extends HistoryState {
  final HistoryData data;
  final List<ChargingSession> displayedSessions;
  final String selectedFilter;
  final String selectedSort;

  HistorySuccess({
    required this.data,
    required this.displayedSessions,
    this.selectedFilter = 'All',
    this.selectedSort = 'Newest',
  });

  HistorySuccess copyWith({
    HistoryData? data,
    List<ChargingSession>? displayedSessions,
    String? selectedFilter,
    String? selectedSort,
  }) {
    return HistorySuccess(
      data: data ?? this.data,
      displayedSessions: displayedSessions ?? this.displayedSessions,
      selectedFilter: selectedFilter ?? this.selectedFilter,
      selectedSort: selectedSort ?? this.selectedSort,
    );
  }
}

final class HistoryError extends HistoryState {
  final String message;

  HistoryError(this.message);
}
