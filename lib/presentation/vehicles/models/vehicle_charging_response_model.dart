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
    
    // Handle charging_session - can be empty array or object
    if (json['charging_session'] != null) {
      if (json['charging_session'] is List) {
        // If it's an empty array, set to null
        final sessionList = json['charging_session'] as List;
        if (sessionList.isEmpty) {
          chargingSession = null;
        } else if (sessionList.isNotEmpty) {
          // If array has items, use first item
          chargingSession = ChargingSession.fromJson(sessionList[0]);
        }
      } else if (json['charging_session'] is Map) {
        // If it's an object, parse it
        chargingSession = ChargingSession.fromJson(json['charging_session']);
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['plate_number'] = plateNumber;
    data['car_model'] = carModel;
    if (chargingSession != null) {
      data['charging_session'] = chargingSession!.toJson();
    }
    return data;
  }

  // Helper to check if vehicle is currently charging
  // Only depends on whether charging_session exists (not empty), not on stop_charging field
  bool get isCharging {
    return chargingSession != null;
  }
}

class ChargingSession {
  int? id;
  String? chargerId;
  String? transactionId;
  String? currentBatteryPercentage;
  String? sessionId;
  String? connectorId;
  bool? stopCharging;

  ChargingSession({
    this.id,
    this.chargerId,
    this.transactionId,
    this.currentBatteryPercentage,
    this.sessionId,
    this.connectorId,
    this.stopCharging,
  });

  ChargingSession.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    chargerId = json['charger_id']?.toString();
    transactionId = json['transaction_id']?.toString();
    currentBatteryPercentage = json['current_battery_percentage']?.toString();
    sessionId = json['session_id'];
    connectorId = json['connector_id']?.toString();
    stopCharging = json['stop_charging'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['charger_id'] = chargerId;
    data['transaction_id'] = transactionId;
    data['current_battery_percentage'] = currentBatteryPercentage;
    data['session_id'] = sessionId;
    data['connector_id'] = connectorId;
    data['stop_charging'] = stopCharging;
    return data;
  }
}

