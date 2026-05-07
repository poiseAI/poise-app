import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/errors/app_error.dart';
import '../../../core/network/api_client.dart';
import '../../../core/utils/result.dart';
import 'models/tpsl_config.dart';

final tpSlApiProvider = Provider<TpSlApi>(
  (ref) => TpSlApi(ref.watch(dioProvider)),
);

class TpSlApi {
  TpSlApi(this._dio);
  final Dio _dio;

  /// GET /positions/:id/tpsl — returns empty config if none exists yet.
  Future<Result<TpSlConfig, AppError>> get(String positionId) async {
    try {
      final resp = await _dio.get<Map<String, dynamic>>(
        '/positions/$positionId/tpsl',
      );
      final data = resp.data;
      if (data == null) return Ok(TpSlConfig());
      return Ok(TpSlConfig.fromJson(data));
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return Ok(TpSlConfig());
      return Err(
        e.error is AppError
            ? e.error as AppError
            : UnknownError(e.message ?? 'Failed to load TP/SL config'),
      );
    }
  }

  /// POST /positions/:id/tpsl
  Future<Result<TpSlConfig, AppError>> save(
    String positionId,
    TpSlConfig config,
  ) async {
    try {
      final resp = await _dio.post<Map<String, dynamic>>(
        '/positions/$positionId/tpsl',
        data: config.toJson(),
      );
      final data = resp.data;
      if (data == null) return Ok(config);
      return Ok(TpSlConfig.fromJson(data));
    } on DioException catch (e) {
      return Err(
        e.error is AppError
            ? e.error as AppError
            : UnknownError(e.message ?? 'Failed to save TP/SL config'),
      );
    }
  }
}
