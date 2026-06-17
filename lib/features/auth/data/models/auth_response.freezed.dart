// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AuthResponse {
  String get token;
  AuthUser get user;
  @JsonKey(name: 'session_id', readValue: _readSessionId)
  String? get sessionId;

  /// Create a copy of AuthResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AuthResponseCopyWith<AuthResponse> get copyWith =>
      _$AuthResponseCopyWithImpl<AuthResponse>(
          this as AuthResponse, _$identity);

  /// Serializes this AuthResponse to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AuthResponse &&
            (identical(other.token, token) || other.token == token) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, token, user, sessionId);

  @override
  String toString() {
    return 'AuthResponse(token: $token, user: $user, sessionId: $sessionId)';
  }
}

/// @nodoc
abstract mixin class $AuthResponseCopyWith<$Res> {
  factory $AuthResponseCopyWith(
          AuthResponse value, $Res Function(AuthResponse) _then) =
      _$AuthResponseCopyWithImpl;
  @useResult
  $Res call(
      {String token,
      AuthUser user,
      @JsonKey(name: 'session_id', readValue: _readSessionId)
      String? sessionId});

  $AuthUserCopyWith<$Res> get user;
}

/// @nodoc
class _$AuthResponseCopyWithImpl<$Res> implements $AuthResponseCopyWith<$Res> {
  _$AuthResponseCopyWithImpl(this._self, this._then);

  final AuthResponse _self;
  final $Res Function(AuthResponse) _then;

  /// Create a copy of AuthResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? token = null,
    Object? user = null,
    Object? sessionId = freezed,
  }) {
    return _then(_self.copyWith(
      token: null == token
          ? _self.token
          : token // ignore: cast_nullable_to_non_nullable
              as String,
      user: null == user
          ? _self.user
          : user // ignore: cast_nullable_to_non_nullable
              as AuthUser,
      sessionId: freezed == sessionId
          ? _self.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }

  /// Create a copy of AuthResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AuthUserCopyWith<$Res> get user {
    return $AuthUserCopyWith<$Res>(_self.user, (value) {
      return _then(_self.copyWith(user: value));
    });
  }
}

/// Adds pattern-matching-related methods to [AuthResponse].
extension AuthResponsePatterns on AuthResponse {
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
    TResult Function(_AuthResponse value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AuthResponse() when $default != null:
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
    TResult Function(_AuthResponse value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AuthResponse():
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
    TResult? Function(_AuthResponse value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AuthResponse() when $default != null:
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
            String token,
            AuthUser user,
            @JsonKey(name: 'session_id', readValue: _readSessionId)
            String? sessionId)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AuthResponse() when $default != null:
        return $default(_that.token, _that.user, _that.sessionId);
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
            String token,
            AuthUser user,
            @JsonKey(name: 'session_id', readValue: _readSessionId)
            String? sessionId)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AuthResponse():
        return $default(_that.token, _that.user, _that.sessionId);
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
            String token,
            AuthUser user,
            @JsonKey(name: 'session_id', readValue: _readSessionId)
            String? sessionId)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AuthResponse() when $default != null:
        return $default(_that.token, _that.user, _that.sessionId);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _AuthResponse implements AuthResponse {
  const _AuthResponse(
      {required this.token,
      required this.user,
      @JsonKey(name: 'session_id', readValue: _readSessionId) this.sessionId});
  factory _AuthResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseFromJson(json);

  @override
  final String token;
  @override
  final AuthUser user;
  @override
  @JsonKey(name: 'session_id', readValue: _readSessionId)
  final String? sessionId;

  /// Create a copy of AuthResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$AuthResponseCopyWith<_AuthResponse> get copyWith =>
      __$AuthResponseCopyWithImpl<_AuthResponse>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$AuthResponseToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AuthResponse &&
            (identical(other.token, token) || other.token == token) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, token, user, sessionId);

  @override
  String toString() {
    return 'AuthResponse(token: $token, user: $user, sessionId: $sessionId)';
  }
}

