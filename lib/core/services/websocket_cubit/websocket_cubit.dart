import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../models/notification_update_model.dart';
import '../models/session_update_model.dart';
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
  String? _chargerSerialNumber; // Store charger serial number from loaded session
  String? _chargerIdPrefix; // Store charger_id_prefix for connector_id

  MeterValueData? get currentMeterData => _currentMeterData;
  String? get currentTransactionId => _currentTransactionId;
  bool get isCompletedSession => _isCompletedSession;
  int? get completedSessionId => _completedSessionId;
  String? get chargerSerialNumber => _chargerSerialNumber;
  String? get chargerIdPrefix => _chargerIdPrefix;

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

  // Clear meter data when starting a new session
  void clearMeterData() {
    _currentMeterData = null;
    _currentTransactionId = null;
    _isCompletedSession = false;
    _completedSessionId = null;
    _chargerSerialNumber = null;
    _chargerIdPrefix = null;
    // Emit initial state to trigger UI update (show shimmer)
    emit(WebSocketInitial());
  }

  // Initialize meter data from API response (when navigating from history)
  void initializeMeterDataFromApi(Map<String, dynamic> apiResponse, {bool isCompleted = false, int? sessionId}) {
    try {
      // Convert API response to MeterValueData format
      final station = apiResponse['station'] as Map<String, dynamic>? ?? {};
      final charger = apiResponse['charger'] as Map<String, dynamic>? ?? {};
      
      // Store charger serial number and charger_id_prefix for stop charging
      _chargerSerialNumber = charger['serial_number']?.toString();
      _chargerIdPrefix = apiResponse['charger_id_prefex']?.toString() ?? 
                        apiResponse['charger_id_prefix']?.toString(); // Handle typo in API
      
      // Create meter data from API response
      final meterDataJson = {
        'charger_id': apiResponse['charger_id']?.toString() ?? '',
        'connector_id': apiResponse['gun_id']?.toString() ?? '',
        'station_id': apiResponse['station_id']?.toString() ?? '',
        'station_name': station['name']?.toString() ?? '',
        'station_address': station['address']?.toString() ?? '',
        'charge_percentage': apiResponse['current_battery_percentage']?.toString() ?? '0',
        'energy_consumed': apiResponse['kwh']?.toString() ?? '0',
        'energy_consumed_unit': 'kWh',
        'cost': apiResponse['cost']?.toString() ?? '0',
        'cost_currency': 'EGP',
        'charging_duration': apiResponse['duration']?.toString() ?? '0 hr 0 min',
        'charging_duration_display': apiResponse['duration']?.toString() ?? '0 hr 0 min',
        'output_power': null, // Not available in API response
        'output_power_unit': 'kW',
        'timestamp': DateTime.now().toIso8601String(),
      };

      final meterData = MeterValueData.fromJson(meterDataJson);
      _currentMeterData = meterData;
      _currentTransactionId = apiResponse['transaction_id']?.toString();
      _isCompletedSession = isCompleted;
      _completedSessionId = sessionId;

      // Create a SessionUpdate event to trigger UI update
      final sessionUpdate = SessionUpdateModel(
        type: 'session_update',
        sessionId: apiResponse['session_id']?.toString() ?? '',
        transactionId: apiResponse['transaction_id']?.toString() ?? '0',
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
          // Reset charger serial number when receiving live updates (not from loaded session)
          _chargerSerialNumber = null;
          _chargerIdPrefix = null;
        }
        emit(SessionUpdate(parsedMessage));
      } else {
        emit(WebSocketMessage(parsedMessage));
      }
    }
  }
}
