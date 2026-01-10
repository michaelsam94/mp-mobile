import 'websocket_response.dart';

class StatusNotificationModel extends WebSocketResponse {
  final int stationId;
  final int connectorId;
  final String? connectorIdPrefix;
  final String stationStatus;
  final String connectorStatus;
  final String? errorCode;

  StatusNotificationModel({
    required super.type,
    required this.stationId,
    required this.connectorId,
    this.connectorIdPrefix,
    required this.stationStatus,
    required this.connectorStatus,
    this.errorCode,
    required super.timestamp,
  });

  factory StatusNotificationModel.fromJson(Map<String, dynamic> json) {
    return StatusNotificationModel(
      type: json['type'] as String,
      stationId: json['station_id'] as int,
      connectorId: json['connector_id'] as int,
      connectorIdPrefix: json['connector_id_prefix']?.toString(),
      stationStatus: json['station_status'] as String,
      connectorStatus: json['connector_status'] as String,
      errorCode: json['error_code'] as String?,
      timestamp: json['timestamp'] as String,
    );
  }
}
