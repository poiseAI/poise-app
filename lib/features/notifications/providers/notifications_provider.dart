import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/websocket/ws_message.dart';
import '../../../core/websocket/ws_service.dart';
import '../../../core/storage/preferences.dart';
import '../data/models/notification_item.dart';
import '../data/notification_repository.dart';

part 'notifications_provider.g.dart';

@riverpod
class Notifications extends _$Notifications {
  StreamSubscription<WsMessage>? _wsSub;
  StreamSubscription<Map<String, dynamic>>? _notifSub;
  bool _subscribed = false;

  @override
  AsyncValue<List<NotificationItem>> build() {
    ref.onDispose(() {
      _wsSub?.cancel();
      _notifSub?.cancel();
    });
    _load();
    return const AsyncLoading();
  }

  Future<void> _load() async {
    final result = await ref.read(notificationRepositoryProvider).getRecent();
    result.fold(
      onOk: (items) {
        state = AsyncData(_sort(items));
        _subscribe();
      },
      onErr: (e) {
        state = AsyncError(e, StackTrace.current);
        _subscribe();
      },
    );
  }

  void _subscribe() {
    if (_subscribed) return;
    _subscribed = true;
    final wsService = ref.read(wsServiceProvider);
    _wsSub = wsService.stream.listen((msg) {
      if (msg is WsOrderUpdate) _injectFromOrder(msg);
      if (msg is WsPositionUpdate) _injectPosition(msg);
    });
    _notifSub = wsService.notificationStream.listen(_injectFromWs);
  }

  void _injectFromWs(Map<String, dynamic> data) {
    final id = _stableId(data, prefix: 'notification');
    _insert(NotificationItem(
      id: id,
      title: data['title'] as String? ?? '',
      body: data['body'] as String? ?? '',
      type: data['notification_type'] as String? ?? 'system',
      read: data['read'] as bool? ?? false,
      createdAt: data['created_at'] as String? ?? DateTime.now().toIso8601String(),
      meta: (data['meta'] as Map<String, dynamic>?) ?? data,
    ));
  }

  void _injectFromOrder(WsOrderUpdate msg) {
    final data = msg.data;
    final status = data['status'] as String? ?? '';
    if (status != 'filled' && status != 'cancelled' && status != 'rejected') {
      return;
    }
    _insert(NotificationItem(
      id: _stableId(data, prefix: 'order'),
      title: switch (status) {
        'filled' => 'Order filled',
        'cancelled' => 'Order cancelled',
        'rejected' => 'Order rejected',
        _ => 'Order updated',
      },
      body:
          '${data['symbol'] ?? ''} ${data['side'] ?? ''} order ${_statusPhrase(status)}.',
      type: switch (status) {
        'filled' => 'order_filled',
        'cancelled' => 'order_cancelled',
        'rejected' => 'order_rejected',
        _ => 'order_update',
      },
      createdAt: DateTime.now().toIso8601String(),
      meta: data,
    ));
  }

  void _injectPosition(WsPositionUpdate msg) {
    final data = msg.data;
    _insert(NotificationItem(
      id: _stableId(data, prefix: 'position', fallbackId: msg.positionId),
      title: data['source'] == 'external'
          ? 'External trade captured'
          : 'Position updated',
      body:
          '${data['symbol'] ?? 'Position'} updated from your connected exchange.',
      type: data['source'] == 'external'
          ? 'external_trade_captured'
          : 'position_update',
      createdAt: DateTime.now().toIso8601String(),
      meta: data,
    ));
  }

  void _insert(NotificationItem notification) {
    if (!_allows(notification.type)) return;
    final current = state.valueOrNull ?? const <NotificationItem>[];
    if (current.any((n) => n.id == notification.id)) return;
    state = AsyncData(_sort([notification, ...current]));
  }

  bool _allows(String type) {
    final prefs = ref.read(appPreferencesProvider).valueOrNull;
    if (prefs == null) return true;
    if (type.contains('external_trade')) {
      return prefs.externalTradeNotifications;
    }
    if (type.contains('guardrail') || type.contains('risk')) {
      return prefs.guardrailNotifications;
    }
    if (type.contains('order') || type.contains('position')) {
      return prefs.tradeUpdateNotifications;
    }
    return true;
  }

  Future<void> dismiss(String id) async {
    final current = state.valueOrNull ?? const <NotificationItem>[];
    state = AsyncData(current.where((n) => n.id != id).toList());
    await ref.read(notificationRepositoryProvider).dismiss(id);
  }

  Future<void> markRead(String id) async {
    final current = state.valueOrNull ?? const <NotificationItem>[];
    state = AsyncData([
      for (final n in current)
        if (n.id == id) n.copyWith(read: true) else n,
    ]);
    await ref.read(notificationRepositoryProvider).markRead(id);
  }

  Future<void> markAllRead() async {
    final current = state.valueOrNull ?? const <NotificationItem>[];
    state = AsyncData(current.map((n) => n.copyWith(read: true)).toList());
    await ref.read(notificationRepositoryProvider).markAllRead();
  }

  List<NotificationItem> _sort(List<NotificationItem> items) {
    final copy = [...items];
    copy.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return copy;
  }
}

String _statusPhrase(String status) => switch (status) {
      'filled' => 'was filled',
      'cancelled' => 'was cancelled',
      'rejected' => 'was rejected',
      _ => 'was updated',
    };

String _stableId(
  Map<String, dynamic> data, {
  required String prefix,
  String? fallbackId,
}) {
  final id = data['notification_id'] ??
      data['event_id'] ??
      data['id'] ??
      data['order_id'] ??
      data['exchange_order_id'] ??
      data['position_id'] ??
      fallbackId;
  final updated = data['updated_at'] ?? data['last_synced_at'] ?? data['status'];
  if (id != null && id.toString().isNotEmpty) return '$prefix-$id-$updated';
  return '$prefix-${DateTime.now().microsecondsSinceEpoch}';
}

@riverpod
int notificationUnreadCount(Ref ref) {
  final items = ref.watch(notificationsProvider).valueOrNull ?? const [];
  return items.where((n) => !n.read).length;
}
