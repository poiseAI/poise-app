import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:poise_ai/core/network/api_client.dart';
import 'package:poise_ai/core/router/routes.dart';
import 'package:poise_ai/core/theme/app_theme.dart';
import 'package:poise_ai/core/widgets/buttons/p_primary_button.dart';
import 'package:poise_ai/features/auth/providers/auth_provider.dart';
import 'package:poise_ai/features/auth/providers/auth_state.dart';
import 'package:poise_ai/features/billing/data/billing_api.dart';
import 'package:poise_ai/features/billing/providers/billing_provider.dart';
import 'package:poise_ai/features/billing/screens/billing_screen.dart';
import 'package:poise_ai/features/profile/screens/profile_screen.dart';

class _MockDio extends Mock implements Dio {}

void main() {
  testWidgets('profile shows subscription row and starts checkout',
      (tester) async {
    _setFigmaPhoneViewport(tester);
    const subscription = BillingSubscription.none;
    final dio = _profileDio(subscription: subscription);
    final launched = <String>[];

    await tester.pumpWidget(_profileHarness(
      dio: dio,
      launched: launched,
      subscription: subscription,
    ));
    await tester.pumpAndSettle();

    expect(find.text('Subscription'), findsOneWidget);
    expect(find.text('ACCOUNT'), findsOneWidget);
    expect(find.text('TRADING'), findsOneWidget);
    expect(find.text('PREFERENCES'), findsOneWidget);
    expect(find.text('Change password'), findsOneWidget);
    expect(find.text('Security'), findsNothing);
    expect(find.text(r'$79/month'), findsNothing);
    expect(find.text('Notification'), findsOneWidget);
    expect(find.text('Notifications'), findsNothing);
    expect(
      tester
          .getSize(
            find
                .ancestor(
                  of: find.text('Edit profile'),
                  matching: find.byType(InkWell),
                )
                .first,
          )
          .height,
      48,
    );
    expect(
      tester
          .getSize(
            find
                .ancestor(
                  of: find.text('Log out'),
                  matching: find.byType(InkWell),
                )
                .first,
          )
          .height,
      48,
    );

    await tester.tap(find.text('Subscription'));
    await tester.pumpAndSettle();

    expect(find.text('Upgrade to Poise Core'), findsOneWidget);
    expect(find.widgetWithText(PPrimaryButton, 'Start free trial'),
        findsOneWidget);

    await tester.tap(find.widgetWithText(PPrimaryButton, 'Start free trial'));
    await tester.pump(const Duration(milliseconds: 1200));

    expect(launched, ['https://checkout.stripe.test/session']);

    await tester.pumpAndSettle(const Duration(seconds: 5));
  });

  testWidgets('profile shows Core plan and uses switch confirmation flow',
      (tester) async {
    _setFigmaPhoneViewport(tester);
    final subscription = BillingSubscription(
      plan: BillingPlan.core,
      status: BillingStatus.trialing,
      entitled: true,
      cycle: BillingCycle.monthly,
      currentPeriodEnd: DateTime.utc(2026, 6, 7),
      tradesUsed: 4,
      tradesLimit: 10,
      trialDaysRemaining: 9,
      trialDaysTotal: 14,
    );
    final dio = _profileDio(subscription: subscription);
    final launched = <String>[];

    await tester.pumpWidget(_profileHarness(
      dio: dio,
      launched: launched,
      subscription: subscription,
    ));
    await tester.pumpAndSettle();

    expect(find.text('Subscription'), findsOneWidget);
    expect(find.text('Poise Core'), findsOneWidget);

    await tester.tap(find.text('Subscription'));
    await tester.pumpAndSettle();

    expect(find.text('Current plan'), findsNWidgets(2));
    expect(find.text('4/10'), findsOneWidget);
    expect(find.text('9 of 14'), findsOneWidget);
    expect(find.text('June 7, 2026'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('Switch'), 200);
    await tester.ensureVisible(find.text('Switch'));
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(TextButton, 'Switch'));
    await tester.pumpAndSettle();

    expect(launched, isEmpty);
    expect(find.text('Switch Plan'), findsWidgets);
    expect(
      find.text('Are you sure you want to switch this plan?'),
      findsOneWidget,
    );

    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    expect(launched, isEmpty);
    expect(find.text('Select billing cycle'), findsOneWidget);
    expect(
      find.text('Unlock all features and maximize your trading discipline'),
      findsOneWidget,
    );

    await tester.tap(find.text('Switch plans'));
    await tester.pump(const Duration(milliseconds: 1200));

    expect(launched, ['https://billing.stripe.test/session']);
  });

  testWidgets('profile change password matches Figma states', (tester) async {
    _setFigmaPhoneViewport(tester);
    const subscription = BillingSubscription.none;
    final dio = _profileDio(subscription: subscription);

    await tester.pumpWidget(_profileHarness(
      dio: dio,
      launched: <String>[],
      subscription: subscription,
    ));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Change password'));
    await tester.pumpAndSettle();

    expect(find.text('Enter a new secure password for your account'),
        findsOneWidget);
    expect(find.widgetWithText(PPrimaryButton, 'Save'), findsOneWidget);
    expect(find.widgetWithText(PPrimaryButton, 'Change password'), findsNothing);
    expect(find.text('Requires at least:'), findsOneWidget);
    expect(find.text('8 characters long'), findsOneWidget);
    expect(find.text('1 symbol'), findsOneWidget);

    final saveButton = tester.widget<PPrimaryButton>(
      find.widgetWithText(PPrimaryButton, 'Save'),
    );
    expect(saveButton.onPressed, isNull);

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Enter password').at(0),
      'old-password',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Enter password').at(1),
      'Newpass1!',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Repeat password'),
      'Newpass1!',
    );
    await tester.pump();

    final enabledSaveButton = tester.widget<PPrimaryButton>(
      find.widgetWithText(PPrimaryButton, 'Save'),
    );
    expect(enabledSaveButton.onPressed, isNotNull);
  });
}

void _setFigmaPhoneViewport(WidgetTester tester) {
  tester.view.physicalSize = const Size(390, 843);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
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
      GoRoute(
        path: Routes.billing,
        builder: (_, __) => const BillingScreen(),
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

_MockDio _profileDio({required BillingSubscription subscription}) {
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
  when(() => dio.get<Map<String, dynamic>>('/billing/subscription')).thenAnswer(
    (_) async => Response<Map<String, dynamic>>(
      requestOptions: RequestOptions(path: '/billing/subscription'),
      data: {'subscription': subscription.toJson()},
    ),
  );
  when(
    () => dio.put<void>(
      '/password',
      data: any(named: 'data'),
    ),
  ).thenAnswer(
    (_) async => Response<void>(
      requestOptions: RequestOptions(path: '/password'),
      statusCode: 200,
    ),
  );
  when(
    () => dio.post<Map<String, dynamic>>(
      '/billing/checkout',
      data: any(named: 'data'),
    ),
  ).thenAnswer(
    (_) async => Response<Map<String, dynamic>>(
      requestOptions: RequestOptions(path: '/billing/checkout'),
      data: {
        'checkout_url': 'https://checkout.stripe.test/session',
        'session_id': 'cs_test',
      },
    ),
  );
  when(
    () => dio.post<Map<String, dynamic>>(
      '/billing/portal',
      data: any(named: 'data'),
    ),
  ).thenAnswer(
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
