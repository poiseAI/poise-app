import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/profile_api.dart';

part 'notification_preferences_provider.g.dart';

class NotificationPreferences {
  const NotificationPreferences({
    required this.tradeUpdates,
    required this.guardrails,
    required this.externalTrades,
    required this.emailNotifications,
    required this.lossLimits,
    required this.weeklyInsights,
    required this.aiFeedback,
  });

  factory NotificationPreferences.fromJson(Map<String, dynamic> json) {
    return NotificationPreferences(
      tradeUpdates: json['trade_updates'] as bool? ?? true,
      guardrails: json['guardrails'] as bool? ?? true,
      externalTrades: json['external_trades'] as bool? ?? true,
      emailNotifications: json['email_notifications'] as bool? ?? false,
      lossLimits: json['loss_limits'] as bool? ?? true,
      weeklyInsights: json['weekly_insights'] as bool? ?? true,
      aiFeedback: json['ai_feedback'] as bool? ?? true,
    );
  }

  final bool tradeUpdates;
  final bool guardrails;
  final bool externalTrades;
  final bool emailNotifications;
  final bool lossLimits;
  final bool weeklyInsights;
  final bool aiFeedback;

  Map<String, dynamic> toJson() => {
        'trade_updates': tradeUpdates,
        'guardrails': guardrails,
        'external_trades': externalTrades,
        'email_notifications': emailNotifications,
        'loss_limits': lossLimits,
        'weekly_insights': weeklyInsights,
        'ai_feedback': aiFeedback,
      };

  NotificationPreferences copyWith({
    bool? tradeUpdates,
    bool? guardrails,
    bool? externalTrades,
    bool? emailNotifications,
    bool? lossLimits,
    bool? weeklyInsights,
    bool? aiFeedback,
  }) {
    return NotificationPreferences(
      tradeUpdates: tradeUpdates ?? this.tradeUpdates,
      guardrails: guardrails ?? this.guardrails,
      externalTrades: externalTrades ?? this.externalTrades,
      emailNotifications: emailNotifications ?? this.emailNotifications,
      lossLimits: lossLimits ?? this.lossLimits,
      weeklyInsights: weeklyInsights ?? this.weeklyInsights,
      aiFeedback: aiFeedback ?? this.aiFeedback,
    );
  }
}

@riverpod
class NotificationPreferencesController
    extends _$NotificationPreferencesController {
  @override
  Future<NotificationPreferences> build() async {
    final result =
        await ref.read(profileApiProvider).getNotificationPreferences();
    if (result.isErr) throw result.error;
    return NotificationPreferences.fromJson(result.value);
  }

  Future<void> save(NotificationPreferences prefs) async {
    final previous = state.valueOrNull;
    state = AsyncData(prefs);
    final result = await ref
        .read(profileApiProvider)
        .updateNotificationPreferences(prefs.toJson());
    if (result.isErr) {
      if (previous != null) state = AsyncData(previous);
      throw result.error;
    }
    state = AsyncData(NotificationPreferences.fromJson(result.value));
  }
}
