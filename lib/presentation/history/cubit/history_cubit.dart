import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../history_model.dart';
import '../history_repository.dart';

part 'history_state.dart';

class HistoryCubit extends Cubit<HistoryState> {
  final HistoryRepository repository;

  HistoryCubit(this.repository) : super(HistoryInitial());

  Future<void> getChargingHistory() async {
    emit(HistoryLoading());
    try {
      final response = await repository.getChargingHistory();
      if (response.success) {
        final validSessions = _getValidSessions(response.data.sessions);
        // Apply default filter (All) and sort (Newest)
        final filteredSessions = validSessions; // All by default
        final sortedSessions = _applySorting(filteredSessions, 'Newest');
        
        emit(HistorySuccess(
          data: response.data,
          displayedSessions: sortedSessions,
          selectedFilter: 'All',
          selectedSort: 'Newest',
        ));
      } else {
        emit(HistoryError(response.message));
      }
    } catch (e) {
      emit(HistoryError(e.toString()));
    }
  }

  List<ChargingSession> _getValidSessions(List<ChargingSession> sessions) {
    return sessions.where((s) => 
      s.startTime != null && s.duration != null && s.kwh != null
    ).toList();
  }

  void applyFilter(String filter) {
    final currentState = state;
    if (currentState is HistorySuccess) {
      final validSessions = _getValidSessions(currentState.data.sessions);
      List<ChargingSession> filteredSessions;

      switch (filter) {
        case 'Active':
          filteredSessions = validSessions.where((s) => s.status == 'on').toList();
          break;
        case 'Completed':
          filteredSessions = validSessions.where((s) => s.status == 'off').toList();
          break;
        default: // All
          filteredSessions = validSessions;
      }

      // Re-apply current sort
      filteredSessions = _applySorting(filteredSessions, currentState.selectedSort);

      emit(currentState.copyWith(
        displayedSessions: filteredSessions,
        selectedFilter: filter,
      ));
    }
  }

  void applySort(String sortType) {
    final currentState = state;
    if (currentState is HistorySuccess) {
      // First, get the filtered sessions based on current filter
      final validSessions = _getValidSessions(currentState.data.sessions);
      List<ChargingSession> filteredSessions;

      switch (currentState.selectedFilter) {
        case 'Active':
          filteredSessions = validSessions.where((s) => s.status == 'on').toList();
          break;
        case 'Completed':
          filteredSessions = validSessions.where((s) => s.status == 'off').toList();
          break;
        default: // All
          filteredSessions = validSessions;
      }

      // Then apply the new sort
      final sortedSessions = _applySorting(filteredSessions, sortType);

      emit(currentState.copyWith(
        displayedSessions: sortedSessions,
        selectedSort: sortType,
      ));
    }
  }

  List<ChargingSession> _applySorting(List<ChargingSession> sessions, String sortType) {
    final sortedList = List<ChargingSession>.from(sessions);

    switch (sortType) {
      case 'Newest':
        sortedList.sort((a, b) {
          if (a.startTime == null || b.startTime == null) {
            if (a.startTime == null && b.startTime == null) return 0;
            if (a.startTime == null) return 1; // null goes to end
            return -1; // b is null, a goes first
          }
          try {
            final aDate = DateTime.parse(a.startTime!);
            final bDate = DateTime.parse(b.startTime!);
            return bDate.compareTo(aDate); // newest first
          } catch (e) {
            return 0; // if parsing fails, maintain order
          }
        });
        break;
      case 'Oldest':
        sortedList.sort((a, b) {
          if (a.startTime == null || b.startTime == null) {
            if (a.startTime == null && b.startTime == null) return 0;
            if (a.startTime == null) return 1; // null goes to end
            return -1; // b is null, a goes first
          }
          try {
            final aDate = DateTime.parse(a.startTime!);
            final bDate = DateTime.parse(b.startTime!);
            return aDate.compareTo(bDate); // oldest first
          } catch (e) {
            return 0; // if parsing fails, maintain order
          }
        });
        break;
      case 'Highest Energy':
        sortedList.sort((a, b) {
          final aKwh = double.tryParse(a.kwh ?? '0') ?? 0.0;
          final bKwh = double.tryParse(b.kwh ?? '0') ?? 0.0;
          return bKwh.compareTo(aKwh); // highest first
        });
        break;
      case 'Lowest Energy':
        sortedList.sort((a, b) {
          final aKwh = double.tryParse(a.kwh ?? '0') ?? 0.0;
          final bKwh = double.tryParse(b.kwh ?? '0') ?? 0.0;
          return aKwh.compareTo(bKwh); // lowest first
        });
        break;
    }

    return sortedList;
  }
}