/// @nodoc
abstract mixin class _$AuthResponseCopyWith<$Res>
    implements $AuthResponseCopyWith<$Res> {
  factory _$AuthResponseCopyWith(
          _AuthResponse value, $Res Function(_AuthResponse) _then) =
      __$AuthResponseCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String token,
      AuthUser user,
      @JsonKey(name: 'session_id', readValue: _readSessionId)
      String? sessionId});

  @override
  $AuthUserCopyWith<$Res> get user;
}

/// @nodoc
class __$AuthResponseCopyWithImpl<$Res>
    implements _$AuthResponseCopyWith<$Res> {
  __$AuthResponseCopyWithImpl(this._self, this._then);

  final _AuthResponse _self;
  final $Res Function(_AuthResponse) _then;

  /// Create a copy of AuthResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? token = null,
    Object? user = null,
    Object? sessionId = freezed,
  }) {
    return _then(_AuthResponse(
      token: null == token
          ? _self.token
          : token // ignore: cast_nullable_to_non_nullable
              as String,
      user: null == user
          ? _self.user
          : user // ignore: cast_nullable_to_non_nullable
              as AuthUser,
      sessionId: freezed == sessionId
          ? _self.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }

  /// Create a copy of AuthResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AuthUserCopyWith<$Res> get user {
    return $AuthUserCopyWith<$Res>(_self.user, (value) {
      return _then(_self.copyWith(user: value));
    });
  }
}

/// @nodoc
mixin _$AuthUser {
  String get id;
  String get email;
  @JsonKey(name: 'full_name', readValue: _readFullName)
  String get fullName;
  @JsonKey(name: 'email_verified')
  bool get emailVerified;
  @JsonKey(name: 'is_admin')
  bool get isAdmin;
  @JsonKey(name: 'totp_enabled')
  bool get totpEnabled;
  @JsonKey(
      name: 'has_exchange_connection', readValue: _readHasExchangeConnection)
  bool get hasExchangeConnection;
  @JsonKey(fromJson: _readSubscription, toJson: _writeSubscription)
  BillingSubscription get subscription;

  /// Create a copy of AuthUser
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AuthUserCopyWith<AuthUser> get copyWith =>
      _$AuthUserCopyWithImpl<AuthUser>(this as AuthUser, _$identity);

  /// Serializes this AuthUser to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AuthUser &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.emailVerified, emailVerified) ||
                other.emailVerified == emailVerified) &&
            (identical(other.isAdmin, isAdmin) || other.isAdmin == isAdmin) &&
            (identical(other.totpEnabled, totpEnabled) ||
                other.totpEnabled == totpEnabled) &&
            (identical(other.hasExchangeConnection, hasExchangeConnection) ||
                other.hasExchangeConnection == hasExchangeConnection) &&
            (identical(other.subscription, subscription) ||
                other.subscription == subscription));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, email, fullName,
      emailVerified, isAdmin, totpEnabled, hasExchangeConnection, subscription);

  @override
  String toString() {
    return 'AuthUser(id: $id, email: $email, fullName: $fullName, emailVerified: $emailVerified, isAdmin: $isAdmin, totpEnabled: $totpEnabled, hasExchangeConnection: $hasExchangeConnection, subscription: $subscription)';
  }
}

/// @nodoc
abstract mixin class $AuthUserCopyWith<$Res> {
  factory $AuthUserCopyWith(AuthUser value, $Res Function(AuthUser) _then) =
      _$AuthUserCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String email,
      @JsonKey(name: 'full_name', readValue: _readFullName) String fullName,
      @JsonKey(name: 'email_verified') bool emailVerified,
      @JsonKey(name: 'is_admin') bool isAdmin,
      @JsonKey(name: 'totp_enabled') bool totpEnabled,
      @JsonKey(
          name: 'has_exchange_connection',
          readValue: _readHasExchangeConnection)
      bool hasExchangeConnection,
      @JsonKey(fromJson: _readSubscription, toJson: _writeSubscription)
      BillingSubscription subscription});
}

/// @nodoc
class _$AuthUserCopyWithImpl<$Res> implements $AuthUserCopyWith<$Res> {
  _$AuthUserCopyWithImpl(this._self, this._then);

  final AuthUser _self;
  final $Res Function(AuthUser) _then;

