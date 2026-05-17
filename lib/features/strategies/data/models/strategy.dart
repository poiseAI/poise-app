import 'package:freezed_annotation/freezed_annotation.dart';

part 'strategy.freezed.dart';
part 'strategy.g.dart';

@freezed
abstract class Strategy with _$Strategy {
  const factory Strategy({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    required String name,
    @JsonKey(name: 'is_active') @Default(false) bool isActive,
    @JsonKey(name: 'is_system') @Default(false) bool isSystem,
    @JsonKey(name: 'max_position_size') @Default(0.0) double maxPositionSize,
    @JsonKey(name: 'max_position_value_usd')
    @Default(0.0)
    double maxPositionValueUsd,
    @JsonKey(name: 'position_size_type')
    @Default('fixed_usd')
    String positionSizeType,
    @JsonKey(name: 'daily_loss_limit_type')
    @Default('fixed_usd')
    String dailyLossLimitType,
    @JsonKey(name: 'max_daily_loss_usd') @Default(0.0) double maxDailyLossUsd,
    @JsonKey(name: 'max_daily_loss_percent') double? maxDailyLossPercent,
    @JsonKey(name: 'max_weekly_loss_usd') @Default(0.0) double maxWeeklyLossUsd,
    @JsonKey(name: 'max_open_positions') @Default(5) int maxOpenPositions,
    @JsonKey(name: 'max_trades_per_day') @Default(5) int maxTradesPerDay,
    @JsonKey(name: 'max_consecutive_losses')
    @Default(3)
    int maxConsecutiveLosses,
    @JsonKey(name: 'session_start_hour') int? sessionStartHour,
    @JsonKey(name: 'session_end_hour') int? sessionEndHour,
    @JsonKey(name: 'min_risk_reward_ratio')
    @Default(1.5)
    double minRiskRewardRatio,
    @JsonKey(name: 'max_leverage') @Default(10.0) double maxLeverage,
    @JsonKey(name: 'require_exit_reason')
    @Default(false)
    bool requireExitReason,
    @JsonKey(name: 'require_otp_for_exit')
    @Default(false)
    bool requireOtpForExit,
    @JsonKey(name: 'created_at') required String createdAt,
  }) = _Strategy;

  factory Strategy.fromJson(Map<String, dynamic> json) =>
      _$StrategyFromJson(json);
}

@freezed
abstract class CreateStrategyRequest with _$CreateStrategyRequest {
  const factory CreateStrategyRequest({
    required String name,
    @JsonKey(name: 'max_position_size') @Default(1000.0) double maxPositionSize,
    @JsonKey(name: 'max_position_value_usd')
    @Default(5000.0)
    double maxPositionValueUsd,
    @JsonKey(name: 'position_size_type')
    @Default('fixed_usd')
    String positionSizeType,
    @JsonKey(name: 'daily_loss_limit_type')
    @Default('fixed_usd')
    String dailyLossLimitType,
    @JsonKey(name: 'max_daily_loss_usd') @Default(200.0) double maxDailyLossUsd,
    @JsonKey(name: 'max_daily_loss_percent') double? maxDailyLossPercent,
    @JsonKey(name: 'max_weekly_loss_usd') @Default(0.0) double maxWeeklyLossUsd,
    @JsonKey(name: 'max_open_positions') @Default(5) int maxOpenPositions,
    @JsonKey(name: 'max_trades_per_day') @Default(5) int maxTradesPerDay,
    @JsonKey(name: 'max_consecutive_losses')
    @Default(3)
    int maxConsecutiveLosses,
    @JsonKey(name: 'session_start_hour') int? sessionStartHour,
    @JsonKey(name: 'session_end_hour') int? sessionEndHour,
    @JsonKey(name: 'min_risk_reward_ratio')
    @Default(1.5)
    double minRiskRewardRatio,
    @JsonKey(name: 'max_leverage') @Default(10.0) double maxLeverage,
    @JsonKey(name: 'require_exit_reason') @Default(true) bool requireExitReason,
    @JsonKey(name: 'require_otp_for_exit')
    @Default(true)
    bool requireOtpForExit,
  }) = _CreateStrategyRequest;

  factory CreateStrategyRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateStrategyRequestFromJson(json);
}
