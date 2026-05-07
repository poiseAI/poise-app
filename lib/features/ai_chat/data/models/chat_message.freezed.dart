// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_message.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ChatMessage {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is ChatMessage);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'ChatMessage()';
  }
}

/// @nodoc
class $ChatMessageCopyWith<$Res> {
  $ChatMessageCopyWith(ChatMessage _, $Res Function(ChatMessage) __);
}

/// Adds pattern-matching-related methods to [ChatMessage].
extension ChatMessagePatterns on ChatMessage {
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
    TResult Function(UserMessage value)? user,
    TResult Function(AiMessage value)? ai,
    TResult Function(ToolResultMessage value)? toolResult,
    TResult Function(ConfirmationMessage value)? confirmation,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case UserMessage() when user != null:
        return user(_that);
      case AiMessage() when ai != null:
        return ai(_that);
      case ToolResultMessage() when toolResult != null:
        return toolResult(_that);
      case ConfirmationMessage() when confirmation != null:
        return confirmation(_that);
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
    required TResult Function(UserMessage value) user,
    required TResult Function(AiMessage value) ai,
    required TResult Function(ToolResultMessage value) toolResult,
    required TResult Function(ConfirmationMessage value) confirmation,
  }) {
    final _that = this;
    switch (_that) {
      case UserMessage():
        return user(_that);
      case AiMessage():
        return ai(_that);
      case ToolResultMessage():
        return toolResult(_that);
      case ConfirmationMessage():
        return confirmation(_that);
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
    TResult? Function(UserMessage value)? user,
    TResult? Function(AiMessage value)? ai,
    TResult? Function(ToolResultMessage value)? toolResult,
    TResult? Function(ConfirmationMessage value)? confirmation,
  }) {
    final _that = this;
    switch (_that) {
      case UserMessage() when user != null:
        return user(_that);
      case AiMessage() when ai != null:
        return ai(_that);
      case ToolResultMessage() when toolResult != null:
        return toolResult(_that);
      case ConfirmationMessage() when confirmation != null:
        return confirmation(_that);
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
    TResult Function(String text, DateTime at)? user,
    TResult Function(String text, DateTime at, bool isStreaming,
            List<AiToolCallInfo> toolCalls)?
        ai,
    TResult Function(
            String toolCallId, String toolName, dynamic result, DateTime at)?
        toolResult,
    TResult Function(String toolCallId, String actionSummary,
            Map<String, dynamic> actionDetails, ConfirmationStatus status)?
        confirmation,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case UserMessage() when user != null:
        return user(_that.text, _that.at);
      case AiMessage() when ai != null:
        return ai(_that.text, _that.at, _that.isStreaming, _that.toolCalls);
      case ToolResultMessage() when toolResult != null:
        return toolResult(
            _that.toolCallId, _that.toolName, _that.result, _that.at);
      case ConfirmationMessage() when confirmation != null:
        return confirmation(_that.toolCallId, _that.actionSummary,
            _that.actionDetails, _that.status);
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
    required TResult Function(String text, DateTime at) user,
    required TResult Function(String text, DateTime at, bool isStreaming,
            List<AiToolCallInfo> toolCalls)
        ai,
    required TResult Function(
            String toolCallId, String toolName, dynamic result, DateTime at)
        toolResult,
    required TResult Function(String toolCallId, String actionSummary,
            Map<String, dynamic> actionDetails, ConfirmationStatus status)
        confirmation,
  }) {
    final _that = this;
    switch (_that) {
      case UserMessage():
        return user(_that.text, _that.at);
      case AiMessage():
        return ai(_that.text, _that.at, _that.isStreaming, _that.toolCalls);
      case ToolResultMessage():
        return toolResult(
            _that.toolCallId, _that.toolName, _that.result, _that.at);
      case ConfirmationMessage():
        return confirmation(_that.toolCallId, _that.actionSummary,
            _that.actionDetails, _that.status);
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
    TResult? Function(String text, DateTime at)? user,
    TResult? Function(String text, DateTime at, bool isStreaming,
            List<AiToolCallInfo> toolCalls)?
        ai,
    TResult? Function(
            String toolCallId, String toolName, dynamic result, DateTime at)?
        toolResult,
    TResult? Function(String toolCallId, String actionSummary,
            Map<String, dynamic> actionDetails, ConfirmationStatus status)?
        confirmation,
  }) {
    final _that = this;
    switch (_that) {
      case UserMessage() when user != null:
        return user(_that.text, _that.at);
      case AiMessage() when ai != null:
        return ai(_that.text, _that.at, _that.isStreaming, _that.toolCalls);
      case ToolResultMessage() when toolResult != null:
        return toolResult(
            _that.toolCallId, _that.toolName, _that.result, _that.at);
      case ConfirmationMessage() when confirmation != null:
        return confirmation(_that.toolCallId, _that.actionSummary,
            _that.actionDetails, _that.status);
      case _:
        return null;
    }
  }
}

