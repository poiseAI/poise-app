import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../data/models/symbol.dart';
import '../../providers/symbol_search_provider.dart';
import '../../providers/trade_form_provider.dart';

class SymbolPicker extends ConsumerStatefulWidget {
  const SymbolPicker({
    super.key,
    required this.selected,
    this.exchange = 'bybit',
  });

  final TradingSymbol? selected;
  final String exchange;

  @override
  ConsumerState<SymbolPicker> createState() => _SymbolPickerState();
}

class _SymbolPickerState extends ConsumerState<SymbolPicker> {
  bool _expanded = false;
  final _ctrl = TextEditingController();

  String get _exchange => _normalizeExchange(widget.exchange);

  @override
  void didUpdateWidget(covariant SymbolPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_expanded) return;
    if (_normalizeExchange(oldWidget.exchange) != _exchange) {
      _ctrl.clear();
      ref.read(symbolSearchProvider.notifier).loadPopular(exchange: _exchange);
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _open() {
    setState(() => _expanded = true);
    ref.read(symbolSearchProvider.notifier).loadPopular(exchange: _exchange);
  }

  void _close() {
    FocusScope.of(context).unfocus();
    setState(() => _expanded = false);
  }

  void _select(TradingSymbol sym) {
    ref.read(tradeFormProvider.notifier).setSymbol(sym);
    ref.read(symbolSearchProvider.notifier).remember(sym);
    _ctrl.clear();
    _close();
  }

  @override
  Widget build(BuildContext context) {
    final sym = widget.selected;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: _expanded ? _close : _open,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: AppColors.bgCard,
              borderRadius: AppRadius.chipRadius,
              border: Border.all(
                color: _expanded ? AppColors.accent : AppColors.borderLight,
                width: _expanded ? 1.5 : 1,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: sym == null
                      ? _SymbolPlaceholder(exchange: _exchange)
                      : _SelectedSymbol(symbol: sym),
                ),
                const SizedBox(width: AppSpacing.sm),
                AnimatedRotation(
                  turns: _expanded ? 0.5 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 20,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          alignment: Alignment.topCenter,
          child: _expanded
              ? _SearchPanel(
                  onSelect: _select,
                  ctrl: _ctrl,
                  exchange: _exchange,
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}

class _SymbolPlaceholder extends StatelessWidget {
  const _SymbolPlaceholder({required this.exchange});

  final String exchange;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.search_rounded,
          size: 18,
          color: AppColors.textSecondary,
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            'Search ${exchange.toUpperCase()} symbol',
            style: AppTypography.body.copyWith(
              color: AppColors.textDisabled,
            ),
            overflow: TextOverflow.ellipsis,
          ),
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
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: 2,
          ),
          decoration: BoxDecoration(
            color: AppColors.accent.withValues(alpha: 0.12),
            borderRadius: AppRadius.chipRadius,
          ),
          child: Text(
            symbol.symbol,
            style: AppTypography.label.copyWith(color: AppColors.accent),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Flexible(
          child: Text(
            _symbolMeta(symbol),
            style: AppTypography.numericSm.copyWith(
              color: AppColors.textSecondary,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _SearchPanel extends ConsumerWidget {
  const _SearchPanel({
    required this.onSelect,
    required this.ctrl,
    required this.exchange,
  });

  final ValueChanged<TradingSymbol> onSelect;
  final TextEditingController ctrl;
  final String exchange;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchState = ref.watch(symbolSearchProvider);

    return Container(
      margin: const EdgeInsets.only(top: AppSpacing.xs),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: AppRadius.cardRadius,
        border: Border.all(color: AppColors.borderLight),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.sm),
            child: TextField(
              controller: ctrl,
              autofocus: true,
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
                hintText: 'Search ${exchange.toUpperCase()} symbols',
                hintStyle: AppTypography.body.copyWith(
                  color: AppColors.textDisabled,
                ),
                prefixIcon: const Icon(
                  Icons.search_rounded,
                  size: 18,
                  color: AppColors.textSecondary,
                ),
                suffixIcon: ctrl.text.isEmpty
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.close_rounded, size: 18),
                        onPressed: () {
                          ctrl.clear();
                          ref
                              .read(symbolSearchProvider.notifier)
                              .loadPopular(exchange: exchange);
                        },
                      ),
                filled: true,
                fillColor: AppColors.bgPrimary,
                border: const OutlineInputBorder(
                  borderRadius: AppRadius.chipRadius,
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
              ),
              onChanged: (value) => ref
                  .read(symbolSearchProvider.notifier)
                  .search(value, exchange: exchange),
            ),
          ),
          searchState.when(
            loading: () => const Padding(
              padding: EdgeInsets.all(AppSpacing.md),
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            error: (_, __) => _SymbolPanelMessage(
              title: 'Failed to load symbols',
              actionLabel: 'Retry',
              onAction: () => ref
                  .read(symbolSearchProvider.notifier)
                  .loadPopular(exchange: exchange),
            ),
            data: (symbols) {
              if (symbols.isEmpty) {
                return const _SymbolPanelMessage(title: 'No symbols found');
              }
              return ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 320),
                child: Scrollbar(
                  child: ListView.separated(
                    shrinkWrap: true,
                    padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                    itemCount: symbols.length,
                    separatorBuilder: (_, __) => const Divider(
                      height: 1,
                      color: AppColors.borderLight,
                    ),
                    itemBuilder: (ctx, i) {
                      return _SymbolResultTile(
                        symbol: symbols[i],
                        onTap: () => onSelect(symbols[i]),
                      )
                          .animate(delay: (i * 25).ms)
                          .fadeIn(duration: 150.ms)
                          .slideY(
                            begin: 0.1,
                            end: 0,
                            curve: Curves.easeOut,
                          );
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _SymbolResultTile extends StatelessWidget {
  const _SymbolResultTile({required this.symbol, required this.onTap});

  final TradingSymbol symbol;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final pct = symbol.priceChangePct;
    final hasPct = pct != 0;
    final pctColor = pct >= 0 ? AppColors.profitGreen : AppColors.lossRed;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          symbol.symbol,
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.textPrimary,
                          ),
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
              ),
            ),
            if (hasPct) ...[
              const SizedBox(width: AppSpacing.sm),
              Text(
                '${pct >= 0 ? '+' : ''}${pct.toStringAsFixed(2)}%',
                style: AppTypography.numericSm.copyWith(color: pctColor),
              ),
            ],
          ],
        ),
      ),
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
      padding: const EdgeInsets.all(AppSpacing.md),
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
