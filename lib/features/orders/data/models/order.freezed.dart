// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Order {
  String get id;
  String get symbol;
  String get side;
  String get status;
  @JsonKey(name: 'order_type')
  String get orderType;
  double get quantity;
  double? get price;
  double get leverage;
  @JsonKey(name: 'tp_levels')
  List<double> get tpLevels;
  @JsonKey(name: 'sl_price', readValue: _readSlPrice)
  double? get slPrice;
  @JsonKey(name: 'created_at')
  String get createdAt;

  /// Create a copy of Order
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $OrderCopyWith<Order> get copyWith =>
      _$OrderCopyWithImpl<Order>(this as Order, _$identity);

  /// Serializes this Order to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Order &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.symbol, symbol) || other.symbol == symbol) &&
            (identical(other.side, side) || other.side == side) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.orderType, orderType) ||
                other.orderType == orderType) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.leverage, leverage) ||
                other.leverage == leverage) &&
            const DeepCollectionEquality().equals(other.tpLevels, tpLevels) &&
            (identical(other.slPrice, slPrice) || other.slPrice == slPrice) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      symbol,
      side,
      status,
      orderType,
      quantity,
      price,
      leverage,
      const DeepCollectionEquality().hash(tpLevels),
      slPrice,
      createdAt);

  @override
  String toString() {
    return 'Order(id: $id, symbol: $symbol, side: $side, status: $status, orderType: $orderType, quantity: $quantity, price: $price, leverage: $leverage, tpLevels: $tpLevels, slPrice: $slPrice, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class $OrderCopyWith<$Res> {
  factory $OrderCopyWith(Order value, $Res Function(Order) _then) =
      _$OrderCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String symbol,
      String side,
      String status,
      @JsonKey(name: 'order_type') String orderType,
      double quantity,
      double? price,
      double leverage,
      @JsonKey(name: 'tp_levels') List<double> tpLevels,
      @JsonKey(name: 'sl_price', readValue: _readSlPrice) double? slPrice,
      @JsonKey(name: 'created_at') String createdAt});
}

/// @nodoc
class _$OrderCopyWithImpl<$Res> implements $OrderCopyWith<$Res> {
  _$OrderCopyWithImpl(this._self, this._then);

  final Order _self;
  final $Res Function(Order) _then;

