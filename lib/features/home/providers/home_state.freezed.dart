// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'home_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HomeState {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is HomeState);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'HomeState()';
  }
}

/// @nodoc
class $HomeStateCopyWith<$Res> {
  $HomeStateCopyWith(HomeState _, $Res Function(HomeState) __);
}

/// Adds pattern-matching-related methods to [HomeState].
extension HomeStatePatterns on HomeState {
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
    TResult Function(HomeLoading value)? loading,
    TResult Function(HomeNoExchange value)? noExchange,
    TResult Function(HomeEmpty value)? empty,
    TResult Function(HomeData value)? data,
    TResult Function(HomeError value)? error,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case HomeLoading() when loading != null:
        return loading(_that);
      case HomeNoExchange() when noExchange != null:
        return noExchange(_that);
      case HomeEmpty() when empty != null:
        return empty(_that);
      case HomeData() when data != null:
        return data(_that);
      case HomeError() when error != null:
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
    required TResult Function(HomeLoading value) loading,
    required TResult Function(HomeNoExchange value) noExchange,
    required TResult Function(HomeEmpty value) empty,
    required TResult Function(HomeData value) data,
    required TResult Function(HomeError value) error,
  }) {
    final _that = this;
    switch (_that) {
      case HomeLoading():
        return loading(_that);
      case HomeNoExchange():
        return noExchange(_that);
      case HomeEmpty():
        return empty(_that);
      case HomeData():
        return data(_that);
      case HomeError():
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
    TResult? Function(HomeLoading value)? loading,
    TResult? Function(HomeNoExchange value)? noExchange,
    TResult? Function(HomeEmpty value)? empty,
    TResult? Function(HomeData value)? data,
    TResult? Function(HomeError value)? error,
  }) {
    final _that = this;
    switch (_that) {
      case HomeLoading() when loading != null:
        return loading(_that);
      case HomeNoExchange() when noExchange != null:
        return noExchange(_that);
      case HomeEmpty() when empty != null:
        return empty(_that);
      case HomeData() when data != null:
        return data(_that);
      case HomeError() when error != null:
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
    TResult Function()? loading,
    TResult Function()? noExchange,
    TResult Function(PnlSummary summary)? empty,
    TResult Function(List<Position> positions, PnlSummary summary)? data,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case HomeLoading() when loading != null:
        return loading();
      case HomeNoExchange() when noExchange != null:
        return noExchange();
      case HomeEmpty() when empty != null:
        return empty(_that.summary);
      case HomeData() when data != null:
        return data(_that.positions, _that.summary);
      case HomeError() when error != null:
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
    required TResult Function() loading,
    required TResult Function() noExchange,
    required TResult Function(PnlSummary summary) empty,
    required TResult Function(List<Position> positions, PnlSummary summary)
        data,
    required TResult Function(String message) error,
  }) {
    final _that = this;
    switch (_that) {
      case HomeLoading():
        return loading();
      case HomeNoExchange():
        return noExchange();
      case HomeEmpty():
        return empty(_that.summary);
      case HomeData():
        return data(_that.positions, _that.summary);
      case HomeError():
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
    TResult? Function()? loading,
    TResult? Function()? noExchange,
    TResult? Function(PnlSummary summary)? empty,
    TResult? Function(List<Position> positions, PnlSummary summary)? data,
    TResult? Function(String message)? error,
  }) {
    final _that = this;
    switch (_that) {
      case HomeLoading() when loading != null:
        return loading();
      case HomeNoExchange() when noExchange != null:
        return noExchange();
      case HomeEmpty() when empty != null:
        return empty(_that.summary);
      case HomeData() when data != null:
        return data(_that.positions, _that.summary);
      case HomeError() when error != null:
        return error(_that.message);
      case _:
        return null;
    }
  }
}

/// @nodoc

class HomeLoading implements HomeState {
  const HomeLoading();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is HomeLoading);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'HomeState.loading()';
  }
}

/// @nodoc

class HomeNoExchange implements HomeState {
  const HomeNoExchange();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is HomeNoExchange);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'HomeState.noExchange()';
  }
}

/// @nodoc

class HomeEmpty implements HomeState {
  const HomeEmpty({required this.summary});

  final PnlSummary summary;

  /// Create a copy of HomeState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $HomeEmptyCopyWith<HomeEmpty> get copyWith =>
      _$HomeEmptyCopyWithImpl<HomeEmpty>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is HomeEmpty &&
            (identical(other.summary, summary) || other.summary == summary));
  }

  @override
  int get hashCode => Object.hash(runtimeType, summary);

  @override
  String toString() {
    return 'HomeState.empty(summary: $summary)';
  }
}

