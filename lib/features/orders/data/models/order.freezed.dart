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
  @JsonKey(readValue: _readId)
  String get id;
  @JsonKey(readValue: _readSymbol)
  String get symbol;
  @JsonKey(readValue: _readSide)
  String get side;
  @JsonKey(readValue: _readStatus)
  String get status;
  @JsonKey(name: 'order_type', readValue: _readOrderType)
  String get orderType;
  @JsonKey(readValue: _readQuantity)
  double get quantity;
  @JsonKey(readValue: _readSource)
  String get source;
  @JsonKey(readValue: _readExchange)
  String get exchange;
  @JsonKey(name: 'exchange_order_id', readValue: _readExchangeOrderId)
  String? get exchangeOrderId;
  @JsonKey(name: 'entry_price', readValue: _readEntryPrice)
  double? get entryPrice;
  @JsonKey(name: 'mark_price', readValue: _readMarkPrice)
  double? get markPrice;
  @JsonKey(name: 'liquidation_price', readValue: _readLiquidationPrice)
  double? get liquidationPrice;
  @JsonKey(name: 'margin_used', readValue: _readMarginUsed)
  double? get marginUsed;
  @JsonKey(name: 'realized_pnl', readValue: _readRealizedPnl)
  double? get realizedPnl;
  @JsonKey(name: 'unrealized_pnl', readValue: _readUnrealizedPnl)
  double? get unrealizedPnl;
  @JsonKey(name: 'remaining_quantity', readValue: _readRemainingQuantity)
  double? get remainingQuantity;
  @JsonKey(name: 'sync_status', readValue: _readSyncStatus)
  String? get syncStatus;
  @JsonKey(name: 'last_synced_at', readValue: _readLastSyncedAt)
  String? get lastSyncedAt;
  @JsonKey(name: 'closed_at', readValue: _readClosedAt)
  String? get closedAt;
  @JsonKey(readValue: _readPrice)
  double? get price;
  @JsonKey(readValue: _readLeverage)
  double get leverage;
  @JsonKey(name: 'tp_levels', readValue: _readTpLevels)
  List<double> get tpLevels;
  @JsonKey(name: 'sl_price', readValue: _readSlPrice)
  double? get slPrice;
  @JsonKey(
      name: 'auto_cancel_after_minutes', readValue: _readAutoCancelAfterMinutes)
  int? get autoCancelAfterMinutes;
  @JsonKey(name: 'expires_at', readValue: _readExpiresAt)
  String? get expiresAt;
  @JsonKey(name: 'auto_cancelled_at', readValue: _readAutoCancelledAt)
  String? get autoCancelledAt;
  @JsonKey(name: 'auto_cancel_reason', readValue: _readAutoCancelReason)
  String? get autoCancelReason;
  @JsonKey(name: 'created_at', readValue: _readCreatedAt)
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
            (identical(other.source, source) || other.source == source) &&
            (identical(other.exchange, exchange) ||
                other.exchange == exchange) &&
            (identical(other.exchangeOrderId, exchangeOrderId) ||
                other.exchangeOrderId == exchangeOrderId) &&
            (identical(other.entryPrice, entryPrice) ||
                other.entryPrice == entryPrice) &&
            (identical(other.markPrice, markPrice) ||
                other.markPrice == markPrice) &&
            (identical(other.liquidationPrice, liquidationPrice) ||
                other.liquidationPrice == liquidationPrice) &&
            (identical(other.marginUsed, marginUsed) ||
                other.marginUsed == marginUsed) &&
            (identical(other.realizedPnl, realizedPnl) ||
                other.realizedPnl == realizedPnl) &&
            (identical(other.unrealizedPnl, unrealizedPnl) ||
                other.unrealizedPnl == unrealizedPnl) &&
            (identical(other.remainingQuantity, remainingQuantity) ||
                other.remainingQuantity == remainingQuantity) &&
            (identical(other.syncStatus, syncStatus) ||
                other.syncStatus == syncStatus) &&
            (identical(other.lastSyncedAt, lastSyncedAt) ||
                other.lastSyncedAt == lastSyncedAt) &&
            (identical(other.closedAt, closedAt) ||
                other.closedAt == closedAt) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.leverage, leverage) ||
                other.leverage == leverage) &&
            const DeepCollectionEquality().equals(other.tpLevels, tpLevels) &&
            (identical(other.slPrice, slPrice) || other.slPrice == slPrice) &&
            (identical(other.autoCancelAfterMinutes, autoCancelAfterMinutes) ||
                other.autoCancelAfterMinutes == autoCancelAfterMinutes) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt) &&
            (identical(other.autoCancelledAt, autoCancelledAt) ||
                other.autoCancelledAt == autoCancelledAt) &&
            (identical(other.autoCancelReason, autoCancelReason) ||
                other.autoCancelReason == autoCancelReason) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        symbol,
        side,
        status,
        orderType,
        quantity,
        source,
        exchange,
        exchangeOrderId,
        entryPrice,
        markPrice,
        liquidationPrice,
        marginUsed,
        realizedPnl,
        unrealizedPnl,
        remainingQuantity,
        syncStatus,
        lastSyncedAt,
        closedAt,
        price,
        leverage,
        const DeepCollectionEquality().hash(tpLevels),
        slPrice,
        autoCancelAfterMinutes,
        expiresAt,
        autoCancelledAt,
        autoCancelReason,
        createdAt
      ]);

  @override
  String toString() {
    return 'Order(id: $id, symbol: $symbol, side: $side, status: $status, orderType: $orderType, quantity: $quantity, source: $source, exchange: $exchange, exchangeOrderId: $exchangeOrderId, entryPrice: $entryPrice, markPrice: $markPrice, liquidationPrice: $liquidationPrice, marginUsed: $marginUsed, realizedPnl: $realizedPnl, unrealizedPnl: $unrealizedPnl, remainingQuantity: $remainingQuantity, syncStatus: $syncStatus, lastSyncedAt: $lastSyncedAt, closedAt: $closedAt, price: $price, leverage: $leverage, tpLevels: $tpLevels, slPrice: $slPrice, autoCancelAfterMinutes: $autoCancelAfterMinutes, expiresAt: $expiresAt, autoCancelledAt: $autoCancelledAt, autoCancelReason: $autoCancelReason, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class $OrderCopyWith<$Res> {
  factory $OrderCopyWith(Order value, $Res Function(Order) _then) =
      _$OrderCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(readValue: _readId) String id,
      @JsonKey(readValue: _readSymbol) String symbol,
      @JsonKey(readValue: _readSide) String side,
      @JsonKey(readValue: _readStatus) String status,
      @JsonKey(name: 'order_type', readValue: _readOrderType) String orderType,
      @JsonKey(readValue: _readQuantity) double quantity,
      @JsonKey(readValue: _readSource) String source,
      @JsonKey(readValue: _readExchange) String exchange,
      @JsonKey(name: 'exchange_order_id', readValue: _readExchangeOrderId)
      String? exchangeOrderId,
      @JsonKey(name: 'entry_price', readValue: _readEntryPrice)
      double? entryPrice,
      @JsonKey(name: 'mark_price', readValue: _readMarkPrice) double? markPrice,
      @JsonKey(name: 'liquidation_price', readValue: _readLiquidationPrice)
      double? liquidationPrice,
      @JsonKey(name: 'margin_used', readValue: _readMarginUsed)
      double? marginUsed,
      @JsonKey(name: 'realized_pnl', readValue: _readRealizedPnl)
      double? realizedPnl,
      @JsonKey(name: 'unrealized_pnl', readValue: _readUnrealizedPnl)
      double? unrealizedPnl,
      @JsonKey(name: 'remaining_quantity', readValue: _readRemainingQuantity)
      double? remainingQuantity,
      @JsonKey(name: 'sync_status', readValue: _readSyncStatus)
      String? syncStatus,
      @JsonKey(name: 'last_synced_at', readValue: _readLastSyncedAt)
      String? lastSyncedAt,
      @JsonKey(name: 'closed_at', readValue: _readClosedAt) String? closedAt,
      @JsonKey(readValue: _readPrice) double? price,
      @JsonKey(readValue: _readLeverage) double leverage,
      @JsonKey(name: 'tp_levels', readValue: _readTpLevels)
      List<double> tpLevels,
      @JsonKey(name: 'sl_price', readValue: _readSlPrice) double? slPrice,
      @JsonKey(
          name: 'auto_cancel_after_minutes',
          readValue: _readAutoCancelAfterMinutes)
      int? autoCancelAfterMinutes,
      @JsonKey(name: 'expires_at', readValue: _readExpiresAt) String? expiresAt,
      @JsonKey(name: 'auto_cancelled_at', readValue: _readAutoCancelledAt)
      String? autoCancelledAt,
      @JsonKey(name: 'auto_cancel_reason', readValue: _readAutoCancelReason)
      String? autoCancelReason,
      @JsonKey(name: 'created_at', readValue: _readCreatedAt)
      String createdAt});
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
    Object? source = null,
    Object? exchange = null,
    Object? exchangeOrderId = freezed,
    Object? entryPrice = freezed,
    Object? markPrice = freezed,
    Object? liquidationPrice = freezed,
    Object? marginUsed = freezed,
    Object? realizedPnl = freezed,
    Object? unrealizedPnl = freezed,
    Object? remainingQuantity = freezed,
    Object? syncStatus = freezed,
    Object? lastSyncedAt = freezed,
    Object? closedAt = freezed,
    Object? price = freezed,
    Object? leverage = null,
    Object? tpLevels = null,
    Object? slPrice = freezed,
    Object? autoCancelAfterMinutes = freezed,
    Object? expiresAt = freezed,
    Object? autoCancelledAt = freezed,
    Object? autoCancelReason = freezed,
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
      source: null == source
          ? _self.source
          : source // ignore: cast_nullable_to_non_nullable
              as String,
      exchange: null == exchange
          ? _self.exchange
          : exchange // ignore: cast_nullable_to_non_nullable
              as String,
      exchangeOrderId: freezed == exchangeOrderId
          ? _self.exchangeOrderId
          : exchangeOrderId // ignore: cast_nullable_to_non_nullable
              as String?,
      entryPrice: freezed == entryPrice
          ? _self.entryPrice
          : entryPrice // ignore: cast_nullable_to_non_nullable
              as double?,
      markPrice: freezed == markPrice
          ? _self.markPrice
          : markPrice // ignore: cast_nullable_to_non_nullable
              as double?,
      liquidationPrice: freezed == liquidationPrice
          ? _self.liquidationPrice
          : liquidationPrice // ignore: cast_nullable_to_non_nullable
              as double?,
      marginUsed: freezed == marginUsed
          ? _self.marginUsed
          : marginUsed // ignore: cast_nullable_to_non_nullable
              as double?,
      realizedPnl: freezed == realizedPnl
          ? _self.realizedPnl
          : realizedPnl // ignore: cast_nullable_to_non_nullable
              as double?,
      unrealizedPnl: freezed == unrealizedPnl
          ? _self.unrealizedPnl
          : unrealizedPnl // ignore: cast_nullable_to_non_nullable
              as double?,
      remainingQuantity: freezed == remainingQuantity
          ? _self.remainingQuantity
          : remainingQuantity // ignore: cast_nullable_to_non_nullable
              as double?,
      syncStatus: freezed == syncStatus
          ? _self.syncStatus
          : syncStatus // ignore: cast_nullable_to_non_nullable
              as String?,
      lastSyncedAt: freezed == lastSyncedAt
          ? _self.lastSyncedAt
          : lastSyncedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      closedAt: freezed == closedAt
          ? _self.closedAt
          : closedAt // ignore: cast_nullable_to_non_nullable
              as String?,
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
      autoCancelAfterMinutes: freezed == autoCancelAfterMinutes
          ? _self.autoCancelAfterMinutes
          : autoCancelAfterMinutes // ignore: cast_nullable_to_non_nullable
              as int?,
      expiresAt: freezed == expiresAt
          ? _self.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as String?,
      autoCancelledAt: freezed == autoCancelledAt
          ? _self.autoCancelledAt
          : autoCancelledAt // ignore: cast_nullable_to_non_nullable
              as String?,
      autoCancelReason: freezed == autoCancelReason
          ? _self.autoCancelReason
          : autoCancelReason // ignore: cast_nullable_to_non_nullable
              as String?,
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
            @JsonKey(readValue: _readId) String id,
            @JsonKey(readValue: _readSymbol) String symbol,
            @JsonKey(readValue: _readSide) String side,
            @JsonKey(readValue: _readStatus) String status,
            @JsonKey(name: 'order_type', readValue: _readOrderType)
            String orderType,
            @JsonKey(readValue: _readQuantity) double quantity,
            @JsonKey(readValue: _readSource) String source,
            @JsonKey(readValue: _readExchange) String exchange,
            @JsonKey(name: 'exchange_order_id', readValue: _readExchangeOrderId)
            String? exchangeOrderId,
            @JsonKey(name: 'entry_price', readValue: _readEntryPrice)
            double? entryPrice,
            @JsonKey(name: 'mark_price', readValue: _readMarkPrice)
            double? markPrice,
            @JsonKey(
                name: 'liquidation_price', readValue: _readLiquidationPrice)
            double? liquidationPrice,
            @JsonKey(name: 'margin_used', readValue: _readMarginUsed)
            double? marginUsed,
            @JsonKey(name: 'realized_pnl', readValue: _readRealizedPnl)
            double? realizedPnl,
            @JsonKey(name: 'unrealized_pnl', readValue: _readUnrealizedPnl)
            double? unrealizedPnl,
            @JsonKey(
                name: 'remaining_quantity', readValue: _readRemainingQuantity)
            double? remainingQuantity,
            @JsonKey(name: 'sync_status', readValue: _readSyncStatus)
            String? syncStatus,
            @JsonKey(name: 'last_synced_at', readValue: _readLastSyncedAt)
            String? lastSyncedAt,
            @JsonKey(name: 'closed_at', readValue: _readClosedAt)
            String? closedAt,
            @JsonKey(readValue: _readPrice) double? price,
            @JsonKey(readValue: _readLeverage) double leverage,
            @JsonKey(name: 'tp_levels', readValue: _readTpLevels)
            List<double> tpLevels,
            @JsonKey(name: 'sl_price', readValue: _readSlPrice) double? slPrice,
            @JsonKey(
                name: 'auto_cancel_after_minutes',
                readValue: _readAutoCancelAfterMinutes)
            int? autoCancelAfterMinutes,
            @JsonKey(name: 'expires_at', readValue: _readExpiresAt)
            String? expiresAt,
            @JsonKey(name: 'auto_cancelled_at', readValue: _readAutoCancelledAt)
            String? autoCancelledAt,
            @JsonKey(
                name: 'auto_cancel_reason', readValue: _readAutoCancelReason)
            String? autoCancelReason,
            @JsonKey(name: 'created_at', readValue: _readCreatedAt)
            String createdAt)?
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
            _that.source,
            _that.exchange,
            _that.exchangeOrderId,
            _that.entryPrice,
            _that.markPrice,
            _that.liquidationPrice,
            _that.marginUsed,
            _that.realizedPnl,
            _that.unrealizedPnl,
            _that.remainingQuantity,
            _that.syncStatus,
            _that.lastSyncedAt,
            _that.closedAt,
            _that.price,
            _that.leverage,
            _that.tpLevels,
            _that.slPrice,
            _that.autoCancelAfterMinutes,
            _that.expiresAt,
            _that.autoCancelledAt,
            _that.autoCancelReason,
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
            @JsonKey(readValue: _readId) String id,
            @JsonKey(readValue: _readSymbol) String symbol,
            @JsonKey(readValue: _readSide) String side,
            @JsonKey(readValue: _readStatus) String status,
            @JsonKey(name: 'order_type', readValue: _readOrderType)
            String orderType,
            @JsonKey(readValue: _readQuantity) double quantity,
            @JsonKey(readValue: _readSource) String source,
            @JsonKey(readValue: _readExchange) String exchange,
            @JsonKey(name: 'exchange_order_id', readValue: _readExchangeOrderId)
            String? exchangeOrderId,
            @JsonKey(name: 'entry_price', readValue: _readEntryPrice)
            double? entryPrice,
            @JsonKey(name: 'mark_price', readValue: _readMarkPrice)
            double? markPrice,
            @JsonKey(
                name: 'liquidation_price', readValue: _readLiquidationPrice)
            double? liquidationPrice,
            @JsonKey(name: 'margin_used', readValue: _readMarginUsed)
            double? marginUsed,
            @JsonKey(name: 'realized_pnl', readValue: _readRealizedPnl)
            double? realizedPnl,
            @JsonKey(name: 'unrealized_pnl', readValue: _readUnrealizedPnl)
            double? unrealizedPnl,
            @JsonKey(
                name: 'remaining_quantity', readValue: _readRemainingQuantity)
            double? remainingQuantity,
            @JsonKey(name: 'sync_status', readValue: _readSyncStatus)
            String? syncStatus,
            @JsonKey(name: 'last_synced_at', readValue: _readLastSyncedAt)
            String? lastSyncedAt,
            @JsonKey(name: 'closed_at', readValue: _readClosedAt)
            String? closedAt,
            @JsonKey(readValue: _readPrice) double? price,
            @JsonKey(readValue: _readLeverage) double leverage,
            @JsonKey(name: 'tp_levels', readValue: _readTpLevels)
            List<double> tpLevels,
            @JsonKey(name: 'sl_price', readValue: _readSlPrice) double? slPrice,
            @JsonKey(
                name: 'auto_cancel_after_minutes',
                readValue: _readAutoCancelAfterMinutes)
            int? autoCancelAfterMinutes,
            @JsonKey(name: 'expires_at', readValue: _readExpiresAt)
            String? expiresAt,
            @JsonKey(name: 'auto_cancelled_at', readValue: _readAutoCancelledAt)
            String? autoCancelledAt,
            @JsonKey(
                name: 'auto_cancel_reason', readValue: _readAutoCancelReason)
            String? autoCancelReason,
            @JsonKey(name: 'created_at', readValue: _readCreatedAt)
            String createdAt)
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
            _that.source,
            _that.exchange,
            _that.exchangeOrderId,
            _that.entryPrice,
            _that.markPrice,
            _that.liquidationPrice,
            _that.marginUsed,
            _that.realizedPnl,
            _that.unrealizedPnl,
            _that.remainingQuantity,
            _that.syncStatus,
            _that.lastSyncedAt,
            _that.closedAt,
            _that.price,
            _that.leverage,
            _that.tpLevels,
            _that.slPrice,
            _that.autoCancelAfterMinutes,
            _that.expiresAt,
            _that.autoCancelledAt,
            _that.autoCancelReason,
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
            @JsonKey(readValue: _readId) String id,
            @JsonKey(readValue: _readSymbol) String symbol,
            @JsonKey(readValue: _readSide) String side,
            @JsonKey(readValue: _readStatus) String status,
            @JsonKey(name: 'order_type', readValue: _readOrderType)
            String orderType,
            @JsonKey(readValue: _readQuantity) double quantity,
            @JsonKey(readValue: _readSource) String source,
            @JsonKey(readValue: _readExchange) String exchange,
            @JsonKey(name: 'exchange_order_id', readValue: _readExchangeOrderId)
            String? exchangeOrderId,
            @JsonKey(name: 'entry_price', readValue: _readEntryPrice)
            double? entryPrice,
            @JsonKey(name: 'mark_price', readValue: _readMarkPrice)
            double? markPrice,
            @JsonKey(
                name: 'liquidation_price', readValue: _readLiquidationPrice)
            double? liquidationPrice,
            @JsonKey(name: 'margin_used', readValue: _readMarginUsed)
            double? marginUsed,
            @JsonKey(name: 'realized_pnl', readValue: _readRealizedPnl)
            double? realizedPnl,
            @JsonKey(name: 'unrealized_pnl', readValue: _readUnrealizedPnl)
            double? unrealizedPnl,
            @JsonKey(
                name: 'remaining_quantity', readValue: _readRemainingQuantity)
            double? remainingQuantity,
            @JsonKey(name: 'sync_status', readValue: _readSyncStatus)
            String? syncStatus,
            @JsonKey(name: 'last_synced_at', readValue: _readLastSyncedAt)
            String? lastSyncedAt,
            @JsonKey(name: 'closed_at', readValue: _readClosedAt)
            String? closedAt,
            @JsonKey(readValue: _readPrice) double? price,
            @JsonKey(readValue: _readLeverage) double leverage,
            @JsonKey(name: 'tp_levels', readValue: _readTpLevels)
            List<double> tpLevels,
            @JsonKey(name: 'sl_price', readValue: _readSlPrice) double? slPrice,
            @JsonKey(
                name: 'auto_cancel_after_minutes',
                readValue: _readAutoCancelAfterMinutes)
            int? autoCancelAfterMinutes,
            @JsonKey(name: 'expires_at', readValue: _readExpiresAt)
            String? expiresAt,
            @JsonKey(name: 'auto_cancelled_at', readValue: _readAutoCancelledAt)
            String? autoCancelledAt,
            @JsonKey(
                name: 'auto_cancel_reason', readValue: _readAutoCancelReason)
            String? autoCancelReason,
            @JsonKey(name: 'created_at', readValue: _readCreatedAt)
            String createdAt)?
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
            _that.source,
            _that.exchange,
            _that.exchangeOrderId,
            _that.entryPrice,
            _that.markPrice,
            _that.liquidationPrice,
            _that.marginUsed,
            _that.realizedPnl,
            _that.unrealizedPnl,
            _that.remainingQuantity,
            _that.syncStatus,
            _that.lastSyncedAt,
            _that.closedAt,
            _that.price,
            _that.leverage,
            _that.tpLevels,
            _that.slPrice,
            _that.autoCancelAfterMinutes,
            _that.expiresAt,
            _that.autoCancelledAt,
            _that.autoCancelReason,
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
      {@JsonKey(readValue: _readId) this.id = '',
      @JsonKey(readValue: _readSymbol) this.symbol = '',
      @JsonKey(readValue: _readSide) this.side = 'buy',
      @JsonKey(readValue: _readStatus) this.status = 'unknown',
      @JsonKey(name: 'order_type', readValue: _readOrderType)
      this.orderType = 'market',
      @JsonKey(readValue: _readQuantity) this.quantity = 0.0,
      @JsonKey(readValue: _readSource) this.source = 'poise',
      @JsonKey(readValue: _readExchange) this.exchange = 'bybit',
      @JsonKey(name: 'exchange_order_id', readValue: _readExchangeOrderId)
      this.exchangeOrderId,
      @JsonKey(name: 'entry_price', readValue: _readEntryPrice) this.entryPrice,
      @JsonKey(name: 'mark_price', readValue: _readMarkPrice) this.markPrice,
      @JsonKey(name: 'liquidation_price', readValue: _readLiquidationPrice)
      this.liquidationPrice,
      @JsonKey(name: 'margin_used', readValue: _readMarginUsed) this.marginUsed,
      @JsonKey(name: 'realized_pnl', readValue: _readRealizedPnl)
      this.realizedPnl,
      @JsonKey(name: 'unrealized_pnl', readValue: _readUnrealizedPnl)
      this.unrealizedPnl,
      @JsonKey(name: 'remaining_quantity', readValue: _readRemainingQuantity)
      this.remainingQuantity,
      @JsonKey(name: 'sync_status', readValue: _readSyncStatus) this.syncStatus,
      @JsonKey(name: 'last_synced_at', readValue: _readLastSyncedAt)
      this.lastSyncedAt,
      @JsonKey(name: 'closed_at', readValue: _readClosedAt) this.closedAt,
      @JsonKey(readValue: _readPrice) this.price,
      @JsonKey(readValue: _readLeverage) this.leverage = 1.0,
      @JsonKey(name: 'tp_levels', readValue: _readTpLevels)
      final List<double> tpLevels = const [],
      @JsonKey(name: 'sl_price', readValue: _readSlPrice) this.slPrice,
      @JsonKey(
          name: 'auto_cancel_after_minutes',
          readValue: _readAutoCancelAfterMinutes)
      this.autoCancelAfterMinutes,
      @JsonKey(name: 'expires_at', readValue: _readExpiresAt) this.expiresAt,
      @JsonKey(name: 'auto_cancelled_at', readValue: _readAutoCancelledAt)
      this.autoCancelledAt,
      @JsonKey(name: 'auto_cancel_reason', readValue: _readAutoCancelReason)
      this.autoCancelReason,
      @JsonKey(name: 'created_at', readValue: _readCreatedAt)
      this.createdAt = ''})
      : _tpLevels = tpLevels;
  factory _Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);

  @override
  @JsonKey(readValue: _readId)
  final String id;
  @override
  @JsonKey(readValue: _readSymbol)
  final String symbol;
  @override
  @JsonKey(readValue: _readSide)
  final String side;
  @override
  @JsonKey(readValue: _readStatus)
  final String status;
  @override
  @JsonKey(name: 'order_type', readValue: _readOrderType)
  final String orderType;
  @override
  @JsonKey(readValue: _readQuantity)
  final double quantity;
  @override
  @JsonKey(readValue: _readSource)
  final String source;
  @override
  @JsonKey(readValue: _readExchange)
  final String exchange;
  @override
  @JsonKey(name: 'exchange_order_id', readValue: _readExchangeOrderId)
  final String? exchangeOrderId;
  @override
  @JsonKey(name: 'entry_price', readValue: _readEntryPrice)
  final double? entryPrice;
  @override
  @JsonKey(name: 'mark_price', readValue: _readMarkPrice)
  final double? markPrice;
  @override
  @JsonKey(name: 'liquidation_price', readValue: _readLiquidationPrice)
  final double? liquidationPrice;
  @override
  @JsonKey(name: 'margin_used', readValue: _readMarginUsed)
  final double? marginUsed;
  @override
  @JsonKey(name: 'realized_pnl', readValue: _readRealizedPnl)
  final double? realizedPnl;
  @override
  @JsonKey(name: 'unrealized_pnl', readValue: _readUnrealizedPnl)
  final double? unrealizedPnl;
  @override
  @JsonKey(name: 'remaining_quantity', readValue: _readRemainingQuantity)
  final double? remainingQuantity;
  @override
  @JsonKey(name: 'sync_status', readValue: _readSyncStatus)
  final String? syncStatus;
  @override
  @JsonKey(name: 'last_synced_at', readValue: _readLastSyncedAt)
  final String? lastSyncedAt;
  @override
  @JsonKey(name: 'closed_at', readValue: _readClosedAt)
  final String? closedAt;
  @override
  @JsonKey(readValue: _readPrice)
  final double? price;
  @override
  @JsonKey(readValue: _readLeverage)
  final double leverage;
  final List<double> _tpLevels;
  @override
  @JsonKey(name: 'tp_levels', readValue: _readTpLevels)
  List<double> get tpLevels {
    if (_tpLevels is EqualUnmodifiableListView) return _tpLevels;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tpLevels);
  }

  @override
  @JsonKey(name: 'sl_price', readValue: _readSlPrice)
  final double? slPrice;
  @override
  @JsonKey(
      name: 'auto_cancel_after_minutes', readValue: _readAutoCancelAfterMinutes)
  final int? autoCancelAfterMinutes;
  @override
  @JsonKey(name: 'expires_at', readValue: _readExpiresAt)
  final String? expiresAt;
  @override
  @JsonKey(name: 'auto_cancelled_at', readValue: _readAutoCancelledAt)
  final String? autoCancelledAt;
  @override
  @JsonKey(name: 'auto_cancel_reason', readValue: _readAutoCancelReason)
  final String? autoCancelReason;
  @override
  @JsonKey(name: 'created_at', readValue: _readCreatedAt)
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
            (identical(other.source, source) || other.source == source) &&
            (identical(other.exchange, exchange) ||
                other.exchange == exchange) &&
            (identical(other.exchangeOrderId, exchangeOrderId) ||
                other.exchangeOrderId == exchangeOrderId) &&
            (identical(other.entryPrice, entryPrice) ||
                other.entryPrice == entryPrice) &&
            (identical(other.markPrice, markPrice) ||
                other.markPrice == markPrice) &&
            (identical(other.liquidationPrice, liquidationPrice) ||
                other.liquidationPrice == liquidationPrice) &&
            (identical(other.marginUsed, marginUsed) ||
                other.marginUsed == marginUsed) &&
            (identical(other.realizedPnl, realizedPnl) ||
                other.realizedPnl == realizedPnl) &&
            (identical(other.unrealizedPnl, unrealizedPnl) ||
                other.unrealizedPnl == unrealizedPnl) &&
            (identical(other.remainingQuantity, remainingQuantity) ||
                other.remainingQuantity == remainingQuantity) &&
            (identical(other.syncStatus, syncStatus) ||
                other.syncStatus == syncStatus) &&
            (identical(other.lastSyncedAt, lastSyncedAt) ||
                other.lastSyncedAt == lastSyncedAt) &&
            (identical(other.closedAt, closedAt) ||
                other.closedAt == closedAt) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.leverage, leverage) ||
                other.leverage == leverage) &&
            const DeepCollectionEquality().equals(other._tpLevels, _tpLevels) &&
            (identical(other.slPrice, slPrice) || other.slPrice == slPrice) &&
            (identical(other.autoCancelAfterMinutes, autoCancelAfterMinutes) ||
                other.autoCancelAfterMinutes == autoCancelAfterMinutes) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt) &&
            (identical(other.autoCancelledAt, autoCancelledAt) ||
                other.autoCancelledAt == autoCancelledAt) &&
            (identical(other.autoCancelReason, autoCancelReason) ||
                other.autoCancelReason == autoCancelReason) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        symbol,
        side,
        status,
        orderType,
        quantity,
        source,
        exchange,
        exchangeOrderId,
        entryPrice,
        markPrice,
        liquidationPrice,
        marginUsed,
        realizedPnl,
        unrealizedPnl,
        remainingQuantity,
        syncStatus,
        lastSyncedAt,
        closedAt,
        price,
        leverage,
        const DeepCollectionEquality().hash(_tpLevels),
        slPrice,
        autoCancelAfterMinutes,
        expiresAt,
        autoCancelledAt,
        autoCancelReason,
        createdAt
      ]);

  @override
  String toString() {
    return 'Order(id: $id, symbol: $symbol, side: $side, status: $status, orderType: $orderType, quantity: $quantity, source: $source, exchange: $exchange, exchangeOrderId: $exchangeOrderId, entryPrice: $entryPrice, markPrice: $markPrice, liquidationPrice: $liquidationPrice, marginUsed: $marginUsed, realizedPnl: $realizedPnl, unrealizedPnl: $unrealizedPnl, remainingQuantity: $remainingQuantity, syncStatus: $syncStatus, lastSyncedAt: $lastSyncedAt, closedAt: $closedAt, price: $price, leverage: $leverage, tpLevels: $tpLevels, slPrice: $slPrice, autoCancelAfterMinutes: $autoCancelAfterMinutes, expiresAt: $expiresAt, autoCancelledAt: $autoCancelledAt, autoCancelReason: $autoCancelReason, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class _$OrderCopyWith<$Res> implements $OrderCopyWith<$Res> {
  factory _$OrderCopyWith(_Order value, $Res Function(_Order) _then) =
      __$OrderCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(readValue: _readId) String id,
      @JsonKey(readValue: _readSymbol) String symbol,
      @JsonKey(readValue: _readSide) String side,
      @JsonKey(readValue: _readStatus) String status,
      @JsonKey(name: 'order_type', readValue: _readOrderType) String orderType,
      @JsonKey(readValue: _readQuantity) double quantity,
      @JsonKey(readValue: _readSource) String source,
      @JsonKey(readValue: _readExchange) String exchange,
      @JsonKey(name: 'exchange_order_id', readValue: _readExchangeOrderId)
      String? exchangeOrderId,
      @JsonKey(name: 'entry_price', readValue: _readEntryPrice)
      double? entryPrice,
      @JsonKey(name: 'mark_price', readValue: _readMarkPrice) double? markPrice,
      @JsonKey(name: 'liquidation_price', readValue: _readLiquidationPrice)
      double? liquidationPrice,
      @JsonKey(name: 'margin_used', readValue: _readMarginUsed)
      double? marginUsed,
      @JsonKey(name: 'realized_pnl', readValue: _readRealizedPnl)
      double? realizedPnl,
      @JsonKey(name: 'unrealized_pnl', readValue: _readUnrealizedPnl)
      double? unrealizedPnl,
      @JsonKey(name: 'remaining_quantity', readValue: _readRemainingQuantity)
      double? remainingQuantity,
      @JsonKey(name: 'sync_status', readValue: _readSyncStatus)
      String? syncStatus,
      @JsonKey(name: 'last_synced_at', readValue: _readLastSyncedAt)
      String? lastSyncedAt,
      @JsonKey(name: 'closed_at', readValue: _readClosedAt) String? closedAt,
      @JsonKey(readValue: _readPrice) double? price,
      @JsonKey(readValue: _readLeverage) double leverage,
      @JsonKey(name: 'tp_levels', readValue: _readTpLevels)
      List<double> tpLevels,
      @JsonKey(name: 'sl_price', readValue: _readSlPrice) double? slPrice,
      @JsonKey(
          name: 'auto_cancel_after_minutes',
          readValue: _readAutoCancelAfterMinutes)
      int? autoCancelAfterMinutes,
      @JsonKey(name: 'expires_at', readValue: _readExpiresAt) String? expiresAt,
      @JsonKey(name: 'auto_cancelled_at', readValue: _readAutoCancelledAt)
      String? autoCancelledAt,
      @JsonKey(name: 'auto_cancel_reason', readValue: _readAutoCancelReason)
      String? autoCancelReason,
      @JsonKey(name: 'created_at', readValue: _readCreatedAt)
      String createdAt});
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
    Object? source = null,
    Object? exchange = null,
    Object? exchangeOrderId = freezed,
    Object? entryPrice = freezed,
    Object? markPrice = freezed,
    Object? liquidationPrice = freezed,
    Object? marginUsed = freezed,
    Object? realizedPnl = freezed,
    Object? unrealizedPnl = freezed,
    Object? remainingQuantity = freezed,
    Object? syncStatus = freezed,
    Object? lastSyncedAt = freezed,
    Object? closedAt = freezed,
    Object? price = freezed,
    Object? leverage = null,
    Object? tpLevels = null,
    Object? slPrice = freezed,
    Object? autoCancelAfterMinutes = freezed,
    Object? expiresAt = freezed,
    Object? autoCancelledAt = freezed,
    Object? autoCancelReason = freezed,
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
      source: null == source
          ? _self.source
          : source // ignore: cast_nullable_to_non_nullable
              as String,
      exchange: null == exchange
          ? _self.exchange
          : exchange // ignore: cast_nullable_to_non_nullable
              as String,
      exchangeOrderId: freezed == exchangeOrderId
          ? _self.exchangeOrderId
          : exchangeOrderId // ignore: cast_nullable_to_non_nullable
              as String?,
      entryPrice: freezed == entryPrice
          ? _self.entryPrice
          : entryPrice // ignore: cast_nullable_to_non_nullable
              as double?,
      markPrice: freezed == markPrice
          ? _self.markPrice
          : markPrice // ignore: cast_nullable_to_non_nullable
              as double?,
      liquidationPrice: freezed == liquidationPrice
          ? _self.liquidationPrice
          : liquidationPrice // ignore: cast_nullable_to_non_nullable
              as double?,
      marginUsed: freezed == marginUsed
          ? _self.marginUsed
          : marginUsed // ignore: cast_nullable_to_non_nullable
              as double?,
      realizedPnl: freezed == realizedPnl
          ? _self.realizedPnl
          : realizedPnl // ignore: cast_nullable_to_non_nullable
              as double?,
      unrealizedPnl: freezed == unrealizedPnl
          ? _self.unrealizedPnl
          : unrealizedPnl // ignore: cast_nullable_to_non_nullable
              as double?,
      remainingQuantity: freezed == remainingQuantity
          ? _self.remainingQuantity
          : remainingQuantity // ignore: cast_nullable_to_non_nullable
              as double?,
      syncStatus: freezed == syncStatus
          ? _self.syncStatus
          : syncStatus // ignore: cast_nullable_to_non_nullable
              as String?,
      lastSyncedAt: freezed == lastSyncedAt
          ? _self.lastSyncedAt
          : lastSyncedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      closedAt: freezed == closedAt
          ? _self.closedAt
          : closedAt // ignore: cast_nullable_to_non_nullable
              as String?,
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
      autoCancelAfterMinutes: freezed == autoCancelAfterMinutes
          ? _self.autoCancelAfterMinutes
          : autoCancelAfterMinutes // ignore: cast_nullable_to_non_nullable
              as int?,
      expiresAt: freezed == expiresAt
          ? _self.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as String?,
      autoCancelledAt: freezed == autoCancelledAt
          ? _self.autoCancelledAt
          : autoCancelledAt // ignore: cast_nullable_to_non_nullable
              as String?,
      autoCancelReason: freezed == autoCancelReason
          ? _self.autoCancelReason
          : autoCancelReason // ignore: cast_nullable_to_non_nullable
              as String?,
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
