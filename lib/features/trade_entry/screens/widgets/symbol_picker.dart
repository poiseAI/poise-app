import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../data/models/symbol.dart';
import '../../providers/symbol_search_provider.dart';
import '../../providers/trade_form_provider.dart';

class SymbolPicker extends ConsumerWidget {
  const SymbolPicker({
    super.key,
    required this.selected,
    this.exchange = 'bybit',
  });

  final TradingSymbol? selected;
  final String exchange;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final normalizedExchange = _normalizeExchange(exchange);
    final selected = this.selected;

    return Material(
      color: AppColors.bgCard,
      borderRadius: AppRadius.cardRadius,
      child: InkWell(
        borderRadius: AppRadius.cardRadius,
        onTap: () {
          HapticFeedback.selectionClick();
          ref
              .read(symbolSearchProvider.notifier)
              .loadPopular(exchange: normalizedExchange);
          showModalBottomSheet<void>(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (_) => _SymbolChooserSheet(
              exchange: normalizedExchange,
              selected: selected,
            ),
          );
        },
        child: Container(
          padding: AppSpacing.cardPadding,
          decoration: BoxDecoration(
            borderRadius: AppRadius.cardRadius,
            border: Border.all(color: AppColors.borderLight),
          ),
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: AppColors.accent.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.currency_bitcoin_rounded,
                  color: AppColors.accent,
                  size: 20,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: selected == null
                    ? _SymbolPrompt(exchange: normalizedExchange)
                    : _SelectedSymbol(symbol: selected),
              ),
              const SizedBox(width: AppSpacing.sm),
              const Icon(
                Icons.keyboard_arrow_right_rounded,
                size: 22,
                color: AppColors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SymbolChooserSheet extends ConsumerStatefulWidget {
  const _SymbolChooserSheet({
    required this.exchange,
    this.selected,
  });

  final String exchange;
  final TradingSymbol? selected;

  @override
  ConsumerState<_SymbolChooserSheet> createState() =>
      _SymbolChooserSheetState();
}

class _SymbolChooserSheetState extends ConsumerState<_SymbolChooserSheet> {
  final _ctrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref
          .read(symbolSearchProvider.notifier)
          .loadPopular(exchange: widget.exchange),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _select(TradingSymbol symbol) {
    if (symbol.lastPrice <= 0) {
      ref.read(symbolSearchProvider.notifier).search(
            symbol.baseAsset,
            exchange: widget.exchange,
          );
      return;
    }
    ref.read(tradeFormProvider.notifier).setSymbol(symbol);
    ref.read(symbolSearchProvider.notifier).remember(symbol);
    Navigator.pop(context);
  }

  void _search(String value) {
    setState(() {});
    ref.read(symbolSearchProvider.notifier).search(
          value,
          exchange: widget.exchange,
        );
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(symbolSearchProvider);
    final viewInsets = MediaQuery.viewInsetsOf(context);
    final searching = _ctrl.text.trim().isNotEmpty;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: AppSpacing.md,
          right: AppSpacing.md,
          bottom: viewInsets.bottom + AppSpacing.md,
        ),
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.sizeOf(context).height * 0.78,
          ),
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.md,
            AppSpacing.lg,
            AppSpacing.lg,
          ),
          decoration: const BoxDecoration(
            color: AppColors.bgPrimary,
            borderRadius: BorderRadius.all(Radius.circular(28)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Choose market',
                      style: AppTypography.h2.copyWith(letterSpacing: 0),
                    ),
                  ),
                  IconButton(
                    tooltip: 'Close',
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),
              TextField(
                controller: _ctrl,
                textCapitalization: TextCapitalization.characters,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp('[A-Za-z0-9]')),
                  TextInputFormatter.withFunction(
                    (oldValue, newValue) => newValue.copyWith(
                      text: newValue.text.toUpperCase(),
                      selection: newValue.selection,
                    ),
                  ),
                ],
                style: AppTypography.body,
                decoration: InputDecoration(
                  hintText: 'Search coin or pair',
                  hintStyle: AppTypography.body.copyWith(
                    color: AppColors.textDisabled,
                  ),
                  prefixIcon: const Icon(
                    Icons.search_rounded,
                    size: 18,
                    color: AppColors.textSecondary,
                  ),
                  suffixIcon: _ctrl.text.isEmpty
                      ? null
                      : IconButton(
                          tooltip: 'Clear search',
                          icon: const Icon(Icons.close_rounded, size: 18),
                          onPressed: () {
                            _ctrl.clear();
                            _search('');
                          },
                        ),
                  filled: true,
                  fillColor: AppColors.bgCard,
                  border: const OutlineInputBorder(
                    borderRadius: AppRadius.chipRadius,
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.xs,
                  ),
                ),
                onChanged: _search,
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                searching ? 'Best matches' : 'Recent & popular',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Flexible(
                child: searchState.when(
                  loading: () => const _SymbolLoadingList(),
                  error: (_, __) => _SymbolPanelMessage(
                    title: 'Failed to load markets',
                    actionLabel: 'Retry',
                    onAction: () => ref
                        .read(symbolSearchProvider.notifier)
                        .loadPopular(exchange: widget.exchange),
                  ),
                  data: (symbols) {
                    if (symbols.isEmpty) {
                      return const _SymbolPanelMessage(
                        title: 'No matching market found',
                      );
                    }
                    return ListView.separated(
                      shrinkWrap: true,
                      itemCount: symbols.length,
                      separatorBuilder: (_, __) => const Divider(
                        height: 1,
                        color: AppColors.borderLight,
                      ),
                      itemBuilder: (context, index) {
                        final symbol = symbols[index];
                        return _SymbolResultTile(
                          symbol: symbol,
                          selected: symbol.symbol == widget.selected?.symbol,
                          enabled: symbol.lastPrice > 0,
                          onTap: () => _select(symbol),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SymbolPrompt extends StatelessWidget {
  const _SymbolPrompt({required this.exchange});

  final String exchange;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Market', style: AppTypography.bodyMedium),
        const SizedBox(height: 2),
        Text(
          'Tap to pick BTC, ETH, SOL or a recent ${exchange.toUpperCase()} pair',
          style: AppTypography.caption.copyWith(
            color: AppColors.textSecondary,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

class _SelectedSymbol extends StatelessWidget {
  const _SelectedSymbol({required this.symbol});

  final TradingSymbol symbol;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Flexible(
              child: Text(
                symbol.symbol,
                style: AppTypography.h4,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            _ExchangePill(symbol.exchange),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          _symbolMeta(symbol),
          style: AppTypography.caption.copyWith(
            color: AppColors.textSecondary,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

class _SymbolResultTile extends StatelessWidget {
  const _SymbolResultTile({
    required this.symbol,
    required this.selected,
    required this.enabled,
    required this.onTap,
  });

  final TradingSymbol symbol;
  final bool selected;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final pct = symbol.priceChangePct;
    final hasPct = pct != 0;
    final pctColor = pct >= 0 ? AppColors.profitGreen : AppColors.lossRed;

    return Material(
      color: selected ? AppColors.accent.withValues(alpha: 0.08) : null,
      child: InkWell(
        onTap: enabled ? onTap : null,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.sm,
          ),
          child: Row(
            children: [
              Expanded(
                child: _SelectedSymbol(symbol: symbol),
              ),
              const SizedBox(width: AppSpacing.sm),
              if (!enabled)
                Text(
                  'Loading price',
                  style: AppTypography.caption.copyWith(
                    color: AppColors.textTertiary,
                  ),
                )
              else if (hasPct)
                Text(
                  '${pct >= 0 ? '+' : ''}${pct.toStringAsFixed(2)}%',
                  style: AppTypography.numericSm.copyWith(color: pctColor),
                )
              else
                Text(
                  'Popular',
                  style: AppTypography.caption.copyWith(
                    color: AppColors.textTertiary,
                  ),
                ),
              const SizedBox(width: AppSpacing.sm),
              Icon(
                selected
                    ? Icons.check_circle_rounded
                    : Icons.add_circle_outline_rounded,
                color: selected ? AppColors.accent : AppColors.textTertiary,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SymbolLoadingList extends StatelessWidget {
  const _SymbolLoadingList();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(AppSpacing.lg),
      child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
    );
  }
}

class _ExchangePill extends StatelessWidget {
  const _ExchangePill(this.exchange);

  final String exchange;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.profitGreen.withValues(alpha: 0.1),
        borderRadius: AppRadius.pillRadius,
      ),
      child: Text(
        exchange.toUpperCase(),
        style: AppTypography.caption.copyWith(color: AppColors.profitGreen),
      ),
    );
  }
}

class _SymbolPanelMessage extends StatelessWidget {
  const _SymbolPanelMessage({
    required this.title,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: AppTypography.body.copyWith(color: AppColors.textSecondary),
          ),
          if (actionLabel != null && onAction != null) ...[
            const SizedBox(height: AppSpacing.sm),
            TextButton(onPressed: onAction, child: Text(actionLabel!)),
          ],
        ],
      ),
    );
  }
}

String _normalizeExchange(String value) {
  final normalized = value.trim().toLowerCase();
  return normalized.isEmpty ? 'bybit' : normalized;
}

String _symbolMeta(TradingSymbol symbol) {
  final pair = '${symbol.baseAsset}/${symbol.quoteAsset}';
  if (symbol.lastPrice <= 0) return pair;
  return '$pair - \$${symbol.lastPrice.toStringAsFixed(_priceDecimals(symbol.lastPrice))}';
}

int _priceDecimals(double price) {
  if (price >= 100) return 2;
  if (price >= 1) return 4;
  return 6;
}
