// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'trade_form_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TradeFormState {
  TradingSymbol? get symbol;
  OrderType get orderType;
  OrderSide get side;
  double get quantity;
  double? get limitPrice;
  double get leverage;
  List<double> get tpLevels;
  double? get slPrice;
  RiskScore? get riskScore;
  bool get isSubmitting;
  String? get submitError;
  Order? get lastOrder;

  /// Create a copy of TradeFormState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TradeFormStateCopyWith<TradeFormState> get copyWith =>
      _$TradeFormStateCopyWithImpl<TradeFormState>(
          this as TradeFormState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TradeFormState &&
            (identical(other.symbol, symbol) || other.symbol == symbol) &&
            (identical(other.orderType, orderType) ||
                other.orderType == orderType) &&
            (identical(other.side, side) || other.side == side) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.limitPrice, limitPrice) ||
                other.limitPrice == limitPrice) &&
            (identical(other.leverage, leverage) ||
                other.leverage == leverage) &&
            const DeepCollectionEquality().equals(other.tpLevels, tpLevels) &&
            (identical(other.slPrice, slPrice) || other.slPrice == slPrice) &&
            (identical(other.riskScore, riskScore) ||
                other.riskScore == riskScore) &&
            (identical(other.isSubmitting, isSubmitting) ||
                other.isSubmitting == isSubmitting) &&
            (identical(other.submitError, submitError) ||
                other.submitError == submitError) &&
            (identical(other.lastOrder, lastOrder) ||
                other.lastOrder == lastOrder));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      symbol,
      orderType,
      side,
      quantity,
      limitPrice,
      leverage,
      const DeepCollectionEquality().hash(tpLevels),
      slPrice,
      riskScore,
      isSubmitting,
      submitError,
      lastOrder);

  @override
  String toString() {
    return 'TradeFormState(symbol: $symbol, orderType: $orderType, side: $side, quantity: $quantity, limitPrice: $limitPrice, leverage: $leverage, tpLevels: $tpLevels, slPrice: $slPrice, riskScore: $riskScore, isSubmitting: $isSubmitting, submitError: $submitError, lastOrder: $lastOrder)';
  }
}

/// @nodoc
abstract mixin class $TradeFormStateCopyWith<$Res> {
  factory $TradeFormStateCopyWith(
          TradeFormState value, $Res Function(TradeFormState) _then) =
      _$TradeFormStateCopyWithImpl;
  @useResult
  $Res call(
      {TradingSymbol? symbol,
      OrderType orderType,
      OrderSide side,
      double quantity,
      double? limitPrice,
      double leverage,
      List<double> tpLevels,
      double? slPrice,
      RiskScore? riskScore,
      bool isSubmitting,
      String? submitError,
      Order? lastOrder});

  $TradingSymbolCopyWith<$Res>? get symbol;
  $RiskScoreCopyWith<$Res>? get riskScore;
  $OrderCopyWith<$Res>? get lastOrder;
}

