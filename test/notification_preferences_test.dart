import 'package:flutter_test/flutter_test.dart';
import 'package:poise_ai/features/profile/providers/notification_preferences_provider.dart';

void main() {
  test('notification preferences parse backend defaults and serialize updates',
      () {
    final prefs = NotificationPreferences.fromJson(const {
      'trade_updates': false,
      'guardrails': true,
      'external_trades': false,
      'email_notifications': true,
      'loss_limits': false,
      'weekly_insights': true,
      'ai_feedback': false,
    });

    expect(prefs.tradeUpdates, isFalse);
    expect(prefs.guardrails, isTrue);
    expect(prefs.externalTrades, isFalse);
    expect(prefs.emailNotifications, isTrue);
    expect(prefs.lossLimits, isFalse);
    expect(prefs.weeklyInsights, isTrue);
    expect(prefs.aiFeedback, isFalse);

    expect(prefs.copyWith(tradeUpdates: true).toJson(),
        containsPair('trade_updates', true));
  });
}
