// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Order _$OrderFromJson(Map<String, dynamic> json) => _Order(
      id: _readId(json, 'id') as String? ?? '',
      symbol: _readSymbol(json, 'symbol') as String? ?? '',
      side: _readSide(json, 'side') as String? ?? 'buy',
      status: _readStatus(json, 'status') as String? ?? 'unknown',
      orderType: _readOrderType(json, 'order_type') as String? ?? 'market',
      quantity: (_readQuantity(json, 'quantity') as num?)?.toDouble() ?? 0.0,
      source: _readSource(json, 'source') as String? ?? 'poise',
      exchange: _readExchange(json, 'exchange') as String? ?? 'bybit',
      exchangeOrderId:
          _readExchangeOrderId(json, 'exchange_order_id') as String?,
      entryPrice: (_readEntryPrice(json, 'entry_price') as num?)?.toDouble(),
      markPrice: (_readMarkPrice(json, 'mark_price') as num?)?.toDouble(),
      liquidationPrice:
          (_readLiquidationPrice(json, 'liquidation_price') as num?)
              ?.toDouble(),
      marginUsed: (_readMarginUsed(json, 'margin_used') as num?)?.toDouble(),
      realizedPnl: (_readRealizedPnl(json, 'realized_pnl') as num?)?.toDouble(),
      unrealizedPnl:
          (_readUnrealizedPnl(json, 'unrealized_pnl') as num?)?.toDouble(),
      remainingQuantity:
          (_readRemainingQuantity(json, 'remaining_quantity') as num?)
              ?.toDouble(),
      syncStatus: _readSyncStatus(json, 'sync_status') as String?,
      lastSyncedAt: _readLastSyncedAt(json, 'last_synced_at') as String?,
      closedAt: _readClosedAt(json, 'closed_at') as String?,
      price: (_readPrice(json, 'price') as num?)?.toDouble(),
      leverage: (_readLeverage(json, 'leverage') as num?)?.toDouble() ?? 1.0,
      tpLevels: (_readTpLevels(json, 'tp_levels') as List<dynamic>?)
              ?.map((e) => (e as num).toDouble())
              .toList() ??
          const [],
      slPrice: (_readSlPrice(json, 'sl_price') as num?)?.toDouble(),
      autoCancelAfterMinutes:
          (_readAutoCancelAfterMinutes(json, 'auto_cancel_after_minutes')
                  as num?)
              ?.toInt(),
      expiresAt: _readExpiresAt(json, 'expires_at') as String?,
      autoCancelledAt:
          _readAutoCancelledAt(json, 'auto_cancelled_at') as String?,
      autoCancelReason:
          _readAutoCancelReason(json, 'auto_cancel_reason') as String?,
      createdAt: _readCreatedAt(json, 'created_at') as String? ?? '',
    );

Map<String, dynamic> _$OrderToJson(_Order instance) => <String, dynamic>{
      'id': instance.id,
      'symbol': instance.symbol,
      'side': instance.side,
      'status': instance.status,
      'order_type': instance.orderType,
      'quantity': instance.quantity,
      'source': instance.source,
      'exchange': instance.exchange,
      'exchange_order_id': instance.exchangeOrderId,
      'entry_price': instance.entryPrice,
      'mark_price': instance.markPrice,
      'liquidation_price': instance.liquidationPrice,
      'margin_used': instance.marginUsed,
      'realized_pnl': instance.realizedPnl,
      'unrealized_pnl': instance.unrealizedPnl,
      'remaining_quantity': instance.remainingQuantity,
      'sync_status': instance.syncStatus,
      'last_synced_at': instance.lastSyncedAt,
      'closed_at': instance.closedAt,
      'price': instance.price,
      'leverage': instance.leverage,
      'tp_levels': instance.tpLevels,
      'sl_price': instance.slPrice,
      'auto_cancel_after_minutes': instance.autoCancelAfterMinutes,
      'expires_at': instance.expiresAt,
      'auto_cancelled_at': instance.autoCancelledAt,
      'auto_cancel_reason': instance.autoCancelReason,
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
