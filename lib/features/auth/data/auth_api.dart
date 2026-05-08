import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/errors/app_error.dart';
import '../../../core/network/api_client.dart';
import '../../../core/utils/result.dart';
import 'models/auth_response.dart';

part 'auth_api.g.dart';

@riverpod
AuthApi authApi(Ref ref) => AuthApi(ref.watch(dioProvider));

class AuthApi {
  AuthApi(this._dio);
  final Dio _dio;

  Future<Result<AuthResponse, AppError>> login({
    required String email,
    required String password,
    String? totpToken,
  }) async {
    try {
      final resp = await _dio.post<Map<String, dynamic>>(
        '/auth/login',
        data: {
          'email': email,
          'password': password,
          if (totpToken != null) 'totp_token': totpToken,
        },
      );
      return Ok(AuthResponse.fromJson(resp.data!));
    } on DioException catch (e) {
      return Err(e.error is AppError
          ? e.error as AppError
          : UnknownError(e.message ?? ''));
    } on Object catch (e) {
      return Err(UnknownError('Unexpected login response: $e'));
    }
  }

  Future<Result<AuthResponse, AppError>> register({
    required String fullName,
    required String email,
    required String password,
  }) async {
    try {
      final resp = await _dio.post<Map<String, dynamic>>(
        '/auth/register',
        data: {
          'name': fullName,
          'full_name': fullName,
          'email': email,
          'password': password,
        },
      );
      return Ok(AuthResponse.fromJson(resp.data!));
    } on DioException catch (e) {
      return Err(e.error is AppError
          ? e.error as AppError
          : UnknownError(e.message ?? ''));
    } on Object catch (e) {
      return Err(UnknownError('Unexpected registration response: $e'));
    }
  }

  Future<Result<Map<String, dynamic>, AppError>> getMe() async {
    try {
      final resp = await _dio.get<Map<String, dynamic>>('/profile');
      return Ok(resp.data!);
    } on DioException catch (e) {
      return Err(e.error is AppError
          ? e.error as AppError
          : UnknownError(e.message ?? ''));
    } on Object catch (e) {
      return Err(UnknownError('Unexpected profile response: $e'));
    }
  }

  Future<Result<void, AppError>> forgotPassword(String email) async {
    try {
      await _dio.post<void>('/auth/forgot-password', data: {'email': email});
      return const Ok(null);
    } on DioException catch (e) {
      return Err(e.error is AppError
          ? e.error as AppError
          : UnknownError(e.message ?? ''));
    }
  }

  Future<Result<void, AppError>> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    try {
      await _dio.post<void>('/auth/reset-password', data: {
        'email': email,
        'otp': otp,
        'new_password': newPassword,
      });
      return const Ok(null);
    } on DioException catch (e) {
      return Err(e.error is AppError
          ? e.error as AppError
          : UnknownError(e.message ?? ''));
    }
  }
}
