import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/errors/app_error.dart';
import '../../../core/network/api_client.dart';
import '../../../core/utils/result.dart';
import '../../orders/data/models/order.dart';

part 'trade_api.g.dart';

@riverpod
TradeApi tradeApi(Ref ref) => TradeApi(ref.watch(dioProvider));

class TradeApi {
  TradeApi(this._dio);
  final Dio _dio;

  Future<Result<TradePreflight, AppError>> preflight({
    String exchange = 'bybit',
  }) async {
    try {
      final normalizedExchange = exchange.trim().toLowerCase();
      final resp = await _dio.get<Map<String, dynamic>>(
        '/trade/preflight',
        queryParameters: {'exchange': normalizedExchange},
      );
      return Ok(
        TradePreflight.fromJson(
          resp.data ?? const {},
          fallbackExchange:
              normalizedExchange.isEmpty ? 'bybit' : normalizedExchange,
        ),
      );
    } on DioException catch (e) {
      return Err(_err(e));
    }
  }

  Future<Result<ExchangeBalance, AppError>> balance(String exchange) async {
    try {
      final resp = await _dio.get<Map<String, dynamic>>(
        '/exchange/balance',
        queryParameters: {'exchange': exchange},
      );
      return Ok(ExchangeBalance.fromJson(resp.data ?? const {}));
    } on DioException catch (e) {
      return Err(_err(e));
    }
  }

  Future<Result<TradeValidationResult, AppError>> validate(
    Map<String, dynamic> draft,
  ) async {
    try {
      final resp = await _dio.post<Map<String, dynamic>>(
        '/trade/validate',
        data: draft,
      );
      return Ok(TradeValidationResult.fromJson(resp.data ?? const {}));
    } on DioException catch (e) {
      return Err(_err(e));
    }
  }

  Future<Result<Order, AppError>> submit({
    required Map<String, dynamic> draft,
    required String submitToken,
    required bool proceedAfterWarnings,
    String? clientOrderId,
  }) async {
    try {
      final resp = await _dio.post<Map<String, dynamic>>(
        '/trade/submit',
        data: {
          'draft': draft,
          'submit_token': submitToken,
          'proceed_after_warnings': proceedAfterWarnings,
          if (clientOrderId != null) 'client_order_id': clientOrderId,
        },
      );
      return Ok(Order.fromJson(resp.data ?? const {}));
    } on DioException catch (e) {
      return Err(_err(e));
    }
  }

  AppError _err(DioException e) =>
      e.error is AppError ? e.error as AppError : UnknownError(e.message ?? '');
}

class TradePreflight {
  const TradePreflight({
    required this.allowed,
    this.blockingReason,
    this.dailyResetAt,
    required this.exchange,
    required this.riskPerTradePct,
    required this.maxLeverage,
    required this.tradesToday,
    required this.maxTradesPerDay,
    required this.dailyLossLimitType,
    required this.dailyLossLimitUsd,
    required this.dailyBaselineBalanceUsd,
    required this.dailyAvailableBalanceUsd,
    required this.balanceSnapshotComplete,
    required this.balanceSnapshotExpectedConnections,
    required this.balanceSnapshotCapturedConnections,
    required this.externalOpenPositions,
    required this.unknownRiskPositions,
  });

  factory TradePreflight.fromJson(
    Map<String, dynamic> json, {
    String fallbackExchange = 'bybit',
  }) {
    final rules = (json['rules'] as Map<String, dynamic>?) ?? json;
    return TradePreflight(
      allowed: json['allowed'] as bool? ?? true,
      blockingReason: json['blocking_reason'] as String?,
      dailyResetAt: json['daily_reset_at'] as String?,
      exchange: json['exchange'] as String? ?? fallbackExchange,
      riskPerTradePct: ((rules['risk_per_trade_pct'] ??
              rules['riskPerTradePct'] ??
              2) as num)
          .toDouble(),
      maxLeverage:
          ((rules['max_leverage'] ?? rules['maxLeverage'] ?? 10) as num)
              .toDouble(),
      tradesToday: ((rules['trades_today'] ?? 0) as num).toInt(),
      maxTradesPerDay: ((rules['max_trades_per_day'] ?? 5) as num).toInt(),
      dailyLossLimitType:
          rules['daily_loss_limit_type'] as String? ?? 'fixed_usd',
      dailyLossLimitUsd:
          ((rules['daily_loss_limit_usd'] ?? 0) as num).toDouble(),
      dailyBaselineBalanceUsd:
          ((rules['daily_baseline_balance_usd'] ?? 0) as num).toDouble(),
      dailyAvailableBalanceUsd:
          ((rules['daily_available_balance_usd'] ?? 0) as num).toDouble(),
      balanceSnapshotComplete:
          rules['balance_snapshot_complete'] as bool? ?? true,
      balanceSnapshotExpectedConnections:
          ((rules['balance_snapshot_expected_connections'] ?? 0) as num)
              .toInt(),
      balanceSnapshotCapturedConnections:
          ((rules['balance_snapshot_captured_connections'] ?? 0) as num)
              .toInt(),
      externalOpenPositions:
          ((rules['external_open_positions'] ?? 0) as num).toInt(),
      unknownRiskPositions:
          ((rules['unknown_risk_positions'] ?? 0) as num).toInt(),
    );
  }

