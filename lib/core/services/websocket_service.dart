import 'dart:async';
import 'dart:convert';

import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:mega_plus/core/helpers/cache/cache_helper.dart';
import 'package:mega_plus/core/helpers/cache/cache_keys.dart';

class WebSocketService {
  WebSocketChannel? channel;
  Function(dynamic)? onMessage;
  Function()? onConnect;
  Function(String)? onError;
  Function()? onDisconnect;
  
  Timer? _reconnectTimer;
  bool _isConnected = false;
  bool _shouldReconnect = true;
  int _reconnectAttempts = 0;
  static const int _maxReconnectDelay = 30; // seconds

  void connect() {
    _shouldReconnect = true;
    _connectInternal();
  }

  void _connectInternal() {
    try {
      final token = CacheHelper.getString(CacheKeys.token.name);
      // Check if user is logged in (not guest mode)
      final isLoggedIn = CacheHelper.checkLogin() == 3;
      
      String url;
      if (isLoggedIn && token != null && token.isNotEmpty) {
        url = 'ws://35.195.65.178:7070?token=$token';
      } else {
        // Guest mode - connect without token
        url = 'ws://35.195.65.178:7070';
      }
      
      channel = WebSocketChannel.connect(
        Uri.parse(url),
      );

      channel!.stream.listen(
        (message) {
          _isConnected = true;
          _reconnectAttempts = 0;
          if (onMessage != null) {
            onMessage!(jsonDecode(message));
          }
        },
        onError: (error) {
          _isConnected = false;
          if (onError != null) {
            onError!(error.toString());
          }
          _scheduleReconnect();
        },
        onDone: () {
          _isConnected = false;
          if (onDisconnect != null) {
            onDisconnect!();
          }
          _scheduleReconnect();
        },
      );

      _isConnected = true;
      if (onConnect != null) {
        onConnect!();
      }
    } catch (e) {
      _isConnected = false;
      if (onError != null) {
        onError!(e.toString());
      }
      _scheduleReconnect();
    }
  }

  void _scheduleReconnect() {
    if (!_shouldReconnect) return;
    
    _reconnectTimer?.cancel();
    
    // Exponential backoff: 1s, 2s, 4s, 8s... up to max
    final delay = (_reconnectAttempts < 5) 
        ? (1 << _reconnectAttempts) 
        : _maxReconnectDelay;
    _reconnectAttempts++;
    
    _reconnectTimer = Timer(Duration(seconds: delay), () {
      if (_shouldReconnect && !_isConnected) {
        _connectInternal();
      }
    });
  }

  void disconnect() {
    _shouldReconnect = false;
    _reconnectTimer?.cancel();
    _isConnected = false;
    channel?.sink.close();
  }

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
