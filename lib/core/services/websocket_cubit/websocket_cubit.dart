import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/notification_update_model.dart';
import '../models/session_update_model.dart';
import '../models/status_notification_model.dart';
import '../models/websocket_response.dart';
import '../websocket_service.dart';

part 'websocket_state.dart';

class WebSocketCubit extends Cubit<WebSocketState> {
  final WebSocketService service;

  // حفظ آخر session data
  MeterValueData? _currentMeterData;
  String? _currentTransactionId;
  bool _isCompletedSession = false;
  int? _completedSessionId;

  MeterValueData? get currentMeterData => _currentMeterData;
  String? get currentTransactionId => _currentTransactionId;
  bool get isCompletedSession => _isCompletedSession;
  int? get completedSessionId => _completedSessionId;

  WebSocketCubit(this.service) : super(WebSocketInitial()) {
    service.setMessageHandler(_handleMessage);
    service.setConnectHandler(() => emit(WebSocketConnected()));
    service.setErrorHandler((error) => emit(WebSocketError(error)));
    service.setDisconnectHandler(() => emit(WebSocketDisconnected()));
  }

  void connect() {
    service.connect();
  }

  void disconnect() {
    service.disconnect();
  }

  // Clear cached meter data (when starting a new session)
  void clearMeterData() {
    _currentMeterData = null;
    _currentTransactionId = null;
    _isCompletedSession = false;
    _completedSessionId = null;
    // Emit initial state to trigger UI update (show shimmer)
    emit(WebSocketInitial());
  }

  // Initialize meter data from API response (when navigating from history)
  void initializeMeterDataFromApi(Map<String, dynamic> apiResponse, {bool isCompleted = false, int? sessionId}) {
    try {
      // Extract data from API response - handle both old and new formats
      Map<String, dynamic> data;
      if (apiResponse.containsKey('data') && apiResponse['data'] is Map) {
        // New format: response has 'data' wrapper
        data = apiResponse['data'] as Map<String, dynamic>;
      } else {
        // Old format: data is directly in apiResponse
        data = apiResponse;
      }
      
      // Handle nested station object (old format) or direct fields (new format)
      final station = data['station'] as Map<String, dynamic>?;
      
      // Create meter data from API response
      final meterDataJson = {
        'charger_id': data['charger_id']?.toString() ?? '',
        'connector_id': data['connector_id']?.toString() ?? data['gun_id']?.toString() ?? '',
        'station_id': data['station_id']?.toString() ?? '',
        'station_name': data['station_name']?.toString() ?? station?['name']?.toString() ?? '',
        'station_address': data['address']?.toString() ?? data['station_address']?.toString() ?? station?['address']?.toString() ?? '',
        'station_status': data['station_status']?.toString(),
        'ac_compatible': data['ac_compatible'] ?? station?['ac_compatible'] ?? true,
        'charge_percentage': data['current_percentage']?.toString() ?? data['current_battery_percentage']?.toString() ?? '0',
        'energy_consumed': data['power_consumtion']?.toString() ?? data['power_consumption']?.toString() ?? data['kwh']?.toString() ?? '0',
        'energy_consumed_unit': 'kWh',
        'cost': data['cost']?.toString() ?? '0',
        'cost_currency': 'EGP',
        'charging_duration': data['duration']?.toString() ?? '0 hr 0 min',
        'charging_duration_display': data['duration']?.toString() ?? '0 hr 0 min',
        'output_power': data['output']?.toString() ?? data['output_power']?.toString(),
        'output_power_unit': 'kW',
        'timestamp': DateTime.now().toIso8601String(),
      };

      final meterData = MeterValueData.fromJson(meterDataJson);
      _currentMeterData = meterData;
      _currentTransactionId = data['transaction_id']?.toString();
      _isCompletedSession = isCompleted;
      _completedSessionId = sessionId ?? data['id'];

      // Create a SessionUpdate event to trigger UI update
      final sessionUpdate = SessionUpdateModel(
        type: 'session_update',
        sessionId: data['id']?.toString() ?? data['session_id']?.toString() ?? '',
        transactionId: data['transaction_id']?.toString() ?? '0',
        event: 'meter_value',
        data: meterData,
        timestamp: DateTime.now().toIso8601String(),
      );

      emit(SessionUpdate(sessionUpdate));
    } catch (e) {
      if (kDebugMode) {
        print('Error initializing meter data from API: $e');
      }
    }
  }

  void _handleMessage(dynamic message) {
    if (message is Map<String, dynamic>) {
      print(message);

      final parsedMessage = WebSocketResponse.parseMessage(message);

      if (parsedMessage == null) {
        emit(WebSocketError('Unknown message type'));
        return;
      }

      // Emit specific states based on message type
      if (parsedMessage is NotificationUpdateModel) {
        emit(NotificationUpdate(parsedMessage));
      } else if (parsedMessage is SessionUpdateModel) {
        // حفظ الـ meter data
        if (parsedMessage.isMeterValue) {
          _currentMeterData = parsedMessage.meterData;
          _currentTransactionId = parsedMessage.transactionId?.toString();
          // Reset completed session flag when receiving new meter values (active session)
          _isCompletedSession = false;
          _completedSessionId = null;
        }
        // Note: We don't clear meter data when session_stopped is received via WebSocket
        // This allows the UI to show final values for PDF download
        // Meter data will be cleared when starting a new session
        emit(SessionUpdate(parsedMessage));
      } else if (parsedMessage is StatusNotificationModel) {
        emit(StatusNotificationUpdate(parsedMessage));
      } else {
        emit(WebSocketMessage(parsedMessage));
      }
    }
  }
}