  /// Create a copy of Order
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? symbol = null,
    Object? side = null,
    Object? status = null,
    Object? orderType = null,
    Object? quantity = null,
    Object? price = freezed,
    Object? leverage = null,
    Object? tpLevels = null,
    Object? slPrice = freezed,
    Object? createdAt = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      symbol: null == symbol
          ? _self.symbol
          : symbol // ignore: cast_nullable_to_non_nullable
              as String,
      side: null == side
          ? _self.side
          : side // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      orderType: null == orderType
          ? _self.orderType
          : orderType // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _self.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as double,
      price: freezed == price
          ? _self.price
          : price // ignore: cast_nullable_to_non_nullable
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
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// Adds pattern-matching-related methods to [Order].
extension OrderPatterns on Order {
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
    TResult Function(_Order value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Order() when $default != null:
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
    TResult Function(_Order value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Order():
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
    TResult? Function(_Order value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Order() when $default != null:
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
            String symbol,
            String side,
            String status,
            @JsonKey(name: 'order_type') String orderType,
            double quantity,
            double? price,
            double leverage,
            @JsonKey(name: 'tp_levels') List<double> tpLevels,
            @JsonKey(name: 'sl_price', readValue: _readSlPrice) double? slPrice,
            @JsonKey(name: 'created_at') String createdAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Order() when $default != null:
        return $default(
            _that.id,
            _that.symbol,
            _that.side,
            _that.status,
            _that.orderType,
            _that.quantity,
            _that.price,
            _that.leverage,
            _that.tpLevels,
            _that.slPrice,
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
            String symbol,
            String side,
            String status,
            @JsonKey(name: 'order_type') String orderType,
            double quantity,
            double? price,
            double leverage,
            @JsonKey(name: 'tp_levels') List<double> tpLevels,
            @JsonKey(name: 'sl_price', readValue: _readSlPrice) double? slPrice,
            @JsonKey(name: 'created_at') String createdAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Order():
        return $default(
            _that.id,
            _that.symbol,
            _that.side,
            _that.status,
            _that.orderType,
            _that.quantity,
            _that.price,
            _that.leverage,
            _that.tpLevels,
            _that.slPrice,
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
            String symbol,
            String side,
            String status,
            @JsonKey(name: 'order_type') String orderType,
            double quantity,
            double? price,
            double leverage,
            @JsonKey(name: 'tp_levels') List<double> tpLevels,
            @JsonKey(name: 'sl_price', readValue: _readSlPrice) double? slPrice,
            @JsonKey(name: 'created_at') String createdAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Order() when $default != null:
        return $default(
            _that.id,
            _that.symbol,
            _that.side,
            _that.status,
            _that.orderType,
            _that.quantity,
            _that.price,
            _that.leverage,
            _that.tpLevels,
            _that.slPrice,
            _that.createdAt);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _Order implements Order {
  const _Order(
      {required this.id,
      required this.symbol,
      required this.side,
      required this.status,
      @JsonKey(name: 'order_type') required this.orderType,
      required this.quantity,
      this.price,
      this.leverage = 1.0,
      @JsonKey(name: 'tp_levels') final List<double> tpLevels = const [],
      @JsonKey(name: 'sl_price', readValue: _readSlPrice) this.slPrice,
      @JsonKey(name: 'created_at') required this.createdAt})
      : _tpLevels = tpLevels;
  factory _Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);

  @override
  final String id;
  @override
  final String symbol;
  @override
  final String side;
  @override
  final String status;
  @override
  @JsonKey(name: 'order_type')
  final String orderType;
  @override
  final double quantity;
  @override
  final double? price;
  @override
  @JsonKey()
  final double leverage;
  final List<double> _tpLevels;
  @override
  @JsonKey(name: 'tp_levels')
  List<double> get tpLevels {
    if (_tpLevels is EqualUnmodifiableListView) return _tpLevels;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tpLevels);
  }

  @override
  @JsonKey(name: 'sl_price', readValue: _readSlPrice)
  final double? slPrice;
  @override
  @JsonKey(name: 'created_at')
  final String createdAt;

  /// Create a copy of Order
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$OrderCopyWith<_Order> get copyWith =>
      __$OrderCopyWithImpl<_Order>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$OrderToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Order &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.symbol, symbol) || other.symbol == symbol) &&
            (identical(other.side, side) || other.side == side) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.orderType, orderType) ||
                other.orderType == orderType) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.leverage, leverage) ||
                other.leverage == leverage) &&
            const DeepCollectionEquality().equals(other._tpLevels, _tpLevels) &&
            (identical(other.slPrice, slPrice) || other.slPrice == slPrice) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      symbol,
      side,
      status,
      orderType,
      quantity,
      price,
      leverage,
      const DeepCollectionEquality().hash(_tpLevels),
      slPrice,
      createdAt);

  @override
  String toString() {
    return 'Order(id: $id, symbol: $symbol, side: $side, status: $status, orderType: $orderType, quantity: $quantity, price: $price, leverage: $leverage, tpLevels: $tpLevels, slPrice: $slPrice, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class _$OrderCopyWith<$Res> implements $OrderCopyWith<$Res> {
  factory _$OrderCopyWith(_Order value, $Res Function(_Order) _then) =
      __$OrderCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String symbol,
      String side,
      String status,
      @JsonKey(name: 'order_type') String orderType,
      double quantity,
      double? price,
      double leverage,
      @JsonKey(name: 'tp_levels') List<double> tpLevels,
      @JsonKey(name: 'sl_price', readValue: _readSlPrice) double? slPrice,
      @JsonKey(name: 'created_at') String createdAt});
}

/// @nodoc
class __$OrderCopyWithImpl<$Res> implements _$OrderCopyWith<$Res> {
  __$OrderCopyWithImpl(this._self, this._then);

  final _Order _self;
  final $Res Function(_Order) _then;

