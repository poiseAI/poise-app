import 'package:freezed_annotation/freezed_annotation.dart';

part 'symbol.freezed.dart';
part 'symbol.g.dart';

@freezed
abstract class TradingSymbol with _$TradingSymbol {
  const factory TradingSymbol({
    required String symbol,
    @JsonKey(readValue: _readBaseAsset) required String baseAsset,
    @JsonKey(readValue: _readQuoteAsset) required String quoteAsset,
    @Default('bybit') String exchange,
    @JsonKey(name: 'last_price') @Default(0.0) double lastPrice,
    @JsonKey(name: 'price_change_pct') @Default(0.0) double priceChangePct,
    @JsonKey(name: 'min_qty') @Default(0.001) double minQty,
    @JsonKey(name: 'max_leverage') @Default(100) int maxLeverage,
  }) = _TradingSymbol;

  factory TradingSymbol.fromJson(Map<String, dynamic> json) =>
      _$TradingSymbolFromJson(json);
}

Object? _readBaseAsset(Map<dynamic, dynamic> json, String key) =>
    json[key] ?? json['baseCoin'];

Object? _readQuoteAsset(Map<dynamic, dynamic> json, String key) =>
    json[key] ?? json['quoteCoin'];
