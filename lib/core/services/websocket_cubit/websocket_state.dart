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
  final dynamic message;
  WebSocketMessage(this.message);
}

final class ChargerStatusUpdate extends WebSocketState {
  final Map<String, dynamic> data;
  ChargerStatusUpdate(this.data);
}

final class SessionUpdate extends WebSocketState {
  final Map<String, dynamic> data;
  SessionUpdate(this.data);
}

final class ActiveSessionUpdate extends WebSocketState {
  final Map<String, dynamic> data;
  ActiveSessionUpdate(this.data);
}

final class ChargerListUpdate extends WebSocketState {
  final Map<String, dynamic> data;
  ChargerListUpdate(this.data);
}

final class NotificationUpdate extends WebSocketState {
  final Map<String, dynamic> data;
  NotificationUpdate(this.data);
}
