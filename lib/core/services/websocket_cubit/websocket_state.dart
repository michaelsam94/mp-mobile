part of 'websocket_cubit.dart';

@immutable
sealed class WebSocketState {}

final class WebSocketInitial extends WebSocketState {}

final class WebSocketConnected extends WebSocketState {}

final class WebSocketDisconnected extends WebSocketState {}

final class WebSocketError extends WebSocketState {
  final String message;
  WebSocketError(this.message);
}

final class WebSocketMessage extends WebSocketState {
  final WebSocketResponse message;
  WebSocketMessage(this.message);
}

// final class ChargerStatusUpdate extends WebSocketState {
//   final ChargerStatusUpdateModel data;
//   ChargerStatusUpdate(this.data);
// }

final class SessionUpdate extends WebSocketState {
  final SessionUpdateModel data;
  SessionUpdate(this.data);
}

// final class ActiveSessionUpdate extends WebSocketState {
//   final ActiveSessionUpdateModel data;
//   ActiveSessionUpdate(this.data);
// }

// final class ChargerListUpdate extends WebSocketState {
//   final ChargerListUpdateModel data;
//   ChargerListUpdate(this.data);
// }

final class NotificationUpdate extends WebSocketState {
  final NotificationUpdateModel data;
  NotificationUpdate(this.data);
}

final class StatusNotificationUpdate extends WebSocketState {
  final StatusNotificationModel data;
  StatusNotificationUpdate(this.data);
}
