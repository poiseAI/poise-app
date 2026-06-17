import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/errors/app_error.dart';
import '../../../core/network/api_client.dart';
import '../../../core/utils/result.dart';

final billingApiProvider = Provider.autoDispose<BillingApi>(
  (ref) => BillingApi(ref.watch(dioProvider)),
);

enum BillingPlan { none, core }

enum BillingStatus {
  none,
  incomplete,
  trialing,
  active,
  pastDue,
  canceled,
  unpaid
}

class BillingSubscription {
  const BillingSubscription({
    required this.plan,
    required this.status,
    required this.entitled,
    this.trialEnd,
    this.currentPeriodEnd,
    this.cancelAtPeriodEnd = false,
  });

  static const none = BillingSubscription(
    plan: BillingPlan.none,
    status: BillingStatus.none,
    entitled: false,
  );

  factory BillingSubscription.fromJson(Map<String, dynamic>? json) {
    final data = json ?? const {};
    return BillingSubscription(
      plan: _planFromString(data['plan'] as String?),
      status: _statusFromString(data['status'] as String?),
      entitled: data['entitled'] as bool? ?? false,
      trialEnd: _dateFromJson(data['trial_end']),
      currentPeriodEnd: _dateFromJson(data['current_period_end']),
      cancelAtPeriodEnd: data['cancel_at_period_end'] as bool? ?? false,
    );
  }

  final BillingPlan plan;
  final BillingStatus status;
  final bool entitled;
  final DateTime? trialEnd;
  final DateTime? currentPeriodEnd;
  final bool cancelAtPeriodEnd;

  Map<String, dynamic> toJson() => {
        'plan': _planToString(plan),
        'status': _statusToString(status),
        'entitled': entitled,
        'trial_end': trialEnd?.toUtc().toIso8601String(),
        'current_period_end': currentPeriodEnd?.toUtc().toIso8601String(),
        'cancel_at_period_end': cancelAtPeriodEnd,
      };
}

class BillingCheckoutSession {
  const BillingCheckoutSession({required this.url, this.sessionId});

  factory BillingCheckoutSession.fromJson(Map<String, dynamic> json) {
    return BillingCheckoutSession(
      url: json['checkout_url'] as String? ?? '',
      sessionId: json['session_id'] as String?,
    );
  }

  final String url;
  final String? sessionId;
}

class BillingPortalSession {
  const BillingPortalSession({required this.url});

  factory BillingPortalSession.fromJson(Map<String, dynamic> json) {
    return BillingPortalSession(url: json['portal_url'] as String? ?? '');
  }

  final String url;
}

class BillingApi {
  BillingApi(this._dio);
  final Dio _dio;

  Future<Result<BillingSubscription, AppError>> getSubscription() async {
    try {
      final resp =
          await _dio.get<Map<String, dynamic>>('/billing/subscription');
      final raw = resp.data?['subscription'] as Map<String, dynamic>?;
      return Ok(BillingSubscription.fromJson(raw));
    } on DioException catch (e) {
      return Err(e.error is AppError
          ? e.error as AppError
          : UnknownError(e.message ?? ''));
    }
  }

  Future<Result<BillingCheckoutSession, AppError>> startCheckout() async {
    try {
      final resp = await _dio.post<Map<String, dynamic>>('/billing/checkout');
      return Ok(BillingCheckoutSession.fromJson(resp.data ?? const {}));
    } on DioException catch (e) {
      return Err(e.error is AppError
          ? e.error as AppError
          : UnknownError(e.message ?? ''));
    }
  }

  Future<Result<BillingPortalSession, AppError>> createPortal() async {
    try {
      final resp = await _dio.post<Map<String, dynamic>>('/billing/portal');
      return Ok(BillingPortalSession.fromJson(resp.data ?? const {}));
    } on DioException catch (e) {
      return Err(e.error is AppError
          ? e.error as AppError
          : UnknownError(e.message ?? ''));
    }
  }
}

BillingPlan _planFromString(String? value) {
  return switch (value) {
    'core' => BillingPlan.core,
    _ => BillingPlan.none,
  };
}

String _planToString(BillingPlan value) {
  return switch (value) {
    BillingPlan.core => 'core',
    BillingPlan.none => 'none',
  };
}

BillingStatus _statusFromString(String? value) {
  return switch (value) {
    'incomplete' => BillingStatus.incomplete,
    'trialing' => BillingStatus.trialing,
    'active' => BillingStatus.active,
    'past_due' => BillingStatus.pastDue,
    'canceled' => BillingStatus.canceled,
    'unpaid' => BillingStatus.unpaid,
    _ => BillingStatus.none,
  };
}

String _statusToString(BillingStatus value) {
  return switch (value) {
    BillingStatus.incomplete => 'incomplete',
    BillingStatus.trialing => 'trialing',
    BillingStatus.active => 'active',
    BillingStatus.pastDue => 'past_due',
    BillingStatus.canceled => 'canceled',
    BillingStatus.unpaid => 'unpaid',
    BillingStatus.none => 'none',
  };
}

DateTime? _dateFromJson(Object? value) {
  if (value is! String || value.isEmpty) return null;
  return DateTime.tryParse(value);
}
