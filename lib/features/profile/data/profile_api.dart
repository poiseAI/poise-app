import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/errors/app_error.dart';
import '../../../core/network/api_client.dart';
import '../../../core/utils/result.dart';

part 'profile_api.g.dart';

@riverpod
ProfileApi profileApi(Ref ref) => ProfileApi(ref.watch(dioProvider));

class ProfileApi {
  ProfileApi(this._dio);
  final Dio _dio;

  Future<Result<Map<String, dynamic>, AppError>> getProfile() async {
    try {
      final resp = await _dio.get<Map<String, dynamic>>('/profile');
      return Ok(resp.data!);
    } on DioException catch (e) {
      return Err(e.error is AppError
          ? e.error as AppError
          : UnknownError(e.message ?? ''));
    }
  }

  Future<Result<void, AppError>> updateProfile({
    String? fullName,
    required String email,
  }) async {
    try {
      await _dio.put<void>('/profile', data: {
        if (fullName != null) 'full_name': fullName,
        'email': email,
      });
      return const Ok(null);
    } on DioException catch (e) {
      return Err(e.error is AppError
          ? e.error as AppError
          : UnknownError(e.message ?? ''));
    }
  }

  Future<Result<void, AppError>> deleteAccount() async {
    try {
      await _dio.delete<void>('/profile');
      return const Ok(null);
    } on DioException catch (e) {
      return Err(e.error is AppError
          ? e.error as AppError
          : UnknownError(e.message ?? ''));
    }
  }

  Future<Result<void, AppError>> updatePassword({
    required String current,
    required String newPassword,
  }) async {
    try {
      await _dio.put<void>('/password', data: {
        'current_password': current,
        'new_password': newPassword,
      });
      return const Ok(null);
    } on DioException catch (e) {
      return Err(e.error is AppError
          ? e.error as AppError
          : UnknownError(e.message ?? ''));
    }
  }

  Future<Result<Map<String, dynamic>, AppError>> setupTotp() async {
    try {
      final resp = await _dio.post<Map<String, dynamic>>('/2fa/setup');
      return Ok(resp.data!);
    } on DioException catch (e) {
      return Err(e.error is AppError
          ? e.error as AppError
          : UnknownError(e.message ?? ''));
    }
  }

  Future<Result<void, AppError>> enableTotp({
    required String secret,
    required String token,
  }) async {
    try {
      await _dio
          .post<void>('/2fa/enable', data: {'secret': secret, 'token': token});
      return const Ok(null);
    } on DioException catch (e) {
      return Err(e.error is AppError
          ? e.error as AppError
          : UnknownError(e.message ?? ''));
    }
  }

  Future<Result<List<Map<String, dynamic>>, AppError>>
      getExchangeConnections() async {
    try {
      final resp = await _dio.get<dynamic>('/exchange-connections');
      final data = resp.data;
      final list = data is List
          ? data.whereType<Map<String, dynamic>>().toList()
          : ((data as Map<String, dynamic>?)?['connections']
                      as List<dynamic>? ??
                  const [])
              .whereType<Map<String, dynamic>>()
              .toList();
      return Ok(list);
    } on DioException catch (e) {
      return Err(e.error is AppError
          ? e.error as AppError
          : UnknownError(e.message ?? ''));
    }
  }

  Future<Result<void, AppError>> disableTotp({required String token}) async {
    try {
      await _dio.post<void>('/2fa/disable', data: {'token': token});
      return const Ok(null);
    } on DioException catch (e) {
      return Err(e.error is AppError
          ? e.error as AppError
          : UnknownError(e.message ?? ''));
    }
  }

  Future<Result<void, AppError>> activateExchangeConnection(String id) async {
    try {
      await _dio.post<void>('/exchange-connections/$id/activate');
      return const Ok(null);
    } on DioException catch (e) {
      return Err(e.error is AppError
          ? e.error as AppError
          : UnknownError(e.message ?? ''));
    }
  }

  Future<Result<void, AppError>> deactivateExchangeConnection(String id) async {
    try {
      await _dio.post<void>('/exchange-connections/$id/deactivate');
      return const Ok(null);
    } on DioException catch (e) {
      return Err(e.error is AppError
          ? e.error as AppError
          : UnknownError(e.message ?? ''));
    }
  }

  Future<Result<Map<String, dynamic>, AppError>> createExchangeConnection({
    required String exchange,
    required String apiKey,
    required String apiSecret,
    required bool isTestnet,
  }) async {
    try {
      final resp = await _dio.post<Map<String, dynamic>>(
        '/exchange-connections',
        data: {
          'exchange': exchange,
          'api_key': apiKey,
          'api_secret': apiSecret,
          'is_testnet': isTestnet,
        },
      );
      return Ok(resp.data!);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return Err(_exchangeAuthError(exchange));
      }
      return Err(e.error is AppError
          ? e.error as AppError
          : UnknownError(e.message ?? ''));
    }
  }

  /// Generates a single-use magic link and emails it to the user.
  /// User clicks the link to set up exchange API keys on the web dashboard.
  Future<Result<void, AppError>> requestApiKeyMagicLink() async {
    try {
      await _dio.post<void>('/exchange-connections/magic-link');
      return const Ok(null);
    } on DioException catch (e) {
      return Err(e.error is AppError
          ? e.error as AppError
          : UnknownError(e.message ?? ''));
    }
  }

  Future<Result<Map<String, dynamic>, AppError>> testExchangeConnection({
    required String exchange,
    required String apiKey,
    required String apiSecret,
    required bool isTestnet,
  }) async {
    try {
      final resp = await _dio.post<Map<String, dynamic>>(
        '/exchange-connections/test',
        data: {
          'exchange': exchange,
          'api_key': apiKey,
          'api_secret': apiSecret,
          'is_testnet': isTestnet,
        },
      );
      return Ok(resp.data!);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return Err(_exchangeAuthError(exchange));
      }
      return Err(e.error is AppError
          ? e.error as AppError
          : UnknownError(e.message ?? ''));
    }
  }

  Future<Result<Map<String, dynamic>, AppError>>
      getNotificationPreferences() async {
    try {
      final resp =
          await _dio.get<Map<String, dynamic>>('/notification-preferences');
      return Ok(resp.data ?? const {});
    } on DioException catch (e) {
      return Err(e.error is AppError
          ? e.error as AppError
          : UnknownError(e.message ?? ''));
    }
  }

  Future<Result<Map<String, dynamic>, AppError>> updateNotificationPreferences(
    Map<String, dynamic> prefs,
  ) async {
    try {
      final resp = await _dio.put<Map<String, dynamic>>(
        '/notification-preferences',
        data: prefs,
      );
      return Ok(resp.data ?? const {});
    } on DioException catch (e) {
      return Err(e.error is AppError
          ? e.error as AppError
          : UnknownError(e.message ?? ''));
    }
  }
}

ServerError _exchangeAuthError(String exchange) {
  final label = exchange.toLowerCase() == 'binance' ? 'Binance' : 'Bybit';
  return ServerError(
    401,
    'Unable to authenticate with $label. Check your API key, secret key, IP restrictions, and trading permissions.',
  );
}
