class HistoryResponse {
  final bool success;
  final HistoryData data;
  final String message;

  HistoryResponse({
    required this.success,
    required this.data,
    required this.message,
  });

  factory HistoryResponse.fromJson(Map<String, dynamic> json) {
    return HistoryResponse(
      success: json['success'] ?? false,
      data: HistoryData.fromJson(json['data'] ?? {}),
      message: json['message'] ?? '',
    );
  }
}

class HistoryData {
  final List<ChargingSession> sessions;
  final HistorySummary summary;
  final String pdfUrl;

  HistoryData({
    required this.sessions,
    required this.summary,
    required this.pdfUrl,
  });

  factory HistoryData.fromJson(Map<String, dynamic> json) {
    return HistoryData(
      sessions:
          (json['sessions'] as List?)
              ?.map((e) => ChargingSession.fromJson(e))
              .toList() ??
          [],
      summary: HistorySummary.fromJson(json['summery'] ?? {}),
      pdfUrl: json['pdfUrl'] ?? '',
    );
  }
}

class ChargingSession {
  final int id;
  final int customerId;
  final int stationId;
  final int chargerId;
  final int gunId;
  final String? chargerIdPrefix;
  final String? sessionId;
  final String idTag;
  final String? transactionId;
  final String? startTime;
  final String? endTime;
  final String? duration;
  final String? startingMeterValue;
  final String? kwh;
  final String? startingBatteryPercentage;
  final String? currentBatteryPercentage;
  final String? cost;
  final String status;
  final String createdAt;
  final Station station;

  ChargingSession({
    required this.id,
    required this.customerId,
    required this.stationId,
    required this.chargerId,
    required this.gunId,
    this.chargerIdPrefix,
    this.sessionId,
    required this.idTag,
    this.transactionId,
    this.startTime,
    this.endTime,
    this.duration,
    this.startingMeterValue,
    this.kwh,
    this.startingBatteryPercentage,
    this.currentBatteryPercentage,
    this.cost,
    required this.status,
    required this.createdAt,
    required this.station,
  });

  factory ChargingSession.fromJson(Map<String, dynamic> json) {
    return ChargingSession(
      id: json['id'] ?? 0,
      customerId: json['customer_id'] ?? 0,
      stationId: json['station_id'] ?? 0,
      chargerId: json['charger_id'] ?? 0,
      gunId: json['gun_id'] ?? 0,
      chargerIdPrefix: json['charger_id_prefex'],
      sessionId: json['session_id'],
      idTag: json['id_tag'] ?? '',
      transactionId: json['transaction_id'],
      startTime: json['start_time'],
      endTime: json['end_time'],
      duration: json['duration'],
      startingMeterValue: json['starting_meter_value'],
      kwh: json['kwh'],
      startingBatteryPercentage: json['starting_battery_percentage'],
      currentBatteryPercentage: json['current_battery_percentage'],
      cost: json['cost'],
      status: json['status'] ?? 'off',
      createdAt: json['created_at'] ?? '',
      station: Station.fromJson(json['station'] ?? {}),
    );
  }

  // Helper getters
  String get displayCost => cost ?? '0';
  String get displayKwh => kwh != null
      ? '${(num.parse(kwh!) / 1000).toStringAsFixed(1)} kWh'
      : '0 kWh';
  String get displayDuration => duration ?? '0 hr 0 min';
  bool get isActive => status == 'on';
}

class Station {
  final int id;
  final String name;
  final String address;
  final String city;
  final num latitude;
  final num longitude;
  final String status;
  final int? userId;
  final String createdAt;

  Station({
    required this.id,
    required this.name,
    required this.address,
    required this.city,
    required this.latitude,
    required this.longitude,
    required this.status,
    this.userId,
    required this.createdAt,
  });

  factory Station.fromJson(Map<String, dynamic> json) {
    return Station(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      city: json['city'] ?? '',
      latitude: (json['latitude'] ?? 0).toDouble(),
      longitude: (json['longitude'] ?? 0).toDouble(),
      status: json['status'] ?? '',
      userId: json['user_id'],
      createdAt: json['created_at'] ?? '',
    );
  }
}

class HistorySummary {
  final num totalSessions;
  final num totalKwh;
  final num totalCost;
  final String totalDuration;

  HistorySummary({
    required this.totalSessions,
    required this.totalKwh,
    required this.totalCost,
    required this.totalDuration,
  });

  factory HistorySummary.fromJson(Map<String, dynamic> json) {
    return HistorySummary(
      totalSessions: json['total_sessions'] ?? 0,
      totalKwh: json['total_kwh'] ?? 0,
      totalCost: json['total_cost'] ?? 0,
      totalDuration: json['total_duration'] ?? '0 hr 0 min',
    );
  }

  // Helper getters
  // String get displayTotalKwh => '${(totalKwh / 1000).toStringAsFixed(1)} kWh';
  // String get displayTotalCost => '$totalCost EGP';
}
