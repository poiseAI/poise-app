import 'package:freezed_annotation/freezed_annotation.dart';

part 'position.freezed.dart';
part 'position.g.dart';

@freezed
abstract class Position with _$Position {
  const factory Position({
    required String id,
    required String symbol,
    required String side, // 'long' | 'short'
    @JsonKey(name: 'entry_price', readValue: _readEntryPrice)
    required double entryPrice,
    @JsonKey(name: 'current_price', readValue: _readCurrentPrice)
    required double currentPrice,
    @JsonKey(readValue: _readQuantity) required double quantity,
    @Default('external') String source,
    @JsonKey(name: 'exchange_order_id') String? exchangeOrderId,
    @Default(1.0) double leverage,
    @JsonKey(name: 'unrealized_pnl', readValue: _readUnrealizedPnl)
    required double unrealizedPnl,
    @JsonKey(
      name: 'unrealized_pnl_pct',
      readValue: _readUnrealizedPnlPct,
    )
    @Default(0.0)
    double unrealizedPnlPct,
    @JsonKey(name: 'realized_pnl') @Default(0.0) double realizedPnl,
    @JsonKey(name: 'liquidation_price') double? liquidationPrice,
    @JsonKey(name: 'margin_used') double? marginUsed,
    @JsonKey(name: 'remaining_quantity') double? remainingQuantity,
    @JsonKey(name: 'sync_status') @Default('synced') String syncStatus,
    @JsonKey(name: 'last_synced_at') String? lastSyncedAt,
    @JsonKey(name: 'closed_at') String? closedAt,
    required String status, // 'open' | 'locked' | 'closing'
    @JsonKey(name: 'is_locked', readValue: _readIsLocked)
    @Default(false)
    bool isLocked,
    @JsonKey(name: 'tp_levels') @Default([]) List<double> tpLevels,
    @JsonKey(name: 'sl_price') double? slPrice,
    @JsonKey(name: 'exchange') @Default('bybit') String exchange,
    @JsonKey(name: 'created_at') required String createdAt,
  }) = _Position;

  factory Position.fromJson(Map<String, dynamic> json) =>
      _$PositionFromJson(json);
}

Object? _readQuantity(Map<dynamic, dynamic> json, String key) =>
    _num(json[key] ?? json['size']);

Object? _readEntryPrice(Map<dynamic, dynamic> json, String key) =>
    _num(json[key] ?? json['entryPrice']);

Object? _readCurrentPrice(Map<dynamic, dynamic> json, String key) => _num(
      json[key] ??
          json['currentPrice'] ??
          json['mark_price'] ??
          json['markPrice'],
    );

Object? _readUnrealizedPnl(Map<dynamic, dynamic> json, String key) =>
    _num(json[key] ?? json['unrealizedPnl'] ?? json['unrealisedPnl']);

Object? _readUnrealizedPnlPct(Map<dynamic, dynamic> json, String key) =>
    _num(json[key] ?? json['unrealizedPnlPct']);

Object? _readIsLocked(Map<dynamic, dynamic> json, String key) =>
    json[key] ?? json['isLocked'];

Object? _num(Object? value) {
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value);
  return value;
}

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
