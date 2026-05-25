import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../storage/secure_storage.dart';

/// Increments when any request gets a 401 — auth_provider watches this
/// and transitions to unauthenticated when it changes.
final authInvalidatedProvider = StateProvider<int>((_) => 0);
final authInvalidationReasonProvider = StateProvider<String?>((_) => null);

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
    if (err.response?.statusCode == 401 &&
        !_isAuthRequest(err.requestOptions.path) &&
        !_isExchangeCredentialRequest(err.requestOptions.path)) {
      _ref.read(authInvalidationReasonProvider.notifier).state =
          _friendlyInvalidationMessage(err.response?.data);
      await _ref.read(secureStorageProvider).deleteToken();
      _ref.read(authInvalidatedProvider.notifier).update((n) => n + 1);
    }
    handler.next(err);
  }

  bool _isAuthRequest(String path) {
    return path.startsWith('/auth/');
  }

  bool _isExchangeCredentialRequest(String path) {
    return path == '/exchange-connections' ||
        path == '/exchange-connections/test';
  }
}

String _friendlyInvalidationMessage(Object? data) {
  final raw = switch (data) {
    final Map<String, dynamic> map => map['error']?.toString() ?? '',
    final Map<dynamic, dynamic> map => map['error']?.toString() ?? '',
    _ => '',
  };
  final lower = raw.toLowerCase();
  if (lower.contains('session expired') ||
      lower.contains('active session') ||
      lower.contains('another device')) {
    return 'Your account was signed in on another device, so this session was ended.';
  }
  return 'Your session has expired. Please log in again.';
}
