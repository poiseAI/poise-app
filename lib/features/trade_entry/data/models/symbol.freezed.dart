// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'symbol.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TradingSymbol {
  String get symbol;
  @JsonKey(readValue: _readBaseAsset)
  String get baseAsset;
  @JsonKey(readValue: _readQuoteAsset)
  String get quoteAsset;
  @JsonKey(readValue: _readExchange)
  String get exchange;
  @JsonKey(readValue: _readStatus)
  String get status;
  @JsonKey(readValue: _readLastPrice)
  double get lastPrice;
  @JsonKey(readValue: _readPriceChangePct)
  double get priceChangePct;
  @JsonKey(readValue: _readMinQty)
  double get minQty;
  @JsonKey(readValue: _readMaxLeverage)
  int get maxLeverage;
  @JsonKey(readValue: _readTickSize)
  double get tickSize;
  @JsonKey(readValue: _readQtyStep)
  double get qtyStep;
  @JsonKey(readValue: _readMinNotional)
  double get minNotional;

  /// Create a copy of TradingSymbol
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TradingSymbolCopyWith<TradingSymbol> get copyWith =>
      _$TradingSymbolCopyWithImpl<TradingSymbol>(
          this as TradingSymbol, _$identity);

  /// Serializes this TradingSymbol to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TradingSymbol &&
            (identical(other.symbol, symbol) || other.symbol == symbol) &&
            (identical(other.baseAsset, baseAsset) ||
                other.baseAsset == baseAsset) &&
            (identical(other.quoteAsset, quoteAsset) ||
                other.quoteAsset == quoteAsset) &&
            (identical(other.exchange, exchange) ||
                other.exchange == exchange) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.lastPrice, lastPrice) ||
                other.lastPrice == lastPrice) &&
            (identical(other.priceChangePct, priceChangePct) ||
                other.priceChangePct == priceChangePct) &&
            (identical(other.minQty, minQty) || other.minQty == minQty) &&
            (identical(other.maxLeverage, maxLeverage) ||
                other.maxLeverage == maxLeverage) &&
            (identical(other.tickSize, tickSize) ||
                other.tickSize == tickSize) &&
            (identical(other.qtyStep, qtyStep) || other.qtyStep == qtyStep) &&
            (identical(other.minNotional, minNotional) ||
                other.minNotional == minNotional));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      symbol,
      baseAsset,
      quoteAsset,
      exchange,
      status,
      lastPrice,
      priceChangePct,
      minQty,
      maxLeverage,
      tickSize,
      qtyStep,
      minNotional);

  @override
  String toString() {
    return 'TradingSymbol(symbol: $symbol, baseAsset: $baseAsset, quoteAsset: $quoteAsset, exchange: $exchange, status: $status, lastPrice: $lastPrice, priceChangePct: $priceChangePct, minQty: $minQty, maxLeverage: $maxLeverage, tickSize: $tickSize, qtyStep: $qtyStep, minNotional: $minNotional)';
  }
}

/// @nodoc
abstract mixin class $TradingSymbolCopyWith<$Res> {
  factory $TradingSymbolCopyWith(
          TradingSymbol value, $Res Function(TradingSymbol) _then) =
      _$TradingSymbolCopyWithImpl;
  @useResult
  $Res call(
      {String symbol,
      @JsonKey(readValue: _readBaseAsset) String baseAsset,
      @JsonKey(readValue: _readQuoteAsset) String quoteAsset,
      @JsonKey(readValue: _readExchange) String exchange,
      @JsonKey(readValue: _readStatus) String status,
      @JsonKey(readValue: _readLastPrice) double lastPrice,
      @JsonKey(readValue: _readPriceChangePct) double priceChangePct,
      @JsonKey(readValue: _readMinQty) double minQty,
      @JsonKey(readValue: _readMaxLeverage) int maxLeverage,
      @JsonKey(readValue: _readTickSize) double tickSize,
      @JsonKey(readValue: _readQtyStep) double qtyStep,
      @JsonKey(readValue: _readMinNotional) double minNotional});
}

