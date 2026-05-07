import 'package:freezed_annotation/freezed_annotation.dart';
import '../../positions/data/models/position.dart';

part 'home_state.freezed.dart';

/// Maps 1:1 to the six Figma home screen variants (A–F).
@freezed
sealed class HomeState with _$HomeState {
  /// A — first paint, fetching data
  const factory HomeState.loading() = HomeLoading;

  /// C — authenticated but no exchange connected
  const factory HomeState.noExchange() = HomeNoExchange;

  /// D — exchange connected, zero open positions
  const factory HomeState.empty({
    required PnlSummary summary,
  }) = HomeEmpty;

  /// E — has open positions + live data
  const factory HomeState.data({
    required List<Position> positions,
    required PnlSummary summary,
  }) = HomeData;

  /// F — fetch failed
  const factory HomeState.error({
    required String message,
  }) = HomeError;
}
