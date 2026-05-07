import 'package:flutter/material.dart';
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
  const SymbolPicker({super.key, required this.selected});
  final TradingSymbol? selected;

  @override
  ConsumerState<SymbolPicker> createState() => _SymbolPickerState();
}

class _SymbolPickerState extends ConsumerState<SymbolPicker> {
  bool _expanded = false;
  final _ctrl = TextEditingController();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _open() {
    setState(() => _expanded = true);
    ref.read(symbolSearchProvider.notifier).loadPopular();
  }

  void _close() => setState(() => _expanded = false);

  void _select(TradingSymbol sym) {
    ref.read(tradeFormProvider.notifier).setSymbol(sym);
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
                horizontal: AppSpacing.md, vertical: AppSpacing.sm),
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
                if (sym != null) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.accent.withValues(alpha: 0.12),
                      borderRadius: AppRadius.chipRadius,
                    ),
                    child: Text(sym.symbol,
                        style: AppTypography.label
                            .copyWith(color: AppColors.accent)),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    sym.lastPrice > 0
                        ? '\$${sym.lastPrice.toStringAsFixed(2)}'
                        : '—',
                    style: AppTypography.numericSm
                        .copyWith(color: AppColors.textSecondary),
                  ),
                ] else
                  Text('Select symbol',
                      style: AppTypography.body
                          .copyWith(color: AppColors.textDisabled)),
                const Spacer(),
                AnimatedRotation(
                  turns: _expanded ? 0.5 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: const Icon(Icons.keyboard_arrow_down_rounded,
                      size: 20, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
        ),
        if (_expanded) _SearchPanel(onSelect: _select, ctrl: _ctrl),
      ],
    );
  }
}

class _SearchPanel extends ConsumerWidget {
  const _SearchPanel({required this.onSelect, required this.ctrl});
  final ValueChanged<TradingSymbol> onSelect;
  final TextEditingController ctrl;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchState = ref.watch(symbolSearchProvider);

    return Container(
      margin: const EdgeInsets.only(top: 4),
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
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.sm),
            child: TextField(
              controller: ctrl,
              autofocus: true,
              style: AppTypography.body,
              decoration: InputDecoration(
                hintText: 'Search symbol...',
                hintStyle:
                    AppTypography.body.copyWith(color: AppColors.textDisabled),
                prefixIcon: const Icon(Icons.search_rounded,
                    size: 18, color: AppColors.textSecondary),
                filled: true,
                fillColor: AppColors.bgPrimary,
                border: const OutlineInputBorder(
                  borderRadius: AppRadius.chipRadius,
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
              ),
              onChanged: ref.read(symbolSearchProvider.notifier).search,
            ),
          ),
          searchState.when(
            loading: () => const Padding(
              padding: EdgeInsets.all(AppSpacing.md),
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            error: (_, __) => const Padding(
              padding: EdgeInsets.all(AppSpacing.md),
              child: Text('Failed to load symbols'),
            ),
            data: (symbols) => ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: symbols.length,
              itemBuilder: (ctx, i) {
                final sym = symbols[i];
                final pct = sym.priceChangePct;
                final pctColor = pct >= 0 ? AppColors.profitGreen : AppColors.lossRed;
                return ListTile(
                  dense: true,
                  title: Text(sym.symbol, style: AppTypography.label),
                  subtitle: Text(
                    sym.lastPrice > 0
                        ? '\$${sym.lastPrice.toStringAsFixed(2)}'
                        : sym.baseAsset,
                    style: AppTypography.caption
                        .copyWith(color: AppColors.textSecondary),
                  ),
                  trailing: pct != 0
                      ? Text(
                          '${pct >= 0 ? '+' : ''}${pct.toStringAsFixed(2)}%',
                          style: AppTypography.numericSm.copyWith(color: pctColor),
                        )
                      : null,
                  onTap: () => onSelect(sym),
                )
                    .animate(delay: (i * 25).ms)
                    .fadeIn(duration: 150.ms)
                    .slideY(begin: 0.1, end: 0, curve: Curves.easeOut);
              },
            ),
          ),
        ],
      ),
    );
  }
}