/// @nodoc
class _$TradeFormStateCopyWithImpl<$Res>
    implements $TradeFormStateCopyWith<$Res> {
  _$TradeFormStateCopyWithImpl(this._self, this._then);

  final TradeFormState _self;
  final $Res Function(TradeFormState) _then;

  /// Create a copy of TradeFormState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? symbol = freezed,
    Object? orderType = null,
    Object? side = null,
    Object? quantity = null,
    Object? limitPrice = freezed,
    Object? leverage = null,
    Object? tpLevels = null,
    Object? slPrice = freezed,
    Object? riskScore = freezed,
    Object? isSubmitting = null,
    Object? submitError = freezed,
    Object? lastOrder = freezed,
  }) {
    return _then(_self.copyWith(
      symbol: freezed == symbol
          ? _self.symbol
          : symbol // ignore: cast_nullable_to_non_nullable
              as TradingSymbol?,
      orderType: null == orderType
          ? _self.orderType
          : orderType // ignore: cast_nullable_to_non_nullable
              as OrderType,
      side: null == side
          ? _self.side
          : side // ignore: cast_nullable_to_non_nullable
              as OrderSide,
      quantity: null == quantity
          ? _self.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as double,
      limitPrice: freezed == limitPrice
          ? _self.limitPrice
          : limitPrice // ignore: cast_nullable_to_non_nullable
              as double?,
      leverage: null == leverage
          ? _self.leverage
          : leverage // ignore: cast_nullable_to_non_nullable
              as double,
      tpLevels: null == tpLevels
          ? _self.tpLevels
          : tpLevels // ignore: cast_nullable_to_non_nullable
              as List<double>,
      slPrice: freezed == slPrice
          ? _self.slPrice
          : slPrice // ignore: cast_nullable_to_non_nullable
              as double?,
      riskScore: freezed == riskScore
          ? _self.riskScore
          : riskScore // ignore: cast_nullable_to_non_nullable
              as RiskScore?,
      isSubmitting: null == isSubmitting
          ? _self.isSubmitting
          : isSubmitting // ignore: cast_nullable_to_non_nullable
              as bool,
      submitError: freezed == submitError
          ? _self.submitError
          : submitError // ignore: cast_nullable_to_non_nullable
              as String?,
      lastOrder: freezed == lastOrder
          ? _self.lastOrder
          : lastOrder // ignore: cast_nullable_to_non_nullable
              as Order?,
    ));
  }

  /// Create a copy of TradeFormState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TradingSymbolCopyWith<$Res>? get symbol {
    if (_self.symbol == null) {
      return null;
    }

    return $TradingSymbolCopyWith<$Res>(_self.symbol!, (value) {
      return _then(_self.copyWith(symbol: value));
    });
  }

  /// Create a copy of TradeFormState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $RiskScoreCopyWith<$Res>? get riskScore {
    if (_self.riskScore == null) {
      return null;
    }

    return $RiskScoreCopyWith<$Res>(_self.riskScore!, (value) {
      return _then(_self.copyWith(riskScore: value));
    });
  }

  /// Create a copy of TradeFormState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $OrderCopyWith<$Res>? get lastOrder {
    if (_self.lastOrder == null) {
      return null;
    }

    return $OrderCopyWith<$Res>(_self.lastOrder!, (value) {
      return _then(_self.copyWith(lastOrder: value));
    });
  }
}

