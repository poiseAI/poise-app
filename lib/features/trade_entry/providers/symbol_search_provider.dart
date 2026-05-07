import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/models/symbol.dart';
import '../data/symbols_api.dart';

part 'symbol_search_provider.g.dart';

@riverpod
class SymbolSearch extends _$SymbolSearch {
  Timer? _debounce;

  @override
  AsyncValue<List<TradingSymbol>> build() => const AsyncValue.loading();

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
    if (query.isEmpty) {
      loadPopular();
      return;
    }
    _debounce = Timer(const Duration(milliseconds: 300), () async {
      state = const AsyncValue.loading();
      final result = await ref.read(symbolsApiProvider).search(query);
      state = result.fold(
        onOk: AsyncValue.data,
        onErr: (e) => AsyncValue.error(e, StackTrace.current),
      );
    });
  }
}
