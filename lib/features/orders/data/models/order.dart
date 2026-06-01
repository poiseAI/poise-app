import 'package:freezed_annotation/freezed_annotation.dart';

part 'order.freezed.dart';
part 'order.g.dart';

@freezed
abstract class Order with _$Order {
  const factory Order({
    @JsonKey(readValue: _readId) @Default('') String id,
    @JsonKey(readValue: _readSymbol) @Default('') String symbol,
    @JsonKey(readValue: _readSide) @Default('buy') String side,
    @JsonKey(readValue: _readStatus) @Default('unknown') String status,
    @JsonKey(name: 'order_type', readValue: _readOrderType)
    @Default('market')
    String orderType,
    @JsonKey(readValue: _readQuantity) @Default(0.0) double quantity,
    @JsonKey(readValue: _readSource) @Default('poise') String source,
    @JsonKey(readValue: _readExchange) @Default('bybit') String exchange,
    @JsonKey(name: 'exchange_order_id', readValue: _readExchangeOrderId)
    String? exchangeOrderId,
    @JsonKey(name: 'entry_price', readValue: _readEntryPrice)
    double? entryPrice,
    @JsonKey(name: 'mark_price', readValue: _readMarkPrice) double? markPrice,
    @JsonKey(name: 'liquidation_price', readValue: _readLiquidationPrice)
    double? liquidationPrice,
    @JsonKey(name: 'margin_used', readValue: _readMarginUsed)
    double? marginUsed,
    @JsonKey(name: 'realized_pnl', readValue: _readRealizedPnl)
    double? realizedPnl,
    @JsonKey(name: 'unrealized_pnl', readValue: _readUnrealizedPnl)
    double? unrealizedPnl,
    @JsonKey(name: 'remaining_quantity', readValue: _readRemainingQuantity)
    double? remainingQuantity,
    @JsonKey(name: 'sync_status', readValue: _readSyncStatus)
    String? syncStatus,
    @JsonKey(name: 'last_synced_at', readValue: _readLastSyncedAt)
    String? lastSyncedAt,
    @JsonKey(name: 'closed_at', readValue: _readClosedAt) String? closedAt,
    @JsonKey(readValue: _readPrice) double? price,
    @JsonKey(readValue: _readLeverage) @Default(1.0) double leverage,
    @JsonKey(name: 'tp_levels', readValue: _readTpLevels)
    @Default([])
    List<double> tpLevels,
    @JsonKey(name: 'sl_price', readValue: _readSlPrice) double? slPrice,
    @JsonKey(name: 'created_at', readValue: _readCreatedAt)
    @Default('')
    String createdAt,
  }) = _Order;

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);
}

extension OrderStatusView on Order {
  bool get isActiveTrade => isActiveOrderStatus(
        status: status,
        remainingQuantity: remainingQuantity,
        closedAt: closedAt,
      );

  String get statusLabel => orderStatusLabel(status);
}

String normalizeOrderStatus(String status) =>
    status.trim().toLowerCase().replaceAll(RegExp(r'[\s_\-]+'), '');

bool isActiveOrderStatus({
  required String status,
  double? remainingQuantity,
  String? closedAt,
}) {
  final normalized = normalizeOrderStatus(status);
  if (closedAt != null && closedAt.trim().isNotEmpty) return false;
  if (remainingQuantity != null) return remainingQuantity > 0;
  if (_isTerminalStatus(normalized)) return false;
  if (normalized.contains('partial')) return true;
  return _activeStatuses.contains(normalized) || normalized.contains('open');
}

String orderStatusLabel(String status) {
  final normalized = normalizeOrderStatus(status);
  if (normalized.isEmpty || normalized == 'unknown') return 'Unknown';
  if (normalized.contains('partial')) return 'Partial';
  if (normalized.contains('filled')) return 'Filled';
  if (normalized.contains('closed')) return 'Closed';
  if (normalized.contains('cancel')) return 'Cancelled';
  if (normalized.contains('reject')) return 'Rejected';
  if (normalized.contains('fail')) return 'Failed';
  if (normalized.contains('expire')) return 'Expired';
  if (normalized == 'pending' ||
      normalized == 'submitted' ||
      normalized == 'accepted' ||
      normalized == 'new' ||
      normalized == 'working' ||
      normalized == 'created' ||
      normalized == 'untriggered' ||
      normalized == 'triggered') {
    return 'Pending';
  }
  if (_activeStatuses.contains(normalized) || normalized.contains('open')) {
    return 'Open';
  }
  return _titleCase(status);
}

