import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:poise_ai/core/errors/app_error.dart';
import 'package:poise_ai/features/auth/data/auth_api.dart';

class _MockDio extends Mock implements Dio {}

void main() {
  test('login sends session policy headers when session id is provided',
      () async {
    final dio = _MockDio();
    Options? capturedOptions;
    when(
      () => dio.post<Map<String, dynamic>>(
        any(),
        data: any<dynamic>(named: 'data'),
        options: any(named: 'options'),
      ),
    ).thenAnswer((invocation) async {
      capturedOptions = invocation.namedArguments[#options] as Options?;
      return Response<Map<String, dynamic>>(
        requestOptions: RequestOptions(path: '/auth/login'),
        statusCode: 200,
        data: {
          'token': 'jwt',
          'user': {
            'id': 'user-1',
            'email': 'user@example.com',
            'full_name': 'Test User',
            'email_verified': true,
          },
        },
      );
    });

    final result = await AuthApi(dio).login(
      email: 'user@example.com',
      password: 'password',
      sessionId: 'session-1',
    );

    expect(result.isOk, isTrue);
    expect(capturedOptions?.headers?['X-Poise-Session-Id'], 'session-1');
    expect(
      capturedOptions?.headers?['X-Poise-Session-Policy'],
      'single-device',
    );
  });

  test('login maps 401 responses to invalid credentials', () async {
    final dio = _MockDio();
    when(
      () => dio.post<Map<String, dynamic>>(
        any(),
        data: any<dynamic>(named: 'data'),
      ),
    ).thenThrow(
      DioException(
        requestOptions: RequestOptions(path: '/auth/login'),
        response: Response<void>(
          requestOptions: RequestOptions(path: '/auth/login'),
          statusCode: 401,
        ),
      ),
    );

    final result = await AuthApi(dio).login(
      email: 'user@example.com',
      password: 'wrong-password',
    );

    expect(result.isErr, isTrue);
    expect(result.error, isA<InvalidCredentialsError>());
    expect(result.error.userMessage, 'Invalid credentials');
  });

  test('login preserves totp challenge errors so 2fa field can open', () async {
    final dio = _MockDio();
    when(
      () => dio.post<Map<String, dynamic>>(
        any(),
        data: any<dynamic>(named: 'data'),
      ),
    ).thenThrow(
      DioException(
        requestOptions: RequestOptions(path: '/auth/login'),
        response: Response<Map<String, dynamic>>(
          requestOptions: RequestOptions(path: '/auth/login'),
          statusCode: 401,
          data: {'error': 'TOTP token required'},
        ),
      ),
    );

    final result = await AuthApi(dio).login(
      email: 'user@example.com',
      password: 'correct-password',
    );

    expect(result.isErr, isTrue);
    expect(result.error, isA<ServerError>());
    expect(result.error.userMessage, contains('totp'));
  });

  test('register sends session policy headers when session id is provided',
      () async {
    final dio = _MockDio();
    Options? capturedOptions;
    when(
      () => dio.post<Map<String, dynamic>>(
        any(),
        data: any<dynamic>(named: 'data'),
        options: any(named: 'options'),
      ),
    ).thenAnswer((invocation) async {
      capturedOptions = invocation.namedArguments[#options] as Options?;
      return Response<Map<String, dynamic>>(
        requestOptions: RequestOptions(path: '/auth/register'),
        statusCode: 201,
        data: {
          'token': 'jwt',
          'user': {
            'id': 'user-1',
            'email': 'user@example.com',
            'full_name': 'Test User',
            'email_verified': false,
          },
        },
      );
    });

    final result = await AuthApi(dio).register(
      fullName: 'Test User',
      email: 'user@example.com',
      password: 'Password1!',
      sessionId: 'session-1',
    );

    expect(result.isOk, isTrue);
    expect(capturedOptions?.headers?['X-Poise-Session-Id'], 'session-1');
    expect(
      capturedOptions?.headers?['X-Poise-Session-Policy'],
      'single-device',
    );
  });
}
