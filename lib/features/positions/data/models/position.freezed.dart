// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'position.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Position {
  @JsonKey(readValue: _readId)
  String get id;
  @JsonKey(readValue: _readSymbol)
  String get symbol;
  @JsonKey(readValue: _readSide)
  String get side;
  @JsonKey(name: 'entry_price', readValue: _readEntryPrice)
  double get entryPrice;
  @JsonKey(name: 'current_price', readValue: _readCurrentPrice)
  double get currentPrice;
  @JsonKey(readValue: _readQuantity)
  double get quantity;
  String get source;
  @JsonKey(name: 'exchange_order_id', readValue: _readExchangeOrderId)
  String? get exchangeOrderId;
  double get leverage;
  @JsonKey(name: 'unrealized_pnl', readValue: _readUnrealizedPnl)
  double get unrealizedPnl;
  @JsonKey(name: 'unrealized_pnl_pct', readValue: _readUnrealizedPnlPct)
  double get unrealizedPnlPct;
  @JsonKey(name: 'realized_pnl', readValue: _readRealizedPnl)
  double get realizedPnl;
  @JsonKey(name: 'liquidation_price', readValue: _readLiquidationPrice)
  double? get liquidationPrice;
  @JsonKey(name: 'margin_used', readValue: _readMarginUsed)
  double? get marginUsed;
  @JsonKey(name: 'remaining_quantity', readValue: _readRemainingQuantity)
  double? get remainingQuantity;
  @JsonKey(name: 'sync_status', readValue: _readSyncStatus)
  String get syncStatus;
  @JsonKey(name: 'last_synced_at', readValue: _readLastSyncedAt)
  String? get lastSyncedAt;
  @JsonKey(name: 'closed_at', readValue: _readClosedAt)
  String? get closedAt;
  @JsonKey(readValue: _readStatus)
  String get status;
  @JsonKey(name: 'is_locked', readValue: _readIsLocked)
  bool get isLocked;
  @JsonKey(name: 'tp_levels', readValue: _readTpLevels)
  List<double> get tpLevels;
  @JsonKey(name: 'sl_price', readValue: _readSlPrice)
  double? get slPrice;
  @JsonKey(name: 'exchange')
  String get exchange;
  @JsonKey(name: 'created_at', readValue: _readCreatedAt)
  String get createdAt;

  /// Create a copy of Position
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PositionCopyWith<Position> get copyWith =>
      _$PositionCopyWithImpl<Position>(this as Position, _$identity);

  /// Serializes this Position to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Position &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.symbol, symbol) || other.symbol == symbol) &&
            (identical(other.side, side) || other.side == side) &&
            (identical(other.entryPrice, entryPrice) ||
                other.entryPrice == entryPrice) &&
            (identical(other.currentPrice, currentPrice) ||
                other.currentPrice == currentPrice) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.source, source) || other.source == source) &&
            (identical(other.exchangeOrderId, exchangeOrderId) ||
                other.exchangeOrderId == exchangeOrderId) &&
            (identical(other.leverage, leverage) ||
                other.leverage == leverage) &&
            (identical(other.unrealizedPnl, unrealizedPnl) ||
                other.unrealizedPnl == unrealizedPnl) &&
            (identical(other.unrealizedPnlPct, unrealizedPnlPct) ||
                other.unrealizedPnlPct == unrealizedPnlPct) &&
            (identical(other.realizedPnl, realizedPnl) ||
                other.realizedPnl == realizedPnl) &&
            (identical(other.liquidationPrice, liquidationPrice) ||
                other.liquidationPrice == liquidationPrice) &&
            (identical(other.marginUsed, marginUsed) ||
                other.marginUsed == marginUsed) &&
            (identical(other.remainingQuantity, remainingQuantity) ||
                other.remainingQuantity == remainingQuantity) &&
            (identical(other.syncStatus, syncStatus) ||
                other.syncStatus == syncStatus) &&
            (identical(other.lastSyncedAt, lastSyncedAt) ||
                other.lastSyncedAt == lastSyncedAt) &&
            (identical(other.closedAt, closedAt) ||
                other.closedAt == closedAt) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.isLocked, isLocked) ||
                other.isLocked == isLocked) &&
            const DeepCollectionEquality().equals(other.tpLevels, tpLevels) &&
            (identical(other.slPrice, slPrice) || other.slPrice == slPrice) &&
            (identical(other.exchange, exchange) ||
                other.exchange == exchange) &&
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
        entryPrice,
        currentPrice,
        quantity,
        source,
        exchangeOrderId,
        leverage,
        unrealizedPnl,
        unrealizedPnlPct,
        realizedPnl,
        liquidationPrice,
        marginUsed,
        remainingQuantity,
        syncStatus,
        lastSyncedAt,
        closedAt,
        status,
        isLocked,
        const DeepCollectionEquality().hash(tpLevels),
        slPrice,
        exchange,
        createdAt
      ]);

  @override
  String toString() {
    return 'Position(id: $id, symbol: $symbol, side: $side, entryPrice: $entryPrice, currentPrice: $currentPrice, quantity: $quantity, source: $source, exchangeOrderId: $exchangeOrderId, leverage: $leverage, unrealizedPnl: $unrealizedPnl, unrealizedPnlPct: $unrealizedPnlPct, realizedPnl: $realizedPnl, liquidationPrice: $liquidationPrice, marginUsed: $marginUsed, remainingQuantity: $remainingQuantity, syncStatus: $syncStatus, lastSyncedAt: $lastSyncedAt, closedAt: $closedAt, status: $status, isLocked: $isLocked, tpLevels: $tpLevels, slPrice: $slPrice, exchange: $exchange, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class $PositionCopyWith<$Res> {
  factory $PositionCopyWith(Position value, $Res Function(Position) _then) =
      _$PositionCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(readValue: _readId) String id,
      @JsonKey(readValue: _readSymbol) String symbol,
      @JsonKey(readValue: _readSide) String side,
      @JsonKey(name: 'entry_price', readValue: _readEntryPrice)
      double entryPrice,
      @JsonKey(name: 'current_price', readValue: _readCurrentPrice)
      double currentPrice,
      @JsonKey(readValue: _readQuantity) double quantity,
      String source,
      @JsonKey(name: 'exchange_order_id', readValue: _readExchangeOrderId)
      String? exchangeOrderId,
      double leverage,
      @JsonKey(name: 'unrealized_pnl', readValue: _readUnrealizedPnl)
      double unrealizedPnl,
      @JsonKey(name: 'unrealized_pnl_pct', readValue: _readUnrealizedPnlPct)
      double unrealizedPnlPct,
      @JsonKey(name: 'realized_pnl', readValue: _readRealizedPnl)
      double realizedPnl,
      @JsonKey(name: 'liquidation_price', readValue: _readLiquidationPrice)
      double? liquidationPrice,
      @JsonKey(name: 'margin_used', readValue: _readMarginUsed)
      double? marginUsed,
      @JsonKey(name: 'remaining_quantity', readValue: _readRemainingQuantity)
      double? remainingQuantity,
      @JsonKey(name: 'sync_status', readValue: _readSyncStatus)
      String syncStatus,
      @JsonKey(name: 'last_synced_at', readValue: _readLastSyncedAt)
      String? lastSyncedAt,
      @JsonKey(name: 'closed_at', readValue: _readClosedAt) String? closedAt,
      @JsonKey(readValue: _readStatus) String status,
      @JsonKey(name: 'is_locked', readValue: _readIsLocked) bool isLocked,
      @JsonKey(name: 'tp_levels', readValue: _readTpLevels)
      List<double> tpLevels,
      @JsonKey(name: 'sl_price', readValue: _readSlPrice) double? slPrice,
      @JsonKey(name: 'exchange') String exchange,
      @JsonKey(name: 'created_at', readValue: _readCreatedAt)
      String createdAt});
}

