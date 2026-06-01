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
    final positions = ref
        .read(localCacheProvider)
        .getList<Position>(
          CacheBoxNames.positions,
          _cacheKey,
          Position.fromJson,
        )
        .where((position) => position.isOpenPosition)
        .toList();
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
    if (current == null) {
      final inserted = _fromWs(msg);
      if (inserted != null && inserted.isOpenPosition) {
        state = AsyncData([inserted]);
        _persist([inserted]);
      }
      return;
    }
    final idx = current.indexWhere((p) => p.id == msg.positionId);
    if (idx == -1) {
      final inserted = _fromWs(msg);
      if (inserted == null || !inserted.isOpenPosition) return;
      final next = [inserted, ...current];
      state = AsyncData(next);
      _persist(next);
      return;
    }
    final data = msg.data;
    final updated = current[idx].copyWith(
      currentPrice: (data['current_price'] as num?)?.toDouble() ??
          current[idx].currentPrice,
      unrealizedPnl: (data['unrealized_pnl'] as num?)?.toDouble() ??
          current[idx].unrealizedPnl,
      unrealizedPnlPct: (data['unrealized_pnl_pct'] as num?)?.toDouble() ??
          current[idx].unrealizedPnlPct,
      quantity: _nullableNum(data['quantity'] ?? data['size']) ??
          current[idx].quantity,
      remainingQuantity: _nullableNum(
            data['remaining_quantity'] ?? data['remainingQuantity'],
          ) ??
          current[idx].remainingQuantity,
      status: data['status'] as String? ??
          data['position_status'] as String? ??
          data['positionStatus'] as String? ??
          current[idx].status,
      closedAt: data['closed_at'] as String? ??
          data['closedAt'] as String? ??
          current[idx].closedAt,
      isLocked: data['is_locked'] as bool? ?? current[idx].isLocked,
      syncStatus: data['sync_status'] as String? ?? current[idx].syncStatus,
      lastSyncedAt:
          data['last_synced_at'] as String? ?? current[idx].lastSyncedAt,
      source: data['source'] as String? ?? current[idx].source,
      slPrice: (data['sl_price'] as num?)?.toDouble() ?? current[idx].slPrice,
    );
    final next = [...current];
    if (!updated.isOpenPosition) {
      next.removeAt(idx);
    } else {
      next[idx] = updated;
    }
    state = AsyncData(next);
    _persist(next);
  }

  Position? _fromWs(WsPositionUpdate msg) {
    final data = msg.data;
    final id = msg.positionId.isNotEmpty
        ? msg.positionId
        : data['id'] as String? ?? data['position_id'] as String?;
    final symbol = data['symbol'] as String?;
    if (id == null || id.isEmpty || symbol == null || symbol.isEmpty) {
      return null;
    }
    final entry =
        _num(data['entry_price'] ?? data['entryPrice'] ?? data['avg_price']);
    final current =
        _num(data['current_price'] ?? data['mark_price'] ?? data['markPrice']);
    return Position(
      id: id,
      symbol: symbol,
      side: _side(data['side'] as String? ?? data['positionSide'] as String?),
      entryPrice: entry,
      currentPrice: current > 0 ? current : entry,
      quantity: _num(data['quantity'] ?? data['size']),
      source: data['source'] as String? ?? 'external',
      exchangeOrderId: data['exchange_order_id'] as String?,
      leverage: _num(data['leverage'], fallback: 1),
      unrealizedPnl: _num(data['unrealized_pnl'] ?? data['unrealisedPnl']),
      unrealizedPnlPct: _num(data['unrealized_pnl_pct']),
      realizedPnl: _num(data['realized_pnl']),
      liquidationPrice: _nullableNum(data['liquidation_price']),
      marginUsed: _nullableNum(data['margin_used']),
      remainingQuantity:
          _nullableNum(data['remaining_quantity'] ?? data['remainingQuantity']),
      syncStatus: data['sync_status'] as String? ?? 'synced',
      lastSyncedAt: data['last_synced_at'] as String?,
      closedAt: data['closed_at'] as String? ?? data['closedAt'] as String?,
      status: data['status'] as String? ??
          data['position_status'] as String? ??
          data['positionStatus'] as String? ??
          'open',
      isLocked: data['is_locked'] as bool? ?? false,
      tpLevels: _tpLevels(data['tp_levels']),
      slPrice: _nullableNum(data['sl_price'] ?? data['stop_loss']),
      exchange: data['exchange'] as String? ?? 'bybit',
      createdAt:
          data['created_at'] as String? ?? DateTime.now().toIso8601String(),
    );
  }

  void _persist(List<Position> positions) {
    ref.read(localCacheProvider).putList<Position>(
          CacheBoxNames.positions,
          _cacheKey,
          positions,
          (p) => p.toJson(),
        );
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

String _side(String? value) {
  final normalized = (value ?? 'long').toLowerCase();
  if (normalized == 'buy') return 'long';
  if (normalized == 'sell') return 'short';
  return normalized;
}
