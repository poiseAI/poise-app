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
  static const _cacheDuration = Duration(minutes: 5);
  final Map<String, ({DateTime at, List<TradingSymbol> data})> _cache = {};

  Future<Result<List<TradingSymbol>, AppError>> getPopular({
    String exchange = 'bybit',
    String quote = 'USDT',
  }) async {
    final normalizedExchange = _normalizeExchange(exchange);
    final normalizedQuote = _normalizeQuote(quote);
    final key = 'popular:$normalizedExchange:$normalizedQuote';
    final cached = _fresh(key);
    if (cached != null) return Ok(cached);
    try {
      final resp = await _dio.get<Map<String, dynamic>>(
        '/symbols/popular',
        queryParameters: {
          'exchange': normalizedExchange,
          'quote': normalizedQuote,
        },
      );
      final list = _extractList(resp.data, 'symbols')
          .map(TradingSymbol.fromJson)
          .where((sym) => _matches(sym, normalizedExchange, normalizedQuote))
          .toList();
      _cache[key] = (at: DateTime.now(), data: list);
      return Ok(list);
    } on DioException catch (e) {
      final stale = _cache[key]?.data;
      if (stale != null) return Ok(stale);
      return _getAllAsPopular(
        e,
        exchange: normalizedExchange,
        quote: normalizedQuote,
      );
    }
  }

  Future<Result<List<TradingSymbol>, AppError>> search(String query,
      {int limit = 20,
      String exchange = 'bybit',
      String quote = 'USDT'}) async {
    final normalized = query.trim().toUpperCase();
    final normalizedExchange = _normalizeExchange(exchange);
    final normalizedQuote = _normalizeQuote(quote);
    if (normalized.isEmpty) {
      return getPopular(exchange: normalizedExchange, quote: normalizedQuote);
    }
    final key =
        'search:$normalized:$limit:$normalizedExchange:$normalizedQuote';
    final cached = _fresh(key);
    if (cached != null) return Ok(cached);
    try {
      final resp = await _dio.get<Map<String, dynamic>>(
        '/symbols/search',
        queryParameters: {
          'q': normalized,
          'limit': limit,
          'exchange': normalizedExchange,
          'quote': normalizedQuote,
        },
      );
      final list = _extractList(resp.data, 'symbols')
          .map(TradingSymbol.fromJson)
          .where((sym) => _matches(sym, normalizedExchange, normalizedQuote))
          .toList();
      _cache[key] = (at: DateTime.now(), data: list);
      return Ok(list);
    } on DioException catch (e) {
      final stale = _cache[key]?.data;
      if (stale != null) return Ok(stale);
      return Err(e.error is AppError
          ? e.error as AppError
          : UnknownError(e.message ?? ''));
    }
  }

  List<TradingSymbol>? _fresh(String key) {
    final cached = _cache[key];
    if (cached == null) return null;
    if (DateTime.now().difference(cached.at) > _cacheDuration) return null;
    return cached.data;
  }

  Future<Result<List<TradingSymbol>, AppError>> _getAllAsPopular(
    DioException original, {
    required String exchange,
    required String quote,
  }) async {
    try {
      final resp = await _dio.get<Map<String, dynamic>>(
        '/symbols',
        queryParameters: {'exchange': exchange, 'quote': quote},
      );
      final list = _extractList(resp.data, 'symbols')
          .map(TradingSymbol.fromJson)
          .where((sym) => _matches(sym, exchange, quote))
          .take(20)
          .toList();
      _cache['popular:$exchange:$quote'] = (at: DateTime.now(), data: list);
      return Ok(list);
    } on DioException {
      return Err(original.error is AppError
          ? original.error as AppError
          : UnknownError(original.message ?? ''));
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

String _normalizeExchange(String value) {
  final normalized = value.trim().toLowerCase();
  return normalized.isEmpty ? 'bybit' : normalized;
}

String _normalizeQuote(String value) {
  final normalized = value.trim().toUpperCase();
  return normalized.isEmpty ? 'USDT' : normalized;
}

bool _matches(TradingSymbol sym, String exchange, String quote) {
  return sym.exchange.toLowerCase() == exchange &&
      sym.quoteAsset.toUpperCase() == quote &&
      sym.status.toLowerCase() == 'trading';
}