  /// Create a copy of AuthUser
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = null,
    Object? fullName = null,
    Object? emailVerified = null,
    Object? isAdmin = null,
    Object? totpEnabled = null,
    Object? hasExchangeConnection = null,
    Object? subscription = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _self.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      fullName: null == fullName
          ? _self.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String,
      emailVerified: null == emailVerified
          ? _self.emailVerified
          : emailVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      isAdmin: null == isAdmin
          ? _self.isAdmin
          : isAdmin // ignore: cast_nullable_to_non_nullable
              as bool,
      totpEnabled: null == totpEnabled
          ? _self.totpEnabled
          : totpEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      hasExchangeConnection: null == hasExchangeConnection
          ? _self.hasExchangeConnection
          : hasExchangeConnection // ignore: cast_nullable_to_non_nullable
              as bool,
      subscription: null == subscription
          ? _self.subscription
          : subscription // ignore: cast_nullable_to_non_nullable
              as BillingSubscription,
    ));
  }
}

/// Adds pattern-matching-related methods to [AuthUser].
extension AuthUserPatterns on AuthUser {
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
    TResult Function(_AuthUser value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AuthUser() when $default != null:
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
    TResult Function(_AuthUser value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AuthUser():
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
    TResult? Function(_AuthUser value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AuthUser() when $default != null:
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
            String email,
            @JsonKey(name: 'full_name', readValue: _readFullName)
            String fullName,
            @JsonKey(name: 'email_verified') bool emailVerified,
            @JsonKey(name: 'is_admin') bool isAdmin,
            @JsonKey(name: 'totp_enabled') bool totpEnabled,
            @JsonKey(
                name: 'has_exchange_connection',
                readValue: _readHasExchangeConnection)
            bool hasExchangeConnection,
            @JsonKey(fromJson: _readSubscription, toJson: _writeSubscription)
            BillingSubscription subscription)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AuthUser() when $default != null:
        return $default(
            _that.id,
            _that.email,
            _that.fullName,
            _that.emailVerified,
            _that.isAdmin,
            _that.totpEnabled,
            _that.hasExchangeConnection,
            _that.subscription);
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
            String email,
            @JsonKey(name: 'full_name', readValue: _readFullName)
            String fullName,
            @JsonKey(name: 'email_verified') bool emailVerified,
            @JsonKey(name: 'is_admin') bool isAdmin,
            @JsonKey(name: 'totp_enabled') bool totpEnabled,
            @JsonKey(
                name: 'has_exchange_connection',
                readValue: _readHasExchangeConnection)
            bool hasExchangeConnection,
            @JsonKey(fromJson: _readSubscription, toJson: _writeSubscription)
            BillingSubscription subscription)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AuthUser():
        return $default(
            _that.id,
            _that.email,
            _that.fullName,
            _that.emailVerified,
            _that.isAdmin,
            _that.totpEnabled,
            _that.hasExchangeConnection,
            _that.subscription);
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
            String email,
            @JsonKey(name: 'full_name', readValue: _readFullName)
            String fullName,
            @JsonKey(name: 'email_verified') bool emailVerified,
            @JsonKey(name: 'is_admin') bool isAdmin,
            @JsonKey(name: 'totp_enabled') bool totpEnabled,
            @JsonKey(
                name: 'has_exchange_connection',
                readValue: _readHasExchangeConnection)
            bool hasExchangeConnection,
            @JsonKey(fromJson: _readSubscription, toJson: _writeSubscription)
            BillingSubscription subscription)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AuthUser() when $default != null:
        return $default(
            _that.id,
            _that.email,
            _that.fullName,
            _that.emailVerified,
            _that.isAdmin,
            _that.totpEnabled,
            _that.hasExchangeConnection,
            _that.subscription);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _AuthUser implements AuthUser {
  const _AuthUser(
      {required this.id,
      required this.email,
      @JsonKey(name: 'full_name', readValue: _readFullName) this.fullName = '',
      @JsonKey(name: 'email_verified') this.emailVerified = false,
      @JsonKey(name: 'is_admin') this.isAdmin = false,
      @JsonKey(name: 'totp_enabled') this.totpEnabled = false,
      @JsonKey(
          name: 'has_exchange_connection',
          readValue: _readHasExchangeConnection)
      this.hasExchangeConnection = false,
      @JsonKey(fromJson: _readSubscription, toJson: _writeSubscription)
      this.subscription = BillingSubscription.none});
  factory _AuthUser.fromJson(Map<String, dynamic> json) =>
      _$AuthUserFromJson(json);

  @override
  final String id;
  @override
  final String email;
  @override
  @JsonKey(name: 'full_name', readValue: _readFullName)
  final String fullName;
  @override
  @JsonKey(name: 'email_verified')
  final bool emailVerified;
  @override
  @JsonKey(name: 'is_admin')
  final bool isAdmin;
  @override
  @JsonKey(name: 'totp_enabled')
  final bool totpEnabled;
  @override
  @JsonKey(
      name: 'has_exchange_connection', readValue: _readHasExchangeConnection)
  final bool hasExchangeConnection;
  @override
  @JsonKey(fromJson: _readSubscription, toJson: _writeSubscription)
  final BillingSubscription subscription;

  /// Create a copy of AuthUser
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$AuthUserCopyWith<_AuthUser> get copyWith =>
      __$AuthUserCopyWithImpl<_AuthUser>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$AuthUserToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AuthUser &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.emailVerified, emailVerified) ||
                other.emailVerified == emailVerified) &&
            (identical(other.isAdmin, isAdmin) || other.isAdmin == isAdmin) &&
            (identical(other.totpEnabled, totpEnabled) ||
                other.totpEnabled == totpEnabled) &&
            (identical(other.hasExchangeConnection, hasExchangeConnection) ||
                other.hasExchangeConnection == hasExchangeConnection) &&
            (identical(other.subscription, subscription) ||
                other.subscription == subscription));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, email, fullName,
      emailVerified, isAdmin, totpEnabled, hasExchangeConnection, subscription);

  @override
  String toString() {
    return 'AuthUser(id: $id, email: $email, fullName: $fullName, emailVerified: $emailVerified, isAdmin: $isAdmin, totpEnabled: $totpEnabled, hasExchangeConnection: $hasExchangeConnection, subscription: $subscription)';
  }
}

