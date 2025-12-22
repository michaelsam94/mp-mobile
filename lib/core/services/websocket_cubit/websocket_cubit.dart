import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../models/notification_update_model.dart';
import '../models/session_update_model.dart';
import '../models/websocket_response.dart';
import '../websocket_service.dart';

part 'websocket_state.dart';

class WebSocketCubit extends Cubit<WebSocketState> {
  final WebSocketService service;

  MeterValueData? _currentMeterData;

  MeterValueData? get currentMeterData => _currentMeterData;

  WebSocketCubit(this.service) : super(WebSocketInitial()) {
    service.setMessageHandler(_handleMessage);
    service.setConnectHandler(() => emit(WebSocketConnected()));
    service.setErrorHandler((error) => emit(WebSocketError(error)));
    service.setDisconnectHandler(() => emit(WebSocketDisconnected()));
  }

  void connect() {
    if (!service.isConnected) {
      service.connect();
    }
  }

  void disconnect() {
    service.disconnect();
  }

  void _handleMessage(dynamic message) {
    if (message is Map<String, dynamic>) {
      print(message);

      final parsedMessage = WebSocketResponse.parseMessage(message);

      if (parsedMessage == null) {
        emit(WebSocketError('Unknown message type'));
        return;
      }

      if (parsedMessage is NotificationUpdateModel) {
        emit(NotificationUpdate(parsedMessage));
      } else if (parsedMessage is SessionUpdateModel) {
        if (parsedMessage.isMeterValue) {
          _currentMeterData = parsedMessage.meterData;
        }
        emit(SessionUpdate(parsedMessage));
      } else {
        emit(WebSocketMessage(parsedMessage));
      }
    }
  }
}
