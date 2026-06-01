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
      color: AppColors.bgPrimary,
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
          height: 56,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: AppRadius.cardRadius,
            border: Border.all(color: AppColors.borderLight),
          ),
          child: Row(
            children: [
              Expanded(
                child: selected == null
                    ? const Text(
                        'Select trading pair',
                        style: TextStyle(
                          color: AppColors.textDisabled,
                          fontSize: 14,
                          fontFamily: 'Inter',
                        ),
                      )
                    : Text(
                        _displayPair(selected),
                        style: AppTypography.bodyLg,
                        overflow: TextOverflow.ellipsis,
                      ),
              ),
              if (selected != null) ...[
                const SizedBox(width: AppSpacing.sm),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '\$${_formatPrice(selected.lastPrice)}',
                      style: AppTypography.bodySm.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Text(
                      _formatPct(selected.priceChangePct),
                      style: AppTypography.bodySm.copyWith(
                        color: AppColors.pnlColor(selected.priceChangePct),
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(width: AppSpacing.sm),
              const Icon(
                Icons.keyboard_arrow_down_rounded,
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
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref
          .read(symbolSearchProvider.notifier)
          .loadPopular(exchange: widget.exchange),
    );
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

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(symbolSearchProvider);
    final viewInsets = MediaQuery.viewInsetsOf(context);

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
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
          decoration: const BoxDecoration(
            color: AppColors.bgPrimary,
            borderRadius: AppRadius.cardRadiusLg,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Trading pair',
                      style: AppTypography.h4.copyWith(letterSpacing: 0),
                    ),
                  ),
                  IconButton(
                    tooltip: 'Close',
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              TextField(
                decoration: const InputDecoration(
                  hintText: 'Search pairs...',
                  prefixIcon: Icon(Icons.search_rounded),
                  filled: true,
                  fillColor: AppColors.bgCard,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: AppRadius.cardRadius,
                    borderSide: BorderSide(color: AppColors.borderLight),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: AppRadius.cardRadius,
                    borderSide:
                        BorderSide(color: AppColors.primary, width: 1.4),
                  ),
                ),
                onChanged: (value) => ref
                    .read(symbolSearchProvider.notifier)
                    .search(value, exchange: widget.exchange),
              ),
              const SizedBox(height: AppSpacing.md),
              Flexible(
                child: searchState.when(
                  loading: () => const _SymbolLoadingList(),
                  error: (_, __) => _SymbolPanelMessage(
                    title: 'Failed to load trading pairs',
                    actionLabel: 'Retry',
                    onAction: () => ref
                        .read(symbolSearchProvider.notifier)
                        .loadPopular(exchange: widget.exchange),
                  ),
                  data: (symbols) {
                    if (symbols.isEmpty) {
                      return const _SymbolPanelMessage(
                        title: 'No matching trading pair found',
                      );
                    }
                    return ListView.separated(
                      shrinkWrap: true,
                      itemCount: symbols.length,
                      separatorBuilder: (_, __) => const SizedBox.shrink(),
                      itemBuilder: (context, index) {
                        final symbol = symbols[index];
                        return Padding(
                          padding: EdgeInsets.only(
                            bottom:
                                index == symbols.length - 1 ? 0 : AppSpacing.sm,
                          ),
                          child: _SymbolResultTile(
                            symbol: symbol,
                            selected: symbol.symbol == widget.selected?.symbol,
                            enabled: symbol.lastPrice > 0,
                            onTap: () => _select(symbol),
                          ),
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
    return Material(
      color: AppColors.bgCard,
      borderRadius: AppRadius.cardRadius,
      child: InkWell(
        borderRadius: AppRadius.cardRadius,
        onTap: enabled ? onTap : null,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
          decoration: BoxDecoration(
            borderRadius: AppRadius.cardRadius,
            border: Border.all(color: AppColors.borderLight),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  _displayPair(symbol),
                  style: AppTypography.bodyLg.copyWith(
                    color: enabled
                        ? AppColors.textPrimary
                        : AppColors.textSecondary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '\$${_formatPrice(symbol.lastPrice)}',
                    style: AppTypography.bodySm.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    _formatPct(symbol.priceChangePct),
                    style: AppTypography.bodySm.copyWith(
                      color: AppColors.pnlColor(symbol.priceChangePct),
                    ),
                  ),
                ],
              ),
              if (selected) ...[
                const SizedBox(width: AppSpacing.sm),
                const Icon(
                  Icons.check_rounded,
                  color: AppColors.primary,
                  size: 18,
                ),
              ],
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

String _displayPair(TradingSymbol symbol) {
  if (symbol.baseAsset.isNotEmpty && symbol.quoteAsset.isNotEmpty) {
    return '${symbol.baseAsset}/${symbol.quoteAsset}';
  }
  return symbol.symbol;
}

String _formatPrice(double value) {
  if (value >= 100) return value.toStringAsFixed(2);
  if (value >= 1) return value.toStringAsFixed(4);
  return value.toStringAsFixed(6);
}

String _formatPct(double value) {
  final sign = value >= 0 ? '+' : '';
  return '$sign${value.toStringAsFixed(2)}%';
}
