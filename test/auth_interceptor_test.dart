import 'dart:async';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:poise_ai/core/network/interceptors/auth_interceptor.dart';
import 'package:poise_ai/core/storage/secure_storage.dart';

final _authInterceptorProvider = Provider<AuthInterceptor>(
  AuthInterceptor.new,
);

void main() {
  test('preserves explicit auth and session headers', () async {
    final storage = _FakeSecureStorage()
      ..token = 'stored-token'
      ..sessionId = 'stored-session';
    final adapter = _CaptureAdapter();
    final container = ProviderContainer(
      overrides: [secureStorageProvider.overrideWithValue(storage)],
    );
    addTearDown(container.dispose);

    final dio = _dioWith(container, adapter);

    await dio.post<void>(
      '/auth/login',
      options: Options(headers: {
        'Authorization': 'Bearer explicit-token',
        'X-Poise-Session-Id': 'new-session',
        'X-Poise-Session-Policy': 'single-device',
      }),
    );

    expect(adapter.options?.headers['Authorization'], 'Bearer explicit-token');
    expect(adapter.options?.headers['X-Poise-Session-Id'], 'new-session');
    expect(
      adapter.options?.headers['X-Poise-Session-Policy'],
      'single-device',
    );
  });

  test('injects stored auth and session headers when absent', () async {
    final storage = _FakeSecureStorage()
      ..token = 'stored-token'
      ..sessionId = 'stored-session';
    final adapter = _CaptureAdapter();
    final container = ProviderContainer(
      overrides: [secureStorageProvider.overrideWithValue(storage)],
    );
    addTearDown(container.dispose);

    final dio = _dioWith(container, adapter);

    await dio.get<void>('/me');

    expect(adapter.options?.headers['Authorization'], 'Bearer stored-token');
    expect(adapter.options?.headers['X-Poise-Session-Id'], 'stored-session');
    expect(
      adapter.options?.headers['X-Poise-Session-Policy'],
      'single-device',
    );
  });

  test('401 invalidation clears the full stored session', () async {
    final storage = _FakeSecureStorage()
      ..token = 'stored-token'
      ..sessionId = 'stored-session';
    final adapter = _CaptureAdapter(
      statusCode: 401,
      body: '{"error":"active session found on another device"}',
    );
    final container = ProviderContainer(
      overrides: [secureStorageProvider.overrideWithValue(storage)],
    );
    addTearDown(container.dispose);

    final dio = _dioWith(container, adapter);

    await expectLater(
      dio.get<void>('/me'),
      throwsA(isA<DioException>()),
    );

    expect(storage.clearSessionCalls, 1);
    expect(container.read(authInvalidatedProvider), 1);
    expect(
      container.read(authInvalidationReasonProvider),
      contains('another device'),
    );
  });
}

Dio _dioWith(ProviderContainer container, _CaptureAdapter adapter) {
  final dio = Dio(BaseOptions(baseUrl: 'https://example.test'));
  dio.interceptors.add(container.read(_authInterceptorProvider));
  dio.httpClientAdapter = adapter;
  return dio;
}

class _CaptureAdapter implements HttpClientAdapter {
  _CaptureAdapter({this.statusCode = 200, this.body = '{}'});

  final int statusCode;
  final String body;
  RequestOptions? options;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    this.options = options;
    return ResponseBody.fromString(
      body,
      statusCode,
      headers: {
        Headers.contentTypeHeader: ['application/json'],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

class _FakeSecureStorage extends SecureStorageService {
  String? token;
  String? sessionId;
  int clearSessionCalls = 0;

  @override
  Future<String?> getToken() async => token;

  @override
  Future<String?> getSessionId() async => sessionId;

  @override
  Future<void> clearSession() async {
    clearSessionCalls++;
    token = null;
    sessionId = null;
  }
}
