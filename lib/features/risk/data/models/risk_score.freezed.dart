// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'risk_score.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RiskScore {
  String get symbol;
  @JsonKey(name: 'risk_score')
  double get score;
  @JsonKey(name: 'risk_level')
  String get level;
  List<String> get factors;
  @JsonKey(name: 'fetched_at')
  String get updatedAt;

  /// Create a copy of RiskScore
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $RiskScoreCopyWith<RiskScore> get copyWith =>
      _$RiskScoreCopyWithImpl<RiskScore>(this as RiskScore, _$identity);

  /// Serializes this RiskScore to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is RiskScore &&
            (identical(other.symbol, symbol) || other.symbol == symbol) &&
            (identical(other.score, score) || other.score == score) &&
            (identical(other.level, level) || other.level == level) &&
            const DeepCollectionEquality().equals(other.factors, factors) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, symbol, score, level,
      const DeepCollectionEquality().hash(factors), updatedAt);

  @override
  String toString() {
    return 'RiskScore(symbol: $symbol, score: $score, level: $level, factors: $factors, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class $RiskScoreCopyWith<$Res> {
  factory $RiskScoreCopyWith(RiskScore value, $Res Function(RiskScore) _then) =
      _$RiskScoreCopyWithImpl;
  @useResult
  $Res call(
      {String symbol,
      @JsonKey(name: 'risk_score') double score,
      @JsonKey(name: 'risk_level') String level,
      List<String> factors,
      @JsonKey(name: 'fetched_at') String updatedAt});
}

/// @nodoc
class _$RiskScoreCopyWithImpl<$Res> implements $RiskScoreCopyWith<$Res> {
  _$RiskScoreCopyWithImpl(this._self, this._then);

  final RiskScore _self;
  final $Res Function(RiskScore) _then;

