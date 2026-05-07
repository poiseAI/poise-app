import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/errors/app_error.dart';
import '../../../core/network/api_client.dart';
import '../../../core/utils/result.dart';
import 'models/position.dart';

part 'positions_api.g.dart';

@riverpod
PositionsApi positionsApi(Ref ref) => PositionsApi(ref.watch(dioProvider));

class PositionsApi {
  PositionsApi(this._dio);
  final Dio _dio;

  Future<Result<List<Position>, AppError>> getOpenPositions() async {
    try {
      final resp = await _dio.get<Map<String, dynamic>>('/positions/open');
      final list =
          _extractList(resp.data, 'positions').map(Position.fromJson).toList();
      return Ok(list);
    } on DioException catch (e) {
      return Err(e.error is AppError
          ? e.error as AppError
          : UnknownError(e.message ?? ''));
    }
  }

  Future<Result<PnlSummary, AppError>> getPnlSummary() async {
    try {
      final resp =
          await _dio.get<Map<String, dynamic>>('/positions/pnl-summary');
      return Ok(PnlSummary.fromJson(resp.data!));
    } on DioException catch (e) {
      return Err(e.error is AppError
          ? e.error as AppError
          : UnknownError(e.message ?? ''));
    }
  }

  Future<Result<void, AppError>> lockPosition(String id) async {
    try {
      await _dio.post<void>('/positions/$id/lock');
      return const Ok(null);
    } on DioException catch (e) {
      return Err(e.error is AppError
          ? e.error as AppError
          : UnknownError(e.message ?? ''));
    }
  }

  Future<Result<void, AppError>> unlockPosition(String id) async {
    try {
      await _dio.post<void>('/positions/$id/unlock');
      return const Ok(null);
    } on DioException catch (e) {
      return Err(e.error is AppError
          ? e.error as AppError
          : UnknownError(e.message ?? ''));
    }
  }

  Future<Result<void, AppError>> closePosition(String id) async {
    try {
      await _dio.post<void>('/positions/$id/close');
      return const Ok(null);
    } on DioException catch (e) {
      return Err(e.error is AppError
          ? e.error as AppError
          : UnknownError(e.message ?? ''));
    }
  }
}

List<Map<String, dynamic>> _extractList(
  Map<String, dynamic>? data,
  String key,
) {
  final raw = data?[key];
  if (raw is! List) return const [];
  return raw.whereType<Map<String, dynamic>>().toList();
}
