// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'strategy.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Strategy _$StrategyFromJson(Map<String, dynamic> json) => _Strategy(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      name: json['name'] as String,
      isActive: json['is_active'] as bool? ?? false,
      isSystem: json['is_system'] as bool? ?? false,
      maxPositionSize: (json['max_position_size'] as num?)?.toDouble() ?? 0.0,
      maxPositionValueUsd:
          (json['max_position_value_usd'] as num?)?.toDouble() ?? 0.0,
      positionSizeType: json['position_size_type'] as String? ?? 'fixed_usd',
      maxDailyLossUsd: (json['max_daily_loss_usd'] as num?)?.toDouble() ?? 0.0,
      maxOpenPositions: (json['max_open_positions'] as num?)?.toInt() ?? 5,
      maxLeverage: (json['max_leverage'] as num?)?.toDouble() ?? 10.0,
      requireExitReason: json['require_exit_reason'] as bool? ?? false,
      requireOtpForExit: json['require_otp_for_exit'] as bool? ?? false,
      createdAt: json['created_at'] as String,
    );

Map<String, dynamic> _$StrategyToJson(_Strategy instance) => <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'name': instance.name,
      'is_active': instance.isActive,
      'is_system': instance.isSystem,
      'max_position_size': instance.maxPositionSize,
      'max_position_value_usd': instance.maxPositionValueUsd,
      'position_size_type': instance.positionSizeType,
      'max_daily_loss_usd': instance.maxDailyLossUsd,
      'max_open_positions': instance.maxOpenPositions,
      'max_leverage': instance.maxLeverage,
      'require_exit_reason': instance.requireExitReason,
      'require_otp_for_exit': instance.requireOtpForExit,
      'created_at': instance.createdAt,
    };

_CreateStrategyRequest _$CreateStrategyRequestFromJson(
        Map<String, dynamic> json) =>
    _CreateStrategyRequest(
      name: json['name'] as String,
      maxPositionSize:
          (json['max_position_size'] as num?)?.toDouble() ?? 1000.0,
      maxPositionValueUsd:
          (json['max_position_value_usd'] as num?)?.toDouble() ?? 5000.0,
      positionSizeType: json['position_size_type'] as String? ?? 'fixed_usd',
      maxDailyLossUsd:
          (json['max_daily_loss_usd'] as num?)?.toDouble() ?? 200.0,
      maxOpenPositions: (json['max_open_positions'] as num?)?.toInt() ?? 5,
      maxLeverage: (json['max_leverage'] as num?)?.toDouble() ?? 10.0,
      requireExitReason: json['require_exit_reason'] as bool? ?? true,
      requireOtpForExit: json['require_otp_for_exit'] as bool? ?? true,
    );

Map<String, dynamic> _$CreateStrategyRequestToJson(
        _CreateStrategyRequest instance) =>
    <String, dynamic>{
      'name': instance.name,
      'max_position_size': instance.maxPositionSize,
      'max_position_value_usd': instance.maxPositionValueUsd,
      'position_size_type': instance.positionSizeType,
      'max_daily_loss_usd': instance.maxDailyLossUsd,
      'max_open_positions': instance.maxOpenPositions,
      'max_leverage': instance.maxLeverage,
      'require_exit_reason': instance.requireExitReason,
      'require_otp_for_exit': instance.requireOtpForExit,
    };
