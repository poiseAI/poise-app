import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:poise_ai/core/network/api_client.dart';
import 'package:poise_ai/core/router/routes.dart';
import 'package:poise_ai/core/theme/app_theme.dart';
import 'package:poise_ai/features/auth/providers/auth_provider.dart';
import 'package:poise_ai/features/auth/providers/auth_state.dart';
import 'package:poise_ai/features/profile/screens/profile_screen.dart';

class _MockDio extends Mock implements Dio {}

class _TestAuth extends Auth {
  @override
  Future<AuthState> build() async => const AuthState.authenticated(
        userId: 'user-1',
        email: 'trader@example.com',
        token: 'token',
        fullName: 'Test Trader',
        emailVerified: true,
        hasActiveStrategy: true,
      );

  @override
  void markHasExchangeConnection() {
    final current = state.valueOrNull;
    if (current is AuthAuthenticated) {
      state = AsyncData(current.copyWith(hasExchangeConnection: true));
    }
  }

  @override
  Future<void> refreshSession() async {}
}

void main() {
  setUpAll(() {
    registerFallbackValue(RequestOptions(path: '/'));
  });

  testWidgets('onboarding exchange screen shows chooser and Bybit form',
      (tester) async {
    final dio = _mockProfileDio();

    await tester.pumpWidget(_exchangeHarness(dio, fromOnboarding: true));
    await tester.pumpAndSettle();

    expect(find.text('Exchange Connections'), findsNothing);
    expect(find.text('Connect your exchange'), findsOneWidget);
    expect(
      find.text(
        'Poise reads your futures balance and checks every trade before it reaches your exchange',
      ),
      findsOneWidget,
    );
    expect(
      find.text(
        'Your keys are encrypted at rest. Poise uses read & trade access only, it can never withdraw your funds.',
      ),
      findsOneWidget,
    );
    expect(find.text('Bybit'), findsOneWidget);
    expect(find.text('Binance'), findsOneWidget);
    expect(
        find.text('Connect at least one exchange to continue'), findsOneWidget);
    expect(find.text('Continue'), findsOneWidget);
    expect(find.text("I'll do this later"), findsOneWidget);

    await tester.tap(find.text('Bybit'));
    await tester.pumpAndSettle();

    expect(find.text('Connect Bybit'), findsOneWidget);
    expect(find.text('How do I get my API keys?'), findsOneWidget);
    expect(find.text('A quick, safe walkthrough'), findsOneWidget);
    expect(find.text('API key'), findsOneWidget);
    expect(find.text('Secret key'), findsOneWidget);
    expect(
      find.text(
        "Enable Contract, Trade (Orders & Positions). Never enable Withdrawals, Poise doesn't need it.",
      ),
      findsOneWidget,
    );
    expect(find.text('Connect exchange'), findsOneWidget);
  });

  testWidgets('API help sheet shows safe key creation warnings',
      (tester) async {
    final dio = _mockProfileDio();

    await tester.pumpWidget(_exchangeHarness(dio, fromOnboarding: true));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Bybit'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('How do I get my API keys?'));
    await tester.pumpAndSettle();

    expect(find.text('Create your Bybit key'), findsOneWidget);
    expect(find.byIcon(Icons.close_rounded), findsOneWidget);
    expect(
      find.text(
        'Leave Withdraw and Account Transfer unchecked. Poise never moves your funds.',
      ),
      findsOneWidget,
    );
    expect(
      find.text(
        'New Bybit accounts must wait 48 hours before creating a key. The Secret is shown only once.',
      ),
      findsOneWidget,
    );
    expect(find.text('Got it'), findsOneWidget);
  });

  testWidgets('skip and connected continue move onboarding to baseline',
      (tester) async {
    final skipDio = _mockProfileDio();

    await tester.pumpWidget(_exchangeHarness(skipDio, fromOnboarding: true));
    await tester.pumpAndSettle();
    await tester.tap(find.text("I'll do this later"));
    await tester.pumpAndSettle();

    expect(find.text('Baseline route'), findsOneWidget);

    final connectedDio = _mockProfileDio(connections: [
      {'id': 'bybit-1', 'exchange': 'bybit', 'is_active': true},
    ]);

    await tester.pumpWidget(
      _exchangeHarness(connectedDio, fromOnboarding: true),
    );
    await tester.pumpAndSettle();

    expect(find.text('Connected'), findsOneWidget);

    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    expect(find.text('Baseline route'), findsOneWidget);
  });

  testWidgets('successful onboarding connect moves to baseline',
      (tester) async {
    final dio = _mockProfileDio(connectSucceeds: true);

    await tester.pumpWidget(_exchangeHarness(dio, fromOnboarding: true));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Binance'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField).at(0), 'key');
    await tester.enterText(
      find.byType(TextFormField).at(1),
      'secret',
    );
    await tester.pump();
    await tester.tap(find.text('Connect exchange'));
    await tester.pumpAndSettle();

    expect(find.text('Baseline route'), findsOneWidget);
  });

  testWidgets('profile exchange mode keeps settings shell', (tester) async {
    final dio = _mockProfileDio();

    await tester.pumpWidget(_exchangeHarness(dio));
    await tester.pumpAndSettle();

    expect(find.text('Exchange Connections'), findsOneWidget);
    expect(find.text('Connect your exchange'), findsNothing);

    await tester.drag(find.byType(ListView).first, const Offset(0, -450));
    await tester.pumpAndSettle();

    expect(find.text('Done'), findsOneWidget);
  });
}

_MockDio _mockProfileDio({
  List<Map<String, dynamic>> connections = const [],
  bool connectSucceeds = false,
}) {
  final dio = _MockDio();
  when(() => dio.get<dynamic>('/exchange-connections')).thenAnswer(
    (_) async => Response<dynamic>(
      requestOptions: RequestOptions(path: '/exchange-connections'),
      data: {'connections': connections},
      statusCode: 200,
    ),
  );
  when(
    () => dio.post<Map<String, dynamic>>(
      '/exchange-connections',
      data: any<dynamic>(named: 'data'),
    ),
  ).thenAnswer(
    (_) async => Response<Map<String, dynamic>>(
      requestOptions: RequestOptions(path: '/exchange-connections'),
      data: connectSucceeds ? {'id': 'connection-1'} : <String, dynamic>{},
      statusCode: 200,
    ),
  );
  return dio;
}

Widget _exchangeHarness(
  Dio dio, {
  bool fromOnboarding = false,
}) {
  final router = GoRouter(
    initialLocation: fromOnboarding
        ? '${Routes.exchangeConnections}?from=onboarding'
        : Routes.exchangeConnections,
    routes: [
      GoRoute(
        path: Routes.exchangeConnections,
        builder: (context, state) => const ExchangeConnectionsScreen(),
      ),
      GoRoute(
        path: '/onboarding/baseline-sync',
        builder: (context, state) => const _RouteProbe('Baseline route'),
      ),
      GoRoute(
        path: Routes.home,
        builder: (context, state) => const _RouteProbe('Home route'),
      ),
      GoRoute(
        path: Routes.profile,
        builder: (context, state) => const _RouteProbe('Profile route'),
      ),
    ],
  );

  return ProviderScope(
    overrides: [
      dioProvider.overrideWithValue(dio),
      authProvider.overrideWith(_TestAuth.new),
    ],
    child: MaterialApp.router(
      theme: AppTheme.light,
      routerConfig: router,
    ),
  );
}

class _RouteProbe extends StatelessWidget {
  const _RouteProbe(this.label);

  final String label;

  @override
  Widget build(BuildContext context) =>
      Scaffold(body: Center(child: Text(label)));
}
