// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'exit_otp_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ExitOtpState {
  bool get isVerifying;
  bool get wrongCode;
  bool get success;
  String? get error;

  /// Create a copy of ExitOtpState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ExitOtpStateCopyWith<ExitOtpState> get copyWith =>
      _$ExitOtpStateCopyWithImpl<ExitOtpState>(
          this as ExitOtpState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ExitOtpState &&
            (identical(other.isVerifying, isVerifying) ||
                other.isVerifying == isVerifying) &&
            (identical(other.wrongCode, wrongCode) ||
                other.wrongCode == wrongCode) &&
            (identical(other.success, success) || other.success == success) &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, isVerifying, wrongCode, success, error);

  @override
  String toString() {
    return 'ExitOtpState(isVerifying: $isVerifying, wrongCode: $wrongCode, success: $success, error: $error)';
  }
}

/// @nodoc
abstract mixin class $ExitOtpStateCopyWith<$Res> {
  factory $ExitOtpStateCopyWith(
          ExitOtpState value, $Res Function(ExitOtpState) _then) =
      _$ExitOtpStateCopyWithImpl;
  @useResult
  $Res call({bool isVerifying, bool wrongCode, bool success, String? error});
}

/// @nodoc
class _$ExitOtpStateCopyWithImpl<$Res> implements $ExitOtpStateCopyWith<$Res> {
  _$ExitOtpStateCopyWithImpl(this._self, this._then);

  final ExitOtpState _self;
  final $Res Function(ExitOtpState) _then;

  /// Create a copy of ExitOtpState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isVerifying = null,
    Object? wrongCode = null,
    Object? success = null,
    Object? error = freezed,
  }) {
    return _then(_self.copyWith(
      isVerifying: null == isVerifying
          ? _self.isVerifying
          : isVerifying // ignore: cast_nullable_to_non_nullable
              as bool,
      wrongCode: null == wrongCode
          ? _self.wrongCode
          : wrongCode // ignore: cast_nullable_to_non_nullable
              as bool,
      success: null == success
          ? _self.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _self.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [ExitOtpState].
extension ExitOtpStatePatterns on ExitOtpState {
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
    TResult Function(_ExitOtpState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ExitOtpState() when $default != null:
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
    TResult Function(_ExitOtpState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ExitOtpState():
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
    TResult? Function(_ExitOtpState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ExitOtpState() when $default != null:
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
            bool isVerifying, bool wrongCode, bool success, String? error)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ExitOtpState() when $default != null:
        return $default(
            _that.isVerifying, _that.wrongCode, _that.success, _that.error);
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
            bool isVerifying, bool wrongCode, bool success, String? error)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ExitOtpState():
        return $default(
            _that.isVerifying, _that.wrongCode, _that.success, _that.error);
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
            bool isVerifying, bool wrongCode, bool success, String? error)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ExitOtpState() when $default != null:
        return $default(
            _that.isVerifying, _that.wrongCode, _that.success, _that.error);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _ExitOtpState implements ExitOtpState {
  const _ExitOtpState(
      {this.isVerifying = false,
      this.wrongCode = false,
      this.success = false,
      this.error});

  @override
  @JsonKey()
  final bool isVerifying;
  @override
  @JsonKey()
  final bool wrongCode;
  @override
  @JsonKey()
  final bool success;
  @override
  final String? error;

  /// Create a copy of ExitOtpState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ExitOtpStateCopyWith<_ExitOtpState> get copyWith =>
      __$ExitOtpStateCopyWithImpl<_ExitOtpState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ExitOtpState &&
            (identical(other.isVerifying, isVerifying) ||
                other.isVerifying == isVerifying) &&
            (identical(other.wrongCode, wrongCode) ||
                other.wrongCode == wrongCode) &&
            (identical(other.success, success) || other.success == success) &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, isVerifying, wrongCode, success, error);

  @override
  String toString() {
    return 'ExitOtpState(isVerifying: $isVerifying, wrongCode: $wrongCode, success: $success, error: $error)';
  }
}

/// @nodoc
abstract mixin class _$ExitOtpStateCopyWith<$Res>
    implements $ExitOtpStateCopyWith<$Res> {
  factory _$ExitOtpStateCopyWith(
          _ExitOtpState value, $Res Function(_ExitOtpState) _then) =
      __$ExitOtpStateCopyWithImpl;
  @override
  @useResult
  $Res call({bool isVerifying, bool wrongCode, bool success, String? error});
}

/// @nodoc
class __$ExitOtpStateCopyWithImpl<$Res>
    implements _$ExitOtpStateCopyWith<$Res> {
  __$ExitOtpStateCopyWithImpl(this._self, this._then);

  final _ExitOtpState _self;
  final $Res Function(_ExitOtpState) _then;

  /// Create a copy of ExitOtpState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? isVerifying = null,
    Object? wrongCode = null,
    Object? success = null,
    Object? error = freezed,
  }) {
    return _then(_ExitOtpState(
      isVerifying: null == isVerifying
          ? _self.isVerifying
          : isVerifying // ignore: cast_nullable_to_non_nullable
              as bool,
      wrongCode: null == wrongCode
          ? _self.wrongCode
          : wrongCode // ignore: cast_nullable_to_non_nullable
              as bool,
      success: null == success
          ? _self.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _self.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
