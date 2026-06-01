import 'package:freezed_annotation/freezed_annotation.dart';

part 'position.freezed.dart';
part 'position.g.dart';

@freezed
abstract class Position with _$Position {
  const factory Position({
    @JsonKey(readValue: _readId) @Default('') String id,
    @JsonKey(readValue: _readSymbol) @Default('') String symbol,
    @JsonKey(readValue: _readSide) @Default('long') String side,
    @JsonKey(name: 'entry_price', readValue: _readEntryPrice)
    @Default(0.0)
    double entryPrice,
    @JsonKey(name: 'current_price', readValue: _readCurrentPrice)
    @Default(0.0)
    double currentPrice,
    @JsonKey(readValue: _readQuantity) @Default(0.0) double quantity,
    @Default('external') String source,
    @JsonKey(name: 'exchange_order_id', readValue: _readExchangeOrderId)
    String? exchangeOrderId,
    @Default(1.0) double leverage,
    @JsonKey(name: 'unrealized_pnl', readValue: _readUnrealizedPnl)
    @Default(0.0)
    double unrealizedPnl,
    @JsonKey(
      name: 'unrealized_pnl_pct',
      readValue: _readUnrealizedPnlPct,
    )
    @Default(0.0)
    double unrealizedPnlPct,
    @JsonKey(name: 'realized_pnl', readValue: _readRealizedPnl)
    @Default(0.0)
    double realizedPnl,
    @JsonKey(name: 'liquidation_price', readValue: _readLiquidationPrice)
    double? liquidationPrice,
    @JsonKey(name: 'margin_used', readValue: _readMarginUsed)
    double? marginUsed,
    @JsonKey(name: 'remaining_quantity', readValue: _readRemainingQuantity)
    double? remainingQuantity,
    @JsonKey(name: 'sync_status', readValue: _readSyncStatus)
    @Default('synced')
    String syncStatus,
    @JsonKey(name: 'last_synced_at', readValue: _readLastSyncedAt)
    String? lastSyncedAt,
    @JsonKey(name: 'closed_at', readValue: _readClosedAt) String? closedAt,
    @JsonKey(readValue: _readStatus) @Default('open') String status,
    @JsonKey(name: 'is_locked', readValue: _readIsLocked)
    @Default(false)
    bool isLocked,
    @JsonKey(name: 'tp_levels', readValue: _readTpLevels)
    @Default([])
    List<double> tpLevels,
    @JsonKey(name: 'sl_price', readValue: _readSlPrice) double? slPrice,
    @JsonKey(name: 'exchange') @Default('bybit') String exchange,
    @JsonKey(name: 'created_at', readValue: _readCreatedAt)
    @Default('')
    String createdAt,
  }) = _Position;

  factory Position.fromJson(Map<String, dynamic> json) =>
      _$PositionFromJson(json);
}

extension PositionLifecycle on Position {
  bool get isOpenPosition {
    final normalized = normalizePositionStatus(status);
    if (closedAt != null && closedAt!.trim().isNotEmpty) return false;
    if (_isTerminalPositionStatus(normalized)) return false;
    final remaining = remainingQuantity;
    if (remaining != null) return remaining > 0;
    return quantity > 0;
  }
}

String normalizePositionStatus(String status) =>
    status.trim().toLowerCase().replaceAll(RegExp(r'[\s_\-]+'), '');

bool _isTerminalPositionStatus(String normalized) =>
    normalized.contains('filled') ||
    normalized.contains('closed') ||
    normalized.contains('cancel') ||
    normalized.contains('reject') ||
    normalized.contains('fail') ||
    normalized.contains('expire') ||
    normalized.contains('liquidated');

Object? _readId(Map<dynamic, dynamic> json, String key) => _str(json[key] ??
    json['position_id'] ??
    json['positionId'] ??
    json['exchange_order_id'] ??
    json['orderId']);

Object? _readSymbol(Map<dynamic, dynamic> json, String key) =>
    _str(json[key] ?? json['pair']);

Object? _readSide(Map<dynamic, dynamic> json, String key) {
  final side =
      (_str(json[key] ?? json['positionSide']) ?? 'long').toLowerCase();
  if (side == 'buy') return 'long';
  if (side == 'sell') return 'short';
  return side;
}

Object? _readQuantity(Map<dynamic, dynamic> json, String key) =>
    _num(json[key] ??
        json['size'] ??
        json['qty'] ??
        json['position_size'] ??
        json['positionSize']);