/// @nodoc
class _$PositionCopyWithImpl<$Res> implements $PositionCopyWith<$Res> {
  _$PositionCopyWithImpl(this._self, this._then);

  final Position _self;
  final $Res Function(Position) _then;

  /// Create a copy of Position
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? symbol = null,
    Object? side = null,
    Object? entryPrice = null,
    Object? currentPrice = null,
    Object? quantity = null,
    Object? source = null,
    Object? exchangeOrderId = freezed,
    Object? leverage = null,
    Object? unrealizedPnl = null,
    Object? unrealizedPnlPct = null,
    Object? realizedPnl = null,
    Object? liquidationPrice = freezed,
    Object? marginUsed = freezed,
    Object? remainingQuantity = freezed,
    Object? syncStatus = null,
    Object? lastSyncedAt = freezed,
    Object? closedAt = freezed,
    Object? status = null,
    Object? isLocked = null,
    Object? tpLevels = null,
    Object? slPrice = freezed,
    Object? exchange = null,
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
      entryPrice: null == entryPrice
          ? _self.entryPrice
          : entryPrice // ignore: cast_nullable_to_non_nullable
              as double,
      currentPrice: null == currentPrice
          ? _self.currentPrice
          : currentPrice // ignore: cast_nullable_to_non_nullable
              as double,
      quantity: null == quantity
          ? _self.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as double,
      source: null == source
          ? _self.source
          : source // ignore: cast_nullable_to_non_nullable
              as String,
      exchangeOrderId: freezed == exchangeOrderId
          ? _self.exchangeOrderId
          : exchangeOrderId // ignore: cast_nullable_to_non_nullable
              as String?,
      leverage: null == leverage
          ? _self.leverage
          : leverage // ignore: cast_nullable_to_non_nullable
              as double,
      unrealizedPnl: null == unrealizedPnl
          ? _self.unrealizedPnl
          : unrealizedPnl // ignore: cast_nullable_to_non_nullable
              as double,
      unrealizedPnlPct: null == unrealizedPnlPct
          ? _self.unrealizedPnlPct
          : unrealizedPnlPct // ignore: cast_nullable_to_non_nullable
              as double,
      realizedPnl: null == realizedPnl
          ? _self.realizedPnl
          : realizedPnl // ignore: cast_nullable_to_non_nullable
              as double,
      liquidationPrice: freezed == liquidationPrice
          ? _self.liquidationPrice
          : liquidationPrice // ignore: cast_nullable_to_non_nullable
              as double?,
      marginUsed: freezed == marginUsed
          ? _self.marginUsed
          : marginUsed // ignore: cast_nullable_to_non_nullable
              as double?,
      remainingQuantity: freezed == remainingQuantity
          ? _self.remainingQuantity
          : remainingQuantity // ignore: cast_nullable_to_non_nullable
              as double?,
      syncStatus: null == syncStatus
          ? _self.syncStatus
          : syncStatus // ignore: cast_nullable_to_non_nullable
              as String,
      lastSyncedAt: freezed == lastSyncedAt
          ? _self.lastSyncedAt
          : lastSyncedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      closedAt: freezed == closedAt
          ? _self.closedAt
          : closedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      isLocked: null == isLocked
          ? _self.isLocked
          : isLocked // ignore: cast_nullable_to_non_nullable
              as bool,
      tpLevels: null == tpLevels
          ? _self.tpLevels
          : tpLevels // ignore: cast_nullable_to_non_nullable
              as List<double>,
      slPrice: freezed == slPrice
          ? _self.slPrice
          : slPrice // ignore: cast_nullable_to_non_nullable
              as double?,
      exchange: null == exchange
          ? _self.exchange
          : exchange // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// Adds pattern-matching-related methods to [Position].
extension PositionPatterns on Position {
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
    TResult Function(_Position value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Position() when $default != null:
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
    TResult Function(_Position value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Position():
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
    TResult? Function(_Position value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Position() when $default != null:
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
            @JsonKey(name: 'entry_price', readValue: _readEntryPrice)
            double entryPrice,
            @JsonKey(name: 'current_price', readValue: _readCurrentPrice)
            double currentPrice,
            @JsonKey(readValue: _readQuantity) double quantity,
            String source,
            @JsonKey(name: 'exchange_order_id', readValue: _readExchangeOrderId)
            String? exchangeOrderId,
            double leverage,
            @JsonKey(name: 'unrealized_pnl', readValue: _readUnrealizedPnl)
            double unrealizedPnl,
            @JsonKey(
                name: 'unrealized_pnl_pct', readValue: _readUnrealizedPnlPct)
            double unrealizedPnlPct,
            @JsonKey(name: 'realized_pnl', readValue: _readRealizedPnl)
            double realizedPnl,
            @JsonKey(
                name: 'liquidation_price', readValue: _readLiquidationPrice)
            double? liquidationPrice,
            @JsonKey(name: 'margin_used', readValue: _readMarginUsed)
            double? marginUsed,
            @JsonKey(
                name: 'remaining_quantity', readValue: _readRemainingQuantity)
            double? remainingQuantity,
            @JsonKey(name: 'sync_status', readValue: _readSyncStatus)
            String syncStatus,
            @JsonKey(name: 'last_synced_at', readValue: _readLastSyncedAt)
            String? lastSyncedAt,
            @JsonKey(name: 'closed_at', readValue: _readClosedAt)
            String? closedAt,
            @JsonKey(readValue: _readStatus) String status,
            @JsonKey(name: 'is_locked', readValue: _readIsLocked) bool isLocked,
            @JsonKey(name: 'tp_levels', readValue: _readTpLevels)
            List<double> tpLevels,
            @JsonKey(name: 'sl_price', readValue: _readSlPrice) double? slPrice,
            @JsonKey(name: 'exchange') String exchange,
            @JsonKey(name: 'created_at', readValue: _readCreatedAt)
            String createdAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Position() when $default != null:
        return $default(
            _that.id,
            _that.symbol,
            _that.side,
            _that.entryPrice,
            _that.currentPrice,
            _that.quantity,
            _that.source,
            _that.exchangeOrderId,
            _that.leverage,
            _that.unrealizedPnl,
            _that.unrealizedPnlPct,
            _that.realizedPnl,
            _that.liquidationPrice,
            _that.marginUsed,
            _that.remainingQuantity,
            _that.syncStatus,
            _that.lastSyncedAt,
            _that.closedAt,
            _that.status,
            _that.isLocked,
            _that.tpLevels,
            _that.slPrice,
            _that.exchange,
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
            @JsonKey(name: 'entry_price', readValue: _readEntryPrice)
            double entryPrice,
            @JsonKey(name: 'current_price', readValue: _readCurrentPrice)
            double currentPrice,
            @JsonKey(readValue: _readQuantity) double quantity,
            String source,
            @JsonKey(name: 'exchange_order_id', readValue: _readExchangeOrderId)
            String? exchangeOrderId,
            double leverage,
            @JsonKey(name: 'unrealized_pnl', readValue: _readUnrealizedPnl)
            double unrealizedPnl,
            @JsonKey(
                name: 'unrealized_pnl_pct', readValue: _readUnrealizedPnlPct)
            double unrealizedPnlPct,
            @JsonKey(name: 'realized_pnl', readValue: _readRealizedPnl)
            double realizedPnl,
            @JsonKey(
                name: 'liquidation_price', readValue: _readLiquidationPrice)
            double? liquidationPrice,
            @JsonKey(name: 'margin_used', readValue: _readMarginUsed)
            double? marginUsed,
            @JsonKey(
                name: 'remaining_quantity', readValue: _readRemainingQuantity)
            double? remainingQuantity,
            @JsonKey(name: 'sync_status', readValue: _readSyncStatus)
            String syncStatus,
            @JsonKey(name: 'last_synced_at', readValue: _readLastSyncedAt)
            String? lastSyncedAt,
            @JsonKey(name: 'closed_at', readValue: _readClosedAt)
            String? closedAt,
            @JsonKey(readValue: _readStatus) String status,
            @JsonKey(name: 'is_locked', readValue: _readIsLocked) bool isLocked,
            @JsonKey(name: 'tp_levels', readValue: _readTpLevels)
            List<double> tpLevels,
            @JsonKey(name: 'sl_price', readValue: _readSlPrice) double? slPrice,
            @JsonKey(name: 'exchange') String exchange,
            @JsonKey(name: 'created_at', readValue: _readCreatedAt)
            String createdAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Position():
        return $default(
            _that.id,
            _that.symbol,
            _that.side,
            _that.entryPrice,
            _that.currentPrice,
            _that.quantity,
            _that.source,
            _that.exchangeOrderId,
            _that.leverage,
            _that.unrealizedPnl,
            _that.unrealizedPnlPct,
            _that.realizedPnl,
            _that.liquidationPrice,
            _that.marginUsed,
            _that.remainingQuantity,
            _that.syncStatus,
            _that.lastSyncedAt,
            _that.closedAt,
            _that.status,
            _that.isLocked,
            _that.tpLevels,
            _that.slPrice,
            _that.exchange,
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
            @JsonKey(name: 'entry_price', readValue: _readEntryPrice)
            double entryPrice,
            @JsonKey(name: 'current_price', readValue: _readCurrentPrice)
            double currentPrice,
            @JsonKey(readValue: _readQuantity) double quantity,
            String source,
            @JsonKey(name: 'exchange_order_id', readValue: _readExchangeOrderId)
            String? exchangeOrderId,
            double leverage,
            @JsonKey(name: 'unrealized_pnl', readValue: _readUnrealizedPnl)
            double unrealizedPnl,
            @JsonKey(
                name: 'unrealized_pnl_pct', readValue: _readUnrealizedPnlPct)
            double unrealizedPnlPct,
            @JsonKey(name: 'realized_pnl', readValue: _readRealizedPnl)
            double realizedPnl,
            @JsonKey(
                name: 'liquidation_price', readValue: _readLiquidationPrice)
            double? liquidationPrice,
            @JsonKey(name: 'margin_used', readValue: _readMarginUsed)
            double? marginUsed,
            @JsonKey(
                name: 'remaining_quantity', readValue: _readRemainingQuantity)
            double? remainingQuantity,
            @JsonKey(name: 'sync_status', readValue: _readSyncStatus)
            String syncStatus,
            @JsonKey(name: 'last_synced_at', readValue: _readLastSyncedAt)
            String? lastSyncedAt,
            @JsonKey(name: 'closed_at', readValue: _readClosedAt)
            String? closedAt,
            @JsonKey(readValue: _readStatus) String status,
            @JsonKey(name: 'is_locked', readValue: _readIsLocked) bool isLocked,
            @JsonKey(name: 'tp_levels', readValue: _readTpLevels)
            List<double> tpLevels,
            @JsonKey(name: 'sl_price', readValue: _readSlPrice) double? slPrice,
            @JsonKey(name: 'exchange') String exchange,
            @JsonKey(name: 'created_at', readValue: _readCreatedAt)
            String createdAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Position() when $default != null:
        return $default(
            _that.id,
            _that.symbol,
            _that.side,
            _that.entryPrice,
            _that.currentPrice,
            _that.quantity,
            _that.source,
            _that.exchangeOrderId,
            _that.leverage,
            _that.unrealizedPnl,
            _that.unrealizedPnlPct,
            _that.realizedPnl,
            _that.liquidationPrice,
            _that.marginUsed,
            _that.remainingQuantity,
            _that.syncStatus,
            _that.lastSyncedAt,
            _that.closedAt,
            _that.status,
            _that.isLocked,
            _that.tpLevels,
            _that.slPrice,
            _that.exchange,
            _that.createdAt);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _Position implements Position {
  const _Position(
      {@JsonKey(readValue: _readId) this.id = '',
      @JsonKey(readValue: _readSymbol) this.symbol = '',
      @JsonKey(readValue: _readSide) this.side = 'long',
      @JsonKey(name: 'entry_price', readValue: _readEntryPrice)
      this.entryPrice = 0.0,
      @JsonKey(name: 'current_price', readValue: _readCurrentPrice)
      this.currentPrice = 0.0,
      @JsonKey(readValue: _readQuantity) this.quantity = 0.0,
      this.source = 'external',
      @JsonKey(name: 'exchange_order_id', readValue: _readExchangeOrderId)
      this.exchangeOrderId,
      this.leverage = 1.0,
      @JsonKey(name: 'unrealized_pnl', readValue: _readUnrealizedPnl)
      this.unrealizedPnl = 0.0,
      @JsonKey(name: 'unrealized_pnl_pct', readValue: _readUnrealizedPnlPct)
      this.unrealizedPnlPct = 0.0,
      @JsonKey(name: 'realized_pnl', readValue: _readRealizedPnl)
      this.realizedPnl = 0.0,
      @JsonKey(name: 'liquidation_price', readValue: _readLiquidationPrice)
      this.liquidationPrice,
      @JsonKey(name: 'margin_used', readValue: _readMarginUsed) this.marginUsed,
      @JsonKey(name: 'remaining_quantity', readValue: _readRemainingQuantity)
      this.remainingQuantity,
      @JsonKey(name: 'sync_status', readValue: _readSyncStatus)
      this.syncStatus = 'synced',
      @JsonKey(name: 'last_synced_at', readValue: _readLastSyncedAt)
      this.lastSyncedAt,
      @JsonKey(name: 'closed_at', readValue: _readClosedAt) this.closedAt,
      @JsonKey(readValue: _readStatus) this.status = 'open',
      @JsonKey(name: 'is_locked', readValue: _readIsLocked)
      this.isLocked = false,
      @JsonKey(name: 'tp_levels', readValue: _readTpLevels)
      final List<double> tpLevels = const [],
      @JsonKey(name: 'sl_price', readValue: _readSlPrice) this.slPrice,
      @JsonKey(name: 'exchange') this.exchange = 'bybit',
      @JsonKey(name: 'created_at', readValue: _readCreatedAt)
      this.createdAt = ''})
      : _tpLevels = tpLevels;
  factory _Position.fromJson(Map<String, dynamic> json) =>
      _$PositionFromJson(json);

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
  @JsonKey(name: 'entry_price', readValue: _readEntryPrice)
  final double entryPrice;
  @override
  @JsonKey(name: 'current_price', readValue: _readCurrentPrice)
  final double currentPrice;
  @override
  @JsonKey(readValue: _readQuantity)
  final double quantity;
  @override
  @JsonKey()
  final String source;
  @override
  @JsonKey(name: 'exchange_order_id', readValue: _readExchangeOrderId)
  final String? exchangeOrderId;
  @override
  @JsonKey()
  final double leverage;
  @override
  @JsonKey(name: 'unrealized_pnl', readValue: _readUnrealizedPnl)
  final double unrealizedPnl;
  @override
  @JsonKey(name: 'unrealized_pnl_pct', readValue: _readUnrealizedPnlPct)
  final double unrealizedPnlPct;
  @override
  @JsonKey(name: 'realized_pnl', readValue: _readRealizedPnl)
  final double realizedPnl;
  @override
  @JsonKey(name: 'liquidation_price', readValue: _readLiquidationPrice)
  final double? liquidationPrice;
  @override
  @JsonKey(name: 'margin_used', readValue: _readMarginUsed)
  final double? marginUsed;
  @override
  @JsonKey(name: 'remaining_quantity', readValue: _readRemainingQuantity)
  final double? remainingQuantity;
  @override
  @JsonKey(name: 'sync_status', readValue: _readSyncStatus)
  final String syncStatus;
  @override
  @JsonKey(name: 'last_synced_at', readValue: _readLastSyncedAt)
  final String? lastSyncedAt;
  @override
  @JsonKey(name: 'closed_at', readValue: _readClosedAt)
  final String? closedAt;
  @override
  @JsonKey(readValue: _readStatus)
  final String status;
  @override
  @JsonKey(name: 'is_locked', readValue: _readIsLocked)
  final bool isLocked;
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
  @JsonKey(name: 'exchange')
  final String exchange;
  @override
  @JsonKey(name: 'created_at', readValue: _readCreatedAt)
  final String createdAt;

  /// Create a copy of Position
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$PositionCopyWith<_Position> get copyWith =>
      __$PositionCopyWithImpl<_Position>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$PositionToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Position &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.symbol, symbol) || other.symbol == symbol) &&
            (identical(other.side, side) || other.side == side) &&
            (identical(other.entryPrice, entryPrice) ||
                other.entryPrice == entryPrice) &&
            (identical(other.currentPrice, currentPrice) ||
                other.currentPrice == currentPrice) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.source, source) || other.source == source) &&
            (identical(other.exchangeOrderId, exchangeOrderId) ||
                other.exchangeOrderId == exchangeOrderId) &&
            (identical(other.leverage, leverage) ||
                other.leverage == leverage) &&
            (identical(other.unrealizedPnl, unrealizedPnl) ||
                other.unrealizedPnl == unrealizedPnl) &&
            (identical(other.unrealizedPnlPct, unrealizedPnlPct) ||
                other.unrealizedPnlPct == unrealizedPnlPct) &&
            (identical(other.realizedPnl, realizedPnl) ||
                other.realizedPnl == realizedPnl) &&
            (identical(other.liquidationPrice, liquidationPrice) ||
                other.liquidationPrice == liquidationPrice) &&
            (identical(other.marginUsed, marginUsed) ||
                other.marginUsed == marginUsed) &&
            (identical(other.remainingQuantity, remainingQuantity) ||
                other.remainingQuantity == remainingQuantity) &&
            (identical(other.syncStatus, syncStatus) ||
                other.syncStatus == syncStatus) &&
            (identical(other.lastSyncedAt, lastSyncedAt) ||
                other.lastSyncedAt == lastSyncedAt) &&
            (identical(other.closedAt, closedAt) ||
                other.closedAt == closedAt) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.isLocked, isLocked) ||
                other.isLocked == isLocked) &&
            const DeepCollectionEquality().equals(other._tpLevels, _tpLevels) &&
            (identical(other.slPrice, slPrice) || other.slPrice == slPrice) &&
            (identical(other.exchange, exchange) ||
                other.exchange == exchange) &&
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
        entryPrice,
        currentPrice,
        quantity,
        source,
        exchangeOrderId,
        leverage,
        unrealizedPnl,
        unrealizedPnlPct,
        realizedPnl,
        liquidationPrice,
        marginUsed,
        remainingQuantity,
        syncStatus,
        lastSyncedAt,
        closedAt,
        status,
        isLocked,
        const DeepCollectionEquality().hash(_tpLevels),
        slPrice,
        exchange,
        createdAt
      ]);

  @override
  String toString() {
    return 'Position(id: $id, symbol: $symbol, side: $side, entryPrice: $entryPrice, currentPrice: $currentPrice, quantity: $quantity, source: $source, exchangeOrderId: $exchangeOrderId, leverage: $leverage, unrealizedPnl: $unrealizedPnl, unrealizedPnlPct: $unrealizedPnlPct, realizedPnl: $realizedPnl, liquidationPrice: $liquidationPrice, marginUsed: $marginUsed, remainingQuantity: $remainingQuantity, syncStatus: $syncStatus, lastSyncedAt: $lastSyncedAt, closedAt: $closedAt, status: $status, isLocked: $isLocked, tpLevels: $tpLevels, slPrice: $slPrice, exchange: $exchange, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class _$PositionCopyWith<$Res>
    implements $PositionCopyWith<$Res> {
  factory _$PositionCopyWith(_Position value, $Res Function(_Position) _then) =
      __$PositionCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(readValue: _readId) String id,
      @JsonKey(readValue: _readSymbol) String symbol,
      @JsonKey(readValue: _readSide) String side,
      @JsonKey(name: 'entry_price', readValue: _readEntryPrice)
      double entryPrice,
      @JsonKey(name: 'current_price', readValue: _readCurrentPrice)
      double currentPrice,
      @JsonKey(readValue: _readQuantity) double quantity,
      String source,
      @JsonKey(name: 'exchange_order_id', readValue: _readExchangeOrderId)
      String? exchangeOrderId,
      double leverage,
      @JsonKey(name: 'unrealized_pnl', readValue: _readUnrealizedPnl)
      double unrealizedPnl,
      @JsonKey(name: 'unrealized_pnl_pct', readValue: _readUnrealizedPnlPct)
      double unrealizedPnlPct,
      @JsonKey(name: 'realized_pnl', readValue: _readRealizedPnl)
      double realizedPnl,
      @JsonKey(name: 'liquidation_price', readValue: _readLiquidationPrice)
      double? liquidationPrice,
      @JsonKey(name: 'margin_used', readValue: _readMarginUsed)
      double? marginUsed,
      @JsonKey(name: 'remaining_quantity', readValue: _readRemainingQuantity)
      double? remainingQuantity,
      @JsonKey(name: 'sync_status', readValue: _readSyncStatus)
      String syncStatus,
      @JsonKey(name: 'last_synced_at', readValue: _readLastSyncedAt)
      String? lastSyncedAt,
      @JsonKey(name: 'closed_at', readValue: _readClosedAt) String? closedAt,
      @JsonKey(readValue: _readStatus) String status,
      @JsonKey(name: 'is_locked', readValue: _readIsLocked) bool isLocked,
      @JsonKey(name: 'tp_levels', readValue: _readTpLevels)
      List<double> tpLevels,
      @JsonKey(name: 'sl_price', readValue: _readSlPrice) double? slPrice,
      @JsonKey(name: 'exchange') String exchange,
      @JsonKey(name: 'created_at', readValue: _readCreatedAt)
      String createdAt});
}

