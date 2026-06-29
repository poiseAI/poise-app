import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:poise_ai/core/network/api_client.dart';
import 'package:poise_ai/core/theme/app_theme.dart';
import 'package:poise_ai/features/trade_entry/data/models/symbol.dart';
import 'package:poise_ai/features/trade_entry/data/trade_api.dart';
import 'package:poise_ai/features/trade_entry/providers/trade_form_provider.dart';
import 'package:poise_ai/features/trade_entry/screens/trade_entry_screen.dart';
import 'package:poise_ai/features/trade_entry/screens/trade_validation_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _MockDio extends Mock implements Dio {}

void main() {
  testWidgets('new trade screen follows the updated entry flow labels',
      (tester) async {
    _setFigmaPhoneViewport(tester);
    SharedPreferences.setMockInitialValues({});
    final dio = _tradeEntryDio();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [dioProvider.overrideWithValue(dio)],
        child: MaterialApp(
          theme: AppTheme.light,
          home: const TradeEntryScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('New Trade'), findsOneWidget);
    expect(find.text('Open a new trade'), findsNothing);
    expect(find.text('Trading pair'), findsOneWidget);
    expect(find.text('Margin type'), findsOneWidget);
    expect(find.text('Entry Type'), findsOneWidget);
    expect(find.text('Market'), findsOneWidget);
    expect(find.text('Limit'), findsOneWidget);
    expect(find.text('Trade amount'), findsOneWidget);
    expect(find.text('Review trade summary'), findsOneWidget);
  });

  testWidgets('trade validation uses the updated trade review language',
      (tester) async {
    _setFigmaPhoneViewport(tester);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          tradeFormProvider.overrideWith(_TradeReviewForm.new),
        ],
        child: MaterialApp(
          theme: AppTheme.light,
          home: const TradeValidationScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Trade review'), findsOneWidget);
    expect(find.text('Trade validation'), findsNothing);
    expect(find.text('Review guardrails'), findsOneWidget);
    expect(find.text('TP1 Possible Profit'), findsOneWidget);
    expect(find.text('Possible Profit'), findsNothing);
  });
}

void _setFigmaPhoneViewport(WidgetTester tester) {
  tester.view.physicalSize = const Size(390, 843);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

_MockDio _tradeEntryDio() {
  final dio = _MockDio();
  when(
    () => dio.get<Map<String, dynamic>>(
      '/trade/preflight',
      queryParameters: any(named: 'queryParameters'),
    ),
  ).thenAnswer(
    (_) async => Response<Map<String, dynamic>>(
      requestOptions: RequestOptions(path: '/trade/preflight'),
      data: {
        'allowed': true,
        'exchange': 'bybit',
        'rules': {
          'risk_per_trade_pct': 2,
          'max_leverage': 20,
          'trades_today': 0,
          'max_trades_per_day': 5,
          'daily_loss_limit_usd': 500,
        },
      },
    ),
  );
  when(
    () => dio.get<Map<String, dynamic>>(
      '/exchange/balance',
      queryParameters: any(named: 'queryParameters'),
    ),
  ).thenAnswer(
    (_) async => Response<Map<String, dynamic>>(
      requestOptions: RequestOptions(path: '/exchange/balance'),
      data: {'available': 10000, 'currency': 'USDT'},
    ),
  );
  when(
    () => dio.get<Map<String, dynamic>>(
      '/symbols/popular',
      queryParameters: any(named: 'queryParameters'),
    ),
  ).thenAnswer(
    (_) async => Response<Map<String, dynamic>>(
      requestOptions: RequestOptions(path: '/symbols/popular'),
      data: {
        'symbols': [
          _symbolJson('BTC', 67420.50, -1.24),
          _symbolJson('ETH', 3151.80, 2.31),
        ],
      },
    ),
  );
  return dio;
}

Map<String, dynamic> _symbolJson(
  String base,
  double price,
  double changePct,
) {
  return {
    'symbol': '${base}USDT',
    'base_asset': base,
    'quote_asset': 'USDT',
    'exchange': 'bybit',
    'status': 'Trading',
    'last_price': price,
    'price_change_24h': price * changePct / 100,
    'price_change_pct': changePct,
    'max_leverage': 20,
  };
}

class _TradeReviewForm extends TradeForm {
  @override
  TradeFormState build() => const TradeFormState(
        symbol: TradingSymbol(
          symbol: 'BTCUSDT',
          baseAsset: 'BTC',
          quoteAsset: 'USDT',
          exchange: 'bybit',
          status: 'Trading',
          lastPrice: 50000,
          maxLeverage: 20,
        ),
        orderType: OrderType.limit,
        side: OrderSide.long,
        collateralMode: CollateralMode.isolated,
        marginMode: MarginMode.fixed,
        marginValue: 5000,
        leverage: 5,
        limitPrice: 50000,
        takeProfit1: 80500,
        slPrice: 60000,
        preflight: TradePreflight(
          allowed: true,
          exchange: 'bybit',
          riskPerTradePct: 2,
          maxLeverage: 20,
          tradesToday: 0,
          maxTradesPerDay: 5,
          dailyLossLimitType: 'fixed_usd',
          dailyLossLimitUsd: 500,
          dailyBaselineBalanceUsd: 10000,
          dailyAvailableBalanceUsd: 10000,
          balanceSnapshotComplete: true,
          balanceSnapshotExpectedConnections: 1,
          balanceSnapshotCapturedConnections: 1,
          externalOpenPositions: 0,
          unknownRiskPositions: 0,
          unfilledOrderCancelAfterMinutes: 120,
        ),
        validation: TradeValidationResult(
          submitToken: 'submit-token',
          riskPct: 2,
          margin: 5000,
          positionSize: 25000,
          riskRewardRatio: '2.5',
          possibleLoss: 125,
          possibleProfit: 437.5,
          dailyBaselineBalanceUsd: 10000,
          dailyAvailableBalanceUsd: 10000,
          dailyLossLimitType: 'fixed_usd',
          dailyLossLimitUsd: 500,
          realizedDailyLossUsd: 0,
          openPositionReservedLossUsd: 0,
          externalUnrealizedLossUsd: 0,
          currentDailyRiskUsedUsd: 0,
          projectedDailyLossUsd: 125,
          remainingDailyLossBudgetUsd: 375,
          balanceSnapshotComplete: true,
          balanceSnapshotExpectedConnections: 1,
          balanceSnapshotCapturedConnections: 1,
          externalOpenPositions: 0,
          unknownRiskPositions: 0,
          requiresExternalRiskReview: false,
          dailyLimitAcknowledgementRequired: false,
          blockingGuardrails: [],
          warningGuardrails: [],
          behavioralWarnings: [],
        ),
      );
}
