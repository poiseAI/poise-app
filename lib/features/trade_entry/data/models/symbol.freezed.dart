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
  String get exchange;
  @JsonKey(name: 'last_price')
  double get lastPrice;
  @JsonKey(name: 'price_change_pct')
  double get priceChangePct;
  @JsonKey(name: 'min_qty')
  double get minQty;
  @JsonKey(name: 'max_leverage')
  int get maxLeverage;

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
            (identical(other.lastPrice, lastPrice) ||
                other.lastPrice == lastPrice) &&
            (identical(other.priceChangePct, priceChangePct) ||
                other.priceChangePct == priceChangePct) &&
            (identical(other.minQty, minQty) || other.minQty == minQty) &&
            (identical(other.maxLeverage, maxLeverage) ||
                other.maxLeverage == maxLeverage));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, symbol, baseAsset, quoteAsset,
      exchange, lastPrice, priceChangePct, minQty, maxLeverage);

  @override
  String toString() {
    return 'TradingSymbol(symbol: $symbol, baseAsset: $baseAsset, quoteAsset: $quoteAsset, exchange: $exchange, lastPrice: $lastPrice, priceChangePct: $priceChangePct, minQty: $minQty, maxLeverage: $maxLeverage)';
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
      String exchange,
      @JsonKey(name: 'last_price') double lastPrice,
      @JsonKey(name: 'price_change_pct') double priceChangePct,
      @JsonKey(name: 'min_qty') double minQty,
      @JsonKey(name: 'max_leverage') int maxLeverage});
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
    Object? lastPrice = null,
    Object? priceChangePct = null,
    Object? minQty = null,
    Object? maxLeverage = null,
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
            String exchange,
            @JsonKey(name: 'last_price') double lastPrice,
            @JsonKey(name: 'price_change_pct') double priceChangePct,
            @JsonKey(name: 'min_qty') double minQty,
            @JsonKey(name: 'max_leverage') int maxLeverage)?
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
            _that.lastPrice,
            _that.priceChangePct,
            _that.minQty,
            _that.maxLeverage);
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
            String exchange,
            @JsonKey(name: 'last_price') double lastPrice,
            @JsonKey(name: 'price_change_pct') double priceChangePct,
            @JsonKey(name: 'min_qty') double minQty,
            @JsonKey(name: 'max_leverage') int maxLeverage)
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
            _that.lastPrice,
            _that.priceChangePct,
            _that.minQty,
            _that.maxLeverage);
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
            String exchange,
            @JsonKey(name: 'last_price') double lastPrice,
            @JsonKey(name: 'price_change_pct') double priceChangePct,
            @JsonKey(name: 'min_qty') double minQty,
            @JsonKey(name: 'max_leverage') int maxLeverage)?
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
            _that.lastPrice,
            _that.priceChangePct,
            _that.minQty,
            _that.maxLeverage);
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
      this.exchange = 'bybit',
      @JsonKey(name: 'last_price') this.lastPrice = 0.0,
      @JsonKey(name: 'price_change_pct') this.priceChangePct = 0.0,
      @JsonKey(name: 'min_qty') this.minQty = 0.001,
      @JsonKey(name: 'max_leverage') this.maxLeverage = 100});
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
  @JsonKey()
  final String exchange;
  @override
  @JsonKey(name: 'last_price')
  final double lastPrice;
  @override
  @JsonKey(name: 'price_change_pct')
  final double priceChangePct;
  @override
  @JsonKey(name: 'min_qty')
  final double minQty;
  @override
  @JsonKey(name: 'max_leverage')
  final int maxLeverage;

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
            (identical(other.lastPrice, lastPrice) ||
                other.lastPrice == lastPrice) &&
            (identical(other.priceChangePct, priceChangePct) ||
                other.priceChangePct == priceChangePct) &&
            (identical(other.minQty, minQty) || other.minQty == minQty) &&
            (identical(other.maxLeverage, maxLeverage) ||
                other.maxLeverage == maxLeverage));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, symbol, baseAsset, quoteAsset,
      exchange, lastPrice, priceChangePct, minQty, maxLeverage);

  @override
  String toString() {
    return 'TradingSymbol(symbol: $symbol, baseAsset: $baseAsset, quoteAsset: $quoteAsset, exchange: $exchange, lastPrice: $lastPrice, priceChangePct: $priceChangePct, minQty: $minQty, maxLeverage: $maxLeverage)';
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
      String exchange,
      @JsonKey(name: 'last_price') double lastPrice,
      @JsonKey(name: 'price_change_pct') double priceChangePct,
      @JsonKey(name: 'min_qty') double minQty,
      @JsonKey(name: 'max_leverage') int maxLeverage});
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
    Object? lastPrice = null,
    Object? priceChangePct = null,
    Object? minQty = null,
    Object? maxLeverage = null,
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
    ));
  }
}

// dart format on
