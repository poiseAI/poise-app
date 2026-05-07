import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/errors/app_error.dart';
import '../../../core/network/api_client.dart';
import '../../../core/utils/result.dart';
import 'models/symbol.dart';

part 'symbols_api.g.dart';

@riverpod
SymbolsApi symbolsApi(Ref ref) => SymbolsApi(ref.watch(dioProvider));

class SymbolsApi {
  SymbolsApi(this._dio);
  final Dio _dio;

  Future<Result<List<TradingSymbol>, AppError>> getPopular() async {
    try {
      final resp = await _dio.get<Map<String, dynamic>>('/symbols/popular');
      final list = _extractList(resp.data, 'symbols')
          .map(TradingSymbol.fromJson)
          .toList();
      return Ok(list);
    } on DioException catch (e) {
      return Err(e.error is AppError
          ? e.error as AppError
          : UnknownError(e.message ?? ''));
    }
  }

  Future<Result<List<TradingSymbol>, AppError>> search(String query) async {
    try {
      final resp = await _dio.get<Map<String, dynamic>>(
        '/symbols/search',
        queryParameters: {'q': query},
      );
      final list = _extractList(resp.data, 'symbols')
          .map(TradingSymbol.fromJson)
          .toList();
      return Ok(list);
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
