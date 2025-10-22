import 'dart:async';
import 'dart:convert';

import 'package:ai_doctor_system/core/logging/logger.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../../features/auth/domain/services/auth_service.dart';
import '../../config/environment_config.dart';
import '../../di/injection_container.dart';

class WebSocketClient {
  WebSocketChannel? _channel;
  final StreamController<Map<String, dynamic>> _messagesController =
      StreamController.broadcast();

  Stream<Map<String, dynamic>> get messages => _messagesController.stream;

  Future<void> connect(String endpoint) async {
    Logger.debug('Attempting WebSocket connect to endpoint: $endpoint', 'WS');
    final token = await sl<AuthService>().getAccessToken();
    final uri =
        Uri.parse('${EnvironmentConfig.websocketUrl}$endpoint?token=$token');
    Logger.info('Connecting WebSocket → ${uri.toString()}', 'WS');
    _channel = WebSocketChannel.connect(uri);

    _channel!.stream.listen(
      (data) {
        Logger.debug('WS ← raw: $data', 'WS');
        try {
          final parsed = jsonDecode(data as String) as Map<String, dynamic>;
          Logger.debug('WS ← parsed: ${Logger.preview(parsed)}', 'WS');
          _messagesController.add(parsed);
        } catch (e, st) {
          Logger.error('Failed to parse WS message: $e', 'WS', e, st);
        }
      },
      onError: (error, st) {
        Logger.error('WebSocket error: $error', 'WS', error, st);
      },
      onDone: () {
        Logger.info('WebSocket connection closed', 'WS');
      },
    );

    Logger.info('WebSocket listener attached', 'WS');
  }

  void send(Map<String, dynamic> payload) {
    if (_channel == null) {
      Logger.warning('Attempted to send on null WebSocket channel', 'WS');
      return;
    }
    final encoded = jsonEncode(payload);
    Logger.debug('WS → sending: ${Logger.preview(payload)}', 'WS');
    _channel!.sink.add(encoded);
  }

  Future<void> disconnect() async {
    Logger.info('Disconnecting WebSocket', 'WS');
    await _channel?.sink.close();
    await _messagesController.close();
    _channel = null;
  }
}
