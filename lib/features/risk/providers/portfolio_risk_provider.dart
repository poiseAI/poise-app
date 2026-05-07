import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/network/interceptors/auth_interceptor.dart';
import '../../../core/websocket/ws_message.dart';
import '../../../core/websocket/ws_service.dart';
import '../data/risk_api.dart';
import '../data/models/risk_score.dart';

part 'portfolio_risk_provider.g.dart';

@riverpod
class PortfolioRiskNotifier extends _$PortfolioRiskNotifier {
  StreamSubscription<WsMessage>? _wsSub;
  Timer? _pollTimer;

  @override
  AsyncValue<PortfolioRisk> build() {
    ref.watch(authInvalidatedProvider);
    ref.onDispose(() {
      _wsSub?.cancel();
      _pollTimer?.cancel();
    });
    _init();
    return const AsyncLoading();
  }

  Future<void> _init() async {
    await _fetch();
    // Poll every 60s as fallback to WS token_score events
    _pollTimer = Timer.periodic(const Duration(seconds: 60), (_) => _fetch());
    _wsSub = ref.read(wsServiceProvider).stream.listen((msg) {
      if (msg is WsTokenScore) _fetch();
    });
  }

  Future<void> _fetch() async {
    final result = await ref.read(riskApiProvider).getPortfolioRisk();
    result.fold(
      onOk: (r) => state = AsyncData(r),
      onErr: (e) {
        if (state is AsyncLoading) state = AsyncError(e, StackTrace.current);
      },
    );
  }

  Future<void> refresh() => _fetch();
}
