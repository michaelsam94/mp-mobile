import 'dart:async';
import 'dart:convert';

import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:mega_plus/core/helpers/cache/cache_helper.dart';
import 'package:mega_plus/core/helpers/cache/cache_keys.dart';

class WebSocketService {
  WebSocketChannel? _channel;

  bool _isConnected = false;
  bool _isManuallyClosed = false;

  int _reconnectAttempts = 0;
  final int _maxReconnectAttempts = 5;
  final Duration _reconnectDelay = const Duration(seconds: 3);

  // Heartbeat / Ping
  Timer? _pingTimer;
  final Duration _pingInterval = const Duration(seconds: 30);
  final String _pingMessage = 'ping';
  // Callbacks
  Function(dynamic)? onMessage;
  Function()? onConnect;
  Function(String)? onError;
  Function()? onDisconnect;

  bool get isConnected => _isConnected;

  void connect() {
    if (_isConnected) return;

    _isManuallyClosed = false;

    final token = CacheHelper.getString(CacheKeys.token.name);
    final uri = Uri.parse('ws://34.38.50.190:7070?token=$token');

    try {
      _channel = WebSocketChannel.connect(uri);

      _channel!.stream.listen(
        (message) {
          _isConnected = true;
          _reconnectAttempts = 0;

          if (message == 'pong') {
            return;
          }

          if (onMessage != null) {
            onMessage!(jsonDecode(message));
          }
        },
        onError: (error) {
          _isConnected = false;
          _stopPing();
          if (onError != null) {
            onError!(error.toString());
          }
          _handleReconnect();
        },
        onDone: () {
          _isConnected = false;
          _stopPing();
          if (onDisconnect != null) {
            onDisconnect!();
          }
          _handleReconnect();
        },
        cancelOnError: true,
      );

      _isConnected = true;
      _reconnectAttempts = 0;
      _startPing();

      if (onConnect != null) {
        onConnect!();
      }
    } catch (e) {
      _isConnected = false;
      _stopPing();
      if (onError != null) {
        onError!(e.toString());
      }
      _handleReconnect();
    }
  }

  void _handleReconnect() {
    if (_isManuallyClosed) return;

    if (_reconnectAttempts >= _maxReconnectAttempts) return;

    _reconnectAttempts++;

    Future.delayed(_reconnectDelay, () {
      if (!_isConnected && !_isManuallyClosed) {
        connect();
      }
    });
  }

  void disconnect() {
    _isManuallyClosed = true;
    _isConnected = false;
    _stopPing();
    _channel?.sink.close();
    _channel = null;
  }

  // ========== Heartbeat / Ping ==========

  void _startPing() {
    _pingTimer?.cancel();
    _pingTimer = Timer.periodic(_pingInterval, (_) {
      if (_isConnected && _channel != null) {
        try {
          _channel!.sink.add(_pingMessage);
        } catch (e) {
          _isConnected = false;
          _stopPing();
          if (onError != null) {
            onError!(e.toString());
          }
          _handleReconnect();
        }
      }
    });
  }

  void _stopPing() {
    _pingTimer?.cancel();
    _pingTimer = null;
  }

  // ========== Handlers setters ==========

  void setMessageHandler(Function(dynamic) handler) {
    onMessage = handler;
  }

  void setConnectHandler(Function() handler) {
    onConnect = handler;
  }

  void setErrorHandler(Function(String) handler) {
    onError = handler;
  }

  void setDisconnectHandler(Function() handler) {
    onDisconnect = handler;
  }
}
