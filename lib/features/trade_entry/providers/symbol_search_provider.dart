import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/storage/preferences.dart';
import '../data/models/symbol.dart';
import '../data/symbols_api.dart';

part 'symbol_search_provider.g.dart';

@riverpod
class SymbolSearch extends _$SymbolSearch {
  Timer? _debounce;
  int _requestId = 0;
  String _activeExchange = 'bybit';
  static const _quote = 'USDT';

  @override
  AsyncValue<List<TradingSymbol>> build() {
    ref.onDispose(() => _debounce?.cancel());
    return AsyncValue.data(_fallbackPopular(_activeExchange));
  }

  Future<void> loadPopular({String exchange = 'bybit'}) async {
    final requestId = ++_requestId;
    _activeExchange = _normalizeExchange(exchange);
    _debounce?.cancel();
    state = AsyncValue.data(_fallbackPopular(_activeExchange));
    final result = await ref
        .read(symbolsApiProvider)
        .getPopular(exchange: _activeExchange, quote: _quote);
    if (requestId != _requestId) return;
    if (result.isErr) {
      state = AsyncValue.error(result.error, StackTrace.current);
      return;
    }
    try {
      final prefs = await ref.read(appPreferencesProvider.future);
      if (requestId != _requestId) return;
      state = AsyncValue.data(
        _withHistory(result.value, prefs.symbolHistory).take(8).toList(),
      );
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> remember(TradingSymbol symbol) async {
    final prefs = await ref.read(appPreferencesProvider.future);
    await prefs.addSymbolHistory(symbol.symbol);
    ref.invalidate(appPreferencesProvider);
  }

  void search(String query, {String? exchange}) {
    _debounce?.cancel();
    final requestId = ++_requestId;
    _activeExchange = _normalizeExchange(exchange ?? _activeExchange);
    final normalized = query.trim().toUpperCase();
    if (normalized.isEmpty) {
      loadPopular(exchange: _activeExchange);
      return;
    }
    state = AsyncValue.data(
      _rank(_fallbackPopular(_activeExchange), normalized, const [])
          .where((symbol) => _matchesQuery(symbol, normalized))
          .take(8)
          .toList(),
    );
    _debounce = Timer(const Duration(milliseconds: 300), () async {
      final result = await ref.read(symbolsApiProvider).search(
            normalized,
            limit: 8,
            exchange: _activeExchange,
            quote: _quote,
          );
      if (requestId != _requestId) return;
      final prefs = await ref.read(appPreferencesProvider.future);
      if (requestId != _requestId) return;
      state = result.fold(
        onOk: (symbols) => AsyncValue.data(
          _rank(symbols, normalized, prefs.symbolHistory).take(8).toList(),
        ),
        onErr: (e) => AsyncValue.error(e, StackTrace.current),
      );
    });
  }

  List<TradingSymbol> _withHistory(
    List<TradingSymbol> symbols,
    List<String> history,
  ) {
    if (history.isEmpty) return symbols;
    final copy = [...symbols];
    copy.sort((a, b) {
      final ah = history.indexOf(a.symbol);
      final bh = history.indexOf(b.symbol);
      if (ah != -1 || bh != -1) {
        if (ah == -1) return 1;
        if (bh == -1) return -1;
        return ah.compareTo(bh);
      }
      return _popularRank(a.symbol).compareTo(_popularRank(b.symbol));
    });
    return copy;
  }

  List<TradingSymbol> _rank(
    List<TradingSymbol> symbols,
    String query,
    List<String> history,
  ) {
    final copy = [...symbols];
    copy.sort((a, b) {
      final ar = _rankValue(a, query, history);
      final br = _rankValue(b, query, history);
      if (ar != br) return ar.compareTo(br);
      final pr = _popularRank(a.symbol).compareTo(_popularRank(b.symbol));
      if (pr != 0) return pr;
      if (a.exchange != b.exchange) return a.exchange == 'bybit' ? -1 : 1;
      return b.priceChangePct.abs().compareTo(a.priceChangePct.abs());
    });
    return copy;
  }

  int _rankValue(TradingSymbol item, String query, List<String> history) {
    final symbol = item.symbol;
    final historyIndex = history.indexOf(symbol);
    if (historyIndex != -1 && symbol.startsWith(query)) return historyIndex;
    if (symbol == query) return 0;
    if (item.baseAsset == query && item.quoteAsset == 'USDT') return 10;
    if (symbol == '${query}USDT') return 11;
    if (symbol.startsWith(query) && symbol.endsWith('USDT')) return 20;
    if (symbol.startsWith(query)) return 30;
    if (symbol.contains(query)) return 40;
    return 50;
  }
}

List<TradingSymbol> _fallbackPopular(String exchange) {
  return _popularBases.map((base) {
    return TradingSymbol(
      symbol: '${base}USDT',
      baseAsset: base,
      quoteAsset: 'USDT',
      exchange: exchange,
      status: 'Trading',
    );
  }).toList();
}

String _normalizeExchange(String value) {
  final normalized = value.trim().toLowerCase();
  return normalized.isEmpty ? 'bybit' : normalized;
}

int _popularRank(String symbol) {
  final idx = _popularSymbols.indexOf(symbol);
  return idx == -1 ? 999 : idx;
}

bool _matchesQuery(TradingSymbol symbol, String query) {
  return symbol.symbol.contains(query) ||
      symbol.baseAsset.contains(query) ||
      symbol.quoteAsset.contains(query);
}

const _popularBases = [
  'BTC',
  'ETH',
  'SOL',
  'BNB',
  'XRP',
  'ADA',
  'DOGE',
  'AVAX',
  'LINK',
  'DOT',
  'AAVE',
  'UNI',
];

const _popularSymbols = [
  'BTCUSDT',
  'ETHUSDT',
  'SOLUSDT',
  'BNBUSDT',
  'XRPUSDT',
  'ADAUSDT',
  'DOGEUSDT',
  'AVAXUSDT',
  'LINKUSDT',
  'DOTUSDT',
  'AAVEUSDT',
  'UNIUSDT',
];