/// @nodoc
class _$TradingSymbolCopyWithImpl<$Res>
    implements $TradingSymbolCopyWith<$Res> {
  _$TradingSymbolCopyWithImpl(this._self, this._then);

  final TradingSymbol _self;
  final $Res Function(TradingSymbol) _then;

  /// Create a copy of TradingSymbol
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? symbol = null,
    Object? baseAsset = null,
    Object? quoteAsset = null,
    Object? exchange = null,
    Object? status = null,
    Object? lastPrice = null,
    Object? priceChangePct = null,
    Object? minQty = null,
    Object? maxLeverage = null,
    Object? tickSize = null,
    Object? qtyStep = null,
    Object? minNotional = null,
  }) {
    return _then(_self.copyWith(
      symbol: null == symbol
          ? _self.symbol
          : symbol // ignore: cast_nullable_to_non_nullable
              as String,
      baseAsset: null == baseAsset
          ? _self.baseAsset
          : baseAsset // ignore: cast_nullable_to_non_nullable
              as String,
      quoteAsset: null == quoteAsset
          ? _self.quoteAsset
          : quoteAsset // ignore: cast_nullable_to_non_nullable
              as String,
      exchange: null == exchange
          ? _self.exchange
          : exchange // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      lastPrice: null == lastPrice
          ? _self.lastPrice
          : lastPrice // ignore: cast_nullable_to_non_nullable
              as double,
      priceChangePct: null == priceChangePct
          ? _self.priceChangePct
          : priceChangePct // ignore: cast_nullable_to_non_nullable
              as double,
      minQty: null == minQty
          ? _self.minQty
          : minQty // ignore: cast_nullable_to_non_nullable
              as double,
      maxLeverage: null == maxLeverage
          ? _self.maxLeverage
          : maxLeverage // ignore: cast_nullable_to_non_nullable
              as int,
      tickSize: null == tickSize
          ? _self.tickSize
          : tickSize // ignore: cast_nullable_to_non_nullable
              as double,
      qtyStep: null == qtyStep
          ? _self.qtyStep
          : qtyStep // ignore: cast_nullable_to_non_nullable
              as double,
      minNotional: null == minNotional
          ? _self.minNotional
          : minNotional // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// Adds pattern-matching-related methods to [TradingSymbol].
extension TradingSymbolPatterns on TradingSymbol {
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
    TResult Function(_TradingSymbol value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TradingSymbol() when $default != null:
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
    TResult Function(_TradingSymbol value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TradingSymbol():
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
    TResult? Function(_TradingSymbol value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TradingSymbol() when $default != null:
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
            @JsonKey(readValue: _readBaseAsset) String baseAsset,
            @JsonKey(readValue: _readQuoteAsset) String quoteAsset,
            @JsonKey(readValue: _readExchange) String exchange,
            @JsonKey(readValue: _readStatus) String status,
            @JsonKey(readValue: _readLastPrice) double lastPrice,
            @JsonKey(readValue: _readPriceChangePct) double priceChangePct,
            @JsonKey(readValue: _readMinQty) double minQty,
            @JsonKey(readValue: _readMaxLeverage) int maxLeverage,
            @JsonKey(readValue: _readTickSize) double tickSize,
            @JsonKey(readValue: _readQtyStep) double qtyStep,
            @JsonKey(readValue: _readMinNotional) double minNotional)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TradingSymbol() when $default != null:
        return $default(
            _that.symbol,
            _that.baseAsset,
            _that.quoteAsset,
            _that.exchange,
            _that.status,
            _that.lastPrice,
            _that.priceChangePct,
            _that.minQty,
            _that.maxLeverage,
            _that.tickSize,
            _that.qtyStep,
            _that.minNotional);
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
            @JsonKey(readValue: _readBaseAsset) String baseAsset,
            @JsonKey(readValue: _readQuoteAsset) String quoteAsset,
            @JsonKey(readValue: _readExchange) String exchange,
            @JsonKey(readValue: _readStatus) String status,
            @JsonKey(readValue: _readLastPrice) double lastPrice,
            @JsonKey(readValue: _readPriceChangePct) double priceChangePct,
            @JsonKey(readValue: _readMinQty) double minQty,
            @JsonKey(readValue: _readMaxLeverage) int maxLeverage,
            @JsonKey(readValue: _readTickSize) double tickSize,
            @JsonKey(readValue: _readQtyStep) double qtyStep,
            @JsonKey(readValue: _readMinNotional) double minNotional)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TradingSymbol():
        return $default(
            _that.symbol,
            _that.baseAsset,
            _that.quoteAsset,
            _that.exchange,
            _that.status,
            _that.lastPrice,
            _that.priceChangePct,
            _that.minQty,
            _that.maxLeverage,
            _that.tickSize,
            _that.qtyStep,
            _that.minNotional);
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
            @JsonKey(readValue: _readBaseAsset) String baseAsset,
            @JsonKey(readValue: _readQuoteAsset) String quoteAsset,
            @JsonKey(readValue: _readExchange) String exchange,
            @JsonKey(readValue: _readStatus) String status,
            @JsonKey(readValue: _readLastPrice) double lastPrice,
            @JsonKey(readValue: _readPriceChangePct) double priceChangePct,
            @JsonKey(readValue: _readMinQty) double minQty,
            @JsonKey(readValue: _readMaxLeverage) int maxLeverage,
            @JsonKey(readValue: _readTickSize) double tickSize,
            @JsonKey(readValue: _readQtyStep) double qtyStep,
            @JsonKey(readValue: _readMinNotional) double minNotional)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TradingSymbol() when $default != null:
        return $default(
            _that.symbol,
            _that.baseAsset,
            _that.quoteAsset,
            _that.exchange,
            _that.status,
            _that.lastPrice,
            _that.priceChangePct,
            _that.minQty,
            _that.maxLeverage,
            _that.tickSize,
            _that.qtyStep,
            _that.minNotional);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _TradingSymbol implements TradingSymbol {
  const _TradingSymbol(
      {required this.symbol,
      @JsonKey(readValue: _readBaseAsset) required this.baseAsset,
      @JsonKey(readValue: _readQuoteAsset) required this.quoteAsset,
      @JsonKey(readValue: _readExchange) this.exchange = 'bybit',
      @JsonKey(readValue: _readStatus) this.status = 'Trading',
      @JsonKey(readValue: _readLastPrice) this.lastPrice = 0.0,
      @JsonKey(readValue: _readPriceChangePct) this.priceChangePct = 0.0,
      @JsonKey(readValue: _readMinQty) this.minQty = 0.001,
      @JsonKey(readValue: _readMaxLeverage) this.maxLeverage = 100,
      @JsonKey(readValue: _readTickSize) this.tickSize = 0.0,
      @JsonKey(readValue: _readQtyStep) this.qtyStep = 0.0,
      @JsonKey(readValue: _readMinNotional) this.minNotional = 0.0});
  factory _TradingSymbol.fromJson(Map<String, dynamic> json) =>
      _$TradingSymbolFromJson(json);

  @override
  final String symbol;
  @override
  @JsonKey(readValue: _readBaseAsset)
  final String baseAsset;
  @override
  @JsonKey(readValue: _readQuoteAsset)
  final String quoteAsset;
  @override
  @JsonKey(readValue: _readExchange)
  final String exchange;
  @override
  @JsonKey(readValue: _readStatus)
  final String status;
  @override
  @JsonKey(readValue: _readLastPrice)
  final double lastPrice;
  @override
  @JsonKey(readValue: _readPriceChangePct)
  final double priceChangePct;
  @override
  @JsonKey(readValue: _readMinQty)
  final double minQty;
  @override
  @JsonKey(readValue: _readMaxLeverage)
  final int maxLeverage;
  @override
  @JsonKey(readValue: _readTickSize)
  final double tickSize;
  @override
  @JsonKey(readValue: _readQtyStep)
  final double qtyStep;
  @override
  @JsonKey(readValue: _readMinNotional)
  final double minNotional;

  /// Create a copy of TradingSymbol
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$TradingSymbolCopyWith<_TradingSymbol> get copyWith =>
      __$TradingSymbolCopyWithImpl<_TradingSymbol>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$TradingSymbolToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _TradingSymbol &&
            (identical(other.symbol, symbol) || other.symbol == symbol) &&
            (identical(other.baseAsset, baseAsset) ||
                other.baseAsset == baseAsset) &&
            (identical(other.quoteAsset, quoteAsset) ||
                other.quoteAsset == quoteAsset) &&
            (identical(other.exchange, exchange) ||
                other.exchange == exchange) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.lastPrice, lastPrice) ||
                other.lastPrice == lastPrice) &&
            (identical(other.priceChangePct, priceChangePct) ||
                other.priceChangePct == priceChangePct) &&
            (identical(other.minQty, minQty) || other.minQty == minQty) &&
            (identical(other.maxLeverage, maxLeverage) ||
                other.maxLeverage == maxLeverage) &&
            (identical(other.tickSize, tickSize) ||
                other.tickSize == tickSize) &&
            (identical(other.qtyStep, qtyStep) || other.qtyStep == qtyStep) &&
            (identical(other.minNotional, minNotional) ||
                other.minNotional == minNotional));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      symbol,
      baseAsset,
      quoteAsset,
      exchange,
      status,
      lastPrice,
      priceChangePct,
      minQty,
      maxLeverage,
      tickSize,
      qtyStep,
      minNotional);

  @override
  String toString() {
    return 'TradingSymbol(symbol: $symbol, baseAsset: $baseAsset, quoteAsset: $quoteAsset, exchange: $exchange, status: $status, lastPrice: $lastPrice, priceChangePct: $priceChangePct, minQty: $minQty, maxLeverage: $maxLeverage, tickSize: $tickSize, qtyStep: $qtyStep, minNotional: $minNotional)';
  }
}

