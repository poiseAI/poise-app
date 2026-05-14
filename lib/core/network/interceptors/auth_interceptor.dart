import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../storage/secure_storage.dart';

/// Increments when any request gets a 401 — auth_provider watches this
/// and transitions to unauthenticated when it changes.
final authInvalidatedProvider = StateProvider<int>((_) => 0);

/// QueuedInterceptor ensures only ONE 401 handler fires even when multiple
/// requests fail simultaneously. All others queue behind it.
class AuthInterceptor extends QueuedInterceptor {
  AuthInterceptor(this._ref);

  final Ref _ref;

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _ref.read(secureStorageProvider).getToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    final sessionId = await _ref.read(secureStorageProvider).getSessionId();
    if (sessionId != null) {
      options.headers['X-Poise-Session-Id'] = sessionId;
      options.headers['X-Poise-Session-Policy'] = 'single-device';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      await _ref.read(secureStorageProvider).deleteToken();
      _ref.read(authInvalidatedProvider.notifier).update((n) => n + 1);
    }
    handler.next(err);
  }
}