/// Adds pattern-matching-related methods to [TradeFormState].
extension TradeFormStatePatterns on TradeFormState {
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
    TResult Function(_TradeFormState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TradeFormState() when $default != null:
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
    TResult Function(_TradeFormState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TradeFormState():
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
    TResult? Function(_TradeFormState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TradeFormState() when $default != null:
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
            TradingSymbol? symbol,
            OrderType orderType,
            OrderSide side,
            double quantity,
            double? limitPrice,
            double leverage,
            List<double> tpLevels,
            double? slPrice,
            RiskScore? riskScore,
            bool isSubmitting,
            String? submitError,
            Order? lastOrder)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TradeFormState() when $default != null:
        return $default(
            _that.symbol,
            _that.orderType,
            _that.side,
            _that.quantity,
            _that.limitPrice,
            _that.leverage,
            _that.tpLevels,
            _that.slPrice,
            _that.riskScore,
            _that.isSubmitting,
            _that.submitError,
            _that.lastOrder);
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
            TradingSymbol? symbol,
            OrderType orderType,
            OrderSide side,
            double quantity,
            double? limitPrice,
            double leverage,
            List<double> tpLevels,
            double? slPrice,
            RiskScore? riskScore,
            bool isSubmitting,
            String? submitError,
            Order? lastOrder)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TradeFormState():
        return $default(
            _that.symbol,
            _that.orderType,
            _that.side,
            _that.quantity,
            _that.limitPrice,
            _that.leverage,
            _that.tpLevels,
            _that.slPrice,
            _that.riskScore,
            _that.isSubmitting,
            _that.submitError,
            _that.lastOrder);
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
            TradingSymbol? symbol,
            OrderType orderType,
            OrderSide side,
            double quantity,
            double? limitPrice,
            double leverage,
            List<double> tpLevels,
            double? slPrice,
            RiskScore? riskScore,
            bool isSubmitting,
            String? submitError,
            Order? lastOrder)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TradeFormState() when $default != null:
        return $default(
            _that.symbol,
            _that.orderType,
            _that.side,
            _that.quantity,
            _that.limitPrice,
            _that.leverage,
            _that.tpLevels,
            _that.slPrice,
            _that.riskScore,
            _that.isSubmitting,
            _that.submitError,
            _that.lastOrder);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _TradeFormState implements TradeFormState {
  const _TradeFormState(
      {this.symbol,
      this.orderType = OrderType.market,
      this.side = OrderSide.buy,
      this.quantity = 1.0,
      this.limitPrice,
      this.leverage = 10.0,
      final List<double> tpLevels = const [],
      this.slPrice,
      this.riskScore,
      this.isSubmitting = false,
      this.submitError,
      this.lastOrder})
      : _tpLevels = tpLevels;

  @override
  final TradingSymbol? symbol;
  @override
  @JsonKey()
  final OrderType orderType;
  @override
  @JsonKey()
  final OrderSide side;
  @override
  @JsonKey()
  final double quantity;
  @override
  final double? limitPrice;
  @override
  @JsonKey()
  final double leverage;
  final List<double> _tpLevels;
  @override
  @JsonKey()
  List<double> get tpLevels {
    if (_tpLevels is EqualUnmodifiableListView) return _tpLevels;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tpLevels);
  }

  @override
  final double? slPrice;
  @override
  final RiskScore? riskScore;
  @override
  @JsonKey()
  final bool isSubmitting;
  @override
  final String? submitError;
  @override
  final Order? lastOrder;

  /// Create a copy of TradeFormState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$TradeFormStateCopyWith<_TradeFormState> get copyWith =>
      __$TradeFormStateCopyWithImpl<_TradeFormState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _TradeFormState &&
            (identical(other.symbol, symbol) || other.symbol == symbol) &&
            (identical(other.orderType, orderType) ||
                other.orderType == orderType) &&
            (identical(other.side, side) || other.side == side) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.limitPrice, limitPrice) ||
                other.limitPrice == limitPrice) &&
            (identical(other.leverage, leverage) ||
                other.leverage == leverage) &&
            const DeepCollectionEquality().equals(other._tpLevels, _tpLevels) &&
            (identical(other.slPrice, slPrice) || other.slPrice == slPrice) &&
            (identical(other.riskScore, riskScore) ||
                other.riskScore == riskScore) &&
            (identical(other.isSubmitting, isSubmitting) ||
                other.isSubmitting == isSubmitting) &&
            (identical(other.submitError, submitError) ||
                other.submitError == submitError) &&
            (identical(other.lastOrder, lastOrder) ||
                other.lastOrder == lastOrder));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      symbol,
      orderType,
      side,
      quantity,
      limitPrice,
      leverage,
      const DeepCollectionEquality().hash(_tpLevels),
      slPrice,
      riskScore,
      isSubmitting,
      submitError,
      lastOrder);

  @override
  String toString() {
    return 'TradeFormState(symbol: $symbol, orderType: $orderType, side: $side, quantity: $quantity, limitPrice: $limitPrice, leverage: $leverage, tpLevels: $tpLevels, slPrice: $slPrice, riskScore: $riskScore, isSubmitting: $isSubmitting, submitError: $submitError, lastOrder: $lastOrder)';
  }
}

