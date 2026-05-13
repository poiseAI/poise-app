import 'package:flutter_test/flutter_test.dart';
import 'package:poise_ai/features/positions/data/models/position.dart';

void main() {
  test('position model parses backend snake_case response fields', () {
    final position = Position.fromJson({
      'id': 'pos-1',
      'symbol': 'BTCUSDT',
      'side': 'long',
      'size': '0.25',
      'entry_price': '100000',
      'current_price': 101250.5,
      'unrealized_pnl': '312.62',
      'unrealized_pnl_pct': 1.25,
      'status': 'open',
      'is_locked': true,
      'exchange': 'bybit',
      'created_at': '2026-05-13T10:00:00Z',
    });

    expect(position.quantity, 0.25);
    expect(position.entryPrice, 100000);
    expect(position.currentPrice, 101250.5);
    expect(position.unrealizedPnl, 312.62);
    expect(position.unrealizedPnlPct, 1.25);
    expect(position.isLocked, isTrue);
  });
}
