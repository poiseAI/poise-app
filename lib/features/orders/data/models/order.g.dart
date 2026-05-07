// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Order _$OrderFromJson(Map<String, dynamic> json) => _Order(
      id: json['id'] as String,
      symbol: json['symbol'] as String,
      side: json['side'] as String,
      status: json['status'] as String,
      orderType: json['order_type'] as String,
      quantity: (json['quantity'] as num).toDouble(),
      price: (json['price'] as num?)?.toDouble(),
      leverage: (json['leverage'] as num?)?.toDouble() ?? 1.0,
      tpLevels: (json['tp_levels'] as List<dynamic>?)
              ?.map((e) => (e as num).toDouble())
              .toList() ??
          const [],
      slPrice: (_readSlPrice(json, 'sl_price') as num?)?.toDouble(),
      createdAt: json['created_at'] as String,
    );

Map<String, dynamic> _$OrderToJson(_Order instance) => <String, dynamic>{
      'id': instance.id,
      'symbol': instance.symbol,
      'side': instance.side,
      'status': instance.status,
      'order_type': instance.orderType,
      'quantity': instance.quantity,
      'price': instance.price,
      'leverage': instance.leverage,
      'tp_levels': instance.tpLevels,
      'sl_price': instance.slPrice,
      'created_at': instance.createdAt,
    };

_PlaceOrderRequest _$PlaceOrderRequestFromJson(Map<String, dynamic> json) =>
    _PlaceOrderRequest(
      exchange: json['exchange'] as String? ?? 'bybit',
      symbol: json['symbol'] as String,
      side: json['side'] as String,
      orderType: json['order_type'] as String,
      quantity: (json['quantity'] as num).toDouble(),
      price: (json['price'] as num?)?.toDouble(),
      stopPrice: (json['stop_price'] as num?)?.toDouble(),
      leverage: (json['leverage'] as num).toDouble(),
      tpLevels: (json['tp_levels'] as List<dynamic>?)
              ?.map((e) => (e as num).toDouble())
              .toList() ??
          const [],
      slPrice: (json['sl_price'] as num?)?.toDouble(),
      immediateTp: (json['immediate_tp'] as num?)?.toDouble(),
      immediateSl: (json['immediate_sl'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$PlaceOrderRequestToJson(_PlaceOrderRequest instance) =>
    <String, dynamic>{
      'exchange': instance.exchange,
      'symbol': instance.symbol,
      'side': instance.side,
      'order_type': instance.orderType,
      'quantity': instance.quantity,
      'price': instance.price,
      'stop_price': instance.stopPrice,
      'leverage': instance.leverage,
      'tp_levels': instance.tpLevels,
      'sl_price': instance.slPrice,
      'immediate_tp': instance.immediateTp,
      'immediate_sl': instance.immediateSl,
    };
