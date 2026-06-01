// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'position.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Position _$PositionFromJson(Map<String, dynamic> json) => _Position(
      id: _readId(json, 'id') as String? ?? '',
      symbol: _readSymbol(json, 'symbol') as String? ?? '',
      side: _readSide(json, 'side') as String? ?? 'long',
      entryPrice:
          (_readEntryPrice(json, 'entry_price') as num?)?.toDouble() ?? 0.0,
      currentPrice:
          (_readCurrentPrice(json, 'current_price') as num?)?.toDouble() ?? 0.0,
      quantity: (_readQuantity(json, 'quantity') as num?)?.toDouble() ?? 0.0,
      source: json['source'] as String? ?? 'external',
      exchangeOrderId:
          _readExchangeOrderId(json, 'exchange_order_id') as String?,
      leverage: (json['leverage'] as num?)?.toDouble() ?? 1.0,
      unrealizedPnl:
          (_readUnrealizedPnl(json, 'unrealized_pnl') as num?)?.toDouble() ??
              0.0,
      unrealizedPnlPct:
          (_readUnrealizedPnlPct(json, 'unrealized_pnl_pct') as num?)
                  ?.toDouble() ??
              0.0,
      realizedPnl:
          (_readRealizedPnl(json, 'realized_pnl') as num?)?.toDouble() ?? 0.0,
      liquidationPrice:
          (_readLiquidationPrice(json, 'liquidation_price') as num?)
              ?.toDouble(),
      marginUsed: (_readMarginUsed(json, 'margin_used') as num?)?.toDouble(),
      remainingQuantity:
          (_readRemainingQuantity(json, 'remaining_quantity') as num?)
              ?.toDouble(),
      syncStatus: _readSyncStatus(json, 'sync_status') as String? ?? 'synced',
      lastSyncedAt: _readLastSyncedAt(json, 'last_synced_at') as String?,
      closedAt: _readClosedAt(json, 'closed_at') as String?,
      status: _readStatus(json, 'status') as String? ?? 'open',
      isLocked: _readIsLocked(json, 'is_locked') as bool? ?? false,
      tpLevels: (_readTpLevels(json, 'tp_levels') as List<dynamic>?)
              ?.map((e) => (e as num).toDouble())
              .toList() ??
          const [],
      slPrice: (_readSlPrice(json, 'sl_price') as num?)?.toDouble(),
      exchange: json['exchange'] as String? ?? 'bybit',
      createdAt: _readCreatedAt(json, 'created_at') as String? ?? '',
    );

Map<String, dynamic> _$PositionToJson(_Position instance) => <String, dynamic>{
      'id': instance.id,
      'symbol': instance.symbol,
      'side': instance.side,
      'entry_price': instance.entryPrice,
      'current_price': instance.currentPrice,
      'quantity': instance.quantity,
      'source': instance.source,
      'exchange_order_id': instance.exchangeOrderId,
      'leverage': instance.leverage,
      'unrealized_pnl': instance.unrealizedPnl,
      'unrealized_pnl_pct': instance.unrealizedPnlPct,
      'realized_pnl': instance.realizedPnl,
      'liquidation_price': instance.liquidationPrice,
      'margin_used': instance.marginUsed,
      'remaining_quantity': instance.remainingQuantity,
      'sync_status': instance.syncStatus,
      'last_synced_at': instance.lastSyncedAt,
      'closed_at': instance.closedAt,
      'status': instance.status,
      'is_locked': instance.isLocked,
      'tp_levels': instance.tpLevels,
      'sl_price': instance.slPrice,
      'exchange': instance.exchange,
      'created_at': instance.createdAt,
    };

_PnlSummary _$PnlSummaryFromJson(Map<String, dynamic> json) => _PnlSummary(
      totalUnrealizedPnl:
          (json['total_unrealized_pnl'] as num?)?.toDouble() ?? 0.0,
      totalUnrealizedPnlPct:
          (json['total_unrealized_pnl_pct'] as num?)?.toDouble() ?? 0.0,
      dayPnl: (json['day_pnl'] as num?)?.toDouble() ?? 0.0,
      dayPnlPct: (json['day_pnl_pct'] as num?)?.toDouble() ?? 0.0,
      totalMarginUsed: (json['total_margin_used'] as num?)?.toDouble() ?? 0.0,
      positionCount: (json['position_count'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$PnlSummaryToJson(_PnlSummary instance) =>
    <String, dynamic>{
      'total_unrealized_pnl': instance.totalUnrealizedPnl,
      'total_unrealized_pnl_pct': instance.totalUnrealizedPnlPct,
      'day_pnl': instance.dayPnl,
      'day_pnl_pct': instance.dayPnlPct,
      'total_margin_used': instance.totalMarginUsed,
      'position_count': instance.positionCount,
    };
