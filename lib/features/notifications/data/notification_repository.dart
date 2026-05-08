import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/errors/app_error.dart';
import '../../../core/network/api_client.dart';
import '../../../core/utils/result.dart';
import 'models/notification_item.dart';

part 'notification_repository.g.dart';

@riverpod
NotificationRepository notificationRepository(Ref ref) =>
    NotificationRepository(ref.watch(dioProvider));

class NotificationRepository {
  NotificationRepository(this._dio);
  final Dio _dio;

  Future<Result<List<NotificationItem>, AppError>> getRecent(
      {int limit = 50}) async {
    try {
      final resp = await _dio.get<List<dynamic>>(
        '/notifications',
        queryParameters: {'limit': limit},
      );
      final list = (resp.data ?? [])
          .cast<Map<String, dynamic>>()
          .map(NotificationItem.fromJson)
          .toList();
      return Ok(list);
    } on DioException catch (e) {
      return Err(
          e.error is AppError ? e.error as AppError : UnknownError(e.message ?? ''));
    }
  }

  Future<Result<void, AppError>> markRead(String id) async {
    try {
      await _dio.post<void>('/notifications/$id/read');
      return const Ok(null);
    } on DioException catch (e) {
      return Err(
          e.error is AppError ? e.error as AppError : UnknownError(e.message ?? ''));
    }
  }

  Future<Result<void, AppError>> markAllRead() async {
    try {
      await _dio.post<void>('/notifications/read-all');
      return const Ok(null);
    } on DioException catch (e) {
      return Err(
          e.error is AppError ? e.error as AppError : UnknownError(e.message ?? ''));
    }
  }

  Future<Result<void, AppError>> dismiss(String id) async {
    try {
      await _dio.delete<void>('/notifications/$id');
      return const Ok(null);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return const Ok(null);
      return Err(
          e.error is AppError ? e.error as AppError : UnknownError(e.message ?? ''));
    }
  }
}
