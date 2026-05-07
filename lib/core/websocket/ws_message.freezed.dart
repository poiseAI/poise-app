// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ws_message.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
WsMessage _$WsMessageFromJson(Map<String, dynamic> json) {
  switch (json['runtimeType']) {
    case 'connected':
      return WsConnected.fromJson(json);
    case 'disconnected':
      return WsDisconnected.fromJson(json);
    case 'orderUpdate':
      return WsOrderUpdate.fromJson(json);
    case 'positionUpdate':
      return WsPositionUpdate.fromJson(json);
    case 'tokenScore':
      return WsTokenScore.fromJson(json);
    case 'error':
      return WsError.fromJson(json);

    default:
      throw CheckedFromJsonException(json, 'runtimeType', 'WsMessage',
          'Invalid union type "${json['runtimeType']}"!');
  }
}

/// @nodoc
mixin _$WsMessage {
  /// Serializes this WsMessage to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is WsMessage);
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'WsMessage()';
  }
}

/// @nodoc
class $WsMessageCopyWith<$Res> {
  $WsMessageCopyWith(WsMessage _, $Res Function(WsMessage) __);
}

/// Adds pattern-matching-related methods to [WsMessage].
extension WsMessagePatterns on WsMessage {
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
  TResult maybeMap<TResult extends Object?>({
    TResult Function(WsConnected value)? connected,
    TResult Function(WsDisconnected value)? disconnected,
    TResult Function(WsOrderUpdate value)? orderUpdate,
    TResult Function(WsPositionUpdate value)? positionUpdate,
    TResult Function(WsTokenScore value)? tokenScore,
    TResult Function(WsError value)? error,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case WsConnected() when connected != null:
        return connected(_that);
      case WsDisconnected() when disconnected != null:
        return disconnected(_that);
      case WsOrderUpdate() when orderUpdate != null:
        return orderUpdate(_that);
      case WsPositionUpdate() when positionUpdate != null:
        return positionUpdate(_that);
      case WsTokenScore() when tokenScore != null:
        return tokenScore(_that);
      case WsError() when error != null:
        return error(_that);
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
  TResult map<TResult extends Object?>({
    required TResult Function(WsConnected value) connected,
    required TResult Function(WsDisconnected value) disconnected,
    required TResult Function(WsOrderUpdate value) orderUpdate,
    required TResult Function(WsPositionUpdate value) positionUpdate,
    required TResult Function(WsTokenScore value) tokenScore,
    required TResult Function(WsError value) error,
  }) {
    final _that = this;
    switch (_that) {
      case WsConnected():
        return connected(_that);
      case WsDisconnected():
        return disconnected(_that);
      case WsOrderUpdate():
        return orderUpdate(_that);
      case WsPositionUpdate():
        return positionUpdate(_that);
      case WsTokenScore():
        return tokenScore(_that);
      case WsError():
        return error(_that);
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
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(WsConnected value)? connected,
    TResult? Function(WsDisconnected value)? disconnected,
    TResult? Function(WsOrderUpdate value)? orderUpdate,
    TResult? Function(WsPositionUpdate value)? positionUpdate,
    TResult? Function(WsTokenScore value)? tokenScore,
    TResult? Function(WsError value)? error,
  }) {
    final _that = this;
    switch (_that) {
      case WsConnected() when connected != null:
        return connected(_that);
      case WsDisconnected() when disconnected != null:
        return disconnected(_that);
      case WsOrderUpdate() when orderUpdate != null:
        return orderUpdate(_that);
      case WsPositionUpdate() when positionUpdate != null:
        return positionUpdate(_that);
      case WsTokenScore() when tokenScore != null:
        return tokenScore(_that);
      case WsError() when error != null:
        return error(_that);
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
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? connected,
    TResult Function()? disconnected,
    TResult Function(String orderId, String status, Map<String, dynamic> data)?
        orderUpdate,
    TResult Function(String positionId, Map<String, dynamic> data)?
        positionUpdate,
    TResult Function(String symbol, double score, String riskLevel)? tokenScore,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case WsConnected() when connected != null:
        return connected();
      case WsDisconnected() when disconnected != null:
        return disconnected();
      case WsOrderUpdate() when orderUpdate != null:
        return orderUpdate(_that.orderId, _that.status, _that.data);
      case WsPositionUpdate() when positionUpdate != null:
        return positionUpdate(_that.positionId, _that.data);
      case WsTokenScore() when tokenScore != null:
        return tokenScore(_that.symbol, _that.score, _that.riskLevel);
      case WsError() when error != null:
        return error(_that.message);
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
  TResult when<TResult extends Object?>({
    required TResult Function() connected,
    required TResult Function() disconnected,
    required TResult Function(
            String orderId, String status, Map<String, dynamic> data)
        orderUpdate,
    required TResult Function(String positionId, Map<String, dynamic> data)
        positionUpdate,
    required TResult Function(String symbol, double score, String riskLevel)
        tokenScore,
    required TResult Function(String message) error,
  }) {
    final _that = this;
    switch (_that) {
      case WsConnected():
        return connected();
      case WsDisconnected():
        return disconnected();
      case WsOrderUpdate():
        return orderUpdate(_that.orderId, _that.status, _that.data);
      case WsPositionUpdate():
        return positionUpdate(_that.positionId, _that.data);
      case WsTokenScore():
        return tokenScore(_that.symbol, _that.score, _that.riskLevel);
      case WsError():
        return error(_that.message);
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
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? connected,
    TResult? Function()? disconnected,
    TResult? Function(String orderId, String status, Map<String, dynamic> data)?
        orderUpdate,
    TResult? Function(String positionId, Map<String, dynamic> data)?
        positionUpdate,
    TResult? Function(String symbol, double score, String riskLevel)?
        tokenScore,
    TResult? Function(String message)? error,
  }) {
    final _that = this;
    switch (_that) {
      case WsConnected() when connected != null:
        return connected();
      case WsDisconnected() when disconnected != null:
        return disconnected();
      case WsOrderUpdate() when orderUpdate != null:
        return orderUpdate(_that.orderId, _that.status, _that.data);
      case WsPositionUpdate() when positionUpdate != null:
        return positionUpdate(_that.positionId, _that.data);
      case WsTokenScore() when tokenScore != null:
        return tokenScore(_that.symbol, _that.score, _that.riskLevel);
      case WsError() when error != null:
        return error(_that.message);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class WsConnected implements WsMessage {
  const WsConnected({final String? $type}) : $type = $type ?? 'connected';
  factory WsConnected.fromJson(Map<String, dynamic> json) =>
      _$WsConnectedFromJson(json);

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  Map<String, dynamic> toJson() {
    return _$WsConnectedToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is WsConnected);
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'WsMessage.connected()';
  }
}

/// @nodoc
@JsonSerializable()
class WsDisconnected implements WsMessage {
  const WsDisconnected({final String? $type}) : $type = $type ?? 'disconnected';
  factory WsDisconnected.fromJson(Map<String, dynamic> json) =>
      _$WsDisconnectedFromJson(json);

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  Map<String, dynamic> toJson() {
    return _$WsDisconnectedToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is WsDisconnected);
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'WsMessage.disconnected()';
  }
}

/// @nodoc
@JsonSerializable()
class WsOrderUpdate implements WsMessage {
  const WsOrderUpdate(
      {required this.orderId,
      required this.status,
      required final Map<String, dynamic> data,
      final String? $type})
      : _data = data,
        $type = $type ?? 'orderUpdate';
  factory WsOrderUpdate.fromJson(Map<String, dynamic> json) =>
      _$WsOrderUpdateFromJson(json);

  final String orderId;
  final String status;
  final Map<String, dynamic> _data;
  Map<String, dynamic> get data {
    if (_data is EqualUnmodifiableMapView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_data);
  }

  @JsonKey(name: 'runtimeType')
  final String $type;

  /// Create a copy of WsMessage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $WsOrderUpdateCopyWith<WsOrderUpdate> get copyWith =>
      _$WsOrderUpdateCopyWithImpl<WsOrderUpdate>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$WsOrderUpdateToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is WsOrderUpdate &&
            (identical(other.orderId, orderId) || other.orderId == orderId) &&
            (identical(other.status, status) || other.status == status) &&
            const DeepCollectionEquality().equals(other._data, _data));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, orderId, status, const DeepCollectionEquality().hash(_data));

  @override
  String toString() {
    return 'WsMessage.orderUpdate(orderId: $orderId, status: $status, data: $data)';
  }
}

/// @nodoc
abstract mixin class $WsOrderUpdateCopyWith<$Res>
    implements $WsMessageCopyWith<$Res> {
  factory $WsOrderUpdateCopyWith(
          WsOrderUpdate value, $Res Function(WsOrderUpdate) _then) =
      _$WsOrderUpdateCopyWithImpl;
  @useResult
  $Res call({String orderId, String status, Map<String, dynamic> data});
}

/// @nodoc
class _$WsOrderUpdateCopyWithImpl<$Res>
    implements $WsOrderUpdateCopyWith<$Res> {
  _$WsOrderUpdateCopyWithImpl(this._self, this._then);

  final WsOrderUpdate _self;
  final $Res Function(WsOrderUpdate) _then;

  /// Create a copy of WsMessage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? orderId = null,
    Object? status = null,
    Object? data = null,
  }) {
    return _then(WsOrderUpdate(
      orderId: null == orderId
          ? _self.orderId
          : orderId // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      data: null == data
          ? _self._data
          : data // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class WsPositionUpdate implements WsMessage {
  const WsPositionUpdate(
      {required this.positionId,
      required final Map<String, dynamic> data,
      final String? $type})
      : _data = data,
        $type = $type ?? 'positionUpdate';
  factory WsPositionUpdate.fromJson(Map<String, dynamic> json) =>
      _$WsPositionUpdateFromJson(json);

  final String positionId;
  final Map<String, dynamic> _data;
  Map<String, dynamic> get data {
    if (_data is EqualUnmodifiableMapView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_data);
  }

  @JsonKey(name: 'runtimeType')
  final String $type;

  /// Create a copy of WsMessage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $WsPositionUpdateCopyWith<WsPositionUpdate> get copyWith =>
      _$WsPositionUpdateCopyWithImpl<WsPositionUpdate>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$WsPositionUpdateToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is WsPositionUpdate &&
            (identical(other.positionId, positionId) ||
                other.positionId == positionId) &&
            const DeepCollectionEquality().equals(other._data, _data));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, positionId, const DeepCollectionEquality().hash(_data));

  @override
  String toString() {
    return 'WsMessage.positionUpdate(positionId: $positionId, data: $data)';
  }
}

/// @nodoc
abstract mixin class $WsPositionUpdateCopyWith<$Res>
    implements $WsMessageCopyWith<$Res> {
  factory $WsPositionUpdateCopyWith(
          WsPositionUpdate value, $Res Function(WsPositionUpdate) _then) =
      _$WsPositionUpdateCopyWithImpl;
  @useResult
  $Res call({String positionId, Map<String, dynamic> data});
}

/// @nodoc
class _$WsPositionUpdateCopyWithImpl<$Res>
    implements $WsPositionUpdateCopyWith<$Res> {
  _$WsPositionUpdateCopyWithImpl(this._self, this._then);

  final WsPositionUpdate _self;
  final $Res Function(WsPositionUpdate) _then;

  /// Create a copy of WsMessage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? positionId = null,
    Object? data = null,
  }) {
    return _then(WsPositionUpdate(
      positionId: null == positionId
          ? _self.positionId
          : positionId // ignore: cast_nullable_to_non_nullable
              as String,
      data: null == data
          ? _self._data
          : data // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class WsTokenScore implements WsMessage {
  const WsTokenScore(
      {required this.symbol,
      required this.score,
      required this.riskLevel,
      final String? $type})
      : $type = $type ?? 'tokenScore';
  factory WsTokenScore.fromJson(Map<String, dynamic> json) =>
      _$WsTokenScoreFromJson(json);

  final String symbol;
  final double score;
  final String riskLevel;

  @JsonKey(name: 'runtimeType')
  final String $type;

  /// Create a copy of WsMessage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $WsTokenScoreCopyWith<WsTokenScore> get copyWith =>
      _$WsTokenScoreCopyWithImpl<WsTokenScore>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$WsTokenScoreToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is WsTokenScore &&
            (identical(other.symbol, symbol) || other.symbol == symbol) &&
            (identical(other.score, score) || other.score == score) &&
            (identical(other.riskLevel, riskLevel) ||
                other.riskLevel == riskLevel));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, symbol, score, riskLevel);

  @override
  String toString() {
    return 'WsMessage.tokenScore(symbol: $symbol, score: $score, riskLevel: $riskLevel)';
  }
}

/// @nodoc
abstract mixin class $WsTokenScoreCopyWith<$Res>
    implements $WsMessageCopyWith<$Res> {
  factory $WsTokenScoreCopyWith(
          WsTokenScore value, $Res Function(WsTokenScore) _then) =
      _$WsTokenScoreCopyWithImpl;
  @useResult
  $Res call({String symbol, double score, String riskLevel});
}

/// @nodoc
class _$WsTokenScoreCopyWithImpl<$Res> implements $WsTokenScoreCopyWith<$Res> {
  _$WsTokenScoreCopyWithImpl(this._self, this._then);

