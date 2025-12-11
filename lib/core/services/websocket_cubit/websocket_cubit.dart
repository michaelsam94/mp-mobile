import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../websocket_service.dart';

part 'websocket_state.dart';

class WebSocketCubit extends Cubit<WebSocketState> {
  final WebSocketService service;

  WebSocketCubit(this.service) : super(WebSocketInitial()) {
    service.setMessageHandler(_handleMessage);
    service.setConnectHandler(() => emit(WebSocketConnected()));
    service.setErrorHandler((error) => emit(WebSocketError(error)));
    service.setDisconnectHandler(() => emit(WebSocketDisconnected()));
  }

  void connect() {
    service.connect();
  }

  void disconnect() {
    service.disconnect();
  }

  void _handleMessage(dynamic message) {
    if (message is Map<String, dynamic>) {
      print(message);
      switch (message['type']) {
        case 'charger_status_update':      
          emit(ChargerStatusUpdate(message));
          break;
        case 'session_update':
          emit(SessionUpdate(message));
          break;
        case 'active_session_update':
          emit(ActiveSessionUpdate(message));
          break;
        case 'charger_list_update':
          emit(ChargerListUpdate(message));
          break;
        case 'notification':
          emit(NotificationUpdate(message));
          break;
        case 'error':
          emit(WebSocketError(message['message']));
          break;
        default:
          emit(WebSocketMessage(message));
      }
    }
  }
}
