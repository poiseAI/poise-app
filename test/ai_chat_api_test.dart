import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:poise_ai/features/ai_chat/data/ai_chat_api.dart';

class _MockDio extends Mock implements Dio {}

void main() {
  test('chat maps core_required 402 to upgrade message', () async {
    final dio = _MockDio();
    when(
      () => dio.post<ResponseBody>(
        '/ai/chat',
        data: any(named: 'data'),
        options: any(named: 'options'),
      ),
    ).thenThrow(
      DioException(
        requestOptions: RequestOptions(path: '/ai/chat'),
        response: Response<Map<String, dynamic>>(
          requestOptions: RequestOptions(path: '/ai/chat'),
          statusCode: 402,
          data: {'code': 'core_required'},
        ),
      ),
    );

    final events = await AiChatApi(dio).chat('hello').toList();

    expect(events, hasLength(1));
    expect(events.single, isA<AiError>());
    expect(
      (events.single as AiError).message,
      'Start your 14-day Poise Core trial to chat with Poise AI.',
    );
  });
}
