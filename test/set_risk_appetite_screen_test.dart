import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:poise_ai/core/errors/app_error.dart';
import 'package:poise_ai/core/router/routes.dart';
import 'package:poise_ai/core/theme/app_theme.dart';
import 'package:poise_ai/core/utils/result.dart';
import 'package:poise_ai/core/widgets/buttons/p_primary_button.dart';
import 'package:poise_ai/features/auth/providers/auth_provider.dart';
import 'package:poise_ai/features/auth/providers/auth_state.dart';
import 'package:poise_ai/features/onboarding/screens/set_risk_appetite_screen.dart';
import 'package:poise_ai/features/strategies/data/models/strategy.dart';
import 'package:poise_ai/features/strategies/data/strategies_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets(
      'risk appetite starts with authoritative cards and disabled continue',
      (tester) async {
    await _pumpRiskHarness(tester);

    expect(find.text('Set your risk appetite'), findsOneWidget);
    expect(
      find.text(
        'Poise enforces a rule set matched to how you trade. Every trade is checked against these limits before it reaches the exchange.',
      ),
      findsOneWidget,
    );
    expect(find.text('Conservative'), findsOneWidget);
    expect(find.text('Balanced'), findsOneWidget);
    expect(find.text('Aggressive'), findsOneWidget);
    expect(find.text('Customizable'), findsOneWidget);
    expect(find.text('Core'), findsOneWidget);
    expect(
      tester.widget<PPrimaryButton>(find.byType(PPrimaryButton)).onPressed,
      isNull,
    );
  });

  testWidgets('selecting balanced expands guardrail values', (tester) async {
    await _pumpRiskHarness(tester);

    await tester.tap(find.text('Balanced'));
    await tester.pumpAndSettle();

    expect(find.text('Guardrail values'), findsOneWidget);
    expect(find.text('Percentage risk per trade'), findsOneWidget);
    expect(find.text('Max leverage per asset'), findsOneWidget);
    expect(find.text('Max trades per day'), findsOneWidget);
    expect(find.text('Daily maximum loss'), findsOneWidget);
    expect(find.text('Max concurrent open positions'), findsOneWidget);
    expect(find.text('Max consecutive losses in a day'), findsOneWidget);
    expect(
      tester.widget<PPrimaryButton>(find.byType(PPrimaryButton)).onPressed,
      isNotNull,
    );
  });

  testWidgets('customizable opens Poise Core sheet', (tester) async {
    await _pumpRiskHarness(tester);

    await tester.ensureVisible(find.text('Customizable'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Customizable'));
    await tester.pumpAndSettle();

    expect(find.text('Custom guardrails need Poise Core'), findsOneWidget);
    expect(
      find.textContaining('Set every guardrail by hand'),
      findsOneWidget,
    );
    expect(find.text('Upgrade to Poise Core'), findsOneWidget);
    expect(find.text('Maybe later'), findsOneWidget);
  });

  testWidgets('continue applies selected preset and opens exchange CTA',
      (tester) async {
    final strategiesApi = _RecordingStrategiesApi();
    await _pumpRiskHarness(tester, strategiesApi: strategiesApi);

    await tester.tap(find.text('Balanced'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Continue'));
    await tester.pump();

    expect(strategiesApi.replaceCalls, 1);
    expect(strategiesApi.lastRequest?.name, 'Balanced');

    await tester.pump(const Duration(milliseconds: 400));
    await tester.pumpAndSettle();

    expect(find.text('Balanced rules applied'), findsOneWidget);
    expect(
      find.text(
        'Poise will now guard every trade against these limits. You can fine-tune them anytime in Settings.',
      ),
      findsOneWidget,
    );
    expect(find.textContaining('daily loss cap'), findsOneWidget);
    expect(find.textContaining('max leverage'), findsOneWidget);
    expect(find.textContaining('trades / day'), findsOneWidget);

    await tester.tap(find.text('Connect your exchange'));
    await tester.pumpAndSettle();

    expect(find.text('exchange target from=onboarding'), findsOneWidget);
  });
}

Future<void> _pumpRiskHarness(
  WidgetTester tester, {
  _RecordingStrategiesApi? strategiesApi,
}) async {
  SharedPreferences.setMockInitialValues({});
  tester.view.physicalSize = const Size(1179, 2556);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  final api = strategiesApi ?? _RecordingStrategiesApi();
  final router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SetRiskAppetiteScreen(),
      ),
      GoRoute(
        path: Routes.exchangeConnections,
        builder: (context, state) => Text(
          'exchange target from=${state.uri.queryParameters['from']}',
        ),
      ),
    ],
  );

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        strategiesApiProvider.overrideWithValue(api),
        authProvider.overrideWith(_TestAuth.new),
      ],
      child: MaterialApp.router(
        theme: AppTheme.light,
        routerConfig: router,
      ),
    ),
  );
  await tester.pumpAndSettle();
}

class _TestAuth extends Auth {
  @override
  Future<AuthState> build() async => const AuthState.authenticated(
        userId: 'user-1',
        email: 'user@example.com',
        token: 'token',
      );
}

class _RecordingStrategiesApi extends StrategiesApi {
  _RecordingStrategiesApi() : super(Dio());

  int replaceCalls = 0;
  CreateStrategyRequest? lastRequest;
  List<Strategy> strategies = const [];

  @override
  Future<Result<List<Strategy>, AppError>> getStrategies() async {
    return Ok(strategies);
  }

  @override
  Future<Result<List<Strategy>, AppError>> getActiveStrategies() async {
    return Ok(strategies.where((strategy) => strategy.isActive).toList());
  }

  @override
  Future<Result<Strategy, AppError>> replaceActiveStrategy(
    CreateStrategyRequest req,
  ) async {
    replaceCalls++;
    lastRequest = req;
    final strategy = _strategyFromRequest(req);
    strategies = [strategy];
    return Ok(strategy);
  }
}

Strategy _strategyFromRequest(CreateStrategyRequest request) {
  return Strategy(
    id: 'strategy-${request.name.toLowerCase()}',
    userId: 'user-1',
    name: request.name,
    isActive: true,
    maxPositionSize: request.maxPositionSize,
    maxPositionValueUsd: request.maxPositionValueUsd,
    positionSizeType: request.positionSizeType,
    dailyLossLimitType: request.dailyLossLimitType,
    maxDailyLossUsd: request.maxDailyLossUsd,
    maxDailyLossPercent: request.maxDailyLossPercent,
    maxWeeklyLossUsd: request.maxWeeklyLossUsd,
    maxOpenPositions: request.maxOpenPositions,
    maxTradesPerDay: request.maxTradesPerDay,
    maxConsecutiveLosses: request.maxConsecutiveLosses,
    sessionStartHour: request.sessionStartHour,
    sessionEndHour: request.sessionEndHour,
    minRiskRewardRatio: request.minRiskRewardRatio,
    unfilledOrderCancelAfterMinutes: request.unfilledOrderCancelAfterMinutes,
    maxLeverage: request.maxLeverage,
    requireExitReason: request.requireExitReason,
    requireOtpForExit: request.requireOtpForExit,
    createdAt: '2026-06-16T00:00:00Z',
  );
}