/// @nodoc
class __$PositionCopyWithImpl<$Res> implements _$PositionCopyWith<$Res> {
  __$PositionCopyWithImpl(this._self, this._then);

  final _Position _self;
  final $Res Function(_Position) _then;

  /// Create a copy of Position
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? symbol = null,
    Object? side = null,
    Object? entryPrice = null,
    Object? currentPrice = null,
    Object? quantity = null,
    Object? source = null,
    Object? exchangeOrderId = freezed,
    Object? leverage = null,
    Object? unrealizedPnl = null,
    Object? unrealizedPnlPct = null,
    Object? realizedPnl = null,
    Object? liquidationPrice = freezed,
    Object? marginUsed = freezed,
    Object? remainingQuantity = freezed,
    Object? syncStatus = null,
    Object? lastSyncedAt = freezed,
    Object? closedAt = freezed,
    Object? status = null,
    Object? isLocked = null,
    Object? tpLevels = null,
    Object? slPrice = freezed,
    Object? exchange = null,
    Object? createdAt = null,
  }) {
    return _then(_Position(
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
      entryPrice: null == entryPrice
          ? _self.entryPrice
          : entryPrice // ignore: cast_nullable_to_non_nullable
              as double,
      currentPrice: null == currentPrice
          ? _self.currentPrice
          : currentPrice // ignore: cast_nullable_to_non_nullable
              as double,
      quantity: null == quantity
          ? _self.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as double,
      source: null == source
          ? _self.source
          : source // ignore: cast_nullable_to_non_nullable
              as String,
      exchangeOrderId: freezed == exchangeOrderId
          ? _self.exchangeOrderId
          : exchangeOrderId // ignore: cast_nullable_to_non_nullable
              as String?,
      leverage: null == leverage
          ? _self.leverage
          : leverage // ignore: cast_nullable_to_non_nullable
              as double,
      unrealizedPnl: null == unrealizedPnl
          ? _self.unrealizedPnl
          : unrealizedPnl // ignore: cast_nullable_to_non_nullable
              as double,
      unrealizedPnlPct: null == unrealizedPnlPct
          ? _self.unrealizedPnlPct
          : unrealizedPnlPct // ignore: cast_nullable_to_non_nullable
              as double,
      realizedPnl: null == realizedPnl
          ? _self.realizedPnl
          : realizedPnl // ignore: cast_nullable_to_non_nullable
              as double,
      liquidationPrice: freezed == liquidationPrice
          ? _self.liquidationPrice
          : liquidationPrice // ignore: cast_nullable_to_non_nullable
              as double?,
      marginUsed: freezed == marginUsed
          ? _self.marginUsed
          : marginUsed // ignore: cast_nullable_to_non_nullable
              as double?,
      remainingQuantity: freezed == remainingQuantity
          ? _self.remainingQuantity
          : remainingQuantity // ignore: cast_nullable_to_non_nullable
              as double?,
      syncStatus: null == syncStatus
          ? _self.syncStatus
          : syncStatus // ignore: cast_nullable_to_non_nullable
              as String,
      lastSyncedAt: freezed == lastSyncedAt
          ? _self.lastSyncedAt
          : lastSyncedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      closedAt: freezed == closedAt
          ? _self.closedAt
          : closedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      isLocked: null == isLocked
          ? _self.isLocked
          : isLocked // ignore: cast_nullable_to_non_nullable
              as bool,
      tpLevels: null == tpLevels
          ? _self._tpLevels
          : tpLevels // ignore: cast_nullable_to_non_nullable
              as List<double>,
      slPrice: freezed == slPrice
          ? _self.slPrice
          : slPrice // ignore: cast_nullable_to_non_nullable
              as double?,
      exchange: null == exchange
          ? _self.exchange
          : exchange // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
mixin _$PnlSummary {
  @JsonKey(name: 'total_unrealized_pnl')
  double get totalUnrealizedPnl;
  @JsonKey(name: 'total_unrealized_pnl_pct')
  double get totalUnrealizedPnlPct;
  @JsonKey(name: 'day_pnl')
  double get dayPnl;
  @JsonKey(name: 'day_pnl_pct')
  double get dayPnlPct;
  @JsonKey(name: 'total_margin_used')
  double get totalMarginUsed;
  @JsonKey(name: 'position_count')
  int get positionCount;

  /// Create a copy of PnlSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PnlSummaryCopyWith<PnlSummary> get copyWith =>
      _$PnlSummaryCopyWithImpl<PnlSummary>(this as PnlSummary, _$identity);

  /// Serializes this PnlSummary to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PnlSummary &&
            (identical(other.totalUnrealizedPnl, totalUnrealizedPnl) ||
                other.totalUnrealizedPnl == totalUnrealizedPnl) &&
            (identical(other.totalUnrealizedPnlPct, totalUnrealizedPnlPct) ||
                other.totalUnrealizedPnlPct == totalUnrealizedPnlPct) &&
            (identical(other.dayPnl, dayPnl) || other.dayPnl == dayPnl) &&
            (identical(other.dayPnlPct, dayPnlPct) ||
                other.dayPnlPct == dayPnlPct) &&
            (identical(other.totalMarginUsed, totalMarginUsed) ||
                other.totalMarginUsed == totalMarginUsed) &&
            (identical(other.positionCount, positionCount) ||
                other.positionCount == positionCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, totalUnrealizedPnl,
      totalUnrealizedPnlPct, dayPnl, dayPnlPct, totalMarginUsed, positionCount);

  @override
  String toString() {
    return 'PnlSummary(totalUnrealizedPnl: $totalUnrealizedPnl, totalUnrealizedPnlPct: $totalUnrealizedPnlPct, dayPnl: $dayPnl, dayPnlPct: $dayPnlPct, totalMarginUsed: $totalMarginUsed, positionCount: $positionCount)';
  }
}

/// @nodoc
abstract mixin class $PnlSummaryCopyWith<$Res> {
  factory $PnlSummaryCopyWith(
          PnlSummary value, $Res Function(PnlSummary) _then) =
      _$PnlSummaryCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(name: 'total_unrealized_pnl') double totalUnrealizedPnl,
      @JsonKey(name: 'total_unrealized_pnl_pct') double totalUnrealizedPnlPct,
      @JsonKey(name: 'day_pnl') double dayPnl,
      @JsonKey(name: 'day_pnl_pct') double dayPnlPct,
      @JsonKey(name: 'total_margin_used') double totalMarginUsed,
      @JsonKey(name: 'position_count') int positionCount});
}

/// @nodoc
class _$PnlSummaryCopyWithImpl<$Res> implements $PnlSummaryCopyWith<$Res> {
  _$PnlSummaryCopyWithImpl(this._self, this._then);

  final PnlSummary _self;
  final $Res Function(PnlSummary) _then;

  /// Create a copy of PnlSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalUnrealizedPnl = null,
    Object? totalUnrealizedPnlPct = null,
    Object? dayPnl = null,
    Object? dayPnlPct = null,
    Object? totalMarginUsed = null,
    Object? positionCount = null,
  }) {
    return _then(_self.copyWith(
      totalUnrealizedPnl: null == totalUnrealizedPnl
          ? _self.totalUnrealizedPnl
          : totalUnrealizedPnl // ignore: cast_nullable_to_non_nullable
              as double,
      totalUnrealizedPnlPct: null == totalUnrealizedPnlPct
          ? _self.totalUnrealizedPnlPct
          : totalUnrealizedPnlPct // ignore: cast_nullable_to_non_nullable
              as double,
      dayPnl: null == dayPnl
          ? _self.dayPnl
          : dayPnl // ignore: cast_nullable_to_non_nullable
              as double,
      dayPnlPct: null == dayPnlPct
          ? _self.dayPnlPct
          : dayPnlPct // ignore: cast_nullable_to_non_nullable
              as double,
      totalMarginUsed: null == totalMarginUsed
          ? _self.totalMarginUsed
          : totalMarginUsed // ignore: cast_nullable_to_non_nullable
              as double,
      positionCount: null == positionCount
          ? _self.positionCount
          : positionCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// Adds pattern-matching-related methods to [PnlSummary].
extension PnlSummaryPatterns on PnlSummary {
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
    TResult Function(_PnlSummary value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PnlSummary() when $default != null:
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
    TResult Function(_PnlSummary value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PnlSummary():
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
    TResult? Function(_PnlSummary value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PnlSummary() when $default != null:
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
            @JsonKey(name: 'total_unrealized_pnl') double totalUnrealizedPnl,
            @JsonKey(name: 'total_unrealized_pnl_pct')
            double totalUnrealizedPnlPct,
            @JsonKey(name: 'day_pnl') double dayPnl,
            @JsonKey(name: 'day_pnl_pct') double dayPnlPct,
            @JsonKey(name: 'total_margin_used') double totalMarginUsed,
            @JsonKey(name: 'position_count') int positionCount)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PnlSummary() when $default != null:
        return $default(
            _that.totalUnrealizedPnl,
            _that.totalUnrealizedPnlPct,
            _that.dayPnl,
            _that.dayPnlPct,
            _that.totalMarginUsed,
            _that.positionCount);
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
            @JsonKey(name: 'total_unrealized_pnl') double totalUnrealizedPnl,
            @JsonKey(name: 'total_unrealized_pnl_pct')
            double totalUnrealizedPnlPct,
            @JsonKey(name: 'day_pnl') double dayPnl,
            @JsonKey(name: 'day_pnl_pct') double dayPnlPct,
            @JsonKey(name: 'total_margin_used') double totalMarginUsed,
            @JsonKey(name: 'position_count') int positionCount)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PnlSummary():
        return $default(
            _that.totalUnrealizedPnl,
            _that.totalUnrealizedPnlPct,
            _that.dayPnl,
            _that.dayPnlPct,
            _that.totalMarginUsed,
            _that.positionCount);
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
            @JsonKey(name: 'total_unrealized_pnl') double totalUnrealizedPnl,
            @JsonKey(name: 'total_unrealized_pnl_pct')
            double totalUnrealizedPnlPct,
            @JsonKey(name: 'day_pnl') double dayPnl,
            @JsonKey(name: 'day_pnl_pct') double dayPnlPct,
            @JsonKey(name: 'total_margin_used') double totalMarginUsed,
            @JsonKey(name: 'position_count') int positionCount)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PnlSummary() when $default != null:
        return $default(
            _that.totalUnrealizedPnl,
            _that.totalUnrealizedPnlPct,
            _that.dayPnl,
            _that.dayPnlPct,
            _that.totalMarginUsed,
            _that.positionCount);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _PnlSummary implements PnlSummary {
  const _PnlSummary(
      {@JsonKey(name: 'total_unrealized_pnl') this.totalUnrealizedPnl = 0.0,
      @JsonKey(name: 'total_unrealized_pnl_pct')
      this.totalUnrealizedPnlPct = 0.0,
      @JsonKey(name: 'day_pnl') this.dayPnl = 0.0,
      @JsonKey(name: 'day_pnl_pct') this.dayPnlPct = 0.0,
      @JsonKey(name: 'total_margin_used') this.totalMarginUsed = 0.0,
      @JsonKey(name: 'position_count') this.positionCount = 0});
  factory _PnlSummary.fromJson(Map<String, dynamic> json) =>
      _$PnlSummaryFromJson(json);

  @override
  @JsonKey(name: 'total_unrealized_pnl')
  final double totalUnrealizedPnl;
  @override
  @JsonKey(name: 'total_unrealized_pnl_pct')
  final double totalUnrealizedPnlPct;
  @override
  @JsonKey(name: 'day_pnl')
  final double dayPnl;
  @override
  @JsonKey(name: 'day_pnl_pct')
  final double dayPnlPct;
  @override
  @JsonKey(name: 'total_margin_used')
  final double totalMarginUsed;
  @override
  @JsonKey(name: 'position_count')
  final int positionCount;

  /// Create a copy of PnlSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$PnlSummaryCopyWith<_PnlSummary> get copyWith =>
      __$PnlSummaryCopyWithImpl<_PnlSummary>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$PnlSummaryToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _PnlSummary &&
            (identical(other.totalUnrealizedPnl, totalUnrealizedPnl) ||
                other.totalUnrealizedPnl == totalUnrealizedPnl) &&
            (identical(other.totalUnrealizedPnlPct, totalUnrealizedPnlPct) ||
                other.totalUnrealizedPnlPct == totalUnrealizedPnlPct) &&
            (identical(other.dayPnl, dayPnl) || other.dayPnl == dayPnl) &&
            (identical(other.dayPnlPct, dayPnlPct) ||
                other.dayPnlPct == dayPnlPct) &&
            (identical(other.totalMarginUsed, totalMarginUsed) ||
                other.totalMarginUsed == totalMarginUsed) &&
            (identical(other.positionCount, positionCount) ||
                other.positionCount == positionCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, totalUnrealizedPnl,
      totalUnrealizedPnlPct, dayPnl, dayPnlPct, totalMarginUsed, positionCount);

  @override
  String toString() {
    return 'PnlSummary(totalUnrealizedPnl: $totalUnrealizedPnl, totalUnrealizedPnlPct: $totalUnrealizedPnlPct, dayPnl: $dayPnl, dayPnlPct: $dayPnlPct, totalMarginUsed: $totalMarginUsed, positionCount: $positionCount)';
  }
}

/// @nodoc
abstract mixin class _$PnlSummaryCopyWith<$Res>
    implements $PnlSummaryCopyWith<$Res> {
  factory _$PnlSummaryCopyWith(
          _PnlSummary value, $Res Function(_PnlSummary) _then) =
      __$PnlSummaryCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'total_unrealized_pnl') double totalUnrealizedPnl,
      @JsonKey(name: 'total_unrealized_pnl_pct') double totalUnrealizedPnlPct,
      @JsonKey(name: 'day_pnl') double dayPnl,
      @JsonKey(name: 'day_pnl_pct') double dayPnlPct,
      @JsonKey(name: 'total_margin_used') double totalMarginUsed,
      @JsonKey(name: 'position_count') int positionCount});
}

/// @nodoc
class __$PnlSummaryCopyWithImpl<$Res> implements _$PnlSummaryCopyWith<$Res> {
  __$PnlSummaryCopyWithImpl(this._self, this._then);

  final _PnlSummary _self;
  final $Res Function(_PnlSummary) _then;

  /// Create a copy of PnlSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? totalUnrealizedPnl = null,
    Object? totalUnrealizedPnlPct = null,
    Object? dayPnl = null,
    Object? dayPnlPct = null,
    Object? totalMarginUsed = null,
    Object? positionCount = null,
  }) {
    return _then(_PnlSummary(
      totalUnrealizedPnl: null == totalUnrealizedPnl
          ? _self.totalUnrealizedPnl
          : totalUnrealizedPnl // ignore: cast_nullable_to_non_nullable
              as double,
      totalUnrealizedPnlPct: null == totalUnrealizedPnlPct
          ? _self.totalUnrealizedPnlPct
          : totalUnrealizedPnlPct // ignore: cast_nullable_to_non_nullable
              as double,
      dayPnl: null == dayPnl
          ? _self.dayPnl
          : dayPnl // ignore: cast_nullable_to_non_nullable
              as double,
      dayPnlPct: null == dayPnlPct
          ? _self.dayPnlPct
          : dayPnlPct // ignore: cast_nullable_to_non_nullable
              as double,
      totalMarginUsed: null == totalMarginUsed
          ? _self.totalMarginUsed
          : totalMarginUsed // ignore: cast_nullable_to_non_nullable
              as double,
      positionCount: null == positionCount
          ? _self.positionCount
          : positionCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

// dart format on
