import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/errors/app_error.dart';
import '../../../core/network/api_client.dart';
import '../../../core/utils/result.dart';
import 'models/strategy.dart';

part 'strategies_api.g.dart';

@riverpod
StrategiesApi strategiesApi(Ref ref) =>
    StrategiesApi(ref.watch(dioProvider));

class StrategiesApi {
  StrategiesApi(this._dio);
  final Dio _dio;

  Future<Result<Strategy, AppError>> createStrategy(
      CreateStrategyRequest req) async {
    try {
      final resp = await _dio.post<Map<String, dynamic>>(
        '/strategies',
        data: req.toJson(),
      );
      return Ok(Strategy.fromJson(resp.data!));
    } on DioException catch (e) {
      return Err(
          e.error is AppError ? e.error as AppError : UnknownError(e.message ?? ''));
    }
  }

  Future<Result<List<Strategy>, AppError>> getStrategies() async {
    try {
      final resp = await _dio.get<Map<String, dynamic>>('/strategies');
      final list = ((resp.data?['strategies'] as List<dynamic>?) ?? [])
          .cast<Map<String, dynamic>>()
          .map(Strategy.fromJson)
          .toList();
      return Ok(list);
    } on DioException catch (e) {
      return Err(
          e.error is AppError ? e.error as AppError : UnknownError(e.message ?? ''));
    }
  }

  Future<Result<List<Strategy>, AppError>> getActiveStrategies() async {
    try {
      final resp = await _dio.get<Map<String, dynamic>>('/strategies/active');
      final list = ((resp.data?['strategies'] as List<dynamic>?) ?? [])
          .cast<Map<String, dynamic>>()
          .map(Strategy.fromJson)
          .toList();
      return Ok(list);
    } on DioException catch (e) {
      return Err(
          e.error is AppError ? e.error as AppError : UnknownError(e.message ?? ''));
    }
  }

  Future<Result<void, AppError>> activateStrategy(String id) async {
    try {
      await _dio.post<void>('/strategies/$id/activate');
      return const Ok(null);
    } on DioException catch (e) {
      return Err(
          e.error is AppError ? e.error as AppError : UnknownError(e.message ?? ''));
    }
  }

  Future<Result<void, AppError>> deactivateStrategy(String id) async {
    try {
      await _dio.post<void>('/strategies/$id/deactivate');
      return const Ok(null);
    } on DioException catch (e) {
      return Err(
          e.error is AppError ? e.error as AppError : UnknownError(e.message ?? ''));
    }
  }

  Future<Result<void, AppError>> deleteStrategy(String id) async {
    try {
      await _dio.delete<void>('/strategies/$id');
      return const Ok(null);
    } on DioException catch (e) {
      return Err(
          e.error is AppError ? e.error as AppError : UnknownError(e.message ?? ''));
    }
  }
}
