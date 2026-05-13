import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/network/interceptors/auth_interceptor.dart';
import '../../../core/storage/local_cache.dart';
import '../../../core/websocket/ws_message.dart';
import '../../../core/websocket/ws_service.dart';
import '../../positions/data/models/position.dart';
import '../../positions/data/positions_api.dart';
import '../../profile/data/profile_api.dart';
import 'home_state.dart';

part 'home_provider.g.dart';

@riverpod
class Home extends _$Home {
  StreamSubscription<WsMessage>? _wsSub;
  bool _disposed = false;
  static const _posKey = 'open_positions';

  @override
  HomeState build() {
    ref.watch(authInvalidatedProvider);
    _disposed = false;
    ref.onDispose(() {
      _disposed = true;
      _wsSub?.cancel();
    });
    _init();
    return const HomeState.loading();
  }

  Future<void> _init() async {
    _loadFromCache();
    await _fetchFresh();
    if (_disposed) return;
    _subscribeWs();
  }

  void _loadFromCache() {
    final cache = ref.read(localCacheProvider);
    final positions = cache.getList<Position>(
      CacheBoxNames.positions,
      _posKey,
      Position.fromJson,
    );
    if (positions.isEmpty) return;
    state = HomeState.data(
      positions: positions,
      summary: const PnlSummary(),
    );
  }

  Future<void> _fetchFresh() async {
    // Check exchange connection first — determines whether to show connect CTA
    final connResult =
        await ref.read(profileApiProvider).getExchangeConnections();
    if (_disposed) return;
    final connections = connResult.valueOrNull ?? [];
    if (connections.isEmpty) {
      state = const HomeState.noExchange();
      return;
    }

    final api = ref.read(positionsApiProvider);
    final posResult = await api.getOpenPositions();
    if (_disposed) return;
    final pnlResult = await api.getPnlSummary();
    if (_disposed) return;

    if (posResult.isErr && state is HomeLoading) {
      state = HomeState.error(message: posResult.error.userMessage);
      return;
    }

    final positions = posResult.valueOrNull ?? [];
    final summary = pnlResult.valueOrNull ?? const PnlSummary();

    if (positions.isNotEmpty) {
      await ref.read(localCacheProvider).putList<Position>(
            CacheBoxNames.positions,
            _posKey,
            positions,
            (p) => p.toJson(),
          );
      if (_disposed) return;
    }

    state = positions.isEmpty
        ? HomeState.empty(summary: summary)
        : HomeState.data(positions: positions, summary: summary);
  }

  void _subscribeWs() {
    _wsSub = ref.read(wsServiceProvider).stream.listen((msg) {
      if (msg is WsPositionUpdate) _applyPositionUpdate(msg);
    });
  }

  void _applyPositionUpdate(WsPositionUpdate msg) {
    final current = state;
    if (current is! HomeData && current is! HomeEmpty) return;

    final positions =
        current is HomeData ? current.positions : const <Position>[];
    final summary = switch (current) {
      HomeData(:final summary) => summary,
      HomeEmpty(:final summary) => summary,
      _ => const PnlSummary(),
    };
    final positionId = _positionId(msg);
    final idx = positions.indexWhere((p) => p.id == positionId);
    final updated = idx == -1
        ? _positionFromWs(msg)
        : _mergePositionUpdate(positions[idx], msg.data);
    if (updated == null) return;

    final next = [...positions];
    if (idx == -1) {
      if (updated.status != 'open') return;
      next.insert(0, updated);
    } else if (updated.status == 'closed') {
      next.removeAt(idx);
    } else {
      next[idx] = updated;
    }

    _persistPositions(next);
    state = next.isEmpty
        ? HomeState.empty(summary: summary)
        : HomeState.data(positions: next, summary: summary);
  }

  Future<void> refresh() async {
    state = const HomeState.loading();
    await _fetchFresh();
  }

  /// Optimistic lock toggle — rolls back on error.
  Future<void> toggleLock(String positionId) async {
    final current = state;
    if (current is! HomeData) return;

    final idx = current.positions.indexWhere((p) => p.id == positionId);
    if (idx == -1) return;

    final position = current.positions[idx];
    final nowLocked = !position.isLocked;

    final optimistic = [...current.positions];
    optimistic[idx] = position.copyWith(isLocked: nowLocked);
    state = current.copyWith(positions: optimistic);

    final api = ref.read(positionsApiProvider);
    final result = nowLocked
        ? await api.lockPosition(positionId)
        : await api.unlockPosition(positionId);

    if (result.isErr) {
      final latest = state;
      if (latest is! HomeData) return;
      final rollback = [...latest.positions];
      if (idx >= rollback.length || rollback[idx].id != position.id) return;
      rollback[idx] = position;
      state = latest.copyWith(positions: rollback);
    }
  }