  final bool allowed;
  final String? blockingReason;
  final String? dailyResetAt;
  final String exchange;
  final double riskPerTradePct;
  final double maxLeverage;
  final int tradesToday;
  final int maxTradesPerDay;
  final String dailyLossLimitType;
  final double dailyLossLimitUsd;
  final double dailyBaselineBalanceUsd;
  final double dailyAvailableBalanceUsd;
  final bool balanceSnapshotComplete;
  final int balanceSnapshotExpectedConnections;
  final int balanceSnapshotCapturedConnections;
  final int externalOpenPositions;
  final int unknownRiskPositions;
}

class ExchangeBalance {
  const ExchangeBalance({required this.available, required this.currency});
  factory ExchangeBalance.fromJson(Map<String, dynamic> json) =>
      ExchangeBalance(
        available:
            ((json['available'] ?? json['available_balance'] ?? 0) as num)
                .toDouble(),
        currency: json['currency'] as String? ?? 'USD',
      );

  final double available;
  final String currency;
}

class GuardrailResult {
  const GuardrailResult({
    required this.title,
    required this.message,
    required this.severity,
    this.category,
    this.aiPrompt,
  });

  factory GuardrailResult.fromJson(Map<String, dynamic> json) =>
      GuardrailResult(
        title:
            json['title'] as String? ?? json['name'] as String? ?? 'Guardrail',
        message: json['message'] as String? ??
            json['reason'] as String? ??
            'Review this trade before continuing.',
        severity: json['severity'] as String? ?? 'warning',
        category: json['category'] as String?,
        aiPrompt: json['ai_prompt'] as String?,
      );

  final String title;
  final String message;
  final String severity;
  final String? category;
  final String? aiPrompt;
}

class TradeValidationResult {
  const TradeValidationResult({
    required this.submitToken,
    required this.riskPct,
    required this.margin,
    required this.positionSize,
    required this.riskRewardRatio,
    required this.possibleLoss,
    required this.possibleProfit,
    required this.dailyBaselineBalanceUsd,
    required this.dailyAvailableBalanceUsd,
    required this.dailyLossLimitType,
    required this.dailyLossLimitUsd,
    required this.realizedDailyLossUsd,
    required this.openPositionReservedLossUsd,
    required this.externalUnrealizedLossUsd,
    required this.currentDailyRiskUsedUsd,
    required this.projectedDailyLossUsd,
    required this.remainingDailyLossBudgetUsd,
    required this.balanceSnapshotComplete,
    required this.balanceSnapshotExpectedConnections,
    required this.balanceSnapshotCapturedConnections,
    required this.externalOpenPositions,
    required this.unknownRiskPositions,
    required this.requiresExternalRiskReview,
    required this.dailyLimitAcknowledgementRequired,
    required this.blockingGuardrails,
    required this.warningGuardrails,
    this.aiSessionId,
  });