/// @nodoc
abstract mixin class _$TradingSymbolCopyWith<$Res>
    implements $TradingSymbolCopyWith<$Res> {
  factory _$TradingSymbolCopyWith(
          _TradingSymbol value, $Res Function(_TradingSymbol) _then) =
      __$TradingSymbolCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String symbol,
      @JsonKey(readValue: _readBaseAsset) String baseAsset,
      @JsonKey(readValue: _readQuoteAsset) String quoteAsset,
      @JsonKey(readValue: _readExchange) String exchange,
      @JsonKey(readValue: _readStatus) String status,
      @JsonKey(readValue: _readLastPrice) double lastPrice,
      @JsonKey(readValue: _readPriceChangePct) double priceChangePct,
      @JsonKey(readValue: _readMinQty) double minQty,
      @JsonKey(readValue: _readMaxLeverage) int maxLeverage,
      @JsonKey(readValue: _readTickSize) double tickSize,
      @JsonKey(readValue: _readQtyStep) double qtyStep,
      @JsonKey(readValue: _readMinNotional) double minNotional});
}

/// @nodoc
class __$TradingSymbolCopyWithImpl<$Res>
    implements _$TradingSymbolCopyWith<$Res> {
  __$TradingSymbolCopyWithImpl(this._self, this._then);

  final _TradingSymbol _self;
  final $Res Function(_TradingSymbol) _then;

  /// Create a copy of TradingSymbol
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? symbol = null,
    Object? baseAsset = null,
    Object? quoteAsset = null,
    Object? exchange = null,
    Object? status = null,
    Object? lastPrice = null,
    Object? priceChangePct = null,
    Object? minQty = null,
    Object? maxLeverage = null,
    Object? tickSize = null,
    Object? qtyStep = null,
    Object? minNotional = null,
  }) {
    return _then(_TradingSymbol(
      symbol: null == symbol
          ? _self.symbol
          : symbol // ignore: cast_nullable_to_non_nullable
              as String,
      baseAsset: null == baseAsset
          ? _self.baseAsset
          : baseAsset // ignore: cast_nullable_to_non_nullable
              as String,
      quoteAsset: null == quoteAsset
          ? _self.quoteAsset
          : quoteAsset // ignore: cast_nullable_to_non_nullable
              as String,
      exchange: null == exchange
          ? _self.exchange
          : exchange // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      lastPrice: null == lastPrice
          ? _self.lastPrice
          : lastPrice // ignore: cast_nullable_to_non_nullable
              as double,
      priceChangePct: null == priceChangePct
          ? _self.priceChangePct
          : priceChangePct // ignore: cast_nullable_to_non_nullable
              as double,
      minQty: null == minQty
          ? _self.minQty
          : minQty // ignore: cast_nullable_to_non_nullable
              as double,
      maxLeverage: null == maxLeverage
          ? _self.maxLeverage
          : maxLeverage // ignore: cast_nullable_to_non_nullable
              as int,
      tickSize: null == tickSize
          ? _self.tickSize
          : tickSize // ignore: cast_nullable_to_non_nullable
              as double,
      qtyStep: null == qtyStep
          ? _self.qtyStep
          : qtyStep // ignore: cast_nullable_to_non_nullable
              as double,
      minNotional: null == minNotional
          ? _self.minNotional
          : minNotional // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

// dart format on
