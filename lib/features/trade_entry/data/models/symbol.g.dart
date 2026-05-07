// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'symbol.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TradingSymbol _$TradingSymbolFromJson(Map<String, dynamic> json) =>
    _TradingSymbol(
      symbol: json['symbol'] as String,
      baseAsset: _readBaseAsset(json, 'baseAsset') as String,
      quoteAsset: _readQuoteAsset(json, 'quoteAsset') as String,
      exchange: json['exchange'] as String? ?? 'bybit',
      lastPrice: (json['last_price'] as num?)?.toDouble() ?? 0.0,
      priceChangePct: (json['price_change_pct'] as num?)?.toDouble() ?? 0.0,
      minQty: (json['min_qty'] as num?)?.toDouble() ?? 0.001,
      maxLeverage: (json['max_leverage'] as num?)?.toInt() ?? 100,
    );

Map<String, dynamic> _$TradingSymbolToJson(_TradingSymbol instance) =>
    <String, dynamic>{
      'symbol': instance.symbol,
      'baseAsset': instance.baseAsset,
      'quoteAsset': instance.quoteAsset,
      'exchange': instance.exchange,
      'last_price': instance.lastPrice,
      'price_change_pct': instance.priceChangePct,
      'min_qty': instance.minQty,
      'max_leverage': instance.maxLeverage,
    };
