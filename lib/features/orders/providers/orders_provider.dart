import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/network/interceptors/auth_interceptor.dart';
import '../../../core/websocket/ws_message.dart';
import '../../../core/websocket/ws_service.dart';
import '../data/models/order.dart';
import '../data/orders_api.dart';

part 'orders_provider.g.dart';

@riverpod
class OrdersNotifier extends _$OrdersNotifier {
  StreamSubscription<WsMessage>? _wsSub;
  bool _disposed = false;

  @override
  AsyncValue<List<Order>> build() {
    ref.watch(authInvalidatedProvider);
    _disposed = false;
    ref.onDispose(() {
      _disposed = true;
      _wsSub?.cancel();
    });
    _init();
    return const AsyncLoading();
  }

  Future<void> _init() async {
    await _fetch();
    if (_disposed) return;
    _wsSub = ref.read(wsServiceProvider).stream.listen((msg) {
      if (msg is WsOrderUpdate) _applyOrderUpdate(msg);
    });
  }

  Future<void> _fetch({String? status}) async {
    final result = await ref.read(ordersApiProvider).getOrders(
          status: status,
          limit: 30,
        );
    if (_disposed) return;
    result.fold(
      onOk: (list) => state = AsyncData(list),
      onErr: (e) {
        if (state is AsyncLoading) state = AsyncError(e, StackTrace.current);
      },
    );
  }

  void _applyOrderUpdate(WsOrderUpdate msg) {
    final current = state.valueOrNull;
    if (current == null) return;
    final idx = current.indexWhere((o) => o.id == msg.orderId);
    if (idx == -1) {
      // Prepend new order from WS
      final newOrder = Order.fromJson(msg.data);
      state = AsyncData([newOrder, ...current]);
    } else {
      final updated = Order.fromJson({...current[idx].toJson(), ...msg.data});
      final next = [...current];
      next[idx] = updated;
      state = AsyncData(next);
    }
  }

  Future<void> refresh() => _fetch();

  Future<void> filterByStatus(String? status) => _fetch(status: status);
}