const _activeStatuses = {
  'open',
  'active',
  'live',
  'placed',
  'pending',
  'submitted',
  'accepted',
  'new',
  'working',
  'created',
  'untriggered',
  'triggered',
};

bool _isTerminalStatus(String normalized) =>
    (normalized.contains('filled') && !normalized.contains('partial')) ||
    normalized.contains('closed') ||
    normalized.contains('cancel') ||
    normalized.contains('reject') ||
    normalized.contains('fail') ||
    normalized.contains('expire') ||
    normalized.contains('deactivated') ||
    normalized.contains('liquidated');

String _titleCase(String value) {
  final words = value
      .trim()
      .split(RegExp(r'[\s_\-]+'))
      .where((word) => word.isNotEmpty)
      .toList();
  if (words.isEmpty) return 'Unknown';
  return words
      .map((word) =>
          '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}')
      .join(' ');
}

Object? _readId(Map<dynamic, dynamic> json, String key) => _str(json[key] ??
    json['order_id'] ??
    json['orderId'] ??
    json['exchange_order_id'] ??
    json['orderLinkId']);

Object? _readSymbol(Map<dynamic, dynamic> json, String key) =>
    _str(json[key] ?? json['pair']);

Object? _readSide(Map<dynamic, dynamic> json, String key) =>
    _str(json[key] ?? json['positionSide'] ?? json['order_side']);

Object? _readStatus(Map<dynamic, dynamic> json, String key) =>
    _str(json[key] ?? json['orderStatus'] ?? json['order_status']);

Object? _readOrderType(Map<dynamic, dynamic> json, String key) =>
    _str(json[key] ?? json['orderType'] ?? json['execution_mode']);

Object? _readQuantity(Map<dynamic, dynamic> json, String key) =>
    _num(json[key] ??
        json['qty'] ??
        json['size'] ??
        json['orderQty'] ??
        json['cumExecQty'] ??
        json['filled_qty'] ??
        json['filledQty']);

Object? _readSource(Map<dynamic, dynamic> json, String key) => _str(json[key]);

Object? _readExchange(Map<dynamic, dynamic> json, String key) =>
    _str(json[key]);

Object? _readExchangeOrderId(Map<dynamic, dynamic> json, String key) => _str(
      json[key] ??
          json['exchangeOrderId'] ??
          json['order_id'] ??
          json['orderId'],
    );

Object? _readEntryPrice(Map<dynamic, dynamic> json, String key) {
  final direct = _num(json[key] ??
      json['entryPrice'] ??
      json['entry_price'] ??
      json['avg_entry_price'] ??
      json['avgEntryPrice'] ??
      json['avg_price'] ??
      json['avgPrice'] ??
      json['avgFillPrice'] ??
      json['average_price'] ??
      json['averagePrice']);
  if (direct != null && direct > 0) return direct;
  final execValue = _num(json['cumExecValue'] ?? json['cum_exec_value']);
  final execQty = _num(json['cumExecQty'] ?? json['cum_exec_qty']);
  if (execValue != null && execQty != null && execQty > 0) {
    return execValue / execQty;
  }
  return _num(json['price'] ?? json['orderPrice'] ?? json['limit_price']);
}

Object? _readMarkPrice(Map<dynamic, dynamic> json, String key) => _num(
      json[key] ??
          json['markPrice'] ??
          json['current_price'] ??
          json['currentPrice'],
    );

Object? _readLiquidationPrice(Map<dynamic, dynamic> json, String key) =>
    _num(json[key] ?? json['liquidationPrice']);