Object? _readEntryPrice(Map<dynamic, dynamic> json, String key) =>
    _num(json[key] ??
        json['entryPrice'] ??
        json['avg_price'] ??
        json['avgPrice'] ??
        json['avgEntryPrice']);

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

Object? _readRealizedPnl(Map<dynamic, dynamic> json, String key) =>
    _num(json[key] ?? json['realizedPnl'] ?? json['realisedPnl']);

Object? _readLiquidationPrice(Map<dynamic, dynamic> json, String key) =>
    _num(json[key] ?? json['liquidationPrice']);

Object? _readMarginUsed(Map<dynamic, dynamic> json, String key) =>
    _num(json[key] ?? json['marginUsed'] ?? json['positionIM']);

Object? _readRemainingQuantity(Map<dynamic, dynamic> json, String key) =>
    _num(json[key] ?? json['remainingQuantity'] ?? json['leavesQty']);

Object? _readExchangeOrderId(Map<dynamic, dynamic> json, String key) => _str(
      json[key] ??
          json['exchangeOrderId'] ??
          json['order_id'] ??
          json['orderId'],
    );

Object? _readSyncStatus(Map<dynamic, dynamic> json, String key) =>
    _str(json[key] ?? json['syncStatus']);

Object? _readLastSyncedAt(Map<dynamic, dynamic> json, String key) =>
    _dateString(json[key] ?? json['lastSyncedAt']);

Object? _readClosedAt(Map<dynamic, dynamic> json, String key) {
  final explicit = _dateString(
    json[key] ?? json['closedAt'] ?? json['close_time'] ?? json['closeTime'],
  );
  if (explicit != null) return explicit;
  final status =
      normalizePositionStatus(_str(_readStatus(json, 'status')) ?? '');
  if (!_isTerminalPositionStatus(status)) return null;
  return _dateString(
    json['updated_at'] ??
        json['updatedAt'] ??
        json['updated_time'] ??
        json['updateTime'] ??
        json['updatedTime'],
  );
}

Object? _readStatus(Map<dynamic, dynamic> json, String key) =>
    _str(json[key] ?? json['positionStatus'] ?? json['position_status']);

Object? _readIsLocked(Map<dynamic, dynamic> json, String key) =>
    json[key] ?? json['isLocked'];

Object? _readTpLevels(Map<dynamic, dynamic> json, String key) {
  final raw = json[key] ??
      json['tpLevels'] ??
      json['take_profit_levels'] ??
      json['takeProfits'] ??
      json['take_profit'] ??
      json['takeProfit'] ??
      json['take_profit_price'] ??
      json['takeProfitPrice'];
  if (raw is List) {
    return raw
        .map(_num)
        .whereType<double>()
        .where((value) => value > 0)
        .toList();
  }
  final single = _num(raw);
  return single == null || single <= 0 ? const <double>[] : <double>[single];
}

Object? _readSlPrice(Map<dynamic, dynamic> json, String key) => _positiveNum(
      json[key] ??
          json['slPrice'] ??
          json['stop_loss'] ??
          json['stopLoss'] ??
          json['stop_loss_price'] ??
          json['stopLossPrice'],
    );

Object? _readCreatedAt(Map<dynamic, dynamic> json, String key) => _dateString(
      json[key] ??
          json['createdAt'] ??
          json['created_time'] ??
          json['createTime'] ??
          json['createdTime'],
    );

String? _str(Object? value) {
  if (value == null) return null;
  final text = value.toString().trim();
  return text.isEmpty ? null : text;
}

double? _num(Object? value) {
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value.replaceAll(',', '').trim());
  return null;
}

double? _positiveNum(Object? value) {
  final parsed = _num(value);
  if (parsed == null || parsed <= 0) return null;
  return parsed;
}

String? _dateString(Object? value) {
  if (value == null) return null;
  if (value is num) return _dateFromEpoch(value);
  final text = value.toString().trim();
  if (text.isEmpty) return null;
  final numeric = num.tryParse(text);
  if (numeric != null) return _dateFromEpoch(numeric);
  return text;
}

String _dateFromEpoch(num value) {
  final millis = value > 9999999999 ? value.toInt() : value.toInt() * 1000;
  return DateTime.fromMillisecondsSinceEpoch(millis, isUtc: true)
      .toIso8601String();
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
