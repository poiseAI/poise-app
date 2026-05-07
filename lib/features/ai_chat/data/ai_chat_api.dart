import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/errors/app_error.dart';
import '../../../core/network/api_client.dart';
import '../../../core/utils/result.dart';

part 'ai_chat_api.g.dart';

@riverpod
AiChatApi aiChatApi(Ref ref) => AiChatApi(ref.watch(dioProvider));

sealed class AiEvent {}

class AiSessionStarted extends AiEvent {
  AiSessionStarted(this.sessionId);
  final String sessionId;
}

class AiTextDelta extends AiEvent {
  AiTextDelta(this.delta);
  final String delta;
}

class AiToolCall extends AiEvent {
  AiToolCall({required this.id, required this.name, required this.input});
  final String id;
  final String name;
  final Map<String, dynamic> input;
}

class AiToolResult extends AiEvent {
  AiToolResult({required this.toolCallId, required this.content});
  final String toolCallId;
  final dynamic content;
}

class AiRequiresConfirmation extends AiEvent {
  AiRequiresConfirmation({
    required this.toolCallId,
    required this.actionSummary,
    required this.action,
  });
  final String toolCallId;
  final String actionSummary;
  final Map<String, dynamic> action;
}

class AiDone extends AiEvent {}

class AiError extends AiEvent {
  AiError(this.message);
  final String message;
}

class AiSession {
  AiSession({required this.id, required this.title, required this.updatedAt});

  factory AiSession.fromJson(Map<String, dynamic> json) => AiSession(
        id: json['id'] as String,
        title: json['title'] as String? ?? '',
        updatedAt: DateTime.tryParse(json['updated_at'] as String? ?? '') ??
            DateTime.now(),
      );

  final String id;
  final String title;
  final DateTime updatedAt;
}

class AiChatApi {
  AiChatApi(this._dio);
  final Dio _dio;

  /// Stream chat response as SSE events.
  Stream<AiEvent> chat(String message, {String? sessionId}) async* {
    try {
      final resp = await _dio.post<ResponseBody>(
        '/ai/chat',
        data: {
          'message': message,
          if (sessionId != null) 'session_id': sessionId,
        },
        options: Options(
          responseType: ResponseType.stream,
          headers: {'Accept': 'text/event-stream'},
        ),
      );

      final stream = resp.data!.stream
          .cast<List<int>>()
          .transform(const Utf8Decoder())
          .transform(const LineSplitter());

      await for (final line in stream) {
        if (line.startsWith('data: ')) {
          final raw = line.substring(6).trim();
          if (raw == '[DONE]') break;
          try {
            final json = jsonDecode(raw) as Map<String, dynamic>;
            final event = _parseEvent(json);
            if (event != null) yield event;
          } catch (_) {
            // ignore malformed SSE lines
          }
        }
      }
    } catch (e) {
      yield AiError(e.toString());
    }
  }

  Stream<AiEvent> confirm(
    String sessionId,
    String toolCallId,
    bool confirmed,
  ) {
    return _streamPost(
      '/ai/chat/confirm',
      {
        'session_id': sessionId,
        'tool_call_id': toolCallId,
        'confirmed': confirmed,
      },
    );
  }

  Future<Result<List<AiSession>, AppError>> getSessions() async {
    try {
      final resp = await _dio.get<Map<String, dynamic>>('/ai/sessions');
      final raw = (resp.data?['sessions'] as List<dynamic>?) ?? [];
      final sessions = raw
          .whereType<Map<String, dynamic>>()
          .map(AiSession.fromJson)
          .toList();
      return Ok(sessions);
    } on DioException catch (e) {
      return Err(e.error is AppError
          ? e.error as AppError
          : UnknownError(e.message ?? ''));
    }
  }

  Future<Result<List<Map<String, dynamic>>, AppError>> getSession(
      String id) async {
    try {
      final resp =
          await _dio.get<Map<String, dynamic>>('/ai/sessions/$id');
      final raw = (resp.data?['messages'] as List<dynamic>?) ?? [];
      final msgs = raw.whereType<Map<String, dynamic>>().toList();
      return Ok(msgs);
    } on DioException catch (e) {
      return Err(e.error is AppError
          ? e.error as AppError
          : UnknownError(e.message ?? ''));
    }
  }

  Future<Result<void, AppError>> deleteSession(String id) async {
    try {
      await _dio.delete<void>('/ai/sessions/$id');
      return const Ok(null);
    } on DioException catch (e) {
      return Err(e.error is AppError
          ? e.error as AppError
          : UnknownError(e.message ?? ''));
    }
  }

  AiEvent? _parseEvent(Map<String, dynamic> json) {
    final type = json['type'] as String?;
    return switch (type) {
      'session' => AiSessionStarted(json['session_id'] as String? ?? ''),
      'text' => AiTextDelta(json['delta'] as String? ?? ''),
      'tool_call' => AiToolCall(
          id: json['id'] as String,
          name: json['name'] as String,
          input: (json['input'] as Map<String, dynamic>?) ?? {},
        ),
      'tool_result' => AiToolResult(
          toolCallId: json['tool_call_id'] as String,
          content: json['content'],
        ),
      'requires_confirmation' => AiRequiresConfirmation(
          toolCallId: json['tool_call_id'] as String,
          actionSummary: json['action_summary'] as String? ?? 'Confirm action',
          action: (json['action'] as Map<String, dynamic>?) ?? {},
        ),
      'done' => AiDone(),
      'error' => AiError(json['message'] as String? ?? ''),
      _ => null,
    };
  }

  Stream<AiEvent> _streamPost(
    String path,
    Map<String, dynamic> data,
  ) async* {
    try {
      final resp = await _dio.post<ResponseBody>(
        path,
        data: data,
        options: Options(
          responseType: ResponseType.stream,
          headers: {'Accept': 'text/event-stream'},
        ),
      );

      final stream = resp.data!.stream
          .cast<List<int>>()
          .transform(const Utf8Decoder())
          .transform(const LineSplitter());

      await for (final line in stream) {
        if (!line.startsWith('data: ')) continue;
        final raw = line.substring(6).trim();
        if (raw == '[DONE]') break;
        try {
          final json = jsonDecode(raw) as Map<String, dynamic>;
          final event = _parseEvent(json);
          if (event != null) yield event;
        } catch (_) {
          // ignore malformed SSE lines
        }
      }
    } catch (e) {
      yield AiError(e.toString());
    }
  }
}
