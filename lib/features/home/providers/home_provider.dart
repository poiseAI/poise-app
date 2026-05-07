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
  static const _posKey = 'open_positions';

  @override
  HomeState build() {
    ref.watch(authInvalidatedProvider);
    ref.onDispose(() => _wsSub?.cancel());
    _init();
    return const HomeState.loading();
  }

  Future<void> _init() async {
    _loadFromCache();
    await _fetchFresh();
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
    final connections = connResult.valueOrNull ?? [];
    if (connections.isEmpty) {
      state = const HomeState.noExchange();
      return;
    }

    final api = ref.read(positionsApiProvider);
    final posResult = await api.getOpenPositions();
    final pnlResult = await api.getPnlSummary();

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
    if (current is! HomeData) return;

    try {
      final updated = Position.fromJson(msg.data);
      final idx = current.positions.indexWhere((p) => p.id == updated.id);
      if (idx == -1) {
        state = current.copyWith(
          positions: [updated, ...current.positions],
        );
      } else {
        final list = [...current.positions];
        list[idx] = updated;
        state = current.copyWith(positions: list);
      }
    } catch (_) {
      // Malformed WS payload — skip
    }
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
      final rollback = [...(state as HomeData).positions];
      rollback[idx] = position;
      state = (state as HomeData).copyWith(positions: rollback);
    }
  }
}
