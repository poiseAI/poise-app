// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'strategy.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Strategy {
  String get id;
  @JsonKey(name: 'user_id')
  String get userId;
  String get name;
  @JsonKey(name: 'is_active')
  bool get isActive;
  @JsonKey(name: 'is_system')
  bool get isSystem;
  @JsonKey(name: 'max_position_size')
  double get maxPositionSize;
  @JsonKey(name: 'max_position_value_usd')
  double get maxPositionValueUsd;
  @JsonKey(name: 'position_size_type')
  String get positionSizeType;
  @JsonKey(name: 'daily_loss_limit_type')
  String get dailyLossLimitType;
  @JsonKey(name: 'max_daily_loss_usd')
  double get maxDailyLossUsd;
  @JsonKey(name: 'max_daily_loss_percent')
  double? get maxDailyLossPercent;
  @JsonKey(name: 'max_open_positions')
  int get maxOpenPositions;
  @JsonKey(name: 'max_trades_per_day')
  int get maxTradesPerDay;
  @JsonKey(name: 'max_consecutive_losses')
  int get maxConsecutiveLosses;
  @JsonKey(name: 'session_start_hour')
  int? get sessionStartHour;
  @JsonKey(name: 'session_end_hour')
  int? get sessionEndHour;
  @JsonKey(name: 'min_risk_reward_ratio')
  double get minRiskRewardRatio;
  @JsonKey(name: 'max_leverage')
  double get maxLeverage;
  @JsonKey(name: 'require_exit_reason')
  bool get requireExitReason;
  @JsonKey(name: 'require_otp_for_exit')
  bool get requireOtpForExit;
  @JsonKey(name: 'created_at')
  String get createdAt;

  /// Create a copy of Strategy
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $StrategyCopyWith<Strategy> get copyWith =>
      _$StrategyCopyWithImpl<Strategy>(this as Strategy, _$identity);

  /// Serializes this Strategy to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Strategy &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.isSystem, isSystem) ||
                other.isSystem == isSystem) &&
            (identical(other.maxPositionSize, maxPositionSize) ||
                other.maxPositionSize == maxPositionSize) &&
            (identical(other.maxPositionValueUsd, maxPositionValueUsd) ||
                other.maxPositionValueUsd == maxPositionValueUsd) &&
            (identical(other.positionSizeType, positionSizeType) ||
                other.positionSizeType == positionSizeType) &&
            (identical(other.dailyLossLimitType, dailyLossLimitType) ||
                other.dailyLossLimitType == dailyLossLimitType) &&
            (identical(other.maxDailyLossUsd, maxDailyLossUsd) ||
                other.maxDailyLossUsd == maxDailyLossUsd) &&
            (identical(other.maxDailyLossPercent, maxDailyLossPercent) ||
                other.maxDailyLossPercent == maxDailyLossPercent) &&
            (identical(other.maxOpenPositions, maxOpenPositions) ||
                other.maxOpenPositions == maxOpenPositions) &&
            (identical(other.maxTradesPerDay, maxTradesPerDay) ||
                other.maxTradesPerDay == maxTradesPerDay) &&
            (identical(other.maxConsecutiveLosses, maxConsecutiveLosses) ||
                other.maxConsecutiveLosses == maxConsecutiveLosses) &&
            (identical(other.sessionStartHour, sessionStartHour) ||
                other.sessionStartHour == sessionStartHour) &&
            (identical(other.sessionEndHour, sessionEndHour) ||
                other.sessionEndHour == sessionEndHour) &&
            (identical(other.minRiskRewardRatio, minRiskRewardRatio) ||
                other.minRiskRewardRatio == minRiskRewardRatio) &&
            (identical(other.maxLeverage, maxLeverage) ||
                other.maxLeverage == maxLeverage) &&
            (identical(other.requireExitReason, requireExitReason) ||
                other.requireExitReason == requireExitReason) &&
            (identical(other.requireOtpForExit, requireOtpForExit) ||
                other.requireOtpForExit == requireOtpForExit) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        userId,
        name,
        isActive,
        isSystem,
        maxPositionSize,
        maxPositionValueUsd,
        positionSizeType,
        dailyLossLimitType,
        maxDailyLossUsd,
        maxDailyLossPercent,
        maxOpenPositions,
        maxTradesPerDay,
        maxConsecutiveLosses,
        sessionStartHour,
        sessionEndHour,
        minRiskRewardRatio,
        maxLeverage,
        requireExitReason,
        requireOtpForExit,
        createdAt
      ]);

  @override
  String toString() {
    return 'Strategy(id: $id, userId: $userId, name: $name, isActive: $isActive, isSystem: $isSystem, maxPositionSize: $maxPositionSize, maxPositionValueUsd: $maxPositionValueUsd, positionSizeType: $positionSizeType, dailyLossLimitType: $dailyLossLimitType, maxDailyLossUsd: $maxDailyLossUsd, maxDailyLossPercent: $maxDailyLossPercent, maxOpenPositions: $maxOpenPositions, maxTradesPerDay: $maxTradesPerDay, maxConsecutiveLosses: $maxConsecutiveLosses, sessionStartHour: $sessionStartHour, sessionEndHour: $sessionEndHour, minRiskRewardRatio: $minRiskRewardRatio, maxLeverage: $maxLeverage, requireExitReason: $requireExitReason, requireOtpForExit: $requireOtpForExit, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class $StrategyCopyWith<$Res> {
  factory $StrategyCopyWith(Strategy value, $Res Function(Strategy) _then) =
      _$StrategyCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'user_id') String userId,
      String name,
      @JsonKey(name: 'is_active') bool isActive,
      @JsonKey(name: 'is_system') bool isSystem,
      @JsonKey(name: 'max_position_size') double maxPositionSize,
      @JsonKey(name: 'max_position_value_usd') double maxPositionValueUsd,
      @JsonKey(name: 'position_size_type') String positionSizeType,
      @JsonKey(name: 'daily_loss_limit_type') String dailyLossLimitType,
      @JsonKey(name: 'max_daily_loss_usd') double maxDailyLossUsd,
      @JsonKey(name: 'max_daily_loss_percent') double? maxDailyLossPercent,
      @JsonKey(name: 'max_open_positions') int maxOpenPositions,
      @JsonKey(name: 'max_trades_per_day') int maxTradesPerDay,
      @JsonKey(name: 'max_consecutive_losses') int maxConsecutiveLosses,
      @JsonKey(name: 'session_start_hour') int? sessionStartHour,
      @JsonKey(name: 'session_end_hour') int? sessionEndHour,
      @JsonKey(name: 'min_risk_reward_ratio') double minRiskRewardRatio,
      @JsonKey(name: 'max_leverage') double maxLeverage,
      @JsonKey(name: 'require_exit_reason') bool requireExitReason,
      @JsonKey(name: 'require_otp_for_exit') bool requireOtpForExit,
      @JsonKey(name: 'created_at') String createdAt});
}

/// @nodoc
class _$StrategyCopyWithImpl<$Res> implements $StrategyCopyWith<$Res> {
  _$StrategyCopyWithImpl(this._self, this._then);

  final Strategy _self;
  final $Res Function(Strategy) _then;

