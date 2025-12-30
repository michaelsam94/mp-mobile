class VehicleChargingResponseModel {
  final int? id;
  final bool isCharging;
  final String? carModel;
  final String? plateNumber;
  final ChargingSession? chargingSession;

  VehicleChargingResponseModel({
    this.id,
    required this.isCharging,
    this.carModel,
    this.plateNumber,
    this.chargingSession,
  });

  factory VehicleChargingResponseModel.fromJson(Map<String, dynamic> json) {
    // Handle charging_session - it can be an empty array [], null, or an object
    ChargingSession? session;
    bool isCharging = false;
    
    final chargingSessionData = json['charging_session'];
    if (chargingSessionData != null) {
      if (chargingSessionData is List) {
        // If it's a list, check if it's not empty
        if (chargingSessionData.isNotEmpty) {
          // If list has items, take the first one
          session = ChargingSession.fromJson(
            Map<String, dynamic>.from(chargingSessionData[0])
          );
          isCharging = true;
        }
      } else if (chargingSessionData is Map) {
        // If it's a map/object, there's an active session
        session = ChargingSession.fromJson(
          Map<String, dynamic>.from(chargingSessionData)
        );
        isCharging = true;
      }
    }
    
    return VehicleChargingResponseModel(
      id: json['id'],
      isCharging: isCharging,
      carModel: json['car_model'],
      plateNumber: json['plate_number'],
      chargingSession: session,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'is_charging': isCharging,
      'car_model': carModel,
      'plate_number': plateNumber,
      'charging_session': chargingSession?.toJson(),
    };
  }
}

class ChargingSession {
  final int? id;
  final String? currentBatteryPercentage;
  final int? chargerId;
  final String? transactionId;
  final String? connectorId;

  ChargingSession({
    this.id,
    this.currentBatteryPercentage,
    this.chargerId,
    this.transactionId,
    this.connectorId,
  });

  factory ChargingSession.fromJson(Map<String, dynamic> json) {
    return ChargingSession(
      id: json['id'],
      currentBatteryPercentage: json['current_battery_percentage']?.toString(),
      chargerId: json['charger_id'],
      transactionId: json['transaction_id']?.toString(),
      connectorId: json['connector_id']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'current_battery_percentage': currentBatteryPercentage,
      'charger_id': chargerId,
      'transaction_id': transactionId,
      'connector_id': connectorId,
    };
  }
}

