import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:poise_ai/core/errors/app_error.dart';
import 'package:poise_ai/features/auth/data/auth_api.dart';

class _MockDio extends Mock implements Dio {}

void main() {
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
}