  void _persistPositions(List<Position> positions) {
    ref.read(localCacheProvider).putList<Position>(
          CacheBoxNames.positions,
          _posKey,
          positions,
          (p) => p.toJson(),
        );
  }
}

Position _mergePositionUpdate(Position current, Map<String, dynamic> data) {
  return current.copyWith(
    currentPrice: _num(
      data['current_price'] ?? data['currentPrice'] ?? data['mark_price'],
      fallback: current.currentPrice,
    ),
    unrealizedPnl: _num(
      data['unrealized_pnl'] ?? data['unrealizedPnl'] ?? data['unrealisedPnl'],
      fallback: current.unrealizedPnl,
    ),
    unrealizedPnlPct: _num(
      data['unrealized_pnl_pct'] ?? data['unrealizedPnlPct'],
      fallback: current.unrealizedPnlPct,
    ),
    status: data['status'] as String? ?? current.status,
    isLocked: data['is_locked'] as bool? ??
        data['isLocked'] as bool? ??
        current.isLocked,
    syncStatus: data['sync_status'] as String? ?? current.syncStatus,
    lastSyncedAt: data['last_synced_at'] as String? ?? current.lastSyncedAt,
    source: data['source'] as String? ?? current.source,
    slPrice:
        _nullableNum(data['sl_price'] ?? data['stop_loss']) ?? current.slPrice,
  );
}

Position? _positionFromWs(WsPositionUpdate msg) {
  final data = msg.data;
  final id = _positionId(msg);
  final symbol = data['symbol'] as String?;
  if (id == null || id.isEmpty || symbol == null || symbol.isEmpty) {
    return null;
  }

  final entry =
      _num(data['entry_price'] ?? data['entryPrice'] ?? data['avg_price']);
  final current =
      _num(data['current_price'] ?? data['currentPrice'] ?? data['mark_price']);
  return Position(
    id: id,
    symbol: symbol,
    side: (data['side'] as String? ?? 'long').toLowerCase(),
    entryPrice: entry,
    currentPrice: current > 0 ? current : entry,
    quantity: _num(data['quantity'] ?? data['size']),
    source: data['source'] as String? ?? 'external',
    exchangeOrderId: data['exchange_order_id'] as String?,
    leverage: _num(data['leverage'], fallback: 1),
    unrealizedPnl: _num(
      data['unrealized_pnl'] ?? data['unrealizedPnl'] ?? data['unrealisedPnl'],
    ),
    unrealizedPnlPct:
        _num(data['unrealized_pnl_pct'] ?? data['unrealizedPnlPct']),
    realizedPnl: _num(data['realized_pnl']),
    liquidationPrice: _nullableNum(data['liquidation_price']),
    marginUsed: _nullableNum(data['margin_used']),
    remainingQuantity: _nullableNum(data['remaining_quantity']),
    syncStatus: data['sync_status'] as String? ?? 'synced',
    lastSyncedAt: data['last_synced_at'] as String?,
    closedAt: data['closed_at'] as String?,
    status: data['status'] as String? ?? 'open',
    isLocked: data['is_locked'] as bool? ?? data['isLocked'] as bool? ?? false,
    tpLevels: _tpLevels(data['tp_levels']),
    slPrice: _nullableNum(data['sl_price'] ?? data['stop_loss']),
    exchange: data['exchange'] as String? ?? 'bybit',
    createdAt:
        data['created_at'] as String? ?? DateTime.now().toIso8601String(),
  );
}

String? _positionId(WsPositionUpdate msg) {
  if (msg.positionId.isNotEmpty) return msg.positionId;
  return msg.data['id'] as String? ?? msg.data['position_id'] as String?;
}

double _num(Object? value, {double fallback = 0}) {
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? fallback;
  return fallback;
}

double? _nullableNum(Object? value) {
  if (value == null) return null;
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value);
  return null;
}

List<double> _tpLevels(Object? raw) {
  if (raw is! List) return const [];
  return raw.map(_nullableNum).whereType<double>().toList();
}
