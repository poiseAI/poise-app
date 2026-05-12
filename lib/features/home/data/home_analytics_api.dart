import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/errors/app_error.dart';
import '../../../core/network/api_client.dart';
import '../../../core/utils/result.dart';

part 'home_analytics_api.g.dart';

@riverpod
HomeAnalyticsApi homeAnalyticsApi(Ref ref) =>
    HomeAnalyticsApi(ref.watch(dioProvider));

@riverpod
Future<HomeAnalytics> homeAnalytics(Ref ref, String period) async {
  final result = await ref.read(homeAnalyticsApiProvider).getHome(period);
  return result.fold(
    onOk: (analytics) => analytics,
    onErr: (error) => throw error,
  );
}

class HomeAnalyticsApi {
  HomeAnalyticsApi(this._dio);
  final Dio _dio;

  Future<Result<HomeAnalytics, AppError>> getHome(String period) async {
    try {
      final resp = await _dio.get<Map<String, dynamic>>(
        '/analytics/home',
        queryParameters: {'period': period},
      );
      return Ok(HomeAnalytics.fromJson(resp.data ?? const {}));
    } on DioException catch (e) {
      return Err(e.error is AppError
          ? e.error as AppError
          : UnknownError(e.message ?? ''));
    }
  }
}

class HomeAnalytics {
  const HomeAnalytics({
    required this.adherenceScore,
    required this.adherenceChangePct,
    required this.todayPnl,
    required this.tradesClosedToday,
    required this.compliantTradeStreak,
    required this.opportunityCostTotal,
    required this.opportunityItems,
    required this.guardrails,
    required this.disciplineFlags,
    required this.sourceBreakdown,
    required this.totalBalance,
    required this.balanceTentative,
    required this.connectedExchangeCount,
    this.mostCostlyMistake,
  });

  factory HomeAnalytics.fromJson(Map<String, dynamic> json) {
    return HomeAnalytics(
      adherenceScore: (json['adherence_score'] as num?)?.toInt() ?? 0,
      adherenceChangePct:
          (json['adherence_change_pct'] as num?)?.toDouble() ?? 0,
      todayPnl: (json['today_pnl'] as num?)?.toDouble() ?? 0,
      tradesClosedToday: (json['trades_closed_today'] as num?)?.toInt() ?? 0,
      compliantTradeStreak:
          (json['compliant_trade_streak'] as num?)?.toInt() ?? 0,
      mostCostlyMistake: json['most_costly_mistake'] is Map<String, dynamic>
          ? CostlyMistake.fromJson(
              json['most_costly_mistake'] as Map<String, dynamic>,
            )
          : null,
      opportunityCostTotal: ((json['opportunity_cost']
                  as Map<String, dynamic>?)?['total'] as num?)
              ?.toDouble() ??
          0,
      opportunityItems: (((json['opportunity_cost']
                  as Map<String, dynamic>?)?['items'] as List<dynamic>?) ??
              const [])
          .whereType<Map<String, dynamic>>()
          .map(OpportunityItem.fromJson)
          .toList(),
      guardrails: ((json['guardrails'] as List<dynamic>?) ?? const [])
          .whereType<Map<String, dynamic>>()
          .map(GuardrailMetric.fromJson)
          .toList(),
      disciplineFlags:
          ((json['discipline_flags'] as List<dynamic>?) ?? const [])
              .whereType<Map<String, dynamic>>()
              .map(DisciplineFlag.fromJson)
              .toList(),
      sourceBreakdown: SourceBreakdown.fromJson(
        (json['source_breakdown'] as Map<String, dynamic>?) ?? const {},
      ),
      totalBalance: _readDouble(json, const [
        'total_balance',
        'portfolio_balance',
        'cumulative_balance',
        'account_balance',
        'balance',
      ]),
      balanceTentative: json['balance_tentative'] as bool? ??
          json['is_balance_tentative'] as bool? ??
          false,
      connectedExchangeCount: _readInt(json, const [
        'connected_exchange_count',
        'exchange_count',
        'connected_exchanges',
      ]),
    );
  }

