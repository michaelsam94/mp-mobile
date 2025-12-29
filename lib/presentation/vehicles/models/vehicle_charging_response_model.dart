class VehicleChargingResponseModel {
  int? id;
  String? plateNumber;
  String? carModel;
  ChargingSession? chargingSession;

  VehicleChargingResponseModel({
    this.id,
    this.plateNumber,
    this.carModel,
    this.chargingSession,
  });

  VehicleChargingResponseModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    plateNumber = json['plate_number'];
    carModel = json['car_model'];
    chargingSession = json['charging_session'] != null && 
                      json['charging_session'] is Map &&
                      (json['charging_session'] as Map).isNotEmpty
        ? ChargingSession.fromJson(json['charging_session'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['plate_number'] = plateNumber;
    data['car_model'] = carModel;
    if (chargingSession != null) {
      data['charging_session'] = chargingSession!.toJson();
    }
    return data;
  }

  bool get isCharging => chargingSession != null;
}

class ChargingSession {
  int? id;
  int? chargerId;
  String? transactionId;
  String? currentBatteryPercentage;
  String? sessionId;
  String? connectorId;
  bool? stopCharging;
  String? chargerIdPrefix; // charger_id_prefex from API
  ChargerData? charger; // Full charger data if available

  ChargingSession({
    this.id,
    this.chargerId,
    this.transactionId,
    this.currentBatteryPercentage,
    this.sessionId,
    this.connectorId,
    this.stopCharging,
    this.chargerIdPrefix,
    this.charger,
  });

  ChargingSession.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    chargerId = json['charger_id'];
    transactionId = json['transaction_id']?.toString();
    currentBatteryPercentage = json['current_battery_percentage']?.toString();
    sessionId = json['session_id']?.toString();
    connectorId = json['connector_id']?.toString();
    stopCharging = json['stop_charging'];
    chargerIdPrefix = json['charger_id_prefex']?.toString() ?? 
                      json['charger_id_prefix']?.toString(); // Handle typo in API
    charger = json['charger'] != null ? ChargerData.fromJson(json['charger']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['charger_id'] = chargerId;
    data['transaction_id'] = transactionId;
    data['current_battery_percentage'] = currentBatteryPercentage;
    data['session_id'] = sessionId;
    data['connector_id'] = connectorId;
    data['stop_charging'] = stopCharging;
    data['charger_id_prefex'] = chargerIdPrefix;
    if (charger != null) {
      data['charger'] = charger!.toJson();
    }
    return data;
  }
}

class ChargerData {
  int? id;
  String? serialNumber;

  ChargerData({
    this.id,
    this.serialNumber,
  });

  ChargerData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    serialNumber = json['serial_number']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['serial_number'] = serialNumber;
    return data;
  }
}