/// @nodoc

class UserMessage implements ChatMessage {
  const UserMessage({required this.text, required this.at});

  final String text;
  final DateTime at;

  /// Create a copy of ChatMessage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UserMessageCopyWith<UserMessage> get copyWith =>
      _$UserMessageCopyWithImpl<UserMessage>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UserMessage &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.at, at) || other.at == at));
  }

  @override
  int get hashCode => Object.hash(runtimeType, text, at);

  @override
  String toString() {
    return 'ChatMessage.user(text: $text, at: $at)';
  }
}

/// @nodoc
abstract mixin class $UserMessageCopyWith<$Res>
    implements $ChatMessageCopyWith<$Res> {
  factory $UserMessageCopyWith(
          UserMessage value, $Res Function(UserMessage) _then) =
      _$UserMessageCopyWithImpl;
  @useResult
  $Res call({String text, DateTime at});
}

/// @nodoc
class _$UserMessageCopyWithImpl<$Res> implements $UserMessageCopyWith<$Res> {
  _$UserMessageCopyWithImpl(this._self, this._then);

  final UserMessage _self;
  final $Res Function(UserMessage) _then;

  /// Create a copy of ChatMessage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? text = null,
    Object? at = null,
  }) {
    return _then(UserMessage(
      text: null == text
          ? _self.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      at: null == at
          ? _self.at
          : at // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc

class AiMessage implements ChatMessage {
  const AiMessage(
      {required this.text,
      required this.at,
      this.isStreaming = false,
      final List<AiToolCallInfo> toolCalls = const []})
      : _toolCalls = toolCalls;

  final String text;
  final DateTime at;
  @JsonKey()
  final bool isStreaming;
  final List<AiToolCallInfo> _toolCalls;
  @JsonKey()
  List<AiToolCallInfo> get toolCalls {
    if (_toolCalls is EqualUnmodifiableListView) return _toolCalls;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_toolCalls);
  }

  /// Create a copy of ChatMessage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AiMessageCopyWith<AiMessage> get copyWith =>
      _$AiMessageCopyWithImpl<AiMessage>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AiMessage &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.at, at) || other.at == at) &&
            (identical(other.isStreaming, isStreaming) ||
                other.isStreaming == isStreaming) &&
            const DeepCollectionEquality()
                .equals(other._toolCalls, _toolCalls));
  }

  @override
  int get hashCode => Object.hash(runtimeType, text, at, isStreaming,
      const DeepCollectionEquality().hash(_toolCalls));

  @override
  String toString() {
    return 'ChatMessage.ai(text: $text, at: $at, isStreaming: $isStreaming, toolCalls: $toolCalls)';
  }
}

/// @nodoc
abstract mixin class $AiMessageCopyWith<$Res>
    implements $ChatMessageCopyWith<$Res> {
  factory $AiMessageCopyWith(AiMessage value, $Res Function(AiMessage) _then) =
      _$AiMessageCopyWithImpl;
  @useResult
  $Res call(
      {String text,
      DateTime at,
      bool isStreaming,
      List<AiToolCallInfo> toolCalls});
}

/// @nodoc
class _$AiMessageCopyWithImpl<$Res> implements $AiMessageCopyWith<$Res> {
  _$AiMessageCopyWithImpl(this._self, this._then);

  final AiMessage _self;
  final $Res Function(AiMessage) _then;

  /// Create a copy of ChatMessage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? text = null,
    Object? at = null,
    Object? isStreaming = null,
    Object? toolCalls = null,
  }) {
    return _then(AiMessage(
      text: null == text
          ? _self.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      at: null == at
          ? _self.at
          : at // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isStreaming: null == isStreaming
          ? _self.isStreaming
          : isStreaming // ignore: cast_nullable_to_non_nullable
              as bool,
      toolCalls: null == toolCalls
          ? _self._toolCalls
          : toolCalls // ignore: cast_nullable_to_non_nullable
              as List<AiToolCallInfo>,
    ));
  }
}

/// @nodoc

class ToolResultMessage implements ChatMessage {
  const ToolResultMessage(
      {required this.toolCallId,
      required this.toolName,
      required this.result,
      required this.at});

  final String toolCallId;
  final String toolName;
  final dynamic result;
  final DateTime at;

