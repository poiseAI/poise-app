import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/errors/app_error.dart';
import '../../../core/network/api_client.dart';
import '../../../core/utils/result.dart';
import 'models/order.dart';

part 'orders_api.g.dart';

@riverpod
OrdersApi ordersApi(Ref ref) => OrdersApi(ref.watch(dioProvider));

class OrdersApi {
  OrdersApi(this._dio);
  final Dio _dio;

  Future<Result<Order, AppError>> placeOrder(PlaceOrderRequest req) async {
    try {
      final resp = await _dio.post<Map<String, dynamic>>(
        '/orders',
        data: req.toJson(),
      );
      return Ok(Order.fromJson(resp.data!));
    } on DioException catch (e) {
      return Err(e.error is AppError
          ? e.error as AppError
          : UnknownError(e.message ?? ''));
    }
  }

  Future<Result<List<Order>, AppError>> getOrders({
    String? status,
    String? symbol,
    int limit = 20,
  }) async {
    try {
      final resp = await _dio.get<Map<String, dynamic>>(
        '/orders',
        queryParameters: {
          if (status != null) 'status': status,
          if (symbol != null) 'symbol': symbol,
          'limit': limit,
        },
      );
      final list =
          _extractList(resp.data, 'orders').map(Order.fromJson).toList();
      return Ok(list);
    } on DioException catch (e) {
      return Err(e.error is AppError
          ? e.error as AppError
          : UnknownError(e.message ?? ''));
    }
  }

  Future<Result<OrderInsights, AppError>> getOrderInsights(String id) async {
    try {
      final resp = await _dio.get<Map<String, dynamic>>(
        '/orders/$id/insights',
      );
      return Ok(OrderInsights.fromJson(resp.data!));
    } on DioException catch (e) {
      return Err(e.error is AppError
          ? e.error as AppError
          : UnknownError(e.message ?? ''));
    }
  }

  Future<Result<void, AppError>> cancelOrder(String id) async {
    try {
      await _dio.post<void>('/orders/$id/cancel');
      return const Ok(null);
    } on DioException catch (e) {
      return Err(e.error is AppError
          ? e.error as AppError
          : UnknownError(e.message ?? ''));
    }
  }
}

class OrderInsights {
  const OrderInsights({
    required this.orderId,
    required this.adherenceScore,
    required this.adherenceLabel,
    required this.aiSummary,
    required this.metrics,
    required this.suggestions,
    this.opportunityCost,
  });

  factory OrderInsights.fromJson(Map<String, dynamic> json) => OrderInsights(
        orderId: json['order_id'] as String? ?? '',
        adherenceScore: (json['adherence_score'] as num?)?.toInt() ?? 0,
        adherenceLabel: json['adherence_label'] as String? ?? 'Not scored',
        aiSummary: json['ai_summary'] as String? ?? '',
        opportunityCost: json['opportunity_cost'] is Map<String, dynamic>
            ? OrderOpportunityCost.fromJson(
                json['opportunity_cost'] as Map<String, dynamic>,
              )
            : null,
        metrics: (json['metrics'] as List? ?? const [])
            .whereType<Map<String, dynamic>>()
            .map(OrderInsightMetric.fromJson)
            .toList(),
        suggestions: (json['suggestions'] as List? ?? const [])
            .whereType<String>()
            .toList(),
      );

  final String orderId;
  final int adherenceScore;
  final String adherenceLabel;
  final String aiSummary;
  final OrderOpportunityCost? opportunityCost;
  final List<OrderInsightMetric> metrics;
  final List<String> suggestions;
}

class OrderOpportunityCost {
  const OrderOpportunityCost({
    required this.label,
    required this.value,
    required this.description,
  });

  factory OrderOpportunityCost.fromJson(Map<String, dynamic> json) =>
      OrderOpportunityCost(
        label: json['label'] as String? ?? 'Opportunity cost',
        value: (json['value'] as num?)?.toDouble() ?? 0,
        description: json['description'] as String? ?? '',
      );

  final String label;
  final double value;
  final String description;
}

class OrderInsightMetric {
  const OrderInsightMetric({
    required this.label,
    required this.score,
    required this.status,
  });

  factory OrderInsightMetric.fromJson(Map<String, dynamic> json) =>
      OrderInsightMetric(
        label: json['label'] as String? ?? 'Discipline',
        score: (json['score'] as num?)?.toInt() ?? 0,
        status: json['status'] as String? ?? 'watch',
      );

  final String label;
  final int score;
  final String status;
}

List<Map<String, dynamic>> _extractList(
  Map<String, dynamic>? data,
  String key,
) {
  final raw = data?[key];
  if (raw is! List) return const [];
  return raw.whereType<Map<String, dynamic>>().toList();
}
