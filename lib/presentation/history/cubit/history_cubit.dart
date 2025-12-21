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
        emit(HistorySuccess(
          data: response.data,
          displayedSessions: validSessions,
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
      final sortedSessions = _applySorting(
        List.from(currentState.displayedSessions),
        sortType,
      );

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
          if (a.startTime == null || b.startTime == null) return 0;
          return DateTime.parse(b.startTime!)
              .compareTo(DateTime.parse(a.startTime!));
        });
        break;
      case 'Oldest':
        sortedList.sort((a, b) {
          if (a.startTime == null || b.startTime == null) return 0;
          return DateTime.parse(a.startTime!)
              .compareTo(DateTime.parse(b.startTime!));
        });
        break;
      case 'Highest Energy':
        sortedList.sort((a, b) {
          final aKwh = double.tryParse(a.kwh ?? '0') ?? 0.0;
          final bKwh = double.tryParse(b.kwh ?? '0') ?? 0.0;
          return bKwh.compareTo(aKwh);
        });
        break;
      case 'Lowest Energy':
        sortedList.sort((a, b) {
          final aKwh = double.tryParse(a.kwh ?? '0') ?? 0.0;
          final bKwh = double.tryParse(b.kwh ?? '0') ?? 0.0;
          return aKwh.compareTo(bKwh);
        });
        break;
    }

    return sortedList;
  }
}
