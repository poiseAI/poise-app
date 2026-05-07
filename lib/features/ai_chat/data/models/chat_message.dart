import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_message.freezed.dart';

@freezed
sealed class ChatMessage with _$ChatMessage {
  const factory ChatMessage.user({
    required String text,
    required DateTime at,
  }) = UserMessage;

  const factory ChatMessage.ai({
    required String text,
    required DateTime at,
    @Default(false) bool isStreaming,
    @Default([]) List<AiToolCallInfo> toolCalls,
  }) = AiMessage;

  const factory ChatMessage.toolResult({
    required String toolCallId,
    required String toolName,
    required dynamic result,
    required DateTime at,
  }) = ToolResultMessage;

  const factory ChatMessage.confirmation({
    required String toolCallId,
    required String actionSummary,
    required Map<String, dynamic> actionDetails,
    @Default(ConfirmationStatus.pending) ConfirmationStatus status,
  }) = ConfirmationMessage;
}

enum ConfirmationStatus { pending, confirmed, cancelled }

class AiToolCallInfo {
  const AiToolCallInfo({
    required this.id,
    required this.name,
    required this.input,
    this.isLoading = true,
    this.result,
  });

  final String id;
  final String name;
  final Map<String, dynamic> input;
  final bool isLoading;
  final dynamic result;

  AiToolCallInfo copyWith({
    bool? isLoading,
    dynamic result,
  }) =>
      AiToolCallInfo(
        id: id,
        name: name,
        input: input,
        isLoading: isLoading ?? this.isLoading,
        result: result ?? this.result,
      );
}
