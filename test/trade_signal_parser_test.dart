import 'package:flutter_test/flutter_test.dart';
import 'package:poise_ai/features/trade_entry/data/signal_parser.dart';

void main() {
  group('parseTradeSignal', () {
    test('extracts a standard futures signal', () {
      final parsed = parseTradeSignal('''
BTC/USDT LONG
Entry 67,420.50
SL 66,000
TP1 69,000
TP2 70,500
10x isolated
Margin 1000 USDT
''');

      expect(parsed.symbol, 'BTCUSDT');
      expect(parsed.baseAsset, 'BTC');
      expect(parsed.quoteAsset, 'USDT');
      expect(parsed.side, 'long');
      expect(parsed.entryPrice, 67420.50);
      expect(parsed.stopLoss, 66000);
      expect(parsed.takeProfits, [69000, 70500]);
      expect(parsed.leverage, 10);
      expect(parsed.collateralMode, 'isolated');
      expect(parsed.marginAmount, 1000);
      expect(parsed.isActionable, isTrue);
    });

    test('infers short direction from stop and target placement', () {
      final parsed =
          parseTradeSignal('ETHUSDT entry 3500 stop 3600 target 3300');

      expect(parsed.symbol, 'ETHUSDT');
      expect(parsed.side, 'short');
      expect(parsed.entryPrice, 3500);
      expect(parsed.stopLoss, 3600);
      expect(parsed.takeProfits, [3300]);
    });

    test('extracts compact single-line signal labels', () {
      final parsed = parseTradeSignal(
        'BTCUSDT LONG ENTRY 65000 SL 64000 TP 68000 LEV 5X MARGIN 100',
      );

      expect(parsed.symbol, 'BTCUSDT');
      expect(parsed.side, 'long');
      expect(parsed.entryPrice, 65000);
      expect(parsed.stopLoss, 64000);
      expect(parsed.takeProfits, [68000]);
      expect(parsed.leverage, 5);
      expect(parsed.marginAmount, 100);
    });

    test('reports missing fields for partial signals', () {
      final parsed = parseTradeSignal('SOLUSDT buy tp 180');

      expect(parsed.symbol, 'SOLUSDT');
      expect(parsed.side, 'long');
      expect(parsed.missingFields, contains('entry'));
      expect(parsed.missingFields, contains('stop loss'));
      expect(parsed.isActionable, isFalse);
    });
  });
}
