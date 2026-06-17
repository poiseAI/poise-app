import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:poise_ai/core/network/api_client.dart';
import 'package:poise_ai/core/theme/app_theme.dart';
import 'package:poise_ai/features/auth/providers/auth_provider.dart';
import 'package:poise_ai/features/auth/providers/auth_state.dart';
import 'package:poise_ai/features/billing/data/billing_api.dart';
import 'package:poise_ai/features/billing/providers/billing_provider.dart';
import 'package:poise_ai/features/profile/screens/profile_screen.dart';

class _MockDio extends Mock implements Dio {}

void main() {
  testWidgets('profile shows free Core plan and starts checkout',
      (tester) async {
    final dio = _profileDio();
    final launched = <String>[];

    await tester.pumpWidget(_profileHarness(
      dio: dio,
      launched: launched,
      subscription: BillingSubscription.none,
    ));
    await tester.pumpAndSettle();

    expect(find.text('Poise Core'), findsOneWidget);
    expect(find.text(r'$79/month'), findsOneWidget);
    expect(find.text('14-day trial'), findsOneWidget);

    await tester.tap(find.text('Start trial'));
    await tester.pumpAndSettle();

    expect(launched, ['https://checkout.stripe.test/session']);
  });

  testWidgets('profile shows active Core plan with manage billing',
      (tester) async {
    final dio = _profileDio();
    final launched = <String>[];

    await tester.pumpWidget(_profileHarness(
      dio: dio,
      launched: launched,
      subscription: const BillingSubscription(
        plan: BillingPlan.core,
        status: BillingStatus.active,
        entitled: true,
      ),
    ));
    await tester.pumpAndSettle();

    expect(find.text('Poise Core'), findsOneWidget);
    expect(find.text('Active'), findsWidgets);

    await tester.tap(find.text('Manage billing'));
    await tester.pumpAndSettle();

    expect(launched, ['https://billing.stripe.test/session']);
  });
}

Widget _profileHarness({
  required Dio dio,
  required List<String> launched,
  required BillingSubscription subscription,
}) {
  final router = GoRouter(
    initialLocation: '/profile',
    routes: [
      GoRoute(
        path: '/profile',
        builder: (_, __) => const ProfileScreen(),
      ),
    ],
  );

  return ProviderScope(
    overrides: [
      dioProvider.overrideWithValue(dio),
      billingUrlLauncherProvider.overrideWithValue((url) async {
        launched.add(url);
        return true;
      }),
      authProvider.overrideWith(() => _TestAuth(subscription)),
    ],
    child: MaterialApp.router(
      theme: AppTheme.light,
      routerConfig: router,
    ),
  );
}

_MockDio _profileDio() {
  final dio = _MockDio();
  when(() => dio.get<Map<String, dynamic>>('/profile')).thenAnswer(
    (_) async => Response<Map<String, dynamic>>(
      requestOptions: RequestOptions(path: '/profile'),
      data: {'full_name': 'Test Trader'},
    ),
  );
  when(() => dio.get<Map<String, dynamic>>('/strategies')).thenAnswer(
    (_) async => Response<Map<String, dynamic>>(
      requestOptions: RequestOptions(path: '/strategies'),
      data: {'strategies': <Map<String, dynamic>>[]},
    ),
  );
  when(() => dio.post<Map<String, dynamic>>('/billing/checkout')).thenAnswer(
    (_) async => Response<Map<String, dynamic>>(
      requestOptions: RequestOptions(path: '/billing/checkout'),
      data: {
        'checkout_url': 'https://checkout.stripe.test/session',
        'session_id': 'cs_test',
      },
    ),
  );
  when(() => dio.post<Map<String, dynamic>>('/billing/portal')).thenAnswer(
    (_) async => Response<Map<String, dynamic>>(
      requestOptions: RequestOptions(path: '/billing/portal'),
      data: {'portal_url': 'https://billing.stripe.test/session'},
    ),
  );
  return dio;
}

class _TestAuth extends Auth {
  _TestAuth(this.subscription);
  final BillingSubscription subscription;

  @override
  Future<AuthState> build() async => AuthState.authenticated(
        userId: 'user-1',
        email: 'trader@example.com',
        token: 'token',
        fullName: 'Test Trader',
        emailVerified: true,
        hasActiveStrategy: true,
        subscription: subscription,
      );
}