/// @nodoc
abstract mixin class $HomeEmptyCopyWith<$Res>
    implements $HomeStateCopyWith<$Res> {
  factory $HomeEmptyCopyWith(HomeEmpty value, $Res Function(HomeEmpty) _then) =
      _$HomeEmptyCopyWithImpl;
  @useResult
  $Res call({PnlSummary summary});

  $PnlSummaryCopyWith<$Res> get summary;
}

/// @nodoc
class _$HomeEmptyCopyWithImpl<$Res> implements $HomeEmptyCopyWith<$Res> {
  _$HomeEmptyCopyWithImpl(this._self, this._then);

  final HomeEmpty _self;
  final $Res Function(HomeEmpty) _then;

  /// Create a copy of HomeState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? summary = null,
  }) {
    return _then(HomeEmpty(
      summary: null == summary
          ? _self.summary
          : summary // ignore: cast_nullable_to_non_nullable
              as PnlSummary,
    ));
  }

  /// Create a copy of HomeState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PnlSummaryCopyWith<$Res> get summary {
    return $PnlSummaryCopyWith<$Res>(_self.summary, (value) {
      return _then(_self.copyWith(summary: value));
    });
  }
}

/// @nodoc

class HomeData implements HomeState {
  const HomeData(
      {required final List<Position> positions, required this.summary})
      : _positions = positions;

  final List<Position> _positions;
  List<Position> get positions {
    if (_positions is EqualUnmodifiableListView) return _positions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_positions);
  }

  final PnlSummary summary;

  /// Create a copy of HomeState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $HomeDataCopyWith<HomeData> get copyWith =>
      _$HomeDataCopyWithImpl<HomeData>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is HomeData &&
            const DeepCollectionEquality()
                .equals(other._positions, _positions) &&
            (identical(other.summary, summary) || other.summary == summary));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_positions), summary);

  @override
  String toString() {
    return 'HomeState.data(positions: $positions, summary: $summary)';
  }
}

/// @nodoc
abstract mixin class $HomeDataCopyWith<$Res>
    implements $HomeStateCopyWith<$Res> {
  factory $HomeDataCopyWith(HomeData value, $Res Function(HomeData) _then) =
      _$HomeDataCopyWithImpl;
  @useResult
  $Res call({List<Position> positions, PnlSummary summary});

  $PnlSummaryCopyWith<$Res> get summary;
}

/// @nodoc
class _$HomeDataCopyWithImpl<$Res> implements $HomeDataCopyWith<$Res> {
  _$HomeDataCopyWithImpl(this._self, this._then);

  final HomeData _self;
  final $Res Function(HomeData) _then;

  /// Create a copy of HomeState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? positions = null,
    Object? summary = null,
  }) {
    return _then(HomeData(
      positions: null == positions
          ? _self._positions
          : positions // ignore: cast_nullable_to_non_nullable
              as List<Position>,
      summary: null == summary
          ? _self.summary
          : summary // ignore: cast_nullable_to_non_nullable
              as PnlSummary,
    ));
  }

  /// Create a copy of HomeState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PnlSummaryCopyWith<$Res> get summary {
    return $PnlSummaryCopyWith<$Res>(_self.summary, (value) {
      return _then(_self.copyWith(summary: value));
    });
  }
}

/// @nodoc

class HomeError implements HomeState {
  const HomeError({required this.message});

  final String message;

  /// Create a copy of HomeState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $HomeErrorCopyWith<HomeError> get copyWith =>
      _$HomeErrorCopyWithImpl<HomeError>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is HomeError &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @override
  String toString() {
    return 'HomeState.error(message: $message)';
  }
}

/// @nodoc
abstract mixin class $HomeErrorCopyWith<$Res>
    implements $HomeStateCopyWith<$Res> {
  factory $HomeErrorCopyWith(HomeError value, $Res Function(HomeError) _then) =
      _$HomeErrorCopyWithImpl;
  @useResult
  $Res call({String message});
}

/// @nodoc
class _$HomeErrorCopyWithImpl<$Res> implements $HomeErrorCopyWith<$Res> {
  _$HomeErrorCopyWithImpl(this._self, this._then);

  final HomeError _self;
  final $Res Function(HomeError) _then;

  /// Create a copy of HomeState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? message = null,
  }) {
    return _then(HomeError(
      message: null == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
