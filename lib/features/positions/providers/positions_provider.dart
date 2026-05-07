import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/network/interceptors/auth_interceptor.dart';
import '../../../core/storage/local_cache.dart';
import '../../../core/websocket/ws_message.dart';
import '../../../core/websocket/ws_service.dart';
import '../data/models/position.dart';
import '../data/positions_api.dart';

part 'positions_provider.g.dart';

/// Canonical positions state — shared source of truth for home + other features.
/// Seeds from HTTP, merges WsPositionUpdate events in real time.
@riverpod
class PositionsNotifier extends _$PositionsNotifier {
  StreamSubscription<WsMessage>? _wsSub;
  static const _cacheKey = 'open_positions';

  @override
  AsyncValue<List<Position>> build() {
    ref.watch(authInvalidatedProvider);
    ref.onDispose(() => _wsSub?.cancel());
    _init();
    return const AsyncLoading();
  }

  Future<void> _init() async {
    _loadCache();
    await _fetch();
    _subscribeWs();
  }

  void _loadCache() {
    final positions = ref.read(localCacheProvider).getList<Position>(
          CacheBoxNames.positions,
          _cacheKey,
          Position.fromJson,
        );
    if (positions.isNotEmpty) {
      state = AsyncData(positions);
    }
  }

  Future<void> _fetch() async {
    final result = await ref.read(positionsApiProvider).getOpenPositions();
    result.fold(
      onOk: (list) {
        state = AsyncData(list);
        ref.read(localCacheProvider).putList<Position>(
              CacheBoxNames.positions,
              _cacheKey,
              list,
              (p) => p.toJson(),
            );
      },
      onErr: (e) {
        if (state is AsyncLoading) {
          state = AsyncError(e, StackTrace.current);
        }
      },
    );
  }

  void _subscribeWs() {
    _wsSub = ref.read(wsServiceProvider).stream.listen((msg) {
      if (msg is WsPositionUpdate) _merge(msg);
    });
  }

  void _merge(WsPositionUpdate msg) {
    final current = state.valueOrNull;
    if (current == null) return;
    final idx = current.indexWhere((p) => p.id == msg.positionId);
    if (idx == -1) return;
    final data = msg.data;
    final updated = current[idx].copyWith(
      currentPrice: (data['current_price'] as num?)?.toDouble() ??
          current[idx].currentPrice,
      unrealizedPnl: (data['unrealized_pnl'] as num?)?.toDouble() ??
          current[idx].unrealizedPnl,
      unrealizedPnlPct: (data['unrealized_pnl_pct'] as num?)?.toDouble() ??
          current[idx].unrealizedPnlPct,
      status: data['status'] as String? ?? current[idx].status,
      isLocked: data['is_locked'] as bool? ?? current[idx].isLocked,
    );
    final next = [...current];
    next[idx] = updated;
    state = AsyncData(next);
  }

  Future<void> refresh() => _fetch();

  Future<void> lockPosition(String id) async {
    await ref.read(positionsApiProvider).lockPosition(id);
    await _fetch();
  }

  Future<void> unlockPosition(String id) async {
    await ref.read(positionsApiProvider).unlockPosition(id);
    await _fetch();
  }

  Future<void> closePosition(String id) async {
    await ref.read(positionsApiProvider).closePosition(id);
    await _fetch();
  }
}