  final WsTokenScore _self;
  final $Res Function(WsTokenScore) _then;

  /// Create a copy of WsMessage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? symbol = null,
    Object? score = null,
    Object? riskLevel = null,
  }) {
    return _then(WsTokenScore(
      symbol: null == symbol
          ? _self.symbol
          : symbol // ignore: cast_nullable_to_non_nullable
              as String,
      score: null == score
          ? _self.score
          : score // ignore: cast_nullable_to_non_nullable
              as double,
      riskLevel: null == riskLevel
          ? _self.riskLevel
          : riskLevel // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class WsError implements WsMessage {
  const WsError(this.message, {final String? $type}) : $type = $type ?? 'error';
  factory WsError.fromJson(Map<String, dynamic> json) =>
      _$WsErrorFromJson(json);

  final String message;

  @JsonKey(name: 'runtimeType')
  final String $type;

  /// Create a copy of WsMessage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $WsErrorCopyWith<WsError> get copyWith =>
      _$WsErrorCopyWithImpl<WsError>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$WsErrorToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is WsError &&
            (identical(other.message, message) || other.message == message));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, message);

  @override
  String toString() {
    return 'WsMessage.error(message: $message)';
  }
}

/// @nodoc
abstract mixin class $WsErrorCopyWith<$Res>
    implements $WsMessageCopyWith<$Res> {
  factory $WsErrorCopyWith(WsError value, $Res Function(WsError) _then) =
      _$WsErrorCopyWithImpl;
  @useResult
  $Res call({String message});
}

/// @nodoc
class _$WsErrorCopyWithImpl<$Res> implements $WsErrorCopyWith<$Res> {
  _$WsErrorCopyWithImpl(this._self, this._then);

  final WsError _self;
  final $Res Function(WsError) _then;

  /// Create a copy of WsMessage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? message = null,
  }) {
    return _then(WsError(
      null == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