  /// Create a copy of Strategy
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? name = null,
    Object? isActive = null,
    Object? isSystem = null,
    Object? maxPositionSize = null,
    Object? maxPositionValueUsd = null,
    Object? positionSizeType = null,
    Object? dailyLossLimitType = null,
    Object? maxDailyLossUsd = null,
    Object? maxDailyLossPercent = freezed,
    Object? maxOpenPositions = null,
    Object? maxTradesPerDay = null,
    Object? maxConsecutiveLosses = null,
    Object? sessionStartHour = freezed,
    Object? sessionEndHour = freezed,
    Object? minRiskRewardRatio = null,
    Object? maxLeverage = null,
    Object? requireExitReason = null,
    Object? requireOtpForExit = null,
    Object? createdAt = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _self.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      isActive: null == isActive
          ? _self.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      isSystem: null == isSystem
          ? _self.isSystem
          : isSystem // ignore: cast_nullable_to_non_nullable
              as bool,
      maxPositionSize: null == maxPositionSize
          ? _self.maxPositionSize
          : maxPositionSize // ignore: cast_nullable_to_non_nullable
              as double,
      maxPositionValueUsd: null == maxPositionValueUsd
          ? _self.maxPositionValueUsd
          : maxPositionValueUsd // ignore: cast_nullable_to_non_nullable
              as double,
      positionSizeType: null == positionSizeType
          ? _self.positionSizeType
          : positionSizeType // ignore: cast_nullable_to_non_nullable
              as String,
      dailyLossLimitType: null == dailyLossLimitType
          ? _self.dailyLossLimitType
          : dailyLossLimitType // ignore: cast_nullable_to_non_nullable
              as String,
      maxDailyLossUsd: null == maxDailyLossUsd
          ? _self.maxDailyLossUsd
          : maxDailyLossUsd // ignore: cast_nullable_to_non_nullable
              as double,
      maxDailyLossPercent: freezed == maxDailyLossPercent
          ? _self.maxDailyLossPercent
          : maxDailyLossPercent // ignore: cast_nullable_to_non_nullable
              as double?,
      maxOpenPositions: null == maxOpenPositions
          ? _self.maxOpenPositions
          : maxOpenPositions // ignore: cast_nullable_to_non_nullable
              as int,
      maxTradesPerDay: null == maxTradesPerDay
          ? _self.maxTradesPerDay
          : maxTradesPerDay // ignore: cast_nullable_to_non_nullable
              as int,
      maxConsecutiveLosses: null == maxConsecutiveLosses
          ? _self.maxConsecutiveLosses
          : maxConsecutiveLosses // ignore: cast_nullable_to_non_nullable
              as int,
      sessionStartHour: freezed == sessionStartHour
          ? _self.sessionStartHour
          : sessionStartHour // ignore: cast_nullable_to_non_nullable
              as int?,
      sessionEndHour: freezed == sessionEndHour
          ? _self.sessionEndHour
          : sessionEndHour // ignore: cast_nullable_to_non_nullable
              as int?,
      minRiskRewardRatio: null == minRiskRewardRatio
          ? _self.minRiskRewardRatio
          : minRiskRewardRatio // ignore: cast_nullable_to_non_nullable
              as double,
      maxLeverage: null == maxLeverage
          ? _self.maxLeverage
          : maxLeverage // ignore: cast_nullable_to_non_nullable
              as double,
      requireExitReason: null == requireExitReason
          ? _self.requireExitReason
          : requireExitReason // ignore: cast_nullable_to_non_nullable
              as bool,
      requireOtpForExit: null == requireOtpForExit
          ? _self.requireOtpForExit
          : requireOtpForExit // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// Adds pattern-matching-related methods to [Strategy].
extension StrategyPatterns on Strategy {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_Strategy value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Strategy() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_Strategy value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Strategy():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_Strategy value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Strategy() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            String id,
            @JsonKey(name: 'user_id') String userId,
            String name,
            @JsonKey(name: 'is_active') bool isActive,
            @JsonKey(name: 'is_system') bool isSystem,
            @JsonKey(name: 'max_position_size') double maxPositionSize,
            @JsonKey(name: 'max_position_value_usd') double maxPositionValueUsd,
            @JsonKey(name: 'position_size_type') String positionSizeType,
            @JsonKey(name: 'daily_loss_limit_type') String dailyLossLimitType,
            @JsonKey(name: 'max_daily_loss_usd') double maxDailyLossUsd,
            @JsonKey(name: 'max_daily_loss_percent')
            double? maxDailyLossPercent,
            @JsonKey(name: 'max_open_positions') int maxOpenPositions,
            @JsonKey(name: 'max_trades_per_day') int maxTradesPerDay,
            @JsonKey(name: 'max_consecutive_losses') int maxConsecutiveLosses,
            @JsonKey(name: 'session_start_hour') int? sessionStartHour,
            @JsonKey(name: 'session_end_hour') int? sessionEndHour,
            @JsonKey(name: 'min_risk_reward_ratio') double minRiskRewardRatio,
            @JsonKey(name: 'max_leverage') double maxLeverage,
            @JsonKey(name: 'require_exit_reason') bool requireExitReason,
            @JsonKey(name: 'require_otp_for_exit') bool requireOtpForExit,
            @JsonKey(name: 'created_at') String createdAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Strategy() when $default != null:
        return $default(
            _that.id,
            _that.userId,
            _that.name,
            _that.isActive,
            _that.isSystem,
            _that.maxPositionSize,
            _that.maxPositionValueUsd,
            _that.positionSizeType,
            _that.dailyLossLimitType,
            _that.maxDailyLossUsd,
            _that.maxDailyLossPercent,
            _that.maxOpenPositions,
            _that.maxTradesPerDay,
            _that.maxConsecutiveLosses,
            _that.sessionStartHour,
            _that.sessionEndHour,
            _that.minRiskRewardRatio,
            _that.maxLeverage,
            _that.requireExitReason,
            _that.requireOtpForExit,
            _that.createdAt);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            String id,
            @JsonKey(name: 'user_id') String userId,
            String name,
            @JsonKey(name: 'is_active') bool isActive,
            @JsonKey(name: 'is_system') bool isSystem,
            @JsonKey(name: 'max_position_size') double maxPositionSize,
            @JsonKey(name: 'max_position_value_usd') double maxPositionValueUsd,
            @JsonKey(name: 'position_size_type') String positionSizeType,
            @JsonKey(name: 'daily_loss_limit_type') String dailyLossLimitType,
            @JsonKey(name: 'max_daily_loss_usd') double maxDailyLossUsd,
            @JsonKey(name: 'max_daily_loss_percent')
            double? maxDailyLossPercent,
            @JsonKey(name: 'max_open_positions') int maxOpenPositions,
            @JsonKey(name: 'max_trades_per_day') int maxTradesPerDay,
            @JsonKey(name: 'max_consecutive_losses') int maxConsecutiveLosses,
            @JsonKey(name: 'session_start_hour') int? sessionStartHour,
            @JsonKey(name: 'session_end_hour') int? sessionEndHour,
            @JsonKey(name: 'min_risk_reward_ratio') double minRiskRewardRatio,
            @JsonKey(name: 'max_leverage') double maxLeverage,
            @JsonKey(name: 'require_exit_reason') bool requireExitReason,
            @JsonKey(name: 'require_otp_for_exit') bool requireOtpForExit,
            @JsonKey(name: 'created_at') String createdAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Strategy():
        return $default(
            _that.id,
            _that.userId,
            _that.name,
            _that.isActive,
            _that.isSystem,
            _that.maxPositionSize,
            _that.maxPositionValueUsd,
            _that.positionSizeType,
            _that.dailyLossLimitType,
            _that.maxDailyLossUsd,
            _that.maxDailyLossPercent,
            _that.maxOpenPositions,
            _that.maxTradesPerDay,
            _that.maxConsecutiveLosses,
            _that.sessionStartHour,
            _that.sessionEndHour,
            _that.minRiskRewardRatio,
            _that.maxLeverage,
            _that.requireExitReason,
            _that.requireOtpForExit,
            _that.createdAt);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            String id,
            @JsonKey(name: 'user_id') String userId,
            String name,
            @JsonKey(name: 'is_active') bool isActive,
            @JsonKey(name: 'is_system') bool isSystem,
            @JsonKey(name: 'max_position_size') double maxPositionSize,
            @JsonKey(name: 'max_position_value_usd') double maxPositionValueUsd,
            @JsonKey(name: 'position_size_type') String positionSizeType,
            @JsonKey(name: 'daily_loss_limit_type') String dailyLossLimitType,
            @JsonKey(name: 'max_daily_loss_usd') double maxDailyLossUsd,
            @JsonKey(name: 'max_daily_loss_percent')
            double? maxDailyLossPercent,
            @JsonKey(name: 'max_open_positions') int maxOpenPositions,
            @JsonKey(name: 'max_trades_per_day') int maxTradesPerDay,
            @JsonKey(name: 'max_consecutive_losses') int maxConsecutiveLosses,
            @JsonKey(name: 'session_start_hour') int? sessionStartHour,
            @JsonKey(name: 'session_end_hour') int? sessionEndHour,
            @JsonKey(name: 'min_risk_reward_ratio') double minRiskRewardRatio,
            @JsonKey(name: 'max_leverage') double maxLeverage,
            @JsonKey(name: 'require_exit_reason') bool requireExitReason,
            @JsonKey(name: 'require_otp_for_exit') bool requireOtpForExit,
            @JsonKey(name: 'created_at') String createdAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Strategy() when $default != null:
        return $default(
            _that.id,
            _that.userId,
            _that.name,
            _that.isActive,
            _that.isSystem,
            _that.maxPositionSize,
            _that.maxPositionValueUsd,
            _that.positionSizeType,
            _that.dailyLossLimitType,
            _that.maxDailyLossUsd,
            _that.maxDailyLossPercent,
            _that.maxOpenPositions,
            _that.maxTradesPerDay,
            _that.maxConsecutiveLosses,
            _that.sessionStartHour,
            _that.sessionEndHour,
            _that.minRiskRewardRatio,
            _that.maxLeverage,
            _that.requireExitReason,
            _that.requireOtpForExit,
            _that.createdAt);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _Strategy implements Strategy {
  const _Strategy(
      {required this.id,
      @JsonKey(name: 'user_id') required this.userId,
      required this.name,
      @JsonKey(name: 'is_active') this.isActive = false,
      @JsonKey(name: 'is_system') this.isSystem = false,
      @JsonKey(name: 'max_position_size') this.maxPositionSize = 0.0,
      @JsonKey(name: 'max_position_value_usd') this.maxPositionValueUsd = 0.0,
      @JsonKey(name: 'position_size_type') this.positionSizeType = 'fixed_usd',
      @JsonKey(name: 'daily_loss_limit_type')
      this.dailyLossLimitType = 'fixed_usd',
      @JsonKey(name: 'max_daily_loss_usd') this.maxDailyLossUsd = 0.0,
      @JsonKey(name: 'max_daily_loss_percent') this.maxDailyLossPercent,
      @JsonKey(name: 'max_open_positions') this.maxOpenPositions = 5,
      @JsonKey(name: 'max_trades_per_day') this.maxTradesPerDay = 5,
      @JsonKey(name: 'max_consecutive_losses') this.maxConsecutiveLosses = 3,
      @JsonKey(name: 'session_start_hour') this.sessionStartHour,
      @JsonKey(name: 'session_end_hour') this.sessionEndHour,
      @JsonKey(name: 'min_risk_reward_ratio') this.minRiskRewardRatio = 1.5,
      @JsonKey(name: 'max_leverage') this.maxLeverage = 10.0,
      @JsonKey(name: 'require_exit_reason') this.requireExitReason = false,
      @JsonKey(name: 'require_otp_for_exit') this.requireOtpForExit = false,
      @JsonKey(name: 'created_at') required this.createdAt});
  factory _Strategy.fromJson(Map<String, dynamic> json) =>
      _$StrategyFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  final String name;
  @override
  @JsonKey(name: 'is_active')
  final bool isActive;
  @override
  @JsonKey(name: 'is_system')
  final bool isSystem;
  @override
  @JsonKey(name: 'max_position_size')
  final double maxPositionSize;
  @override
  @JsonKey(name: 'max_position_value_usd')
  final double maxPositionValueUsd;
  @override
  @JsonKey(name: 'position_size_type')
  final String positionSizeType;
  @override
  @JsonKey(name: 'daily_loss_limit_type')
  final String dailyLossLimitType;
  @override
  @JsonKey(name: 'max_daily_loss_usd')
  final double maxDailyLossUsd;
  @override
  @JsonKey(name: 'max_daily_loss_percent')
  final double? maxDailyLossPercent;
  @override
  @JsonKey(name: 'max_open_positions')
  final int maxOpenPositions;
  @override
  @JsonKey(name: 'max_trades_per_day')
  final int maxTradesPerDay;
  @override
  @JsonKey(name: 'max_consecutive_losses')
  final int maxConsecutiveLosses;
  @override
  @JsonKey(name: 'session_start_hour')
  final int? sessionStartHour;
  @override
  @JsonKey(name: 'session_end_hour')
  final int? sessionEndHour;
  @override
  @JsonKey(name: 'min_risk_reward_ratio')
  final double minRiskRewardRatio;
  @override
  @JsonKey(name: 'max_leverage')
  final double maxLeverage;
  @override
  @JsonKey(name: 'require_exit_reason')
  final bool requireExitReason;
  @override
  @JsonKey(name: 'require_otp_for_exit')
  final bool requireOtpForExit;
  @override
  @JsonKey(name: 'created_at')
  final String createdAt;

  /// Create a copy of Strategy
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$StrategyCopyWith<_Strategy> get copyWith =>
      __$StrategyCopyWithImpl<_Strategy>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$StrategyToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Strategy &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.isSystem, isSystem) ||
                other.isSystem == isSystem) &&
            (identical(other.maxPositionSize, maxPositionSize) ||
                other.maxPositionSize == maxPositionSize) &&
            (identical(other.maxPositionValueUsd, maxPositionValueUsd) ||
                other.maxPositionValueUsd == maxPositionValueUsd) &&
            (identical(other.positionSizeType, positionSizeType) ||
                other.positionSizeType == positionSizeType) &&
            (identical(other.dailyLossLimitType, dailyLossLimitType) ||
                other.dailyLossLimitType == dailyLossLimitType) &&
            (identical(other.maxDailyLossUsd, maxDailyLossUsd) ||
                other.maxDailyLossUsd == maxDailyLossUsd) &&
            (identical(other.maxDailyLossPercent, maxDailyLossPercent) ||
                other.maxDailyLossPercent == maxDailyLossPercent) &&
            (identical(other.maxOpenPositions, maxOpenPositions) ||
                other.maxOpenPositions == maxOpenPositions) &&
            (identical(other.maxTradesPerDay, maxTradesPerDay) ||
                other.maxTradesPerDay == maxTradesPerDay) &&
            (identical(other.maxConsecutiveLosses, maxConsecutiveLosses) ||
                other.maxConsecutiveLosses == maxConsecutiveLosses) &&
            (identical(other.sessionStartHour, sessionStartHour) ||
                other.sessionStartHour == sessionStartHour) &&
            (identical(other.sessionEndHour, sessionEndHour) ||
                other.sessionEndHour == sessionEndHour) &&
            (identical(other.minRiskRewardRatio, minRiskRewardRatio) ||
                other.minRiskRewardRatio == minRiskRewardRatio) &&
            (identical(other.maxLeverage, maxLeverage) ||
                other.maxLeverage == maxLeverage) &&
            (identical(other.requireExitReason, requireExitReason) ||
                other.requireExitReason == requireExitReason) &&
            (identical(other.requireOtpForExit, requireOtpForExit) ||
                other.requireOtpForExit == requireOtpForExit) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        userId,
        name,
        isActive,
        isSystem,
        maxPositionSize,
        maxPositionValueUsd,
        positionSizeType,
        dailyLossLimitType,
        maxDailyLossUsd,
        maxDailyLossPercent,
        maxOpenPositions,
        maxTradesPerDay,
        maxConsecutiveLosses,
        sessionStartHour,
        sessionEndHour,
        minRiskRewardRatio,
        maxLeverage,
        requireExitReason,
        requireOtpForExit,
        createdAt
      ]);

  @override
  String toString() {
    return 'Strategy(id: $id, userId: $userId, name: $name, isActive: $isActive, isSystem: $isSystem, maxPositionSize: $maxPositionSize, maxPositionValueUsd: $maxPositionValueUsd, positionSizeType: $positionSizeType, dailyLossLimitType: $dailyLossLimitType, maxDailyLossUsd: $maxDailyLossUsd, maxDailyLossPercent: $maxDailyLossPercent, maxOpenPositions: $maxOpenPositions, maxTradesPerDay: $maxTradesPerDay, maxConsecutiveLosses: $maxConsecutiveLosses, sessionStartHour: $sessionStartHour, sessionEndHour: $sessionEndHour, minRiskRewardRatio: $minRiskRewardRatio, maxLeverage: $maxLeverage, requireExitReason: $requireExitReason, requireOtpForExit: $requireOtpForExit, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class _$StrategyCopyWith<$Res>
    implements $StrategyCopyWith<$Res> {
  factory _$StrategyCopyWith(_Strategy value, $Res Function(_Strategy) _then) =
      __$StrategyCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'user_id') String userId,
      String name,
      @JsonKey(name: 'is_active') bool isActive,
      @JsonKey(name: 'is_system') bool isSystem,
      @JsonKey(name: 'max_position_size') double maxPositionSize,
      @JsonKey(name: 'max_position_value_usd') double maxPositionValueUsd,
      @JsonKey(name: 'position_size_type') String positionSizeType,
      @JsonKey(name: 'daily_loss_limit_type') String dailyLossLimitType,
      @JsonKey(name: 'max_daily_loss_usd') double maxDailyLossUsd,
      @JsonKey(name: 'max_daily_loss_percent') double? maxDailyLossPercent,
      @JsonKey(name: 'max_open_positions') int maxOpenPositions,
      @JsonKey(name: 'max_trades_per_day') int maxTradesPerDay,
      @JsonKey(name: 'max_consecutive_losses') int maxConsecutiveLosses,
      @JsonKey(name: 'session_start_hour') int? sessionStartHour,
      @JsonKey(name: 'session_end_hour') int? sessionEndHour,
      @JsonKey(name: 'min_risk_reward_ratio') double minRiskRewardRatio,
      @JsonKey(name: 'max_leverage') double maxLeverage,
      @JsonKey(name: 'require_exit_reason') bool requireExitReason,
      @JsonKey(name: 'require_otp_for_exit') bool requireOtpForExit,
      @JsonKey(name: 'created_at') String createdAt});
}

