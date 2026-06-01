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
    expect(position.isOpenPosition, isTrue);
  });

  test('position lifecycle excludes filled or closed exchange rows', () {
    final filled = Position.fromJson({
      'id': 'pos-2',
      'symbol': 'ETHUSDT',
      'side': 'Buy',
      'qty': '0',
      'avgPrice': '3500',
      'markPrice': '3500',
      'unrealizedPnl': '0',
      'status': 'Filled',
      'closedAt': '2026-05-31T07:02:09Z',
      'createdAt': '2026-05-31T07:02:09Z',
    });

    expect(filled.side, 'long');
    expect(filled.isOpenPosition, isFalse);

    final zeroOpen = Position.fromJson({
      'id': 'pos-3',
      'symbol': 'BTCUSDT',
      'side': 'long',
      'quantity': 0,
      'entry_price': 70000,
      'current_price': 70000,
      'unrealized_pnl': 0,
      'status': 'open',
      'created_at': '2026-05-31T07:02:09Z',
    });

    expect(zeroOpen.isOpenPosition, isFalse);
  });
}
