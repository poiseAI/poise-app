import 'package:flutter_test/flutter_test.dart';
import 'package:poise_ai/features/orders/data/models/order.dart';

void main() {
  test('order model parses Bybit-style filled order fields', () {
    final order = Order.fromJson({
      'orderId': '2226965116916866818',
      'symbol': 'BTCUSDT',
      'side': 'Buy',
      'orderStatus': 'Filled',
      'orderType': 'Market',
      'qty': '0.0025',
      'avgPrice': '72692.90',
      'takeProfit': '73500',
      'stopLoss': '71000',
      'updatedTime': '1772366529000',
      'createdTime': '1772362922000',
      'exchange': 'bybit',
      'source': 'external',
    });

    expect(order.id, '2226965116916866818');
    expect(order.quantity, 0.0025);
    expect(order.entryPrice, 72692.90);
    expect(order.tpLevels, [73500]);
    expect(order.slPrice, 71000);
    expect(order.closedAt, isNotNull);
    expect(order.isActiveTrade, isFalse);
    expect(order.statusLabel, 'Filled');
  });

  test('open status only includes genuinely active orders', () {
    expect(
      isActiveOrderStatus(status: 'open', remainingQuantity: 0.01),
      isTrue,
    );
    expect(isActiveOrderStatus(status: 'Filled'), isFalse);
    expect(
      isActiveOrderStatus(status: 'PartiallyFilled', remainingQuantity: 0.01),
      isTrue,
    );
    expect(
      isActiveOrderStatus(status: 'PartiallyFilled', remainingQuantity: 0),
      isFalse,
    );
    expect(
      isActiveOrderStatus(status: 'New', remainingQuantity: 0),
      isFalse,
    );
  });
}
