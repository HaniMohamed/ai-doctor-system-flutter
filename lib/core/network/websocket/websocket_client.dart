import 'dart:async';
import 'dart:convert';

import 'package:web_socket_channel/web_socket_channel.dart';

import '../../../features/auth/domain/services/auth_service.dart';
import '../../config/environment_config.dart';
import '../../di/injection_container.dart';

class WebSocketClient {
  WebSocketChannel? _channel;
  final StreamController<Map<String, dynamic>> _messagesController = StreamController.broadcast();

  Stream<Map<String, dynamic>> get messages => _messagesController.stream;

  Future<void> connect(String endpoint) async {
    final token = await sl<AuthService>().getAccessToken();
    final uri = Uri.parse('${EnvironmentConfig.websocketUrl}$endpoint?token=$token');
    _channel = WebSocketChannel.connect(uri);

    _channel!.stream.listen(
      (data) {
        try {
          final parsed = jsonDecode(data as String) as Map<String, dynamic>;
          _messagesController.add(parsed);
        } catch (_) {}
      },
      onError: (_) {},
      onDone: () {},
    );
  }

  void send(Map<String, dynamic> payload) {
    _channel?.sink.add(jsonEncode(payload));
  }

  Future<void> disconnect() async {
    await _channel?.sink.close();
    await _messagesController.close();
  }
}