  /// Create a copy of ChatMessage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ToolResultMessageCopyWith<ToolResultMessage> get copyWith =>
      _$ToolResultMessageCopyWithImpl<ToolResultMessage>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ToolResultMessage &&
            (identical(other.toolCallId, toolCallId) ||
                other.toolCallId == toolCallId) &&
            (identical(other.toolName, toolName) ||
                other.toolName == toolName) &&
            const DeepCollectionEquality().equals(other.result, result) &&
            (identical(other.at, at) || other.at == at));
  }

  @override
  int get hashCode => Object.hash(runtimeType, toolCallId, toolName,
      const DeepCollectionEquality().hash(result), at);

  @override
  String toString() {
    return 'ChatMessage.toolResult(toolCallId: $toolCallId, toolName: $toolName, result: $result, at: $at)';
  }
}

/// @nodoc
abstract mixin class $ToolResultMessageCopyWith<$Res>
    implements $ChatMessageCopyWith<$Res> {
  factory $ToolResultMessageCopyWith(
          ToolResultMessage value, $Res Function(ToolResultMessage) _then) =
      _$ToolResultMessageCopyWithImpl;
  @useResult
  $Res call({String toolCallId, String toolName, dynamic result, DateTime at});
}

/// @nodoc
class _$ToolResultMessageCopyWithImpl<$Res>
    implements $ToolResultMessageCopyWith<$Res> {
  _$ToolResultMessageCopyWithImpl(this._self, this._then);

  final ToolResultMessage _self;
  final $Res Function(ToolResultMessage) _then;

  /// Create a copy of ChatMessage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? toolCallId = null,
    Object? toolName = null,
    Object? result = freezed,
    Object? at = null,
  }) {
    return _then(ToolResultMessage(
      toolCallId: null == toolCallId
          ? _self.toolCallId
          : toolCallId // ignore: cast_nullable_to_non_nullable
              as String,
      toolName: null == toolName
          ? _self.toolName
          : toolName // ignore: cast_nullable_to_non_nullable
              as String,
      result: freezed == result
          ? _self.result
          : result // ignore: cast_nullable_to_non_nullable
              as dynamic,
      at: null == at
          ? _self.at
          : at // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc

class ConfirmationMessage implements ChatMessage {
  const ConfirmationMessage(
      {required this.toolCallId,
      required this.actionSummary,
      required final Map<String, dynamic> actionDetails,
      this.status = ConfirmationStatus.pending})
      : _actionDetails = actionDetails;

  final String toolCallId;
  final String actionSummary;
  final Map<String, dynamic> _actionDetails;
  Map<String, dynamic> get actionDetails {
    if (_actionDetails is EqualUnmodifiableMapView) return _actionDetails;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_actionDetails);
  }

  @JsonKey()
  final ConfirmationStatus status;

  /// Create a copy of ChatMessage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ConfirmationMessageCopyWith<ConfirmationMessage> get copyWith =>
      _$ConfirmationMessageCopyWithImpl<ConfirmationMessage>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ConfirmationMessage &&
            (identical(other.toolCallId, toolCallId) ||
                other.toolCallId == toolCallId) &&
            (identical(other.actionSummary, actionSummary) ||
                other.actionSummary == actionSummary) &&
            const DeepCollectionEquality()
                .equals(other._actionDetails, _actionDetails) &&
            (identical(other.status, status) || other.status == status));
  }

  @override
  int get hashCode => Object.hash(runtimeType, toolCallId, actionSummary,
      const DeepCollectionEquality().hash(_actionDetails), status);

  @override
  String toString() {
    return 'ChatMessage.confirmation(toolCallId: $toolCallId, actionSummary: $actionSummary, actionDetails: $actionDetails, status: $status)';
  }
}

/// @nodoc
abstract mixin class $ConfirmationMessageCopyWith<$Res>
    implements $ChatMessageCopyWith<$Res> {
  factory $ConfirmationMessageCopyWith(
          ConfirmationMessage value, $Res Function(ConfirmationMessage) _then) =
      _$ConfirmationMessageCopyWithImpl;
  @useResult
  $Res call(
      {String toolCallId,
      String actionSummary,
      Map<String, dynamic> actionDetails,
      ConfirmationStatus status});
}

/// @nodoc
class _$ConfirmationMessageCopyWithImpl<$Res>
    implements $ConfirmationMessageCopyWith<$Res> {
  _$ConfirmationMessageCopyWithImpl(this._self, this._then);

  final ConfirmationMessage _self;
  final $Res Function(ConfirmationMessage) _then;

  /// Create a copy of ChatMessage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? toolCallId = null,
    Object? actionSummary = null,
    Object? actionDetails = null,
    Object? status = null,
  }) {
    return _then(ConfirmationMessage(
      toolCallId: null == toolCallId
          ? _self.toolCallId
          : toolCallId // ignore: cast_nullable_to_non_nullable
              as String,
      actionSummary: null == actionSummary
          ? _self.actionSummary
          : actionSummary // ignore: cast_nullable_to_non_nullable
              as String,
      actionDetails: null == actionDetails
          ? _self._actionDetails
          : actionDetails // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as ConfirmationStatus,
    ));
  }
}

// dart format on
