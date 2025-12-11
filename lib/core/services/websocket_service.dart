import 'dart:convert';

import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:mega_plus/core/helpers/cache/cache_helper.dart';
import 'package:mega_plus/core/helpers/cache/cache_keys.dart';

class WebSocketService {
  late WebSocketChannel channel;
  Function(dynamic)? onMessage;
  Function()? onConnect;
  Function(String)? onError;
  Function()? onDisconnect;

  void connect() {
    final token = CacheHelper.getString(CacheKeys.token.name);
    channel = WebSocketChannel.connect(
      Uri.parse('ws://34.38.50.190:7070?token=$token'),
    );

    channel.stream.listen(
      (message) {
        if (onMessage != null) {
          onMessage!(jsonDecode(message));
        }
      },
      onError: (error) {
        if (onError != null) {
          onError!(error.toString());
        }
      },
      onDone: () {
        if (onDisconnect != null) {
          onDisconnect!();
        }
      },
    );

    if (onConnect != null) {
      onConnect!();
    }
  }

  void disconnect() {
    channel.sink.close();
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