/// @nodoc
class __$StrategyCopyWithImpl<$Res> implements _$StrategyCopyWith<$Res> {
  __$StrategyCopyWithImpl(this._self, this._then);

  final _Strategy _self;
  final $Res Function(_Strategy) _then;

  /// Create a copy of Strategy
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? name = null,
    Object? isActive = null,
    Object? isSystem = null,
    Object? maxPositionSize = null,
    Object? maxPositionValueUsd = null,
    Object? positionSizeType = null,
    Object? dailyLossLimitType = null,
    Object? maxDailyLossUsd = null,
    Object? maxDailyLossPercent = freezed,
    Object? maxOpenPositions = null,
    Object? maxTradesPerDay = null,
    Object? maxConsecutiveLosses = null,
    Object? sessionStartHour = freezed,
    Object? sessionEndHour = freezed,
    Object? minRiskRewardRatio = null,
    Object? maxLeverage = null,
    Object? requireExitReason = null,
    Object? requireOtpForExit = null,
    Object? createdAt = null,
  }) {
    return _then(_Strategy(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _self.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      isActive: null == isActive
          ? _self.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      isSystem: null == isSystem
          ? _self.isSystem
          : isSystem // ignore: cast_nullable_to_non_nullable
              as bool,
      maxPositionSize: null == maxPositionSize
          ? _self.maxPositionSize
          : maxPositionSize // ignore: cast_nullable_to_non_nullable
              as double,
      maxPositionValueUsd: null == maxPositionValueUsd
          ? _self.maxPositionValueUsd
          : maxPositionValueUsd // ignore: cast_nullable_to_non_nullable
              as double,
      positionSizeType: null == positionSizeType
          ? _self.positionSizeType
          : positionSizeType // ignore: cast_nullable_to_non_nullable
              as String,
      dailyLossLimitType: null == dailyLossLimitType
          ? _self.dailyLossLimitType
          : dailyLossLimitType // ignore: cast_nullable_to_non_nullable
              as String,
      maxDailyLossUsd: null == maxDailyLossUsd
          ? _self.maxDailyLossUsd
          : maxDailyLossUsd // ignore: cast_nullable_to_non_nullable
              as double,
      maxDailyLossPercent: freezed == maxDailyLossPercent
          ? _self.maxDailyLossPercent
          : maxDailyLossPercent // ignore: cast_nullable_to_non_nullable
              as double?,
      maxOpenPositions: null == maxOpenPositions
          ? _self.maxOpenPositions
          : maxOpenPositions // ignore: cast_nullable_to_non_nullable
              as int,
      maxTradesPerDay: null == maxTradesPerDay
          ? _self.maxTradesPerDay
          : maxTradesPerDay // ignore: cast_nullable_to_non_nullable
              as int,
      maxConsecutiveLosses: null == maxConsecutiveLosses
          ? _self.maxConsecutiveLosses
          : maxConsecutiveLosses // ignore: cast_nullable_to_non_nullable
              as int,
      sessionStartHour: freezed == sessionStartHour
          ? _self.sessionStartHour
          : sessionStartHour // ignore: cast_nullable_to_non_nullable
              as int?,
      sessionEndHour: freezed == sessionEndHour
          ? _self.sessionEndHour
          : sessionEndHour // ignore: cast_nullable_to_non_nullable
              as int?,
      minRiskRewardRatio: null == minRiskRewardRatio
          ? _self.minRiskRewardRatio
          : minRiskRewardRatio // ignore: cast_nullable_to_non_nullable
              as double,
      maxLeverage: null == maxLeverage
          ? _self.maxLeverage
          : maxLeverage // ignore: cast_nullable_to_non_nullable
              as double,
      requireExitReason: null == requireExitReason
          ? _self.requireExitReason
          : requireExitReason // ignore: cast_nullable_to_non_nullable
              as bool,
      requireOtpForExit: null == requireOtpForExit
          ? _self.requireOtpForExit
          : requireOtpForExit // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
mixin _$CreateStrategyRequest {
  String get name;
  @JsonKey(name: 'max_position_size')
  double get maxPositionSize;
  @JsonKey(name: 'max_position_value_usd')
  double get maxPositionValueUsd;
  @JsonKey(name: 'position_size_type')
  String get positionSizeType;
  @JsonKey(name: 'daily_loss_limit_type')
  String get dailyLossLimitType;
  @JsonKey(name: 'max_daily_loss_usd')
  double get maxDailyLossUsd;
  @JsonKey(name: 'max_daily_loss_percent')
  double? get maxDailyLossPercent;
  @JsonKey(name: 'max_open_positions')
  int get maxOpenPositions;
  @JsonKey(name: 'max_trades_per_day')
  int get maxTradesPerDay;
  @JsonKey(name: 'max_consecutive_losses')
  int get maxConsecutiveLosses;
  @JsonKey(name: 'session_start_hour')
  int? get sessionStartHour;
  @JsonKey(name: 'session_end_hour')
  int? get sessionEndHour;
  @JsonKey(name: 'min_risk_reward_ratio')
  double get minRiskRewardRatio;
  @JsonKey(name: 'max_leverage')
  double get maxLeverage;
  @JsonKey(name: 'require_exit_reason')
  bool get requireExitReason;
  @JsonKey(name: 'require_otp_for_exit')
  bool get requireOtpForExit;

  /// Create a copy of CreateStrategyRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CreateStrategyRequestCopyWith<CreateStrategyRequest> get copyWith =>
      _$CreateStrategyRequestCopyWithImpl<CreateStrategyRequest>(
          this as CreateStrategyRequest, _$identity);

  /// Serializes this CreateStrategyRequest to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CreateStrategyRequest &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.maxPositionSize, maxPositionSize) ||
                other.maxPositionSize == maxPositionSize) &&
            (identical(other.maxPositionValueUsd, maxPositionValueUsd) ||
                other.maxPositionValueUsd == maxPositionValueUsd) &&
            (identical(other.positionSizeType, positionSizeType) ||
                other.positionSizeType == positionSizeType) &&
            (identical(other.dailyLossLimitType, dailyLossLimitType) ||
                other.dailyLossLimitType == dailyLossLimitType) &&
            (identical(other.maxDailyLossUsd, maxDailyLossUsd) ||
                other.maxDailyLossUsd == maxDailyLossUsd) &&
            (identical(other.maxDailyLossPercent, maxDailyLossPercent) ||
                other.maxDailyLossPercent == maxDailyLossPercent) &&
            (identical(other.maxOpenPositions, maxOpenPositions) ||
                other.maxOpenPositions == maxOpenPositions) &&
            (identical(other.maxTradesPerDay, maxTradesPerDay) ||
                other.maxTradesPerDay == maxTradesPerDay) &&
            (identical(other.maxConsecutiveLosses, maxConsecutiveLosses) ||
                other.maxConsecutiveLosses == maxConsecutiveLosses) &&
            (identical(other.sessionStartHour, sessionStartHour) ||
                other.sessionStartHour == sessionStartHour) &&
            (identical(other.sessionEndHour, sessionEndHour) ||
                other.sessionEndHour == sessionEndHour) &&
            (identical(other.minRiskRewardRatio, minRiskRewardRatio) ||
                other.minRiskRewardRatio == minRiskRewardRatio) &&
            (identical(other.maxLeverage, maxLeverage) ||
                other.maxLeverage == maxLeverage) &&
            (identical(other.requireExitReason, requireExitReason) ||
                other.requireExitReason == requireExitReason) &&
            (identical(other.requireOtpForExit, requireOtpForExit) ||
                other.requireOtpForExit == requireOtpForExit));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      name,
      maxPositionSize,
      maxPositionValueUsd,
      positionSizeType,
      dailyLossLimitType,
      maxDailyLossUsd,
      maxDailyLossPercent,
      maxOpenPositions,
      maxTradesPerDay,
      maxConsecutiveLosses,
      sessionStartHour,
      sessionEndHour,
      minRiskRewardRatio,
      maxLeverage,
      requireExitReason,
      requireOtpForExit);

  @override
  String toString() {
    return 'CreateStrategyRequest(name: $name, maxPositionSize: $maxPositionSize, maxPositionValueUsd: $maxPositionValueUsd, positionSizeType: $positionSizeType, dailyLossLimitType: $dailyLossLimitType, maxDailyLossUsd: $maxDailyLossUsd, maxDailyLossPercent: $maxDailyLossPercent, maxOpenPositions: $maxOpenPositions, maxTradesPerDay: $maxTradesPerDay, maxConsecutiveLosses: $maxConsecutiveLosses, sessionStartHour: $sessionStartHour, sessionEndHour: $sessionEndHour, minRiskRewardRatio: $minRiskRewardRatio, maxLeverage: $maxLeverage, requireExitReason: $requireExitReason, requireOtpForExit: $requireOtpForExit)';
  }
}