/// @nodoc
abstract mixin class _$TradeFormStateCopyWith<$Res>
    implements $TradeFormStateCopyWith<$Res> {
  factory _$TradeFormStateCopyWith(
          _TradeFormState value, $Res Function(_TradeFormState) _then) =
      __$TradeFormStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {TradingSymbol? symbol,
      OrderType orderType,
      OrderSide side,
      double quantity,
      double? limitPrice,
      double leverage,
      List<double> tpLevels,
      double? slPrice,
      RiskScore? riskScore,
      bool isSubmitting,
      String? submitError,
      Order? lastOrder});

  @override
  $TradingSymbolCopyWith<$Res>? get symbol;
  @override
  $RiskScoreCopyWith<$Res>? get riskScore;
  @override
  $OrderCopyWith<$Res>? get lastOrder;
}

/// @nodoc
class __$TradeFormStateCopyWithImpl<$Res>
    implements _$TradeFormStateCopyWith<$Res> {
  __$TradeFormStateCopyWithImpl(this._self, this._then);

  final _TradeFormState _self;
  final $Res Function(_TradeFormState) _then;

  /// Create a copy of TradeFormState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? symbol = freezed,
    Object? orderType = null,
    Object? side = null,
    Object? quantity = null,
    Object? limitPrice = freezed,
    Object? leverage = null,
    Object? tpLevels = null,
    Object? slPrice = freezed,
    Object? riskScore = freezed,
    Object? isSubmitting = null,
    Object? submitError = freezed,
    Object? lastOrder = freezed,
  }) {
    return _then(_TradeFormState(
      symbol: freezed == symbol
          ? _self.symbol
          : symbol // ignore: cast_nullable_to_non_nullable
              as TradingSymbol?,
      orderType: null == orderType
          ? _self.orderType
          : orderType // ignore: cast_nullable_to_non_nullable
              as OrderType,
      side: null == side
          ? _self.side
          : side // ignore: cast_nullable_to_non_nullable
              as OrderSide,
      quantity: null == quantity
          ? _self.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as double,
      limitPrice: freezed == limitPrice
          ? _self.limitPrice
          : limitPrice // ignore: cast_nullable_to_non_nullable
              as double?,
      leverage: null == leverage
          ? _self.leverage
          : leverage // ignore: cast_nullable_to_non_nullable
              as double,
      tpLevels: null == tpLevels
          ? _self._tpLevels
          : tpLevels // ignore: cast_nullable_to_non_nullable
              as List<double>,
      slPrice: freezed == slPrice
          ? _self.slPrice
          : slPrice // ignore: cast_nullable_to_non_nullable
              as double?,
      riskScore: freezed == riskScore
          ? _self.riskScore
          : riskScore // ignore: cast_nullable_to_non_nullable
              as RiskScore?,
      isSubmitting: null == isSubmitting
          ? _self.isSubmitting
          : isSubmitting // ignore: cast_nullable_to_non_nullable
              as bool,
      submitError: freezed == submitError
          ? _self.submitError
          : submitError // ignore: cast_nullable_to_non_nullable
              as String?,
      lastOrder: freezed == lastOrder
          ? _self.lastOrder
          : lastOrder // ignore: cast_nullable_to_non_nullable
              as Order?,
    ));
  }

  /// Create a copy of TradeFormState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TradingSymbolCopyWith<$Res>? get symbol {
    if (_self.symbol == null) {
      return null;
    }

    return $TradingSymbolCopyWith<$Res>(_self.symbol!, (value) {
      return _then(_self.copyWith(symbol: value));
    });
  }

  /// Create a copy of TradeFormState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $RiskScoreCopyWith<$Res>? get riskScore {
    if (_self.riskScore == null) {
      return null;
    }

    return $RiskScoreCopyWith<$Res>(_self.riskScore!, (value) {
      return _then(_self.copyWith(riskScore: value));
    });
  }

  /// Create a copy of TradeFormState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $OrderCopyWith<$Res>? get lastOrder {
    if (_self.lastOrder == null) {
      return null;
    }

    return $OrderCopyWith<$Res>(_self.lastOrder!, (value) {
      return _then(_self.copyWith(lastOrder: value));
    });
  }
}

// dart format on
