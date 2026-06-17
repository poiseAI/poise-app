import 'package:flutter_test/flutter_test.dart';
import 'package:poise_ai/features/auth/data/models/auth_response.dart';
import 'package:poise_ai/features/auth/providers/auth_state.dart';
import 'package:poise_ai/features/billing/data/billing_api.dart';

void main() {
  test('AuthResponse parses user subscription object', () {
    final resp = AuthResponse.fromJson(const {
      'token': 'jwt',
      'user': {
        'id': 'user-1',
        'email': 'user@example.com',
        'subscription': {
          'plan': 'core',
          'status': 'trialing',
          'entitled': true,
          'trial_end': '2026-07-01T12:00:00Z',
        },
      },
    });

    expect(resp.user.subscription.plan, BillingPlan.core);
    expect(resp.user.subscription.status, BillingStatus.trialing);
    expect(resp.user.subscription.entitled, isTrue);
  });

  test('AuthAuthenticated carries subscription state', () {
    const state = AuthState.authenticated(
      userId: 'user-1',
      email: 'user@example.com',
      token: 'jwt',
      subscription: BillingSubscription(
        plan: BillingPlan.core,
        status: BillingStatus.active,
        entitled: true,
      ),
    );

    expect(state.subscription.entitled, isTrue);
    expect(state.subscription.plan, BillingPlan.core);
  });
}
