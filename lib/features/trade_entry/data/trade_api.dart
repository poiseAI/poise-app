import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
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

  Future<Result<TradePreflight, AppError>> preflight() async {
    try {
      final resp = await _dio.get<Map<String, dynamic>>('/trade/preflight');
      return Ok(TradePreflight.fromJson(resp.data ?? const {}));
    } on DioException catch (e) {
      if (kDebugMode && e.response?.statusCode == 404) {
        return Ok(TradePreflight.fallback());
      }
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
      if (kDebugMode && e.response?.statusCode == 404) {
        return const Ok(ExchangeBalance(available: 0, currency: 'USD'));
      }
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
      if (kDebugMode && e.response?.statusCode == 404) {
        return Ok(TradeValidationResult.localFallback(draft));
      }
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
      if (kDebugMode && e.response?.statusCode == 404) {
        final resp = await _dio.post<Map<String, dynamic>>(
          '/orders',
          data: _legacyOrderPayload(draft, clientOrderId),
        );
        return Ok(Order.fromJson(resp.data ?? const {}));
      }
      return Err(_err(e));
    }
  }

  AppError _err(DioException e) =>
      e.error is AppError ? e.error as AppError : UnknownError(e.message ?? '');
}

Map<String, dynamic> _legacyOrderPayload(
  Map<String, dynamic> draft,
  String? clientOrderId,
) => {
      'exchange': draft['exchange'] ?? 'bybit',
      'symbol': draft['symbol'],
      if (clientOrderId != null) 'client_order_id': clientOrderId,
      'side': draft['side'] == 'short' ? 'sell' : 'buy',
      'order_type': draft['execution_mode'] == 'limit' ? 'limit' : 'market',
      'quantity': draft['quantity'] ?? 1.0,
      'price': draft['limit_price'],
      'margin_amount': draft['margin_amount'],
      'entry_price': draft['entry_price'],
      'leverage': draft['leverage'] ?? 1.0,
      'tp_levels': [
        if (draft['take_profit_1'] != null) draft['take_profit_1'],
        if (draft['take_profit_2'] != null) draft['take_profit_2'],
      ],
      'sl_price': draft['stop_loss'],
      'immediate_tp': draft['take_profit_1'],
      'immediate_sl': draft['stop_loss'],
    };

class TradePreflight {
  const TradePreflight({
    required this.allowed,
    this.blockingReason,
    this.dailyResetAt,
    this.weeklyResetAt,
    required this.exchange,
    required this.riskPerTradePct,
    required this.maxLeverage,
    required this.tradesToday,
    required this.maxTradesPerDay,
  });

  factory TradePreflight.fallback() => const TradePreflight(
        allowed: true,
        exchange: 'bybit',
        riskPerTradePct: 2,
        maxLeverage: 10,
        tradesToday: 0,
        maxTradesPerDay: 5,
      );

  factory TradePreflight.fromJson(Map<String, dynamic> json) {
    final rules = (json['rules'] as Map<String, dynamic>?) ?? json;
    return TradePreflight(
      allowed: json['allowed'] as bool? ?? true,
      blockingReason: json['blocking_reason'] as String?,
      dailyResetAt: json['daily_reset_at'] as String?,
      weeklyResetAt: json['weekly_reset_at'] as String?,
      exchange: json['exchange'] as String? ?? 'bybit',
      riskPerTradePct:
          ((rules['risk_per_trade_pct'] ?? rules['riskPerTradePct'] ?? 2)
                  as num)
              .toDouble(),
      maxLeverage:
          ((rules['max_leverage'] ?? rules['maxLeverage'] ?? 10) as num)
              .toDouble(),
      tradesToday: ((rules['trades_today'] ?? 0) as num).toInt(),
      maxTradesPerDay: ((rules['max_trades_per_day'] ?? 5) as num).toInt(),
    );
  }

