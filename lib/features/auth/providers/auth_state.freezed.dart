// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AuthState {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is AuthState);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'AuthState()';
  }
}

/// @nodoc
class $AuthStateCopyWith<$Res> {
  $AuthStateCopyWith(AuthState _, $Res Function(AuthState) __);
}

/// Adds pattern-matching-related methods to [AuthState].
extension AuthStatePatterns on AuthState {
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
    TResult Function(AuthLoading value)? loading,
    TResult Function(AuthUnauthenticated value)? unauthenticated,
    TResult Function(AuthAuthenticated value)? authenticated,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case AuthLoading() when loading != null:
        return loading(_that);
      case AuthUnauthenticated() when unauthenticated != null:
        return unauthenticated(_that);
      case AuthAuthenticated() when authenticated != null:
        return authenticated(_that);
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
    required TResult Function(AuthLoading value) loading,
    required TResult Function(AuthUnauthenticated value) unauthenticated,
    required TResult Function(AuthAuthenticated value) authenticated,
  }) {
    final _that = this;
    switch (_that) {
      case AuthLoading():
        return loading(_that);
      case AuthUnauthenticated():
        return unauthenticated(_that);
      case AuthAuthenticated():
        return authenticated(_that);
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
    TResult? Function(AuthLoading value)? loading,
    TResult? Function(AuthUnauthenticated value)? unauthenticated,
    TResult? Function(AuthAuthenticated value)? authenticated,
  }) {
    final _that = this;
    switch (_that) {
      case AuthLoading() when loading != null:
        return loading(_that);
      case AuthUnauthenticated() when unauthenticated != null:
        return unauthenticated(_that);
      case AuthAuthenticated() when authenticated != null:
        return authenticated(_that);
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
    TResult Function()? loading,
    TResult Function()? unauthenticated,
    TResult Function(
            String userId,
            String email,
            String token,
            String fullName,
            bool emailVerified,
            bool isAdmin,
            bool totpEnabled,
            bool hasActiveStrategy)?
        authenticated,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case AuthLoading() when loading != null:
        return loading();
      case AuthUnauthenticated() when unauthenticated != null:
        return unauthenticated();
      case AuthAuthenticated() when authenticated != null:
        return authenticated(
            _that.userId,
            _that.email,
            _that.token,
            _that.fullName,
            _that.emailVerified,
            _that.isAdmin,
            _that.totpEnabled,
            _that.hasActiveStrategy);
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
    required TResult Function() loading,
    required TResult Function() unauthenticated,
    required TResult Function(
            String userId,
            String email,
            String token,
            String fullName,
            bool emailVerified,
            bool isAdmin,
            bool totpEnabled,
            bool hasActiveStrategy)
        authenticated,
  }) {
    final _that = this;
    switch (_that) {
      case AuthLoading():
        return loading();
      case AuthUnauthenticated():
        return unauthenticated();
      case AuthAuthenticated():
        return authenticated(
            _that.userId,
            _that.email,
            _that.token,
            _that.fullName,
            _that.emailVerified,
            _that.isAdmin,
            _that.totpEnabled,
            _that.hasActiveStrategy);
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
    TResult? Function()? loading,
    TResult? Function()? unauthenticated,
    TResult? Function(
            String userId,
            String email,
            String token,
            String fullName,
            bool emailVerified,
            bool isAdmin,
            bool totpEnabled,
            bool hasActiveStrategy)?
        authenticated,
  }) {
    final _that = this;
    switch (_that) {
      case AuthLoading() when loading != null:
        return loading();
      case AuthUnauthenticated() when unauthenticated != null:
        return unauthenticated();
      case AuthAuthenticated() when authenticated != null:
        return authenticated(
            _that.userId,
            _that.email,
            _that.token,
            _that.fullName,
            _that.emailVerified,
            _that.isAdmin,
            _that.totpEnabled,
            _that.hasActiveStrategy);
      case _:
        return null;
    }
  }
}

/// @nodoc

class AuthLoading implements AuthState {
  const AuthLoading();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is AuthLoading);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'AuthState.loading()';
  }
}

/// @nodoc

class AuthUnauthenticated implements AuthState {
  const AuthUnauthenticated();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is AuthUnauthenticated);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'AuthState.unauthenticated()';
  }
}

/// @nodoc

class AuthAuthenticated implements AuthState {
  const AuthAuthenticated(
      {required this.userId,
      required this.email,
      required this.token,
      this.fullName = '',
      this.emailVerified = false,
      this.isAdmin = false,
      this.totpEnabled = false,
      this.hasActiveStrategy = false});

  final String userId;
  final String email;
  final String token;
  @JsonKey()
  final String fullName;
  @JsonKey()
  final bool emailVerified;
  @JsonKey()
  final bool isAdmin;
  @JsonKey()
  final bool totpEnabled;
  @JsonKey()
  final bool hasActiveStrategy;

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AuthAuthenticatedCopyWith<AuthAuthenticated> get copyWith =>
      _$AuthAuthenticatedCopyWithImpl<AuthAuthenticated>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AuthAuthenticated &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.token, token) || other.token == token) &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.emailVerified, emailVerified) ||
                other.emailVerified == emailVerified) &&
            (identical(other.isAdmin, isAdmin) || other.isAdmin == isAdmin) &&
            (identical(other.totpEnabled, totpEnabled) ||
                other.totpEnabled == totpEnabled) &&
            (identical(other.hasActiveStrategy, hasActiveStrategy) ||
                other.hasActiveStrategy == hasActiveStrategy));
  }

  @override
  int get hashCode => Object.hash(runtimeType, userId, email, token, fullName,
      emailVerified, isAdmin, totpEnabled, hasActiveStrategy);

  @override
  String toString() {
    return 'AuthState.authenticated(userId: $userId, email: $email, token: $token, fullName: $fullName, emailVerified: $emailVerified, isAdmin: $isAdmin, totpEnabled: $totpEnabled, hasActiveStrategy: $hasActiveStrategy)';
  }
}

/// @nodoc
abstract mixin class $AuthAuthenticatedCopyWith<$Res>
    implements $AuthStateCopyWith<$Res> {
  factory $AuthAuthenticatedCopyWith(
          AuthAuthenticated value, $Res Function(AuthAuthenticated) _then) =
      _$AuthAuthenticatedCopyWithImpl;
  @useResult
  $Res call(
      {String userId,
      String email,
      String token,
      String fullName,
      bool emailVerified,
      bool isAdmin,
      bool totpEnabled,
      bool hasActiveStrategy});
}

/// @nodoc
class _$AuthAuthenticatedCopyWithImpl<$Res>
    implements $AuthAuthenticatedCopyWith<$Res> {
  _$AuthAuthenticatedCopyWithImpl(this._self, this._then);

  final AuthAuthenticated _self;
  final $Res Function(AuthAuthenticated) _then;

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? userId = null,
    Object? email = null,
    Object? token = null,
    Object? fullName = null,
    Object? emailVerified = null,
    Object? isAdmin = null,
    Object? totpEnabled = null,
    Object? hasActiveStrategy = null,
  }) {
    return _then(AuthAuthenticated(
      userId: null == userId
          ? _self.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _self.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      token: null == token
          ? _self.token
          : token // ignore: cast_nullable_to_non_nullable
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
      hasActiveStrategy: null == hasActiveStrategy
          ? _self.hasActiveStrategy
          : hasActiveStrategy // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

// dart format on
