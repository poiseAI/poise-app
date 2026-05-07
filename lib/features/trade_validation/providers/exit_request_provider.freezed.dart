// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'exit_request_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ExitRequestState {
  String get reasonId; // UUID from GET /exit-reasons
  String get description;
  bool get isSubmitting;
  String? get error;
  bool get submitted;
  String? get exitRequestId;

  /// Create a copy of ExitRequestState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ExitRequestStateCopyWith<ExitRequestState> get copyWith =>
      _$ExitRequestStateCopyWithImpl<ExitRequestState>(
          this as ExitRequestState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ExitRequestState &&
            (identical(other.reasonId, reasonId) ||
                other.reasonId == reasonId) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.isSubmitting, isSubmitting) ||
                other.isSubmitting == isSubmitting) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.submitted, submitted) ||
                other.submitted == submitted) &&
            (identical(other.exitRequestId, exitRequestId) ||
                other.exitRequestId == exitRequestId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, reasonId, description,
      isSubmitting, error, submitted, exitRequestId);

  @override
  String toString() {
    return 'ExitRequestState(reasonId: $reasonId, description: $description, isSubmitting: $isSubmitting, error: $error, submitted: $submitted, exitRequestId: $exitRequestId)';
  }
}

/// @nodoc
abstract mixin class $ExitRequestStateCopyWith<$Res> {
  factory $ExitRequestStateCopyWith(
          ExitRequestState value, $Res Function(ExitRequestState) _then) =
      _$ExitRequestStateCopyWithImpl;
  @useResult
  $Res call(
      {String reasonId,
      String description,
      bool isSubmitting,
      String? error,
      bool submitted,
      String? exitRequestId});
}

/// @nodoc
class _$ExitRequestStateCopyWithImpl<$Res>
    implements $ExitRequestStateCopyWith<$Res> {
  _$ExitRequestStateCopyWithImpl(this._self, this._then);

  final ExitRequestState _self;
  final $Res Function(ExitRequestState) _then;

  /// Create a copy of ExitRequestState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? reasonId = null,
    Object? description = null,
    Object? isSubmitting = null,
    Object? error = freezed,
    Object? submitted = null,
    Object? exitRequestId = freezed,
  }) {
    return _then(_self.copyWith(
      reasonId: null == reasonId
          ? _self.reasonId
          : reasonId // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      isSubmitting: null == isSubmitting
          ? _self.isSubmitting
          : isSubmitting // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _self.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      submitted: null == submitted
          ? _self.submitted
          : submitted // ignore: cast_nullable_to_non_nullable
              as bool,
      exitRequestId: freezed == exitRequestId
          ? _self.exitRequestId
          : exitRequestId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [ExitRequestState].
extension ExitRequestStatePatterns on ExitRequestState {
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
    TResult Function(_ExitRequestState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ExitRequestState() when $default != null:
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
    TResult Function(_ExitRequestState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ExitRequestState():
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
    TResult? Function(_ExitRequestState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ExitRequestState() when $default != null:
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
    TResult Function(String reasonId, String description, bool isSubmitting,
            String? error, bool submitted, String? exitRequestId)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ExitRequestState() when $default != null:
        return $default(_that.reasonId, _that.description, _that.isSubmitting,
            _that.error, _that.submitted, _that.exitRequestId);
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
    TResult Function(String reasonId, String description, bool isSubmitting,
            String? error, bool submitted, String? exitRequestId)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ExitRequestState():
        return $default(_that.reasonId, _that.description, _that.isSubmitting,
            _that.error, _that.submitted, _that.exitRequestId);
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
    TResult? Function(String reasonId, String description, bool isSubmitting,
            String? error, bool submitted, String? exitRequestId)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ExitRequestState() when $default != null:
        return $default(_that.reasonId, _that.description, _that.isSubmitting,
            _that.error, _that.submitted, _that.exitRequestId);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _ExitRequestState implements ExitRequestState {
  const _ExitRequestState(
      {this.reasonId = '',
      this.description = '',
      this.isSubmitting = false,
      this.error,
      this.submitted = false,
      this.exitRequestId});

  @override
  @JsonKey()
  final String reasonId;
// UUID from GET /exit-reasons
  @override
  @JsonKey()
  final String description;
  @override
  @JsonKey()
  final bool isSubmitting;
  @override
  final String? error;
  @override
  @JsonKey()
  final bool submitted;
  @override
  final String? exitRequestId;

  /// Create a copy of ExitRequestState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ExitRequestStateCopyWith<_ExitRequestState> get copyWith =>
      __$ExitRequestStateCopyWithImpl<_ExitRequestState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ExitRequestState &&
            (identical(other.reasonId, reasonId) ||
                other.reasonId == reasonId) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.isSubmitting, isSubmitting) ||
                other.isSubmitting == isSubmitting) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.submitted, submitted) ||
                other.submitted == submitted) &&
            (identical(other.exitRequestId, exitRequestId) ||
                other.exitRequestId == exitRequestId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, reasonId, description,
      isSubmitting, error, submitted, exitRequestId);

  @override
  String toString() {
    return 'ExitRequestState(reasonId: $reasonId, description: $description, isSubmitting: $isSubmitting, error: $error, submitted: $submitted, exitRequestId: $exitRequestId)';
  }
}

/// @nodoc
abstract mixin class _$ExitRequestStateCopyWith<$Res>
    implements $ExitRequestStateCopyWith<$Res> {
  factory _$ExitRequestStateCopyWith(
          _ExitRequestState value, $Res Function(_ExitRequestState) _then) =
      __$ExitRequestStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String reasonId,
      String description,
      bool isSubmitting,
      String? error,
      bool submitted,
      String? exitRequestId});
}

/// @nodoc
class __$ExitRequestStateCopyWithImpl<$Res>
    implements _$ExitRequestStateCopyWith<$Res> {
  __$ExitRequestStateCopyWithImpl(this._self, this._then);

  final _ExitRequestState _self;
  final $Res Function(_ExitRequestState) _then;

  /// Create a copy of ExitRequestState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? reasonId = null,
    Object? description = null,
    Object? isSubmitting = null,
    Object? error = freezed,
    Object? submitted = null,
    Object? exitRequestId = freezed,
  }) {
    return _then(_ExitRequestState(
      reasonId: null == reasonId
          ? _self.reasonId
          : reasonId // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      isSubmitting: null == isSubmitting
          ? _self.isSubmitting
          : isSubmitting // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _self.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      submitted: null == submitted
          ? _self.submitted
          : submitted // ignore: cast_nullable_to_non_nullable
              as bool,
      exitRequestId: freezed == exitRequestId
          ? _self.exitRequestId
          : exitRequestId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