/// @nodoc
abstract mixin class $CreateStrategyRequestCopyWith<$Res> {
  factory $CreateStrategyRequestCopyWith(CreateStrategyRequest value,
          $Res Function(CreateStrategyRequest) _then) =
      _$CreateStrategyRequestCopyWithImpl;
  @useResult
  $Res call(
      {String name,
      @JsonKey(name: 'max_position_size') double maxPositionSize,
      @JsonKey(name: 'max_position_value_usd') double maxPositionValueUsd,
      @JsonKey(name: 'position_size_type') String positionSizeType,
      @JsonKey(name: 'daily_loss_limit_type') String dailyLossLimitType,
      @JsonKey(name: 'max_daily_loss_usd') double maxDailyLossUsd,
      @JsonKey(name: 'max_daily_loss_percent') double? maxDailyLossPercent,
      @JsonKey(name: 'max_open_positions') int maxOpenPositions,
      @JsonKey(name: 'max_trades_per_day') int maxTradesPerDay,
      @JsonKey(name: 'max_consecutive_losses') int maxConsecutiveLosses,
      @JsonKey(name: 'session_start_hour') int? sessionStartHour,
      @JsonKey(name: 'session_end_hour') int? sessionEndHour,
      @JsonKey(name: 'min_risk_reward_ratio') double minRiskRewardRatio,
      @JsonKey(name: 'max_leverage') double maxLeverage,
      @JsonKey(name: 'require_exit_reason') bool requireExitReason,
      @JsonKey(name: 'require_otp_for_exit') bool requireOtpForExit});
}

