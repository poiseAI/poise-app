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

List<Map<String, dynamic>> _extractList(
  Map<String, dynamic>? data,
  String key,
) {
  final raw = data?[key];
  if (raw is! List) return const [];
  return raw.whereType<Map<String, dynamic>>().toList();
}
