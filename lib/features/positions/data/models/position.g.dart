// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'position.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Position _$PositionFromJson(Map<String, dynamic> json) => _Position(
      id: json['id'] as String,
      symbol: json['symbol'] as String,
      side: json['side'] as String,
      entryPrice: (json['entryPrice'] as num).toDouble(),
      currentPrice: (json['currentPrice'] as num).toDouble(),
      quantity: (_readQuantity(json, 'quantity') as num).toDouble(),
      leverage: (json['leverage'] as num?)?.toDouble() ?? 1.0,
      unrealizedPnl: (json['unrealizedPnl'] as num).toDouble(),
      unrealizedPnlPct: (json['unrealizedPnlPct'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] as String,
      isLocked: json['isLocked'] as bool? ?? false,
      tpLevels: (json['tp_levels'] as List<dynamic>?)
              ?.map((e) => (e as num).toDouble())
              .toList() ??
          const [],
      slPrice: (json['sl_price'] as num?)?.toDouble(),
      exchange: json['exchange'] as String? ?? 'bybit',
      createdAt: json['created_at'] as String,
    );

Map<String, dynamic> _$PositionToJson(_Position instance) => <String, dynamic>{
      'id': instance.id,
      'symbol': instance.symbol,
      'side': instance.side,
      'entryPrice': instance.entryPrice,
      'currentPrice': instance.currentPrice,
      'quantity': instance.quantity,
      'leverage': instance.leverage,
      'unrealizedPnl': instance.unrealizedPnl,
      'unrealizedPnlPct': instance.unrealizedPnlPct,
      'status': instance.status,
      'isLocked': instance.isLocked,
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
