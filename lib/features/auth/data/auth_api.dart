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
    String? sessionId,
  }) async {
    try {
      final resp = await _dio.post<Map<String, dynamic>>(
        '/auth/login',
        options: sessionId == null
            ? null
            : Options(headers: {
                'X-Poise-Session-Id': sessionId,
                'X-Poise-Session-Policy': 'single-device',
              }),
        data: {
          'email': email,
          'password': password,
          if (totpToken != null) 'totp_token': totpToken,
        },
      );
      return Ok(AuthResponse.fromJson(resp.data!));
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        final rawMessage = _responseErrorMessage(e.response?.data);
        final message = rawMessage.toLowerCase();
        if (message.contains('totp') || message.contains('2fa')) {
          return Err(ServerError(401, rawMessage));
        }
        if (message.contains('disabled') || message.contains('inactive')) {
          return const Err(ServerError(
            401,
            'Account is disabled. Please contact support.',
          ));
        }
        return const Err(InvalidCredentialsError());
      }
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
    String? sessionId,
  }) async {
    try {
      final resp = await _dio.post<Map<String, dynamic>>(
        '/auth/register',
        options: sessionId == null
            ? null
            : Options(headers: {
                'X-Poise-Session-Id': sessionId,
                'X-Poise-Session-Policy': 'single-device',
              }),
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
      final resp = await _dio.get<Map<String, dynamic>>('/me');
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

  Future<Result<void, AppError>> verifyEmail(String otp) async {
    try {
      await _dio.post<void>('/auth/verify-email', data: {'otp': otp});
      return const Ok(null);
    } on DioException catch (e) {
      return Err(e.error is AppError
          ? e.error as AppError
          : UnknownError(e.message ?? ''));
    }
  }

  Future<Result<void, AppError>> resendEmailVerification() async {
    try {
      await _dio.post<void>('/auth/resend-verification');
      return const Ok(null);
    } on DioException catch (e) {
      return Err(e.error is AppError
          ? e.error as AppError
          : UnknownError(e.message ?? ''));
    }
  }
}

String _responseErrorMessage(Object? data) {
  if (data is Map<String, dynamic>) {
    return data['error']?.toString() ?? data['message']?.toString() ?? '';
  }
  if (data is Map<dynamic, dynamic>) {
    return data['error']?.toString() ?? data['message']?.toString() ?? '';
  }
  return '';
}