/// @nodoc
class _$CreateStrategyRequestCopyWithImpl<$Res>
    implements $CreateStrategyRequestCopyWith<$Res> {
  _$CreateStrategyRequestCopyWithImpl(this._self, this._then);

  final CreateStrategyRequest _self;
  final $Res Function(CreateStrategyRequest) _then;

  /// Create a copy of CreateStrategyRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? maxPositionSize = null,
    Object? maxPositionValueUsd = null,
    Object? positionSizeType = null,
    Object? dailyLossLimitType = null,
    Object? maxDailyLossUsd = null,
    Object? maxDailyLossPercent = freezed,
    Object? maxOpenPositions = null,
    Object? maxTradesPerDay = null,
    Object? maxConsecutiveLosses = null,
    Object? sessionStartHour = freezed,
    Object? sessionEndHour = freezed,
    Object? minRiskRewardRatio = null,
    Object? maxLeverage = null,
    Object? requireExitReason = null,
    Object? requireOtpForExit = null,
  }) {
    return _then(_self.copyWith(
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      maxPositionSize: null == maxPositionSize
          ? _self.maxPositionSize
          : maxPositionSize // ignore: cast_nullable_to_non_nullable
              as double,
      maxPositionValueUsd: null == maxPositionValueUsd
          ? _self.maxPositionValueUsd
          : maxPositionValueUsd // ignore: cast_nullable_to_non_nullable
              as double,
      positionSizeType: null == positionSizeType
          ? _self.positionSizeType
          : positionSizeType // ignore: cast_nullable_to_non_nullable
              as String,
      dailyLossLimitType: null == dailyLossLimitType
          ? _self.dailyLossLimitType
          : dailyLossLimitType // ignore: cast_nullable_to_non_nullable
              as String,
      maxDailyLossUsd: null == maxDailyLossUsd
          ? _self.maxDailyLossUsd
          : maxDailyLossUsd // ignore: cast_nullable_to_non_nullable
              as double,
      maxDailyLossPercent: freezed == maxDailyLossPercent
          ? _self.maxDailyLossPercent
          : maxDailyLossPercent // ignore: cast_nullable_to_non_nullable
              as double?,
      maxOpenPositions: null == maxOpenPositions
          ? _self.maxOpenPositions
          : maxOpenPositions // ignore: cast_nullable_to_non_nullable
              as int,
      maxTradesPerDay: null == maxTradesPerDay
          ? _self.maxTradesPerDay
          : maxTradesPerDay // ignore: cast_nullable_to_non_nullable
              as int,
      maxConsecutiveLosses: null == maxConsecutiveLosses
          ? _self.maxConsecutiveLosses
          : maxConsecutiveLosses // ignore: cast_nullable_to_non_nullable
              as int,
      sessionStartHour: freezed == sessionStartHour
          ? _self.sessionStartHour
          : sessionStartHour // ignore: cast_nullable_to_non_nullable
              as int?,
      sessionEndHour: freezed == sessionEndHour
          ? _self.sessionEndHour
          : sessionEndHour // ignore: cast_nullable_to_non_nullable
              as int?,
      minRiskRewardRatio: null == minRiskRewardRatio
          ? _self.minRiskRewardRatio
          : minRiskRewardRatio // ignore: cast_nullable_to_non_nullable
              as double,
      maxLeverage: null == maxLeverage
          ? _self.maxLeverage
          : maxLeverage // ignore: cast_nullable_to_non_nullable
              as double,
      requireExitReason: null == requireExitReason
          ? _self.requireExitReason
          : requireExitReason // ignore: cast_nullable_to_non_nullable
              as bool,
      requireOtpForExit: null == requireOtpForExit
          ? _self.requireOtpForExit
          : requireOtpForExit // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// Adds pattern-matching-related methods to [CreateStrategyRequest].
extension CreateStrategyRequestPatterns on CreateStrategyRequest {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_CreateStrategyRequest value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _CreateStrategyRequest() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_CreateStrategyRequest value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CreateStrategyRequest():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_CreateStrategyRequest value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CreateStrategyRequest() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            String name,
            @JsonKey(name: 'max_position_size') double maxPositionSize,
            @JsonKey(name: 'max_position_value_usd') double maxPositionValueUsd,
            @JsonKey(name: 'position_size_type') String positionSizeType,
            @JsonKey(name: 'daily_loss_limit_type') String dailyLossLimitType,
            @JsonKey(name: 'max_daily_loss_usd') double maxDailyLossUsd,
            @JsonKey(name: 'max_daily_loss_percent')
            double? maxDailyLossPercent,
            @JsonKey(name: 'max_open_positions') int maxOpenPositions,
            @JsonKey(name: 'max_trades_per_day') int maxTradesPerDay,
            @JsonKey(name: 'max_consecutive_losses') int maxConsecutiveLosses,
            @JsonKey(name: 'session_start_hour') int? sessionStartHour,
            @JsonKey(name: 'session_end_hour') int? sessionEndHour,
            @JsonKey(name: 'min_risk_reward_ratio') double minRiskRewardRatio,
            @JsonKey(name: 'max_leverage') double maxLeverage,
            @JsonKey(name: 'require_exit_reason') bool requireExitReason,
            @JsonKey(name: 'require_otp_for_exit') bool requireOtpForExit)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _CreateStrategyRequest() when $default != null:
        return $default(
            _that.name,
            _that.maxPositionSize,
            _that.maxPositionValueUsd,
            _that.positionSizeType,
            _that.dailyLossLimitType,
            _that.maxDailyLossUsd,
            _that.maxDailyLossPercent,
            _that.maxOpenPositions,
            _that.maxTradesPerDay,
            _that.maxConsecutiveLosses,
            _that.sessionStartHour,
            _that.sessionEndHour,
            _that.minRiskRewardRatio,
            _that.maxLeverage,
            _that.requireExitReason,
            _that.requireOtpForExit);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            String name,
            @JsonKey(name: 'max_position_size') double maxPositionSize,
            @JsonKey(name: 'max_position_value_usd') double maxPositionValueUsd,
            @JsonKey(name: 'position_size_type') String positionSizeType,
            @JsonKey(name: 'daily_loss_limit_type') String dailyLossLimitType,
            @JsonKey(name: 'max_daily_loss_usd') double maxDailyLossUsd,
            @JsonKey(name: 'max_daily_loss_percent')
            double? maxDailyLossPercent,
            @JsonKey(name: 'max_open_positions') int maxOpenPositions,
            @JsonKey(name: 'max_trades_per_day') int maxTradesPerDay,
            @JsonKey(name: 'max_consecutive_losses') int maxConsecutiveLosses,
            @JsonKey(name: 'session_start_hour') int? sessionStartHour,
            @JsonKey(name: 'session_end_hour') int? sessionEndHour,
            @JsonKey(name: 'min_risk_reward_ratio') double minRiskRewardRatio,
            @JsonKey(name: 'max_leverage') double maxLeverage,
            @JsonKey(name: 'require_exit_reason') bool requireExitReason,
            @JsonKey(name: 'require_otp_for_exit') bool requireOtpForExit)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CreateStrategyRequest():
        return $default(
            _that.name,
            _that.maxPositionSize,
            _that.maxPositionValueUsd,
            _that.positionSizeType,
            _that.dailyLossLimitType,
            _that.maxDailyLossUsd,
            _that.maxDailyLossPercent,
            _that.maxOpenPositions,
            _that.maxTradesPerDay,
            _that.maxConsecutiveLosses,
            _that.sessionStartHour,
            _that.sessionEndHour,
            _that.minRiskRewardRatio,
            _that.maxLeverage,
            _that.requireExitReason,
            _that.requireOtpForExit);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            String name,
            @JsonKey(name: 'max_position_size') double maxPositionSize,
            @JsonKey(name: 'max_position_value_usd') double maxPositionValueUsd,
            @JsonKey(name: 'position_size_type') String positionSizeType,
            @JsonKey(name: 'daily_loss_limit_type') String dailyLossLimitType,
            @JsonKey(name: 'max_daily_loss_usd') double maxDailyLossUsd,
            @JsonKey(name: 'max_daily_loss_percent')
            double? maxDailyLossPercent,
            @JsonKey(name: 'max_open_positions') int maxOpenPositions,
            @JsonKey(name: 'max_trades_per_day') int maxTradesPerDay,
            @JsonKey(name: 'max_consecutive_losses') int maxConsecutiveLosses,
            @JsonKey(name: 'session_start_hour') int? sessionStartHour,
            @JsonKey(name: 'session_end_hour') int? sessionEndHour,
            @JsonKey(name: 'min_risk_reward_ratio') double minRiskRewardRatio,
            @JsonKey(name: 'max_leverage') double maxLeverage,
            @JsonKey(name: 'require_exit_reason') bool requireExitReason,
            @JsonKey(name: 'require_otp_for_exit') bool requireOtpForExit)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CreateStrategyRequest() when $default != null:
        return $default(
            _that.name,
            _that.maxPositionSize,
            _that.maxPositionValueUsd,
            _that.positionSizeType,
            _that.dailyLossLimitType,
            _that.maxDailyLossUsd,
            _that.maxDailyLossPercent,
            _that.maxOpenPositions,
            _that.maxTradesPerDay,
            _that.maxConsecutiveLosses,
            _that.sessionStartHour,
            _that.sessionEndHour,
            _that.minRiskRewardRatio,
            _that.maxLeverage,
            _that.requireExitReason,
            _that.requireOtpForExit);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _CreateStrategyRequest implements CreateStrategyRequest {
  const _CreateStrategyRequest(
      {required this.name,
      @JsonKey(name: 'max_position_size') this.maxPositionSize = 1000.0,
      @JsonKey(name: 'max_position_value_usd')
      this.maxPositionValueUsd = 5000.0,
      @JsonKey(name: 'position_size_type') this.positionSizeType = 'fixed_usd',
      @JsonKey(name: 'daily_loss_limit_type')
      this.dailyLossLimitType = 'fixed_usd',
      @JsonKey(name: 'max_daily_loss_usd') this.maxDailyLossUsd = 200.0,
      @JsonKey(name: 'max_daily_loss_percent') this.maxDailyLossPercent,
      @JsonKey(name: 'max_open_positions') this.maxOpenPositions = 5,
      @JsonKey(name: 'max_trades_per_day') this.maxTradesPerDay = 5,
      @JsonKey(name: 'max_consecutive_losses') this.maxConsecutiveLosses = 3,
      @JsonKey(name: 'session_start_hour') this.sessionStartHour,
      @JsonKey(name: 'session_end_hour') this.sessionEndHour,
      @JsonKey(name: 'min_risk_reward_ratio') this.minRiskRewardRatio = 1.5,
      @JsonKey(name: 'max_leverage') this.maxLeverage = 10.0,
      @JsonKey(name: 'require_exit_reason') this.requireExitReason = true,
      @JsonKey(name: 'require_otp_for_exit') this.requireOtpForExit = true});
  factory _CreateStrategyRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateStrategyRequestFromJson(json);

  @override
  final String name;
  @override
  @JsonKey(name: 'max_position_size')
  final double maxPositionSize;
  @override
  @JsonKey(name: 'max_position_value_usd')
  final double maxPositionValueUsd;
  @override
  @JsonKey(name: 'position_size_type')
  final String positionSizeType;
  @override
  @JsonKey(name: 'daily_loss_limit_type')
  final String dailyLossLimitType;
  @override
  @JsonKey(name: 'max_daily_loss_usd')
  final double maxDailyLossUsd;
  @override
  @JsonKey(name: 'max_daily_loss_percent')
  final double? maxDailyLossPercent;
  @override
  @JsonKey(name: 'max_open_positions')
  final int maxOpenPositions;
  @override
  @JsonKey(name: 'max_trades_per_day')
  final int maxTradesPerDay;
  @override
  @JsonKey(name: 'max_consecutive_losses')
  final int maxConsecutiveLosses;
  @override
  @JsonKey(name: 'session_start_hour')
  final int? sessionStartHour;
  @override
  @JsonKey(name: 'session_end_hour')
  final int? sessionEndHour;
  @override
  @JsonKey(name: 'min_risk_reward_ratio')
  final double minRiskRewardRatio;
  @override
  @JsonKey(name: 'max_leverage')
  final double maxLeverage;
  @override
  @JsonKey(name: 'require_exit_reason')
  final bool requireExitReason;
  @override
  @JsonKey(name: 'require_otp_for_exit')
  final bool requireOtpForExit;

  /// Create a copy of CreateStrategyRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$CreateStrategyRequestCopyWith<_CreateStrategyRequest> get copyWith =>
      __$CreateStrategyRequestCopyWithImpl<_CreateStrategyRequest>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$CreateStrategyRequestToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _CreateStrategyRequest &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.maxPositionSize, maxPositionSize) ||
                other.maxPositionSize == maxPositionSize) &&
            (identical(other.maxPositionValueUsd, maxPositionValueUsd) ||
                other.maxPositionValueUsd == maxPositionValueUsd) &&
            (identical(other.positionSizeType, positionSizeType) ||
                other.positionSizeType == positionSizeType) &&
            (identical(other.dailyLossLimitType, dailyLossLimitType) ||
                other.dailyLossLimitType == dailyLossLimitType) &&
            (identical(other.maxDailyLossUsd, maxDailyLossUsd) ||
                other.maxDailyLossUsd == maxDailyLossUsd) &&
            (identical(other.maxDailyLossPercent, maxDailyLossPercent) ||
                other.maxDailyLossPercent == maxDailyLossPercent) &&
            (identical(other.maxOpenPositions, maxOpenPositions) ||
                other.maxOpenPositions == maxOpenPositions) &&
            (identical(other.maxTradesPerDay, maxTradesPerDay) ||
                other.maxTradesPerDay == maxTradesPerDay) &&
            (identical(other.maxConsecutiveLosses, maxConsecutiveLosses) ||
                other.maxConsecutiveLosses == maxConsecutiveLosses) &&
            (identical(other.sessionStartHour, sessionStartHour) ||
                other.sessionStartHour == sessionStartHour) &&
            (identical(other.sessionEndHour, sessionEndHour) ||
                other.sessionEndHour == sessionEndHour) &&
            (identical(other.minRiskRewardRatio, minRiskRewardRatio) ||
                other.minRiskRewardRatio == minRiskRewardRatio) &&
            (identical(other.maxLeverage, maxLeverage) ||
                other.maxLeverage == maxLeverage) &&
            (identical(other.requireExitReason, requireExitReason) ||
                other.requireExitReason == requireExitReason) &&
            (identical(other.requireOtpForExit, requireOtpForExit) ||
                other.requireOtpForExit == requireOtpForExit));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      name,
      maxPositionSize,
      maxPositionValueUsd,
      positionSizeType,
      dailyLossLimitType,
      maxDailyLossUsd,
      maxDailyLossPercent,
      maxOpenPositions,
      maxTradesPerDay,
      maxConsecutiveLosses,
      sessionStartHour,
      sessionEndHour,
      minRiskRewardRatio,
      maxLeverage,
      requireExitReason,
      requireOtpForExit);

  @override
  String toString() {
    return 'CreateStrategyRequest(name: $name, maxPositionSize: $maxPositionSize, maxPositionValueUsd: $maxPositionValueUsd, positionSizeType: $positionSizeType, dailyLossLimitType: $dailyLossLimitType, maxDailyLossUsd: $maxDailyLossUsd, maxDailyLossPercent: $maxDailyLossPercent, maxOpenPositions: $maxOpenPositions, maxTradesPerDay: $maxTradesPerDay, maxConsecutiveLosses: $maxConsecutiveLosses, sessionStartHour: $sessionStartHour, sessionEndHour: $sessionEndHour, minRiskRewardRatio: $minRiskRewardRatio, maxLeverage: $maxLeverage, requireExitReason: $requireExitReason, requireOtpForExit: $requireOtpForExit)';
  }
}