Object? _readMarginUsed(Map<dynamic, dynamic> json, String key) => _num(
    json[key] ?? json['marginUsed'] ?? json['margin'] ?? json['cumExecFee']);

Object? _readRealizedPnl(Map<dynamic, dynamic> json, String key) => _num(
      json[key] ??
          json['realizedPnl'] ??
          json['realisedPnl'] ??
          json['closedPnl'] ??
          json['closed_pnl'],
    );

Object? _readUnrealizedPnl(Map<dynamic, dynamic> json, String key) => _num(
      json[key] ?? json['unrealizedPnl'] ?? json['unrealisedPnl'],
    );

Object? _readRemainingQuantity(Map<dynamic, dynamic> json, String key) {
  final direct = _num(
    json[key] ??
        json['remainingQuantity'] ??
        json['remaining_quantity'] ??
        json['leavesQty'] ??
        json['leaves_qty'],
  );
  if (direct != null) return direct;

  final total = _num(json['qty'] ?? json['orderQty'] ?? json['size']);
  final filled = _num(
    json['cumExecQty'] ??
        json['cum_exec_qty'] ??
        json['filled_qty'] ??
        json['filledQty'],
  );
  if (total == null || filled == null) return null;
  final remaining = total - filled;
  return remaining <= 0 ? 0.0 : remaining;
}

Object? _readSyncStatus(Map<dynamic, dynamic> json, String key) =>
    _str(json[key] ?? json['syncStatus']);

Object? _readLastSyncedAt(Map<dynamic, dynamic> json, String key) =>
    _dateString(json[key] ?? json['lastSyncedAt']);

Object? _readClosedAt(Map<dynamic, dynamic> json, String key) {
  final explicit = _dateString(
    json[key] ??
        json['closedAt'] ??
        json['close_time'] ??
        json['closeTime'] ??
        json['closedTime'],
  );
  if (explicit != null) return explicit;
  final status = normalizeOrderStatus(_str(_readStatus(json, 'status')) ?? '');
  if (!_isTerminalStatus(status)) return null;
  return _dateString(
    json['updated_at'] ??
        json['updatedAt'] ??
        json['updated_time'] ??
        json['updateTime'] ??
        json['updatedTime'] ??
        json['exec_time'] ??
        json['execTime'],
  );
}

Object? _readPrice(Map<dynamic, dynamic> json, String key) => _num(
      json[key] ??
          json['orderPrice'] ??
          json['limit_price'] ??
          json['limitPrice'],
    );

Object? _readLeverage(Map<dynamic, dynamic> json, String key) =>
    _num(json[key] ?? json['leverage_value']);

Object? _readTpLevels(Map<dynamic, dynamic> json, String key) {
  final raw = json[key] ??
      json['tpLevels'] ??
      json['take_profit_levels'] ??
      json['takeProfits'] ??
      json['take_profit'] ??
      json['takeProfit'] ??
      json['take_profit_price'] ??
      json['takeProfitPrice'] ??
      json['tp_price'] ??
      json['tpPrice'];
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
          json['stopLossPrice'] ??
          json['sl_price'],
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
  if (value is String) {
    final cleaned = value.replaceAll(',', '').trim();
    if (cleaned.isEmpty) return null;
    return double.tryParse(cleaned);
  }
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
abstract class PlaceOrderRequest with _$PlaceOrderRequest {
  const factory PlaceOrderRequest({
    @Default('bybit') String exchange,
    required String symbol,
    required String side,
    @JsonKey(name: 'order_type') required String orderType,
    required double quantity,
    double? price,
    @JsonKey(name: 'stop_price') double? stopPrice,
    required double leverage,
    @JsonKey(name: 'tp_levels') @Default([]) List<double> tpLevels,
    @JsonKey(name: 'sl_price') double? slPrice,
    @JsonKey(name: 'immediate_tp') double? immediateTp,
    @JsonKey(name: 'immediate_sl') double? immediateSl,
  }) = _PlaceOrderRequest;

  factory PlaceOrderRequest.fromJson(Map<String, dynamic> json) =>
      _$PlaceOrderRequestFromJson(json);
}
