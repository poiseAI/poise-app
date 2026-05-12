import 'package:flutter_test/flutter_test.dart';
import 'package:poise_ai/features/home/data/home_analytics_api.dart';

void main() {
  test('home analytics parses all-exchange balance metadata', () {
    final analytics = HomeAnalytics.fromJson({
      'adherence_score': 82,
      'total_balance': '12840.75',
      'balance_tentative': true,
      'connected_exchanges': ['bybit', 'binance'],
    });

    expect(analytics.totalBalance, 12840.75);
    expect(analytics.balanceTentative, isTrue);
    expect(analytics.connectedExchangeCount, 2);
  });
}