  factory TradeValidationResult.fromJson(Map<String, dynamic> json) {
    final summary = (json['summary'] as Map<String, dynamic>?) ?? json;
    return TradeValidationResult(
      submitToken: json['submit_token'] as String? ?? '',
      riskPct:
          ((summary['risk_pct'] ?? summary['risk'] ?? 0) as num).toDouble(),
      margin: ((summary['margin'] ?? summary['margin_amount'] ?? 0) as num)
          .toDouble(),
      positionSize: ((summary['position_size'] ?? 0) as num).toDouble(),
      riskRewardRatio: summary['risk_reward_ratio'] as String? ??
          summary['rr'] as String? ??
          '-',
      possibleLoss: ((summary['possible_loss'] ?? 0) as num).toDouble(),
      possibleProfit: ((summary['possible_profit'] ?? 0) as num).toDouble(),
      dailyBaselineBalanceUsd:
          ((summary['daily_baseline_balance_usd'] ?? 0) as num).toDouble(),
      dailyAvailableBalanceUsd:
          ((summary['daily_available_balance_usd'] ?? 0) as num).toDouble(),
      dailyLossLimitType:
          summary['daily_loss_limit_type'] as String? ?? 'fixed_usd',
      dailyLossLimitUsd:
          ((summary['daily_loss_limit_usd'] ?? 0) as num).toDouble(),
      realizedDailyLossUsd:
          ((summary['realized_daily_loss_usd'] ?? 0) as num).toDouble(),
      openPositionReservedLossUsd:
          ((summary['open_position_reserved_loss_usd'] ?? 0) as num).toDouble(),
      externalUnrealizedLossUsd:
          ((summary['external_unrealized_loss_usd'] ?? 0) as num).toDouble(),
      currentDailyRiskUsedUsd:
          ((summary['current_daily_risk_used_usd'] ?? 0) as num).toDouble(),
      projectedDailyLossUsd:
          ((summary['projected_daily_loss_usd'] ?? 0) as num).toDouble(),
      remainingDailyLossBudgetUsd:
          ((summary['remaining_daily_loss_budget_usd'] ?? 0) as num).toDouble(),
      balanceSnapshotComplete:
          summary['balance_snapshot_complete'] as bool? ?? true,
      balanceSnapshotExpectedConnections:
          ((summary['balance_snapshot_expected_connections'] ?? 0) as num)
              .toInt(),
      balanceSnapshotCapturedConnections:
          ((summary['balance_snapshot_captured_connections'] ?? 0) as num)
              .toInt(),
      externalOpenPositions:
          ((summary['external_open_positions'] ?? 0) as num).toInt(),
      unknownRiskPositions:
          ((summary['unknown_risk_positions'] ?? 0) as num).toInt(),
      requiresExternalRiskReview:
          summary['requires_external_risk_review'] as bool? ?? false,
      dailyLimitAcknowledgementRequired:
          summary['daily_limit_acknowledgement_required'] as bool? ?? false,
      blockingGuardrails: _guardrails(json['blocking_guardrails']),
      warningGuardrails: [
        ..._guardrails(json['warning_guardrails']),
        ..._guardrails(json['behavioural_warnings']),
      ],
      aiSessionId: json['ai_session_id'] as String?,
    );
  }

  final String submitToken;
  final double riskPct;
  final double margin;
  final double positionSize;
  final String riskRewardRatio;
  final double possibleLoss;
  final double possibleProfit;
  final double dailyBaselineBalanceUsd;
  final double dailyAvailableBalanceUsd;
  final String dailyLossLimitType;
  final double dailyLossLimitUsd;
  final double realizedDailyLossUsd;
  final double openPositionReservedLossUsd;
  final double externalUnrealizedLossUsd;
  final double currentDailyRiskUsedUsd;
  final double projectedDailyLossUsd;
  final double remainingDailyLossBudgetUsd;
  final bool balanceSnapshotComplete;
  final int balanceSnapshotExpectedConnections;
  final int balanceSnapshotCapturedConnections;
  final int externalOpenPositions;
  final int unknownRiskPositions;
  final bool requiresExternalRiskReview;
  final bool dailyLimitAcknowledgementRequired;
  final List<GuardrailResult> blockingGuardrails;
  final List<GuardrailResult> warningGuardrails;
  final String? aiSessionId;

  List<GuardrailResult> get guardrailWarnings => [
        ...warningGuardrails,
        ...blockingGuardrails.where((item) => !_isExchangeGuardrail(item)),
      ];

  bool get requiresExchangeConnection =>
      blockingGuardrails.any(_isExchangeGuardrail);

  bool get hasWarnings => guardrailWarnings.isNotEmpty;
  bool get isBlocked => requiresExchangeConnection;
}

List<GuardrailResult> _guardrails(Object? raw) {
  if (raw is! List) return const [];
  return raw
      .whereType<Map<String, dynamic>>()
      .map(GuardrailResult.fromJson)
      .toList();
}

bool _isExchangeGuardrail(GuardrailResult item) {
  final text = '${item.title} ${item.message}'.toLowerCase();
  return text.contains('exchange') ||
      text.contains('api key') ||
      text.contains('connection');
}
