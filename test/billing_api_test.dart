import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:poise_ai/features/billing/data/billing_api.dart';

class _MockDio extends Mock implements Dio {}

void main() {
  test('BillingSubscription parses empty and trialing states', () {
    final empty = BillingSubscription.fromJson(const {
      'plan': 'none',
      'status': 'none',
      'entitled': false,
    });

    expect(empty.plan, BillingPlan.none);
    expect(empty.status, BillingStatus.none);
    expect(empty.entitled, isFalse);

    final trialing = BillingSubscription.fromJson(const {
      'plan': 'core',
      'status': 'trialing',
      'entitled': true,
      'trial_end': '2026-07-01T12:00:00Z',
      'current_period_end': '2026-07-01T12:00:00Z',
      'cancel_at_period_end': false,
    });

    expect(trialing.plan, BillingPlan.core);
    expect(trialing.status, BillingStatus.trialing);
    expect(trialing.entitled, isTrue);
    expect(trialing.trialEnd?.toUtc().year, 2026);
  });

  test('getSubscription reads nested subscription response', () async {
    final dio = _MockDio();
    when(() => dio.get<Map<String, dynamic>>('/billing/subscription'))
        .thenAnswer((_) async => Response<Map<String, dynamic>>(
              requestOptions: RequestOptions(path: '/billing/subscription'),
              data: {
                'subscription': {
                  'plan': 'core',
                  'status': 'active',
                  'entitled': true,
                },
              },
            ));

    final result = await BillingApi(dio).getSubscription();

    expect(result.isOk, isTrue);
    expect(result.value.plan, BillingPlan.core);
    expect(result.value.status, BillingStatus.active);
    expect(result.value.entitled, isTrue);
  });

  test('startCheckout and createPortal parse hosted urls', () async {
    final dio = _MockDio();
    when(
      () => dio.post<Map<String, dynamic>>(
        '/billing/checkout',
        data: any(named: 'data'),
      ),
    ).thenAnswer((_) async => Response<Map<String, dynamic>>(
          requestOptions: RequestOptions(path: '/billing/checkout'),
          data: {
            'checkout_url': 'https://checkout.stripe.test/session',
            'session_id': 'cs_test',
          },
        ));
    when(() => dio.post<Map<String, dynamic>>('/billing/portal'))
        .thenAnswer((_) async => Response<Map<String, dynamic>>(
              requestOptions: RequestOptions(path: '/billing/portal'),
              data: {
                'portal_url': 'https://billing.stripe.test/session',
              },
            ));

    final checkout = await BillingApi(dio).startCheckout(BillingCycle.monthly);
    final portal = await BillingApi(dio).createPortal();

    expect(checkout.isOk, isTrue);
    expect(checkout.value.url, 'https://checkout.stripe.test/session');
    expect(checkout.value.sessionId, 'cs_test');
    expect(portal.isOk, isTrue);
    expect(portal.value.url, 'https://billing.stripe.test/session');
  });
}
