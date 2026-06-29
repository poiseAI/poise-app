import 'package:freezed_annotation/freezed_annotation.dart';

part 'symbol.freezed.dart';
part 'symbol.g.dart';

@freezed
abstract class TradingSymbol with _$TradingSymbol {
  const factory TradingSymbol({
    required String symbol,
    @JsonKey(readValue: _readBaseAsset) required String baseAsset,
    @JsonKey(readValue: _readQuoteAsset) required String quoteAsset,
    @JsonKey(readValue: _readExchange) @Default('bybit') String exchange,
    @JsonKey(readValue: _readStatus) @Default('Trading') String status,
    @JsonKey(readValue: _readLastPrice) @Default(0.0) double lastPrice,
    @JsonKey(readValue: _readPriceChangePct)
    @Default(0.0)
    double priceChangePct,
    @JsonKey(readValue: _readMinQty) @Default(0.001) double minQty,
    @JsonKey(readValue: _readMaxLeverage) @Default(100) int maxLeverage,
    @JsonKey(readValue: _readTickSize) @Default(0.0) double tickSize,
    @JsonKey(readValue: _readQtyStep) @Default(0.0) double qtyStep,
    @JsonKey(readValue: _readMinNotional) @Default(0.0) double minNotional,
  }) = _TradingSymbol;

  factory TradingSymbol.fromJson(Map<String, dynamic> json) =>
      _$TradingSymbolFromJson(json);
}

Object? _readBaseAsset(Map<dynamic, dynamic> json, String key) =>
    json[key] ?? json['baseCoin'] ?? json['base_asset'] ?? json['base'];

Object? _readQuoteAsset(Map<dynamic, dynamic> json, String key) =>
    json[key] ?? json['quoteCoin'] ?? json['quote_asset'] ?? json['quote'];

Object? _readExchange(Map<dynamic, dynamic> json, String key) =>
    json[key] ?? json['exchange_name'];

Object? _readStatus(Map<dynamic, dynamic> json, String key) =>
    json[key] ?? json['status_text'];

Object? _readLastPrice(Map<dynamic, dynamic> json, String key) =>
    _num(json[key] ??
        json['last_price'] ??
        json['lastPrice'] ??
        json['price'] ??
        json['mark_price'] ??
        json['markPrice']);

Object? _readPriceChangePct(Map<dynamic, dynamic> json, String key) =>
    _num(json[key] ??
        json['price_change_pct'] ??
        json['priceChangePct'] ??
        json['priceChangePercent'] ??
        json['change24h']);

Object? _readMinQty(Map<dynamic, dynamic> json, String key) =>
    _num(json[key] ?? json['min_qty'] ?? json['minQty'] ?? json['minQuantity']);

Object? _readMaxLeverage(Map<dynamic, dynamic> json, String key) =>
    _int(json[key] ?? json['max_leverage'] ?? json['maxLeverage']);

Object? _readTickSize(Map<dynamic, dynamic> json, String key) =>
    _num(json[key] ?? json['tick_size'] ?? json['tickSize']);

Object? _readQtyStep(Map<dynamic, dynamic> json, String key) =>
    _num(json[key] ?? json['qty_step'] ?? json['qtyStep'] ?? json['stepSize']);

Object? _readMinNotional(Map<dynamic, dynamic> json, String key) =>
    _num(json[key] ??
        json['min_notional'] ??
        json['minNotional'] ??
        json['notional']);

Object? _num(Object? value) {
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value);
  return value;
}

Object? _int(Object? value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value);
  return value;
}

extension TradingSymbolPriceChange on TradingSymbol {
  double get priceChange24h => lastPrice * priceChangePct / 100;
}