/// @nodoc
abstract mixin class _$CreateStrategyRequestCopyWith<$Res>
    implements $CreateStrategyRequestCopyWith<$Res> {
  factory _$CreateStrategyRequestCopyWith(_CreateStrategyRequest value,
          $Res Function(_CreateStrategyRequest) _then) =
      __$CreateStrategyRequestCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String name,
      @JsonKey(name: 'max_position_size') double maxPositionSize,
      @JsonKey(name: 'max_position_value_usd') double maxPositionValueUsd,
      @JsonKey(name: 'position_size_type') String positionSizeType,
      @JsonKey(name: 'daily_loss_limit_type') String dailyLossLimitType,
      @JsonKey(name: 'max_daily_loss_usd') double maxDailyLossUsd,
      @JsonKey(name: 'max_daily_loss_percent') double? maxDailyLossPercent,
      @JsonKey(name: 'max_open_positions') int maxOpenPositions,
      @JsonKey(name: 'max_trades_per_day') int maxTradesPerDay,
      @JsonKey(name: 'max_consecutive_losses') int maxConsecutiveLosses,
      @JsonKey(name: 'session_start_hour') int? sessionStartHour,
      @JsonKey(name: 'session_end_hour') int? sessionEndHour,
      @JsonKey(name: 'min_risk_reward_ratio') double minRiskRewardRatio,
      @JsonKey(name: 'max_leverage') double maxLeverage,
      @JsonKey(name: 'require_exit_reason') bool requireExitReason,
      @JsonKey(name: 'require_otp_for_exit') bool requireOtpForExit});
}

