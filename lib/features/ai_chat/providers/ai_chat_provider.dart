import 'dart:async';
import 'package:flutter/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/ai_chat_api.dart';
import '../data/models/chat_message.dart';

part 'ai_chat_provider.g.dart';

@riverpod
class AiChat extends _$AiChat {
  StreamSubscription<AiEvent>? _streamSub;
  String? _sessionId;
  bool _isStreaming = false;
  int _wordCount = 0;

  @override
  List<ChatMessage> build() {
    ref.onDispose(() => _streamSub?.cancel());
    return [];
  }

  bool get isStreaming => _isStreaming;

  Future<void> send(String text) async {
    if (_isStreaming || text.trim().isEmpty) return;

    final userMsg = ChatMessage.user(text: text.trim(), at: DateTime.now());
    final aiMsg =
        ChatMessage.ai(text: '', at: DateTime.now(), isStreaming: true);
    state = [...state, userMsg, aiMsg];

    _isStreaming = true;
    _wordCount = 0;

    final api = ref.read(aiChatApiProvider);
    final stream = api.chat(text.trim(), sessionId: _sessionId);

    _streamSub = stream.listen(
      _onEvent,
      onDone: _onDone,
      onError: (_) => _onDone(),
    );
  }

  void _onEvent(AiEvent event) {
    switch (event) {
      case AiSessionStarted():
        if (event.sessionId.isNotEmpty) _sessionId = event.sessionId;
      case AiTextDelta():
        _appendText(event.delta);
      case AiToolCall():
        _addToolCall(event);
      case AiToolResult():
        _resolveToolCall(event);
      case AiRequiresConfirmation():
        _addConfirmation(event);
      case AiDone():
        _onDone();
      case AiError():
        _appendText('\n\n_Error: ${event.message}_');
        _onDone();
    }
  }

  void _appendText(String delta) {
    if (delta.isEmpty) return;

    final messages = [...state];
    final lastIdx = messages.length - 1;
    if (messages.isEmpty || messages[lastIdx] is! AiMessage) return;

    final last = messages[lastIdx] as AiMessage;
    messages[lastIdx] =
        last.copyWith(text: last.text + delta, isStreaming: true);
    state = messages;

    // Haptic every ~5 words (#59)
    _wordCount += delta.split(' ').where((w) => w.isNotEmpty).length;
    if (_wordCount % 5 == 0) {
      HapticFeedback.selectionClick();
    }
  }

  void _addToolCall(AiToolCall event) {
    final messages = [...state];
    final lastIdx = messages.length - 1;
    if (messages.isEmpty || messages[lastIdx] is! AiMessage) return;

    final last = messages[lastIdx] as AiMessage;
    final toolCall = AiToolCallInfo(
      id: event.id,
      name: event.name,
      input: event.input,
    );
    messages[lastIdx] = last.copyWith(
      toolCalls: [...last.toolCalls, toolCall],
    );
    state = messages;
    HapticFeedback.lightImpact();
  }

  void _resolveToolCall(AiToolResult event) {
    final messages = [...state];
    for (var i = 0; i < messages.length; i++) {
      final msg = messages[i];
      if (msg is AiMessage) {
        final idx = msg.toolCalls.indexWhere((t) => t.id == event.toolCallId);
        if (idx != -1) {
          final updatedCalls = [...msg.toolCalls];
          updatedCalls[idx] = updatedCalls[idx].copyWith(
            isLoading: false,
            result: event.content,
          );
          messages[i] = msg.copyWith(toolCalls: updatedCalls);
          break;
        }
      }
    }
    state = messages;
  }

  void _addConfirmation(AiRequiresConfirmation event) {
    state = [
      ...state,
      ChatMessage.confirmation(
        toolCallId: event.toolCallId,
        actionSummary: event.actionSummary,
        actionDetails: event.action,
      ),
    ];
    HapticFeedback.mediumImpact();
  }

  void _onDone() {
    _isStreaming = false;
    _streamSub?.cancel();
    _streamSub = null;

    final messages = [...state];
    for (var i = 0; i < messages.length; i++) {
      final msg = messages[i];
      if (msg is AiMessage && msg.isStreaming) {
        messages[i] = msg.copyWith(isStreaming: false);
      }
    }
    state = messages;
  }

  void stopStreaming() {
    _streamSub?.cancel();
    _streamSub = null;
    _onDone();
  }

  Future<void> loadSession(String sessionId) async {
    if (_isStreaming) stopStreaming();
    final result = await ref.read(aiChatApiProvider).getSession(sessionId);
    if (result.isErr) return;
    _sessionId = sessionId;
    state = result.value
        .map(_messageFromSessionJson)
        .whereType<ChatMessage>()
        .toList();
  }

  Future<void> confirm(String toolCallId, bool confirmed) async {
    if (_sessionId == null) return;

    final messages = [...state];
    for (var i = 0; i < messages.length; i++) {
      final msg = messages[i];
      if (msg is ConfirmationMessage && msg.toolCallId == toolCallId) {
        messages[i] = msg.copyWith(
          status: confirmed
              ? ConfirmationStatus.confirmed
              : ConfirmationStatus.cancelled,
        );
        break;
      }
    }
    state = messages;

    HapticFeedback.mediumImpact();

    final aiMsg =
        ChatMessage.ai(text: '', at: DateTime.now(), isStreaming: true);
    state = [...state, aiMsg];
    _isStreaming = true;

    _streamSub?.cancel();
    _streamSub = ref
        .read(aiChatApiProvider)
        .confirm(_sessionId!, toolCallId, confirmed)
        .listen(
          _onEvent,
          onDone: _onDone,
          onError: (_) => _onDone(),
        );
  }
}

ChatMessage? _messageFromSessionJson(Map<String, dynamic> json) {
  final role = json['role'] as String? ?? '';
  final content = json['content'];
  final text = switch (content) {
    String value => value,
    List value => value.map((item) => item.toString()).join('\n'),
    Map value => value['text']?.toString() ?? value.toString(),
    null => '',
    _ => content.toString(),
  };
  if (text.trim().isEmpty) return null;
  final at = DateTime.now();
  if (role == 'user') return ChatMessage.user(text: text, at: at);
  if (role == 'assistant') {
    return ChatMessage.ai(text: text, at: at);
  }
  return null;
}