/// @nodoc
abstract mixin class _$AuthUserCopyWith<$Res>
    implements $AuthUserCopyWith<$Res> {
  factory _$AuthUserCopyWith(_AuthUser value, $Res Function(_AuthUser) _then) =
      __$AuthUserCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String email,
      @JsonKey(name: 'full_name', readValue: _readFullName) String fullName,
      @JsonKey(name: 'email_verified') bool emailVerified,
      @JsonKey(name: 'is_admin') bool isAdmin,
      @JsonKey(name: 'totp_enabled') bool totpEnabled,
      @JsonKey(
          name: 'has_exchange_connection',
          readValue: _readHasExchangeConnection)
      bool hasExchangeConnection,
      @JsonKey(fromJson: _readSubscription, toJson: _writeSubscription)
      BillingSubscription subscription});
}

/// @nodoc
class __$AuthUserCopyWithImpl<$Res> implements _$AuthUserCopyWith<$Res> {
  __$AuthUserCopyWithImpl(this._self, this._then);

  final _AuthUser _self;
  final $Res Function(_AuthUser) _then;

  /// Create a copy of AuthUser
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? email = null,
    Object? fullName = null,
    Object? emailVerified = null,
    Object? isAdmin = null,
    Object? totpEnabled = null,
    Object? hasExchangeConnection = null,
    Object? subscription = null,
  }) {
    return _then(_AuthUser(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _self.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      fullName: null == fullName
          ? _self.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String,
      emailVerified: null == emailVerified
          ? _self.emailVerified
          : emailVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      isAdmin: null == isAdmin
          ? _self.isAdmin
          : isAdmin // ignore: cast_nullable_to_non_nullable
              as bool,
      totpEnabled: null == totpEnabled
          ? _self.totpEnabled
          : totpEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      hasExchangeConnection: null == hasExchangeConnection
          ? _self.hasExchangeConnection
          : hasExchangeConnection // ignore: cast_nullable_to_non_nullable
              as bool,
      subscription: null == subscription
          ? _self.subscription
          : subscription // ignore: cast_nullable_to_non_nullable
              as BillingSubscription,
    ));
  }
}

// dart format on
