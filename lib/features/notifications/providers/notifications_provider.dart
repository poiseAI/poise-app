import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/websocket/ws_message.dart';
import '../../../core/websocket/ws_service.dart';
import '../data/models/notification_item.dart';
import '../data/notification_repository.dart';

part 'notifications_provider.g.dart';

@riverpod
class Notifications extends _$Notifications {
  StreamSubscription<WsMessage>? _wsSub;
  StreamSubscription<Map<String, dynamic>>? _notifSub;

  @override
  List<NotificationItem> build() {
    ref.onDispose(() {
      _wsSub?.cancel();
      _notifSub?.cancel();
    });
    _load();
    return [];
  }

  Future<void> _load() async {
    final result =
        await ref.read(notificationRepositoryProvider).getRecent();
    result.fold(
      onOk: (items) => state = items,
      onErr: (_) {},
    );

    final wsService = ref.read(wsServiceProvider);

    // Order fill/cancel events → inline notification
    _wsSub = wsService.stream.listen((msg) {
      if (msg is WsOrderUpdate) _injectFromOrder(msg);
    });

    // Real-time backend notifications (persisted + broadcast via WS)
    _notifSub = wsService.notificationStream.listen(_injectFromWs);
  }

  /// Backend sends: { id, title, body, notification_type, read, created_at }
  void _injectFromWs(Map<String, dynamic> data) {
    final id = data['id'] as String? ??
        'ws-${DateTime.now().millisecondsSinceEpoch}';

    // Avoid duplicates when REST pre-load + WS push overlap
    if (state.any((n) => n.id == id)) return;

    final notification = NotificationItem(
      id: id,
      title: data['title'] as String? ?? '',
      body: data['body'] as String? ?? '',
      type: data['notification_type'] as String? ?? 'system',
      read: false,
      createdAt: data['created_at'] as String? ??
          DateTime.now().toIso8601String(),
    );
    state = [notification, ...state];
  }

  void _injectFromOrder(WsOrderUpdate msg) {
    final data = msg.data;
    final status = data['status'] as String? ?? '';
    if (status != 'filled' && status != 'cancelled') return;

    final notification = NotificationItem(
      id: 'ws-${DateTime.now().millisecondsSinceEpoch}',
      title: status == 'filled' ? 'Order filled' : 'Order cancelled',
      body:
          '${data['symbol'] ?? ''} ${data['side'] ?? ''} order '
          '${status == 'filled' ? 'was filled' : 'was cancelled'}.',
      type: status == 'filled' ? 'order_filled' : 'order_cancelled',
      createdAt: DateTime.now().toIso8601String(),
    );
    state = [notification, ...state];
  }

  void dismiss(String id) {
    state = state.where((n) => n.id != id).toList();
  }

  void markRead(String id) {
    state = [
      for (final n in state)
        if (n.id == id) n.copyWith(read: true) else n,
    ];
    ref.read(notificationRepositoryProvider).markRead(id);
  }

  Future<void> markAllRead() async {
    state = state.map((n) => n.copyWith(read: true)).toList();
    await ref.read(notificationRepositoryProvider).markAllRead();
  }

  int get unreadCount => state.where((n) => !n.read).length;
}

@riverpod
int notificationUnreadCount(Ref ref) {
  final items = ref.watch(notificationsProvider);
  return items.where((n) => !n.read).length;
}
