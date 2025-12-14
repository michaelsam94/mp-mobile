import 'websocket_response.dart';

class SessionUpdateModel extends WebSocketResponse {
  final dynamic sessionId;
  final dynamic transactionId;
  final String event;
  final SessionData data;

  SessionUpdateModel({
    required super.type,
    required this.sessionId,
    required this.transactionId,
    required this.event,
    required this.data,
    required super.timestamp,
  });

  factory SessionUpdateModel.fromJson(Map<String, dynamic> json) {
    try {
      final event = json['event'] as String;
      final dataJson = json['data'] as Map<String, dynamic>;

      return SessionUpdateModel(
        type: json['type'] as String,
        sessionId: json['session_id']?.toString() ?? '',
        transactionId: json['transaction_id']?.toString() ?? '0',
        event: event,
        data: SessionData.fromJson(event, dataJson),
        timestamp: json['timestamp'] as String,
      );
    } catch (e) {
      print('❌ Error in SessionUpdateModel.fromJson: $e');
      print('JSON: $json');
      rethrow;
    }
  }

  bool get isMeterValue => event == 'meter_value';
  bool get isSessionStopped => event == 'session_stopped';

  MeterValueData? get meterData =>
      data is MeterValueData ? data as MeterValueData : null;
  SessionStoppedData? get stoppedData =>
      data is SessionStoppedData ? data as SessionStoppedData : null;
}

// Base class
abstract class SessionData {
  final dynamic chargerId;
  final dynamic connectorId;
  final String timestamp;

  SessionData({
    required this.chargerId,
    required this.connectorId,
    required this.timestamp,
  });

  factory SessionData.fromJson(String event, Map<String, dynamic> json) {
    try {
      // إضافة الـ timestamp للـ json إذا مش موجود
      if (!json.containsKey('timestamp')) {
        json['timestamp'] = DateTime.now().toIso8601String();
      }

      switch (event) {
        case 'meter_value':
          return MeterValueData.fromJson(json);
        case 'session_stopped':
          return SessionStoppedData.fromJson(json);
        default:
          throw Exception('Unknown event: $event');
      }
    } catch (e) {
      print('❌ Error in SessionData.fromJson for event "$event": $e');
      print('Data: $json');
      rethrow;
    }
  }
}

// Meter Value Data
class MeterValueData extends SessionData {
  final dynamic stationId;
  final String? stationName;
  final String? stationAddress;
  final dynamic chargePercentage;
  final dynamic timeRemaining;
  final String? timeRemainingDisplay;
  final dynamic energyConsumed;
  final String energyConsumedUnit;
  final dynamic cost;
  final String costCurrency;
  final dynamic chargingDuration;
  final String? chargingDurationDisplay;
  final dynamic outputPower;
  final String outputPowerUnit;
  final dynamic energyDelivered;
  final dynamic power;
  final dynamic voltage;
  final dynamic current;
  final dynamic meterValue;

  MeterValueData({
    required super.chargerId,
    required super.connectorId,
    required super.timestamp,
    required this.stationId,
    this.stationName,
    this.stationAddress,
    this.chargePercentage,
    this.timeRemaining,
    this.timeRemainingDisplay,
    this.energyConsumed,
    required this.energyConsumedUnit,
    this.cost,
    required this.costCurrency,
    this.chargingDuration,
    this.chargingDurationDisplay,
    this.outputPower,
    required this.outputPowerUnit,
    this.energyDelivered,
    this.power,
    this.voltage,
    this.current,
    this.meterValue,
  });

  factory MeterValueData.fromJson(Map<String, dynamic> json) {
    return MeterValueData(
      chargerId: json['charger_id'],
      connectorId: json['connector_id'],
      stationId: json['station_id'],
      stationName: json['station_name'] as String?,
      stationAddress: json['station_address'] as String?,
      chargePercentage: json['charge_percentage'],
      timeRemaining: json['time_remaining'],
      timeRemainingDisplay: json['time_remaining_display'] as String?,
      energyConsumed: json['energy_consumed'],
      energyConsumedUnit: json['energy_consumed_unit'] as String? ?? 'kWh',
      cost: json['cost'],
      costCurrency: json['cost_currency'] as String? ?? 'EGP',
      chargingDuration: json['charging_duration'],
      chargingDurationDisplay: json['charging_duration_display'] as String?,
      outputPower: json['output_power'],
      outputPowerUnit: json['output_power_unit'] as String? ?? 'kW',
      energyDelivered: json['energy_delivered'],
      power: json['power'],
      voltage: json['voltage'],
      current: json['current'],
      meterValue: json['meter_value'],
      timestamp: json['timestamp'] as String,
    );
  }

  double _toDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is int) return value.toDouble();
    if (value is double) return value;
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  double get chargePercentageValue => _toDouble(chargePercentage);
  double get energyConsumedValue => _toDouble(energyConsumed);
  double get costValue => _toDouble(cost);
  double get outputPowerValue => _toDouble(outputPower);
  double get voltageValue => _toDouble(voltage);
  int get meterValueInt => (meterValue is int)
      ? meterValue as int
      : int.tryParse(meterValue.toString()) ?? 0;
}

// Session Stopped Data
class SessionStoppedData extends SessionData {
  final dynamic meterStop;
  final dynamic energyDelivered;
  final dynamic duration;
  final String stopTime;
  final String stopReason;

  SessionStoppedData({
    required super.chargerId,
    required super.connectorId,
    required super.timestamp,
    this.meterStop,
    this.energyDelivered,
    this.duration,
    required this.stopTime,
    required this.stopReason,
  });

  factory SessionStoppedData.fromJson(Map<String, dynamic> json) {
    return SessionStoppedData(
      chargerId: json['charger_id'],
      connectorId: json['connector_id'],
      meterStop: json['meter_stop'],
      energyDelivered: json['energy_delivered'],
      duration: json['duration'],
      stopTime: json['stop_time'] as String,
      stopReason: json['stop_reason'] as String,
      timestamp:
          json['timestamp'] as String? ??
          json['stop_time'] as String, // fallback
    );
  }

  double _toDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is int) return value.toDouble();
    if (value is double) return value;
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  int get meterStopValue => (meterStop is int)
      ? meterStop as int
      : int.tryParse(meterStop.toString()) ?? 0;
  double get energyDeliveredValue => _toDouble(energyDelivered);
  double get durationValue => _toDouble(duration);
}
