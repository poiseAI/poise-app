import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../config/app_config.dart';
import 'ws_message.dart';

part 'ws_service.g.dart';

@Riverpod(keepAlive: true)
WsService wsService(Ref ref) {
  final service = WsService();
  ref.onDispose(service.dispose);
  return service;
}

enum WsStatus { disconnected, connecting, connected }

class WsService with WidgetsBindingObserver {
  WsService() {
    WidgetsBinding.instance.addObserver(this);
  }

  WebSocketChannel? _channel;
  StreamSubscription? _sub;
  Timer? _reconnectTimer;
  String? _token;

  int _backoffSeconds = 1;
  WsStatus _status = WsStatus.disconnected;
  bool _intentionalDisconnect = false;

  WsStatus get status => _status;
  int get backoffSeconds => _backoffSeconds;

  final _controller = StreamController<WsMessage>.broadcast();
  Stream<WsMessage> get stream => _controller.stream;

  // Separate stream for notification payloads from the backend.
  // Avoids modifying the freezed WsMessage sealed class.
  final _notificationController =
      StreamController<Map<String, dynamic>>.broadcast();
  Stream<Map<String, dynamic>> get notificationStream =>
      _notificationController.stream;

  void connect(String token) {
    _token = token;
    _intentionalDisconnect = false;
    _doConnect();
  }

  void _doConnect() {
    if (_status == WsStatus.connected || _status == WsStatus.connecting) {
      _cleanup(emitDisconnected: false);
    }
    if (_token == null) return;

    _status = WsStatus.connecting;
    try {
      _channel = WebSocketChannel.connect(
        Uri.parse('${AppConfig.wsUrl}?token=$_token'),
      );

      _sub = _channel!.stream.listen(
        _onMessage,
        onError: (_) => _scheduleReconnect(),
        onDone: _scheduleReconnect,
        cancelOnError: false,
      );

      _status = WsStatus.connected;
      _backoffSeconds = 1;
      _controller.add(const WsMessage.connected());
    } catch (e) {
      _scheduleReconnect();
    }
  }

  void _onMessage(dynamic raw) {
    try {
      final json = jsonDecode(raw as String) as Map<String, dynamic>;
      final type = json['type'] as String?;

      // Handle notification type separately — backend sends persisted notification
      // data that maps directly to NotificationItem JSON fields.
      if (type == 'notification') {
        final data = json['data'] as Map<String, dynamic>? ?? {};
        _notificationController.add(data);
        return;
      }

      final msg = parseWsPayload(json);
      if (msg != null) _controller.add(msg);
    } catch (e) {
      if (kDebugMode) debugPrint('[WS] parse error: $e');
    }
  }

  void _scheduleReconnect() {
    if (_intentionalDisconnect || _token == null) return;
    final wasDisconnected = _status == WsStatus.disconnected;
    _status = WsStatus.disconnected;
    if (!wasDisconnected) _controller.add(const WsMessage.disconnected());
    _cleanup(emitDisconnected: false);

    _reconnectTimer = Timer(Duration(seconds: _backoffSeconds), () {
      _backoffSeconds = (_backoffSeconds * 2).clamp(1, 60);
      _doConnect();
    });
  }

  void disconnect() {
    _intentionalDisconnect = true;
    _token = null;
    _cleanup(emitDisconnected: false);
    _status = WsStatus.disconnected;
  }

  void updateToken(String token) {
    _token = token;
    if (_status == WsStatus.connected) {
      _doConnect();
    }
  }

  void _cleanup({bool emitDisconnected = true}) {
    _sub?.cancel();
    _sub = null;
    _reconnectTimer?.cancel();
    _reconnectTimer = null;
    _channel?.sink.close();
    _channel = null;
    if (emitDisconnected && _status == WsStatus.connected) {
      _status = WsStatus.disconnected;
      _controller.add(const WsMessage.disconnected());
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed &&
        _token != null &&
        _status == WsStatus.disconnected) {
      _backoffSeconds = 1;
      _intentionalDisconnect = false;
      _doConnect();
    }
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cleanup();
    _controller.close();
    _notificationController.close();
  }
}
