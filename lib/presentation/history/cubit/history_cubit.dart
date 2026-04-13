import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../history_model.dart';
import '../history_repository.dart';

part 'history_state.dart';

class HistoryCubit extends Cubit<HistoryState> {
  final HistoryRepository repository;

  HistoryCubit(this.repository) : super(HistoryInitial());

  // Internal filter keys (language-independent)
  static const String filterAll = 'all';
  static const String filterActive = 'active';
  static const String filterCompleted = 'completed';

  // Internal sort keys (language-independent)
  static const String sortNewest = 'newest';
  static const String sortOldest = 'oldest';
  static const String sortHighestEnergy = 'highestEnergy';
  static const String sortLowestEnergy = 'lowestEnergy';

  Future<void> getChargingHistory() async {
    emit(HistoryLoading());
    try {
      final response = await repository.getChargingHistory();
      if (response.success) {
        final validSessions = _getValidSessions(response.data.sessions);
        final sortedSessions = _applySorting(validSessions, sortNewest);

        emit(HistorySuccess(
          data: response.data,
          displayedSessions: sortedSessions,
          selectedFilter: filterAll,
          selectedSort: sortNewest,
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
        case filterActive:
          filteredSessions = validSessions.where((s) => s.status == 'on').toList();
          break;
        case filterCompleted:
          filteredSessions = validSessions.where((s) => s.status == 'off').toList();
          break;
        default: // filterAll
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
        case filterActive:
          filteredSessions = validSessions.where((s) => s.status == 'on').toList();
          break;
        case filterCompleted:
          filteredSessions = validSessions.where((s) => s.status == 'off').toList();
          break;
        default: // filterAll
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
      case sortNewest:
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
      case sortOldest:
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
      case sortHighestEnergy:
        sortedList.sort((a, b) {
          final aKwh = double.tryParse(a.kwh ?? '0') ?? 0.0;
          final bKwh = double.tryParse(b.kwh ?? '0') ?? 0.0;
          return bKwh.compareTo(aKwh); // highest first
        });
        break;
      case sortLowestEnergy:
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
