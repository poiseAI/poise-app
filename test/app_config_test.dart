import 'package:flutter_test/flutter_test.dart';
import 'package:poise_ai/core/config/app_config.dart';

void main() {
  test('release network defaults use production TLS endpoints', () {
    expect(AppConfig.baseUrl, 'https://poiseai.brainpad.me/api/v1');
    expect(AppConfig.wsUrl, 'wss://poiseai.brainpad.me/api/v1/ws');
  });
}
