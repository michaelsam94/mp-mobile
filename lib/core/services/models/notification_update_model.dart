import 'websocket_response.dart';

class NotificationUpdateModel extends WebSocketResponse {
  final String title;
  final String message;
  final NotificationData? data;

  NotificationUpdateModel({
    required super.type,
    required this.title,
    required this.message,
    this.data,
    required super.timestamp,
  });

  factory NotificationUpdateModel.fromJson(Map<String, dynamic> json) {
    return NotificationUpdateModel(
      type: json['type'] as String,
      title: json['title'] as String,
      message: json['message'] as String,
      data: json['data'] != null
          ? NotificationData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
      timestamp: json['timestamp'] as String,
    );
  }
}

class NotificationData {
  final String sessionId;
  final int connectorId;

  NotificationData({
    required this.sessionId,
    required this.connectorId,
  });

  factory NotificationData.fromJson(Map<String, dynamic> json) {
    return NotificationData(
      sessionId: json['session_id'] as String,
      connectorId: json['connectorId'] as int,
    );
  }
}