  /// Create a copy of Order
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? symbol = null,
    Object? side = null,
    Object? status = null,
    Object? orderType = null,
    Object? quantity = null,
    Object? price = freezed,
    Object? leverage = null,
    Object? tpLevels = null,
    Object? slPrice = freezed,
    Object? createdAt = null,
  }) {
    return _then(_Order(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      symbol: null == symbol
          ? _self.symbol
          : symbol // ignore: cast_nullable_to_non_nullable
              as String,
      side: null == side
          ? _self.side
          : side // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      orderType: null == orderType
          ? _self.orderType
          : orderType // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _self.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as double,
      price: freezed == price
          ? _self.price
          : price // ignore: cast_nullable_to_non_nullable
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
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
mixin _$PlaceOrderRequest {
  String get exchange;
  String get symbol;
  String get side;
  @JsonKey(name: 'order_type')
  String get orderType;
  double get quantity;
  double? get price;
  @JsonKey(name: 'stop_price')
  double? get stopPrice;
  double get leverage;
  @JsonKey(name: 'tp_levels')
  List<double> get tpLevels;
  @JsonKey(name: 'sl_price')
  double? get slPrice;
  @JsonKey(name: 'immediate_tp')
  double? get immediateTp;
  @JsonKey(name: 'immediate_sl')
  double? get immediateSl;

  /// Create a copy of PlaceOrderRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PlaceOrderRequestCopyWith<PlaceOrderRequest> get copyWith =>
      _$PlaceOrderRequestCopyWithImpl<PlaceOrderRequest>(
          this as PlaceOrderRequest, _$identity);

  /// Serializes this PlaceOrderRequest to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PlaceOrderRequest &&
            (identical(other.exchange, exchange) ||
                other.exchange == exchange) &&
            (identical(other.symbol, symbol) || other.symbol == symbol) &&
            (identical(other.side, side) || other.side == side) &&
            (identical(other.orderType, orderType) ||
                other.orderType == orderType) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.stopPrice, stopPrice) ||
                other.stopPrice == stopPrice) &&
            (identical(other.leverage, leverage) ||
                other.leverage == leverage) &&
            const DeepCollectionEquality().equals(other.tpLevels, tpLevels) &&
            (identical(other.slPrice, slPrice) || other.slPrice == slPrice) &&
            (identical(other.immediateTp, immediateTp) ||
                other.immediateTp == immediateTp) &&
            (identical(other.immediateSl, immediateSl) ||
                other.immediateSl == immediateSl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      exchange,
      symbol,
      side,
      orderType,
      quantity,
      price,
      stopPrice,
      leverage,
      const DeepCollectionEquality().hash(tpLevels),
      slPrice,
      immediateTp,
      immediateSl);

  @override
  String toString() {
    return 'PlaceOrderRequest(exchange: $exchange, symbol: $symbol, side: $side, orderType: $orderType, quantity: $quantity, price: $price, stopPrice: $stopPrice, leverage: $leverage, tpLevels: $tpLevels, slPrice: $slPrice, immediateTp: $immediateTp, immediateSl: $immediateSl)';
  }
}

/// @nodoc
abstract mixin class $PlaceOrderRequestCopyWith<$Res> {
  factory $PlaceOrderRequestCopyWith(
          PlaceOrderRequest value, $Res Function(PlaceOrderRequest) _then) =
      _$PlaceOrderRequestCopyWithImpl;
  @useResult
  $Res call(
      {String exchange,
      String symbol,
      String side,
      @JsonKey(name: 'order_type') String orderType,
      double quantity,
      double? price,
      @JsonKey(name: 'stop_price') double? stopPrice,
      double leverage,
      @JsonKey(name: 'tp_levels') List<double> tpLevels,
      @JsonKey(name: 'sl_price') double? slPrice,
      @JsonKey(name: 'immediate_tp') double? immediateTp,
      @JsonKey(name: 'immediate_sl') double? immediateSl});
}

/// @nodoc
class _$PlaceOrderRequestCopyWithImpl<$Res>
    implements $PlaceOrderRequestCopyWith<$Res> {
  _$PlaceOrderRequestCopyWithImpl(this._self, this._then);

  final PlaceOrderRequest _self;
  final $Res Function(PlaceOrderRequest) _then;

  /// Create a copy of PlaceOrderRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? exchange = null,
    Object? symbol = null,
    Object? side = null,
    Object? orderType = null,
    Object? quantity = null,
    Object? price = freezed,
    Object? stopPrice = freezed,
    Object? leverage = null,
    Object? tpLevels = null,
    Object? slPrice = freezed,
    Object? immediateTp = freezed,
    Object? immediateSl = freezed,
  }) {
    return _then(_self.copyWith(
      exchange: null == exchange
          ? _self.exchange
          : exchange // ignore: cast_nullable_to_non_nullable
              as String,
      symbol: null == symbol
          ? _self.symbol
          : symbol // ignore: cast_nullable_to_non_nullable
              as String,
      side: null == side
          ? _self.side
          : side // ignore: cast_nullable_to_non_nullable
              as String,
      orderType: null == orderType
          ? _self.orderType
          : orderType // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _self.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as double,
      price: freezed == price
          ? _self.price
          : price // ignore: cast_nullable_to_non_nullable
              as double?,
      stopPrice: freezed == stopPrice
          ? _self.stopPrice
          : stopPrice // ignore: cast_nullable_to_non_nullable
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
      immediateTp: freezed == immediateTp
          ? _self.immediateTp
          : immediateTp // ignore: cast_nullable_to_non_nullable
              as double?,
      immediateSl: freezed == immediateSl
          ? _self.immediateSl
          : immediateSl // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// Adds pattern-matching-related methods to [PlaceOrderRequest].
extension PlaceOrderRequestPatterns on PlaceOrderRequest {
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
    TResult Function(_PlaceOrderRequest value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PlaceOrderRequest() when $default != null:
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
    TResult Function(_PlaceOrderRequest value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PlaceOrderRequest():
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
    TResult? Function(_PlaceOrderRequest value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PlaceOrderRequest() when $default != null:
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
            String exchange,
            String symbol,
            String side,
            @JsonKey(name: 'order_type') String orderType,
            double quantity,
            double? price,
            @JsonKey(name: 'stop_price') double? stopPrice,
            double leverage,
            @JsonKey(name: 'tp_levels') List<double> tpLevels,
            @JsonKey(name: 'sl_price') double? slPrice,
            @JsonKey(name: 'immediate_tp') double? immediateTp,
            @JsonKey(name: 'immediate_sl') double? immediateSl)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PlaceOrderRequest() when $default != null:
        return $default(
            _that.exchange,
            _that.symbol,
            _that.side,
            _that.orderType,
            _that.quantity,
            _that.price,
            _that.stopPrice,
            _that.leverage,
            _that.tpLevels,
            _that.slPrice,
            _that.immediateTp,
            _that.immediateSl);
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
            String exchange,
            String symbol,
            String side,
            @JsonKey(name: 'order_type') String orderType,
            double quantity,
            double? price,
            @JsonKey(name: 'stop_price') double? stopPrice,
            double leverage,
            @JsonKey(name: 'tp_levels') List<double> tpLevels,
            @JsonKey(name: 'sl_price') double? slPrice,
            @JsonKey(name: 'immediate_tp') double? immediateTp,
            @JsonKey(name: 'immediate_sl') double? immediateSl)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PlaceOrderRequest():
        return $default(
            _that.exchange,
            _that.symbol,
            _that.side,
            _that.orderType,
            _that.quantity,
            _that.price,
            _that.stopPrice,
            _that.leverage,
            _that.tpLevels,
            _that.slPrice,
            _that.immediateTp,
            _that.immediateSl);
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
            String exchange,
            String symbol,
            String side,
            @JsonKey(name: 'order_type') String orderType,
            double quantity,
            double? price,
            @JsonKey(name: 'stop_price') double? stopPrice,
            double leverage,
            @JsonKey(name: 'tp_levels') List<double> tpLevels,
            @JsonKey(name: 'sl_price') double? slPrice,
            @JsonKey(name: 'immediate_tp') double? immediateTp,
            @JsonKey(name: 'immediate_sl') double? immediateSl)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PlaceOrderRequest() when $default != null:
        return $default(
            _that.exchange,
            _that.symbol,
            _that.side,
            _that.orderType,
            _that.quantity,
            _that.price,
            _that.stopPrice,
            _that.leverage,
            _that.tpLevels,
            _that.slPrice,
            _that.immediateTp,
            _that.immediateSl);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _PlaceOrderRequest implements PlaceOrderRequest {
  const _PlaceOrderRequest(
      {this.exchange = 'bybit',
      required this.symbol,
      required this.side,
      @JsonKey(name: 'order_type') required this.orderType,
      required this.quantity,
      this.price,
      @JsonKey(name: 'stop_price') this.stopPrice,
      required this.leverage,
      @JsonKey(name: 'tp_levels') final List<double> tpLevels = const [],
      @JsonKey(name: 'sl_price') this.slPrice,
      @JsonKey(name: 'immediate_tp') this.immediateTp,
      @JsonKey(name: 'immediate_sl') this.immediateSl})
      : _tpLevels = tpLevels;
  factory _PlaceOrderRequest.fromJson(Map<String, dynamic> json) =>
      _$PlaceOrderRequestFromJson(json);

  @override
  @JsonKey()
  final String exchange;
  @override
  final String symbol;
  @override
  final String side;
  @override
  @JsonKey(name: 'order_type')
  final String orderType;
  @override
  final double quantity;
  @override
  final double? price;
  @override
  @JsonKey(name: 'stop_price')
  final double? stopPrice;
  @override
  final double leverage;
  final List<double> _tpLevels;
  @override
  @JsonKey(name: 'tp_levels')
  List<double> get tpLevels {
    if (_tpLevels is EqualUnmodifiableListView) return _tpLevels;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tpLevels);
  }

  @override
  @JsonKey(name: 'sl_price')
  final double? slPrice;
  @override
  @JsonKey(name: 'immediate_tp')
  final double? immediateTp;
  @override
  @JsonKey(name: 'immediate_sl')
  final double? immediateSl;

  /// Create a copy of PlaceOrderRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$PlaceOrderRequestCopyWith<_PlaceOrderRequest> get copyWith =>
      __$PlaceOrderRequestCopyWithImpl<_PlaceOrderRequest>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$PlaceOrderRequestToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _PlaceOrderRequest &&
            (identical(other.exchange, exchange) ||
                other.exchange == exchange) &&
            (identical(other.symbol, symbol) || other.symbol == symbol) &&
            (identical(other.side, side) || other.side == side) &&
            (identical(other.orderType, orderType) ||
                other.orderType == orderType) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.stopPrice, stopPrice) ||
                other.stopPrice == stopPrice) &&
            (identical(other.leverage, leverage) ||
                other.leverage == leverage) &&
            const DeepCollectionEquality().equals(other._tpLevels, _tpLevels) &&
            (identical(other.slPrice, slPrice) || other.slPrice == slPrice) &&
            (identical(other.immediateTp, immediateTp) ||
                other.immediateTp == immediateTp) &&
            (identical(other.immediateSl, immediateSl) ||
                other.immediateSl == immediateSl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      exchange,
      symbol,
      side,
      orderType,
      quantity,
      price,
      stopPrice,
      leverage,
      const DeepCollectionEquality().hash(_tpLevels),
      slPrice,
      immediateTp,
      immediateSl);

  @override
  String toString() {
    return 'PlaceOrderRequest(exchange: $exchange, symbol: $symbol, side: $side, orderType: $orderType, quantity: $quantity, price: $price, stopPrice: $stopPrice, leverage: $leverage, tpLevels: $tpLevels, slPrice: $slPrice, immediateTp: $immediateTp, immediateSl: $immediateSl)';
  }
}

/// @nodoc
abstract mixin class _$PlaceOrderRequestCopyWith<$Res>
    implements $PlaceOrderRequestCopyWith<$Res> {
  factory _$PlaceOrderRequestCopyWith(
          _PlaceOrderRequest value, $Res Function(_PlaceOrderRequest) _then) =
      __$PlaceOrderRequestCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String exchange,
      String symbol,
      String side,
      @JsonKey(name: 'order_type') String orderType,
      double quantity,
      double? price,
      @JsonKey(name: 'stop_price') double? stopPrice,
      double leverage,
      @JsonKey(name: 'tp_levels') List<double> tpLevels,
      @JsonKey(name: 'sl_price') double? slPrice,
      @JsonKey(name: 'immediate_tp') double? immediateTp,
      @JsonKey(name: 'immediate_sl') double? immediateSl});
}