/// @nodoc
class __$CreateStrategyRequestCopyWithImpl<$Res>
    implements _$CreateStrategyRequestCopyWith<$Res> {
  __$CreateStrategyRequestCopyWithImpl(this._self, this._then);

  final _CreateStrategyRequest _self;
  final $Res Function(_CreateStrategyRequest) _then;

  /// Create a copy of CreateStrategyRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? name = null,
    Object? maxPositionSize = null,
    Object? maxPositionValueUsd = null,
    Object? positionSizeType = null,
    Object? dailyLossLimitType = null,
    Object? maxDailyLossUsd = null,
    Object? maxDailyLossPercent = freezed,
    Object? maxOpenPositions = null,
    Object? maxTradesPerDay = null,
    Object? maxConsecutiveLosses = null,
    Object? sessionStartHour = freezed,
    Object? sessionEndHour = freezed,
    Object? minRiskRewardRatio = null,
    Object? maxLeverage = null,
    Object? requireExitReason = null,
    Object? requireOtpForExit = null,
  }) {
    return _then(_CreateStrategyRequest(
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      maxPositionSize: null == maxPositionSize
          ? _self.maxPositionSize
          : maxPositionSize // ignore: cast_nullable_to_non_nullable
              as double,
      maxPositionValueUsd: null == maxPositionValueUsd
          ? _self.maxPositionValueUsd
          : maxPositionValueUsd // ignore: cast_nullable_to_non_nullable
              as double,
      positionSizeType: null == positionSizeType
          ? _self.positionSizeType
          : positionSizeType // ignore: cast_nullable_to_non_nullable
              as String,
      dailyLossLimitType: null == dailyLossLimitType
          ? _self.dailyLossLimitType
          : dailyLossLimitType // ignore: cast_nullable_to_non_nullable
              as String,
      maxDailyLossUsd: null == maxDailyLossUsd
          ? _self.maxDailyLossUsd
          : maxDailyLossUsd // ignore: cast_nullable_to_non_nullable
              as double,
      maxDailyLossPercent: freezed == maxDailyLossPercent
          ? _self.maxDailyLossPercent
          : maxDailyLossPercent // ignore: cast_nullable_to_non_nullable
              as double?,
      maxOpenPositions: null == maxOpenPositions
          ? _self.maxOpenPositions
          : maxOpenPositions // ignore: cast_nullable_to_non_nullable
              as int,
      maxTradesPerDay: null == maxTradesPerDay
          ? _self.maxTradesPerDay
          : maxTradesPerDay // ignore: cast_nullable_to_non_nullable
              as int,
      maxConsecutiveLosses: null == maxConsecutiveLosses
          ? _self.maxConsecutiveLosses
          : maxConsecutiveLosses // ignore: cast_nullable_to_non_nullable
              as int,
      sessionStartHour: freezed == sessionStartHour
          ? _self.sessionStartHour
          : sessionStartHour // ignore: cast_nullable_to_non_nullable
              as int?,
      sessionEndHour: freezed == sessionEndHour
          ? _self.sessionEndHour
          : sessionEndHour // ignore: cast_nullable_to_non_nullable
              as int?,
      minRiskRewardRatio: null == minRiskRewardRatio
          ? _self.minRiskRewardRatio
          : minRiskRewardRatio // ignore: cast_nullable_to_non_nullable
              as double,
      maxLeverage: null == maxLeverage
          ? _self.maxLeverage
          : maxLeverage // ignore: cast_nullable_to_non_nullable
              as double,
      requireExitReason: null == requireExitReason
          ? _self.requireExitReason
          : requireExitReason // ignore: cast_nullable_to_non_nullable
              as bool,
      requireOtpForExit: null == requireOtpForExit
          ? _self.requireOtpForExit
          : requireOtpForExit // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

// dart format on
