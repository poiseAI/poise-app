import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:poise_ai/core/errors/app_error.dart';
import 'package:poise_ai/core/utils/result.dart';
import 'package:poise_ai/features/orders/data/models/order.dart';
import 'package:poise_ai/features/orders/data/orders_api.dart';
import 'package:poise_ai/features/orders/providers/orders_provider.dart';
import 'package:poise_ai/features/orders/screens/orders_screen.dart';

class _FakeOrdersNotifier extends OrdersNotifier {
  _FakeOrdersNotifier(this._orders);

  final List<Order> _orders;

  @override
  AsyncValue<List<Order>> build() => AsyncData(_orders);
}

void main() {
  testWidgets(
      'empty trades screen shows the empty-state CTA and the persistent floating CTA',
      (tester) async {
    await tester.pumpWidget(
      const _OrdersScreenHarness(orders: []),
    );

    expect(find.text('No trades yet'), findsOneWidget);
    expect(find.text('New trade'), findsNWidgets(2));
  });

  testWidgets('populated trades screen keeps the floating new trade action',
      (tester) async {
    await tester.pumpWidget(
      const _OrdersScreenHarness(
        orders: [_activeOrder],
      ),
    );

    expect(find.text('No trades yet'), findsNothing);
    expect(find.text('New trade'), findsOneWidget);
  });

  testWidgets('history-only trader sees active-empty state with one CTA',
      (tester) async {
    await tester.pumpWidget(
      const _OrdersScreenHarness(
        orders: [_closedOrder],
      ),
    );

    expect(find.text('No active trades'), findsOneWidget);
    expect(find.text('No trades yet'), findsNothing);
    expect(find.text('New trade'), findsOneWidget);

    await tester.tap(find.text('History'));
    await tester.pumpAndSettle();

    expect(find.text('ETH/USDT'), findsOneWidget);
    expect(find.text('No trade history yet'), findsNothing);
    expect(find.text('New trade'), findsOneWidget);
  });

  testWidgets('active-only trader sees history-empty state after tab switch',
      (tester) async {
    await tester.pumpWidget(
      const _OrdersScreenHarness(
        orders: [_activeOrder],
      ),
    );

    expect(find.text('BTC/USDT'), findsOneWidget);
    expect(find.text('Open'), findsOneWidget);
    expect(find.text('No active trades'), findsNothing);
    expect(find.text('New trade'), findsOneWidget);

    await tester.tap(find.text('History'));
    await tester.pumpAndSettle();

    expect(find.text('No trade history yet'), findsOneWidget);
    expect(find.text('New trade'), findsOneWidget);
  });

  testWidgets('trade details loads insights only after insights tab opens',
      (tester) async {
    final api = _CountingOrdersApi();
    await tester.pumpWidget(
      _OrdersScreenHarness(
        orders: const [_activeOrder],
        ordersApi: api,
      ),
    );

    expect(api.insightsCalls, 0);

    await tester.tap(find.text('BTC/USDT'));
    await tester.pumpAndSettle();

    expect(find.text('Trade details'), findsOneWidget);
    expect(api.insightsCalls, 0);

    await tester.tap(find.text('Insights'));
    await tester.pumpAndSettle();

    expect(api.insightsCalls, 1);
    expect(find.text('Post-trade discipline summary'), findsOneWidget);

    await tester.tap(find.text('Trade Info'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Insights'));
    await tester.pumpAndSettle();

    expect(api.insightsCalls, 1);
  });

  testWidgets('accepted unfilled order can be cancelled from trade details',
      (tester) async {
    final api = _CountingOrdersApi();
    await tester.pumpWidget(
      _OrdersScreenHarness(
        orders: const [_cancellableOrder],
        ordersApi: api,
      ),
    );

    await tester.tap(find.text('SOL/USDT'));
    await tester.pumpAndSettle();

    expect(find.text('Cancel unfilled order'), findsOneWidget);

    await tester.ensureVisible(find.text('Cancel unfilled order'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cancel unfilled order'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Cancel order'));
    await tester.pumpAndSettle();

    expect(api.cancelCalls, 1);
    expect(api.cancelledIds, contains('order-3'));
    expect(find.text('CANCELLED'), findsOneWidget);
    expect(find.text('Cancel unfilled order'), findsNothing);

    await tester.pump(const Duration(seconds: 4));
    await tester.pumpAndSettle();
  });
}

const _activeOrder = Order(
  id: 'order-1',
  symbol: 'BTCUSDT',
  status: 'submitted',
  quantity: 1,
  remainingQuantity: 1,
);

const _closedOrder = Order(
  id: 'order-2',
  symbol: 'ETHUSDT',
  status: 'filled',
  quantity: 2,
  remainingQuantity: 0,
  realizedPnl: 42,
  createdAt: '2026-06-03T12:00:00Z',
);

const _cancellableOrder = Order(
  id: 'order-3',
  symbol: 'SOLUSDT',
  status: 'submitted',
  orderType: 'limit',
  quantity: 5,
  remainingQuantity: 5,
  price: 160,
  exchangeOrderId: 'exchange-order-3',
  autoCancelAfterMinutes: 120,
  expiresAt: '2026-06-03T14:00:00Z',
);

class _OrdersScreenHarness extends StatelessWidget {
  const _OrdersScreenHarness({
    required this.orders,
    this.ordersApi,
  });

  final List<Order> orders;
  final OrdersApi? ordersApi;

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      overrides: [
        ordersNotifierProvider.overrideWith(
          () => _FakeOrdersNotifier(orders),
        ),
        if (ordersApi != null) ordersApiProvider.overrideWithValue(ordersApi!),
      ],
      child: const MaterialApp(home: OrdersScreen()),
    );
  }
}

class _CountingOrdersApi extends OrdersApi {
  _CountingOrdersApi() : super(Dio());

  int insightsCalls = 0;
  int cancelCalls = 0;
  final cancelledIds = <String>[];

  @override
  Future<Result<OrderInsights, AppError>> getOrderInsights(String id) async {
    insightsCalls++;
    return Ok(
      OrderInsights(
        orderId: id,
        adherenceScore: 82,
        adherenceLabel: 'On plan',
        aiSummary: 'Post-trade discipline summary',
        metrics: const [
          OrderInsightMetric(
            label: 'Risk Discipline',
            score: 84,
            status: 'good',
          ),
        ],
        suggestions: const ['Keep journaling the setup after execution.'],
      ),
    );
  }

  @override
  Future<Result<void, AppError>> cancelOrder(String id) async {
    cancelCalls++;
    cancelledIds.add(id);
    return const Ok<void, AppError>(null);
  }
}