  /// Create a copy of RiskScore
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? symbol = null,
    Object? score = null,
    Object? level = null,
    Object? factors = null,
    Object? updatedAt = null,
  }) {
    return _then(_self.copyWith(
      symbol: null == symbol
          ? _self.symbol
          : symbol // ignore: cast_nullable_to_non_nullable
              as String,
      score: null == score
          ? _self.score
          : score // ignore: cast_nullable_to_non_nullable
              as double,
      level: null == level
          ? _self.level
          : level // ignore: cast_nullable_to_non_nullable
              as String,
      factors: null == factors
          ? _self.factors
          : factors // ignore: cast_nullable_to_non_nullable
              as List<String>,
      updatedAt: null == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// Adds pattern-matching-related methods to [RiskScore].
extension RiskScorePatterns on RiskScore {
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
    TResult Function(_RiskScore value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _RiskScore() when $default != null:
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
    TResult Function(_RiskScore value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RiskScore():
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
    TResult? Function(_RiskScore value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RiskScore() when $default != null:
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
            String symbol,
            @JsonKey(name: 'risk_score') double score,
            @JsonKey(name: 'risk_level') String level,
            List<String> factors,
            @JsonKey(name: 'fetched_at') String updatedAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _RiskScore() when $default != null:
        return $default(_that.symbol, _that.score, _that.level, _that.factors,
            _that.updatedAt);
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
            String symbol,
            @JsonKey(name: 'risk_score') double score,
            @JsonKey(name: 'risk_level') String level,
            List<String> factors,
            @JsonKey(name: 'fetched_at') String updatedAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RiskScore():
        return $default(_that.symbol, _that.score, _that.level, _that.factors,
            _that.updatedAt);
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
            String symbol,
            @JsonKey(name: 'risk_score') double score,
            @JsonKey(name: 'risk_level') String level,
            List<String> factors,
            @JsonKey(name: 'fetched_at') String updatedAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RiskScore() when $default != null:
        return $default(_that.symbol, _that.score, _that.level, _that.factors,
            _that.updatedAt);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _RiskScore implements RiskScore {
  const _RiskScore(
      {required this.symbol,
      @JsonKey(name: 'risk_score') required this.score,
      @JsonKey(name: 'risk_level') this.level = 'medium',
      final List<String> factors = const [],
      @JsonKey(name: 'fetched_at') this.updatedAt = ''})
      : _factors = factors;
  factory _RiskScore.fromJson(Map<String, dynamic> json) =>
      _$RiskScoreFromJson(json);

  @override
  final String symbol;
  @override
  @JsonKey(name: 'risk_score')
  final double score;
  @override
  @JsonKey(name: 'risk_level')
  final String level;
  final List<String> _factors;
  @override
  @JsonKey()
  List<String> get factors {
    if (_factors is EqualUnmodifiableListView) return _factors;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_factors);
  }

  @override
  @JsonKey(name: 'fetched_at')
  final String updatedAt;

  /// Create a copy of RiskScore
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$RiskScoreCopyWith<_RiskScore> get copyWith =>
      __$RiskScoreCopyWithImpl<_RiskScore>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$RiskScoreToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _RiskScore &&
            (identical(other.symbol, symbol) || other.symbol == symbol) &&
            (identical(other.score, score) || other.score == score) &&
            (identical(other.level, level) || other.level == level) &&
            const DeepCollectionEquality().equals(other._factors, _factors) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, symbol, score, level,
      const DeepCollectionEquality().hash(_factors), updatedAt);

  @override
  String toString() {
    return 'RiskScore(symbol: $symbol, score: $score, level: $level, factors: $factors, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class _$RiskScoreCopyWith<$Res>
    implements $RiskScoreCopyWith<$Res> {
  factory _$RiskScoreCopyWith(
          _RiskScore value, $Res Function(_RiskScore) _then) =
      __$RiskScoreCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String symbol,
      @JsonKey(name: 'risk_score') double score,
      @JsonKey(name: 'risk_level') String level,
      List<String> factors,
      @JsonKey(name: 'fetched_at') String updatedAt});
}

/// @nodoc
class __$RiskScoreCopyWithImpl<$Res> implements _$RiskScoreCopyWith<$Res> {
  __$RiskScoreCopyWithImpl(this._self, this._then);

  final _RiskScore _self;
  final $Res Function(_RiskScore) _then;

  /// Create a copy of RiskScore
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? symbol = null,
    Object? score = null,
    Object? level = null,
    Object? factors = null,
    Object? updatedAt = null,
  }) {
    return _then(_RiskScore(
      symbol: null == symbol
          ? _self.symbol
          : symbol // ignore: cast_nullable_to_non_nullable
              as String,
      score: null == score
          ? _self.score
          : score // ignore: cast_nullable_to_non_nullable
              as double,
      level: null == level
          ? _self.level
          : level // ignore: cast_nullable_to_non_nullable
              as String,
      factors: null == factors
          ? _self._factors
          : factors // ignore: cast_nullable_to_non_nullable
              as List<String>,
      updatedAt: null == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
mixin _$PortfolioRisk {
  @JsonKey(name: 'user_id')
  String get userId;
  List<RiskScore> get positions;

  /// Create a copy of PortfolioRisk
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PortfolioRiskCopyWith<PortfolioRisk> get copyWith =>
      _$PortfolioRiskCopyWithImpl<PortfolioRisk>(
          this as PortfolioRisk, _$identity);

  /// Serializes this PortfolioRisk to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PortfolioRisk &&
            (identical(other.userId, userId) || other.userId == userId) &&
            const DeepCollectionEquality().equals(other.positions, positions));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, userId, const DeepCollectionEquality().hash(positions));

  @override
  String toString() {
    return 'PortfolioRisk(userId: $userId, positions: $positions)';
  }
}

/// @nodoc
abstract mixin class $PortfolioRiskCopyWith<$Res> {
  factory $PortfolioRiskCopyWith(
          PortfolioRisk value, $Res Function(PortfolioRisk) _then) =
      _$PortfolioRiskCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(name: 'user_id') String userId, List<RiskScore> positions});
}

/// @nodoc
class _$PortfolioRiskCopyWithImpl<$Res>
    implements $PortfolioRiskCopyWith<$Res> {
  _$PortfolioRiskCopyWithImpl(this._self, this._then);

  final PortfolioRisk _self;
  final $Res Function(PortfolioRisk) _then;

  /// Create a copy of PortfolioRisk
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? positions = null,
  }) {
    return _then(_self.copyWith(
      userId: null == userId
          ? _self.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      positions: null == positions
          ? _self.positions
          : positions // ignore: cast_nullable_to_non_nullable
              as List<RiskScore>,
    ));
  }
}

/// Adds pattern-matching-related methods to [PortfolioRisk].
extension PortfolioRiskPatterns on PortfolioRisk {
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
    TResult Function(_PortfolioRisk value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PortfolioRisk() when $default != null:
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
    TResult Function(_PortfolioRisk value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PortfolioRisk():
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
    TResult? Function(_PortfolioRisk value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PortfolioRisk() when $default != null:
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
            @JsonKey(name: 'user_id') String userId, List<RiskScore> positions)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PortfolioRisk() when $default != null:
        return $default(_that.userId, _that.positions);
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
            @JsonKey(name: 'user_id') String userId, List<RiskScore> positions)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PortfolioRisk():
        return $default(_that.userId, _that.positions);
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
            @JsonKey(name: 'user_id') String userId, List<RiskScore> positions)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PortfolioRisk() when $default != null:
        return $default(_that.userId, _that.positions);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _PortfolioRisk implements PortfolioRisk {
  const _PortfolioRisk(
      {@JsonKey(name: 'user_id') this.userId = '',
      final List<RiskScore> positions = const []})
      : _positions = positions;
  factory _PortfolioRisk.fromJson(Map<String, dynamic> json) =>
      _$PortfolioRiskFromJson(json);

  @override
  @JsonKey(name: 'user_id')
  final String userId;
  final List<RiskScore> _positions;
  @override
  @JsonKey()
  List<RiskScore> get positions {
    if (_positions is EqualUnmodifiableListView) return _positions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_positions);
  }

  /// Create a copy of PortfolioRisk
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$PortfolioRiskCopyWith<_PortfolioRisk> get copyWith =>
      __$PortfolioRiskCopyWithImpl<_PortfolioRisk>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$PortfolioRiskToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _PortfolioRisk &&
            (identical(other.userId, userId) || other.userId == userId) &&
            const DeepCollectionEquality()
                .equals(other._positions, _positions));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, userId, const DeepCollectionEquality().hash(_positions));

  @override
  String toString() {
    return 'PortfolioRisk(userId: $userId, positions: $positions)';
  }
}

/// @nodoc
abstract mixin class _$PortfolioRiskCopyWith<$Res>
    implements $PortfolioRiskCopyWith<$Res> {
  factory _$PortfolioRiskCopyWith(
          _PortfolioRisk value, $Res Function(_PortfolioRisk) _then) =
      __$PortfolioRiskCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'user_id') String userId, List<RiskScore> positions});
}

/// @nodoc
class __$PortfolioRiskCopyWithImpl<$Res>
    implements _$PortfolioRiskCopyWith<$Res> {
  __$PortfolioRiskCopyWithImpl(this._self, this._then);

  final _PortfolioRisk _self;
  final $Res Function(_PortfolioRisk) _then;

  /// Create a copy of PortfolioRisk
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? userId = null,
    Object? positions = null,
  }) {
    return _then(_PortfolioRisk(
      userId: null == userId
          ? _self.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      positions: null == positions
          ? _self._positions
          : positions // ignore: cast_nullable_to_non_nullable
              as List<RiskScore>,
    ));
  }
}

// dart format on