  final int adherenceScore;
  final double adherenceChangePct;
  final double todayPnl;
  final int tradesClosedToday;
  final int compliantTradeStreak;
  final CostlyMistake? mostCostlyMistake;
  final double opportunityCostTotal;
  final List<OpportunityItem> opportunityItems;
  final List<GuardrailMetric> guardrails;
  final List<DisciplineFlag> disciplineFlags;
  final SourceBreakdown sourceBreakdown;
  final double? totalBalance;
  final bool balanceTentative;
  final int? connectedExchangeCount;
}

double? _readDouble(Map<String, dynamic> json, List<String> keys) {
  for (final key in keys) {
    final value = json[key];
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value);
  }
  return null;
}

int? _readInt(Map<String, dynamic> json, List<String> keys) {
  for (final key in keys) {
    final value = json[key];
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value);
    if (value is List) return value.length;
  }
  return null;
}

class SourceBreakdown {
  const SourceBreakdown({
    required this.poiseOpen,
    required this.externalOpen,
    required this.poiseOrders,
    required this.externalOrders,
  });

  factory SourceBreakdown.fromJson(Map<String, dynamic> json) =>
      SourceBreakdown(
        poiseOpen: (json['poise_open'] as num?)?.toInt() ?? 0,
        externalOpen: (json['external_open'] as num?)?.toInt() ?? 0,
        poiseOrders: (json['poise_orders'] as num?)?.toInt() ?? 0,
        externalOrders: (json['external_orders'] as num?)?.toInt() ?? 0,
      );

  final int poiseOpen;
  final int externalOpen;
  final int poiseOrders;
  final int externalOrders;
}

class DisciplineFlag {
  const DisciplineFlag({
    required this.label,
    required this.description,
    required this.severity,
    required this.impact,
  });

  factory DisciplineFlag.fromJson(Map<String, dynamic> json) => DisciplineFlag(
        label: json['label'] as String? ?? 'Discipline flag',
        description: json['description'] as String? ?? '',
        severity: json['severity'] as String? ?? 'moderate',
        impact: (json['impact'] as num?)?.toDouble() ?? 0,
      );

  final String label;
  final String description;
  final String severity;
  final double impact;
}

class CostlyMistake {
  const CostlyMistake({
    required this.symbol,
    required this.missedPnl,
    required this.reason,
  });

  factory CostlyMistake.fromJson(Map<String, dynamic> json) {
    return CostlyMistake(
      symbol: json['symbol'] as String? ?? '',
      missedPnl: (json['missed_pnl'] as num?)?.toDouble() ?? 0,
      reason: json['reason'] as String? ?? 'Loss management',
    );
  }

  final String symbol;
  final double missedPnl;
  final String reason;
}

class OpportunityItem {
  const OpportunityItem({
    required this.label,
    required this.symbol,
    required this.count,
    required this.value,
  });

  factory OpportunityItem.fromJson(Map<String, dynamic> json) {
    return OpportunityItem(
      label: json['label'] as String? ?? 'Decision cost',
      symbol: json['symbol'] as String? ?? '',
      count: (json['count'] as num?)?.toInt() ?? 0,
      value: (json['value'] as num?)?.toDouble() ?? 0,
    );
  }

  final String label;
  final String symbol;
  final int count;
  final double value;
}

class GuardrailMetric {
  const GuardrailMetric({
    required this.label,
    required this.description,
    required this.value,
    required this.limit,
    required this.unit,
    required this.progress,
    required this.status,
  });

  factory GuardrailMetric.fromJson(Map<String, dynamic> json) {
    return GuardrailMetric(
      label: json['label'] as String? ?? '',
      description: json['description'] as String? ?? '',
      value: (json['value'] as num?)?.toDouble() ?? 0,
      limit: (json['limit'] as num?)?.toDouble() ?? 0,
      unit: json['unit'] as String? ?? '',
      progress: (json['progress'] as num?)?.toDouble() ?? 0,
      status: json['status'] as String? ?? 'normal',
    );
  }

  final String label;
  final String description;
  final double value;
  final double limit;
  final String unit;
  final double progress;
  final String status;
}
