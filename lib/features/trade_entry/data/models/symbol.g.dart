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
      exchange: _readExchange(json, 'exchange') as String? ?? 'bybit',
      status: _readStatus(json, 'status') as String? ?? 'Trading',
      lastPrice: (_readLastPrice(json, 'lastPrice') as num?)?.toDouble() ?? 0.0,
      priceChangePct:
          (_readPriceChangePct(json, 'priceChangePct') as num?)?.toDouble() ??
              0.0,
      minQty: (_readMinQty(json, 'minQty') as num?)?.toDouble() ?? 0.001,
      maxLeverage:
          (_readMaxLeverage(json, 'maxLeverage') as num?)?.toInt() ?? 100,
      tickSize: (_readTickSize(json, 'tickSize') as num?)?.toDouble() ?? 0.0,
      qtyStep: (_readQtyStep(json, 'qtyStep') as num?)?.toDouble() ?? 0.0,
      minNotional:
          (_readMinNotional(json, 'minNotional') as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$TradingSymbolToJson(_TradingSymbol instance) =>
    <String, dynamic>{
      'symbol': instance.symbol,
      'baseAsset': instance.baseAsset,
      'quoteAsset': instance.quoteAsset,
      'exchange': instance.exchange,
      'status': instance.status,
      'lastPrice': instance.lastPrice,
      'priceChangePct': instance.priceChangePct,
      'minQty': instance.minQty,
      'maxLeverage': instance.maxLeverage,
      'tickSize': instance.tickSize,
      'qtyStep': instance.qtyStep,
      'minNotional': instance.minNotional,
    };
