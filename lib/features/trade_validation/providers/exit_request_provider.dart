import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/errors/app_error.dart';
import '../../../core/network/api_client.dart';

part 'exit_request_provider.freezed.dart';
part 'exit_request_provider.g.dart';

// ── Exit reason model ────────────────────────────────────────────────────────

class ExitReason {
  ExitReason({required this.id, required this.name, this.description});

  factory ExitReason.fromJson(Map<String, dynamic> json) => ExitReason(
        id: json['id'] as String,
        name: json['name'] as String? ??
            (json['category'] as String? ?? 'Exit reason').replaceAll('_', ' '),
        description: json['description'] as String?,
      );

  final String id;
  final String name;
  final String? description;
}

// ── Exit reasons provider ────────────────────────────────────────────────────

@riverpod
Future<List<ExitReason>> exitReasons(Ref ref) async {
  final dio = ref.watch(dioProvider);
  try {
    final resp = await dio.get<dynamic>('/exit-reasons');
    final raw = resp.data;
    final list = raw is List
        ? raw.whereType<Map<String, dynamic>>().toList()
        : ((raw as Map<String, dynamic>?)?['reasons'] as List<dynamic>? ??
                const [])
            .whereType<Map<String, dynamic>>()
            .toList();
    return list.map(ExitReason.fromJson).toList();
  } on DioException catch (e) {
    throw e.error is AppError
        ? e.error as AppError
        : UnknownError(e.message ?? 'Failed to load exit reasons');
  }
}

// ── Exit request state ───────────────────────────────────────────────────────

@freezed
abstract class ExitRequestState with _$ExitRequestState {
  const factory ExitRequestState({
    @Default('') String reasonId, // UUID from GET /exit-reasons
    @Default('') String description,
    @Default(false) bool isSubmitting,
    String? error,
    @Default(false) bool submitted,
    String? exitRequestId, // captured from POST response
  }) = _ExitRequestState;
}

// ── Exit request notifier ────────────────────────────────────────────────────

@riverpod
class ExitRequest extends _$ExitRequest {
  @override
  ExitRequestState build(String positionId) => const ExitRequestState();

  void setReason(String id) => state = state.copyWith(reasonId: id);
  void setDescription(String desc) => state = state.copyWith(description: desc);

  Future<void> submit() async {
    if (state.isSubmitting) return;
    if (state.reasonId.isEmpty) return;

    // Backend requires reason_description min=10 chars
    final desc = state.description.trim();
    if (desc.length < 10) {
      state = state.copyWith(
        error: 'Please describe the reason (at least 10 characters).',
      );
      return;
    }

    state = state.copyWith(isSubmitting: true, error: null);

    try {
      final dio = ref.read(dioProvider);
      final resp = await dio.post<Map<String, dynamic>>(
        '/positions/$positionId/exit-request',
        data: {
          'position_id': positionId,
          'exit_reason_id': state.reasonId,
          'reason_description': desc,
        },
      );
      final exitRequestId = resp.data?['id'] as String?;
      state = state.copyWith(
        isSubmitting: false,
        submitted: true,
        exitRequestId: exitRequestId,
      );
    } on DioException catch (e) {
      final err = e.error is AppError
          ? (e.error as AppError).userMessage
          : e.message ?? 'Failed to submit';
      state = state.copyWith(isSubmitting: false, error: err);
    }
  }
}
