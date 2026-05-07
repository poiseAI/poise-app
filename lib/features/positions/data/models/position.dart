import 'package:freezed_annotation/freezed_annotation.dart';

part 'position.freezed.dart';
part 'position.g.dart';

@freezed
abstract class Position with _$Position {
  const factory Position({
    required String id,
    required String symbol,
    required String side, // 'long' | 'short'
    required double entryPrice,
    required double currentPrice,
    @JsonKey(readValue: _readQuantity) required double quantity,
    @Default(1.0) double leverage,
    required double unrealizedPnl,
    @Default(0.0) double unrealizedPnlPct,
    required String status, // 'open' | 'locked' | 'closing'
    @Default(false) bool isLocked,
    @JsonKey(name: 'tp_levels') @Default([]) List<double> tpLevels,
    @JsonKey(name: 'sl_price') double? slPrice,
    @JsonKey(name: 'exchange') @Default('bybit') String exchange,
    @JsonKey(name: 'created_at') required String createdAt,
  }) = _Position;

  factory Position.fromJson(Map<String, dynamic> json) =>
      _$PositionFromJson(json);
}

Object? _readQuantity(Map<dynamic, dynamic> json, String key) =>
    json[key] ?? json['size'];

@freezed
abstract class PnlSummary with _$PnlSummary {
  const factory PnlSummary({
    @JsonKey(name: 'total_unrealized_pnl')
    @Default(0.0)
    double totalUnrealizedPnl,
    @JsonKey(name: 'total_unrealized_pnl_pct')
    @Default(0.0)
    double totalUnrealizedPnlPct,
    @JsonKey(name: 'day_pnl') @Default(0.0) double dayPnl,
    @JsonKey(name: 'day_pnl_pct') @Default(0.0) double dayPnlPct,
    @JsonKey(name: 'total_margin_used') @Default(0.0) double totalMarginUsed,
    @JsonKey(name: 'position_count') @Default(0) int positionCount,
  }) = _PnlSummary;

  factory PnlSummary.fromJson(Map<String, dynamic> json) =>
      _$PnlSummaryFromJson(json);
}
