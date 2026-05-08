import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/models/symbol.dart';
import '../data/symbols_api.dart';

part 'symbol_search_provider.g.dart';

@riverpod
class SymbolSearch extends _$SymbolSearch {
  Timer? _debounce;

  @override
  AsyncValue<List<TradingSymbol>> build() {
    ref.onDispose(() => _debounce?.cancel());
    return const AsyncValue.loading();
  }

  Future<void> loadPopular() async {
    state = const AsyncValue.loading();
    final result = await ref.read(symbolsApiProvider).getPopular();
    state = result.fold(
      onOk: AsyncValue.data,
      onErr: (e) => AsyncValue.error(e, StackTrace.current),
    );
  }

  void search(String query) {
    _debounce?.cancel();
    final normalized = query.trim().toUpperCase();
    if (normalized.isEmpty) {
      loadPopular();
      return;
    }
    _debounce = Timer(const Duration(milliseconds: 300), () async {
      state = const AsyncValue.loading();
      final result =
          await ref.read(symbolsApiProvider).search(normalized, limit: 20);
      state = result.fold(
        onOk: (symbols) => AsyncValue.data(_rank(symbols, normalized)),
        onErr: (e) => AsyncValue.error(e, StackTrace.current),
      );
    });
  }

  List<TradingSymbol> _rank(List<TradingSymbol> symbols, String query) {
    final copy = [...symbols];
    copy.sort((a, b) {
      final ar = _rankValue(a.symbol, query);
      final br = _rankValue(b.symbol, query);
      if (ar != br) return ar.compareTo(br);
      return b.priceChangePct.abs().compareTo(a.priceChangePct.abs());
    });
    return copy;
  }

  int _rankValue(String symbol, String query) {
    if (symbol == query) return 0;
    if (symbol.startsWith(query)) return 1;
    if (symbol.contains(query)) return 2;
    return 3;
  }
}
