import 'package:flutter_test/flutter_test.dart';
import 'package:poise_ai/features/notifications/data/models/notification_item.dart';

void main() {
  test('parses notification metadata returned as JSON string', () {
    final item = NotificationItem.fromJson(const {
      'id': 'n1',
      'title': 'Your trade just hit the SP',
      'body': 'BTC/USDT long position closed at TP1 with profit',
      'notification_type': 'order_filled',
      'read': false,
      'created_at': '2026-05-12T12:00:00Z',
      'meta': '{"symbol":"BTC/USDT","profit":245.5}',
    });

    expect(item.meta?['symbol'], 'BTC/USDT');
    expect(item.meta?['profit'], 245.5);
  });

  test('ignores malformed notification metadata instead of failing list parse',
      () {
    final item = NotificationItem.fromJson(const {
      'id': 'n2',
      'title': 'Exchange sync',
      'body': 'Connection updated',
      'notification_type': 'exchange_sync',
      'created_at': '2026-05-12T12:00:00Z',
      'meta': '{bad json',
    });

    expect(item.meta, isNull);
  });
}
