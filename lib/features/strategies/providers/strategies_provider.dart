import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/errors/app_error.dart';
import '../../../core/network/interceptors/auth_interceptor.dart';
import '../../../core/utils/result.dart';
import '../data/models/strategy.dart';
import '../data/strategies_api.dart';

part 'strategies_provider.g.dart';

sealed class StrategiesState {}

class StrategiesLoading extends StrategiesState {}

class StrategiesLoaded extends StrategiesState {
  StrategiesLoaded(this.strategies);
  final List<Strategy> strategies;
  Strategy? get active => strategies.where((s) => s.isActive).firstOrNull;
}

class StrategiesError extends StrategiesState {
  StrategiesError(this.error);
  final AppError error;
}

@riverpod
class StrategiesNotifier extends _$StrategiesNotifier {
  @override
  StrategiesState build() {
    ref.watch(authInvalidatedProvider);
    _load();
    return StrategiesLoading();
  }

  Future<void> _load() async {
    final result = await ref.read(strategiesApiProvider).getStrategies();
    state = result.fold(
      onOk: StrategiesLoaded.new,
      onErr: StrategiesError.new,
    );
  }

  Future<Result<Strategy, AppError>> createAndActivate(
      CreateStrategyRequest req) async {
    final api = ref.read(strategiesApiProvider);
    final result = await api.createStrategy(req);
    if (result.isErr) return Err(result.error);
    final strategy = result.value;
    final activateResult = await api.activateStrategy(strategy.id);
    if (activateResult.isErr) return Err(activateResult.error);
    await _load();
    return Ok(strategy);
  }

  Future<void> refresh() => _load();
}
