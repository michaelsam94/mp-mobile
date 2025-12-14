import 'notification_update_model.dart';
import 'session_update_model.dart';

abstract class WebSocketResponse {
  final String type;
  final String timestamp;

  WebSocketResponse({required this.type, required this.timestamp});

  static WebSocketResponse? parseMessage(Map<String, dynamic> json) {
    try {
      final type = json['type'] as String?;

      switch (type) {
        case 'notification':
          return NotificationUpdateModel.fromJson(json);
        case 'session_update':
          return SessionUpdateModel.fromJson(json);
        // case 'active_session_update':
        //   return ActiveSessionUpdateModel.fromJson(json);
        // case 'charger_status_update':
        //   return ChargerStatusUpdateModel.fromJson(json);
        // case 'charger_list_update':
        //   return ChargerListUpdateModel.fromJson(json);
        default:
          return null;
      }
    } catch (e) {
      print('Error parsing WebSocket message: $e');
      return null;
    }
  }
}
