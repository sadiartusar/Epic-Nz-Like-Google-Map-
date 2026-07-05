import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:epic_nz/core/base_url/api_constants.dart';
import 'package:flutter/foundation.dart';

class SocketChatService {
  IO.Socket? _socket;

  void connect({
    required String userId,
    required void Function(dynamic data) onMessage,
    required void Function() onConnected,
    required void Function(dynamic err) onError,
  }) {
    _socket?.disconnect();

    _socket = IO.io(
      ApiConstants.socketBaseUrl,
      IO.OptionBuilder()
          .setTransports(['websocket', 'polling'])
          .enableAutoConnect()
          .enableReconnection()
          .setReconnectionAttempts(100)
          .setReconnectionDelay(1000)
          .setExtraHeaders({
            'ngrok-skip-browser-warning': 'true',
            'Accept': 'application/json',
          })
          .build(),
    );

    _socket!.onConnect((_) {
      debugPrint("✅✅SOCKET CONNECTED: ${_socket!.id}");
      _socket!.emit("joinroom", userId);
      _socket!.emit("join-chat", userId);
      onConnected();
    });

    _socket!.on("message", (data) {
      debugPrint("📩 INCOMING MESSAGE: $data");
      onMessage(data);
    });

    _socket!.onConnectError((err) => onError(err));
    _socket!.onError((err) => onError(err));
  }

  void disconnect() {
    _socket?.disconnect();
    _socket?.dispose();
    _socket = null;
  }
}