/// @nodoc
class __$PlaceOrderRequestCopyWithImpl<$Res>
    implements _$PlaceOrderRequestCopyWith<$Res> {
  __$PlaceOrderRequestCopyWithImpl(this._self, this._then);

  final _PlaceOrderRequest _self;
  final $Res Function(_PlaceOrderRequest) _then;

  /// Create a copy of PlaceOrderRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? exchange = null,
    Object? symbol = null,
    Object? side = null,
    Object? orderType = null,
    Object? quantity = null,
    Object? price = freezed,
    Object? stopPrice = freezed,
    Object? leverage = null,
    Object? tpLevels = null,
    Object? slPrice = freezed,
    Object? immediateTp = freezed,
    Object? immediateSl = freezed,
  }) {
    return _then(_PlaceOrderRequest(
      exchange: null == exchange
          ? _self.exchange
          : exchange // ignore: cast_nullable_to_non_nullable
              as String,
      symbol: null == symbol
          ? _self.symbol
          : symbol // ignore: cast_nullable_to_non_nullable
              as String,
      side: null == side
          ? _self.side
          : side // ignore: cast_nullable_to_non_nullable
              as String,
      orderType: null == orderType
          ? _self.orderType
          : orderType // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _self.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as double,
      price: freezed == price
          ? _self.price
          : price // ignore: cast_nullable_to_non_nullable
              as double?,
      stopPrice: freezed == stopPrice
          ? _self.stopPrice
          : stopPrice // ignore: cast_nullable_to_non_nullable
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
      immediateTp: freezed == immediateTp
          ? _self.immediateTp
          : immediateTp // ignore: cast_nullable_to_non_nullable
              as double?,
      immediateSl: freezed == immediateSl
          ? _self.immediateSl
          : immediateSl // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

// dart format on