  final bool allowed;
  final String? blockingReason;
  final String? dailyResetAt;
  final String? weeklyResetAt;
  final String exchange;
  final double riskPerTradePct;
  final double maxLeverage;
  final int tradesToday;
  final int maxTradesPerDay;
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
    this.aiPrompt,
  });

  factory GuardrailResult.fromJson(Map<String, dynamic> json) =>
      GuardrailResult(
        title: json['title'] as String? ?? json['name'] as String? ?? 'Guardrail',
        message: json['message'] as String? ??
            json['reason'] as String? ??
            'Review this trade before continuing.',
        severity: json['severity'] as String? ?? 'warning',
        aiPrompt: json['ai_prompt'] as String?,
      );

  final String title;
  final String message;
  final String severity;
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
    required this.blockingGuardrails,
    required this.warningGuardrails,
    this.aiSessionId,
  });

  factory TradeValidationResult.fromJson(Map<String, dynamic> json) {
    final summary = (json['summary'] as Map<String, dynamic>?) ?? json;
    return TradeValidationResult(
      submitToken: json['submit_token'] as String? ?? 'validated-local',
      riskPct: ((summary['risk_pct'] ?? summary['risk'] ?? 0) as num).toDouble(),
      margin: ((summary['margin'] ?? summary['margin_amount'] ?? 0) as num)
          .toDouble(),
      positionSize:
          ((summary['position_size'] ?? 0) as num).toDouble(),
      riskRewardRatio:
          summary['risk_reward_ratio'] as String? ?? summary['rr'] as String? ?? '-',
      possibleLoss:
          ((summary['possible_loss'] ?? 0) as num).toDouble(),
      possibleProfit:
          ((summary['possible_profit'] ?? 0) as num).toDouble(),
      blockingGuardrails: _guardrails(json['blocking_guardrails']),
      warningGuardrails: [
        ..._guardrails(json['warning_guardrails']),
        ..._guardrails(json['behavioural_warnings']),
      ],
      aiSessionId: json['ai_session_id'] as String?,
    );
  }

  factory TradeValidationResult.localFallback(Map<String, dynamic> draft) {
    final margin = ((draft['margin_amount'] ?? 0) as num).toDouble();
    final leverage = ((draft['leverage'] ?? 1) as num).toDouble();
    final entry = ((draft['entry_price'] ?? draft['limit_price'] ?? 0) as num)
        .toDouble();
    final sl = (draft['stop_loss'] as num?)?.toDouble();
    final tp1 = (draft['take_profit_1'] as num?)?.toDouble();
    final positionSize = margin * leverage;
    final possibleLoss = entry > 0 && sl != null
        ? positionSize * ((entry - sl).abs() / entry)
        : 0.0;
    final possibleProfit = entry > 0 && tp1 != null
        ? positionSize * ((tp1 - entry).abs() / entry)
        : 0.0;
    final riskPct =
        margin > 0 && possibleLoss > 0 ? (possibleLoss / margin) * 100 : 0.0;
    final rr = possibleLoss > 0
        ? '1:${(possibleProfit / possibleLoss).toStringAsFixed(1)}'
        : '-';
    return TradeValidationResult(
      submitToken: 'validated-local',
      riskPct: riskPct,
      margin: margin,
      positionSize: positionSize,
      riskRewardRatio: rr,
      possibleLoss: possibleLoss,
      possibleProfit: possibleProfit,
      blockingGuardrails: const [],
      warningGuardrails: const [],
    );
  }

  final String submitToken;
  final double riskPct;
  final double margin;
  final double positionSize;
  final String riskRewardRatio;
  final double possibleLoss;
  final double possibleProfit;
  final List<GuardrailResult> blockingGuardrails;
  final List<GuardrailResult> warningGuardrails;
  final String? aiSessionId;

  bool get hasWarnings => warningGuardrails.isNotEmpty;
  bool get isBlocked => blockingGuardrails.isNotEmpty;
}

List<GuardrailResult> _guardrails(Object? raw) {
  if (raw is! List) return const [];
  return raw
      .whereType<Map<String, dynamic>>()
      .map(GuardrailResult.fromJson)
      .toList();
}
