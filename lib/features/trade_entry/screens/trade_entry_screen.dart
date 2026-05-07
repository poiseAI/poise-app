import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/buttons/p_primary_button.dart';
import '../providers/trade_form_provider.dart';
import 'widgets/leverage_slider.dart';
import 'widgets/order_preview_sheet.dart';
import 'widgets/order_type_toggle.dart';
import 'widgets/risk_score_badge.dart';
import 'widgets/symbol_picker.dart';
import 'widgets/tp_sl_section.dart';

class TradeEntryScreen extends ConsumerStatefulWidget {
  const TradeEntryScreen({super.key});

  @override
  ConsumerState<TradeEntryScreen> createState() => _TradeEntryScreenState();
}

class _TradeEntryScreenState extends ConsumerState<TradeEntryScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseCtrl;
  bool _wasValid = false;
  final _qtyCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    _qtyCtrl.dispose();
    _priceCtrl.dispose();
    super.dispose();
  }

  void _onFormChanged(TradeFormState? prev, TradeFormState next) {
    final isValid = ref.read(tradeFormProvider.notifier).isValid;
    if (isValid && !_wasValid) {
      _pulseCtrl.forward().then((_) => _pulseCtrl.reverse());
    }
    _wasValid = isValid;
  }

  void _showPreview() {
    HapticFeedback.mediumImpact();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const OrderPreviewSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final form = ref.watch(tradeFormProvider);
    final notifier = ref.read(tradeFormProvider.notifier);

    ref.listen(tradeFormProvider, _onFormChanged);

    final isValid = notifier.isValid;
    final isBuy = form.side == OrderSide.buy;

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: AppSpacing.screenPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: AppSpacing.lg),
                    const Text('Trade', style: AppTypography.h1),
                    const SizedBox(height: AppSpacing.xl),

                    // ── Symbol picker ──────────────────────────────────────
                    SymbolPicker(selected: form.symbol),
                    const SizedBox(height: AppSpacing.md),

                    // ── Risk score (only when symbol selected) ─────────────
                    if (form.symbol != null) ...[
                      RiskScoreBadge(score: form.riskScore)
                          .animate(key: ValueKey(form.symbol?.symbol))
                          .fadeIn(duration: 300.ms)
                          .slideX(begin: 0.1, end: 0),
                      const SizedBox(height: AppSpacing.md),
                    ],

                    // ── Buy / Sell toggle ──────────────────────────────────
                    Row(
                      children: [
                        _SideButton(
                          label: 'Buy',
                          active: isBuy,
                          color: AppColors.profitGreen,
                          onTap: () => notifier.setSide(OrderSide.buy),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        _SideButton(
                          label: 'Sell',
                          active: !isBuy,
                          color: AppColors.lossRed,
                          onTap: () => notifier.setSide(OrderSide.sell),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),

                    // ── Order type toggle (#38) ────────────────────────────
                    OrderTypeToggle(
                      selected: form.orderType,
                      onChanged: notifier.setOrderType,
                    ),
                    const SizedBox(height: AppSpacing.md),

                    // ── Quantity ───────────────────────────────────────────
                    _NumberField(
                      label: 'Quantity',
                      controller: _qtyCtrl,
                      hint: form.symbol?.minQty.toStringAsFixed(4) ?? '0.001',
                      suffix: form.symbol?.baseAsset ?? '',
                      onChanged: (v) {
                        final val = double.tryParse(v);
                        if (val != null) notifier.setQuantity(val);
                      },
                    ),
                    const SizedBox(height: AppSpacing.md),

                    // ── Limit price (only for limit/stop) ─────────────────
                    if (form.orderType != OrderType.market) ...[
                      _NumberField(
                        label: form.orderType == OrderType.limit
                            ? 'Limit price'
                            : 'Stop price',
                        controller: _priceCtrl,
                        hint: '0.00',
                        suffix: 'USDT',
                        onChanged: (v) {
                          notifier.setLimitPrice(double.tryParse(v));
                        },
                      ),
                      const SizedBox(height: AppSpacing.md),
                    ],

                    // ── Leverage slider (#36) ──────────────────────────────
                    LeverageSlider(
                      value: form.leverage,
                      max: form.symbol?.maxLeverage ?? 100,
                      onChanged: notifier.setLeverage,
                    ),
                    const SizedBox(height: AppSpacing.md),

                    // ── TP / SL section (#39-40) ───────────────────────────
                    TpSlSection(
                      tpLevels: form.tpLevels,
                      slPrice: form.slPrice,
                      onAddTp: notifier.addTpLevel,
                      onRemoveTp: notifier.removeTpLevel,
                      onSlChanged: notifier.setSlPrice,
                    ),
                    const SizedBox(height: AppSpacing.xl),

                    // ── Submit button (#41 pulse on valid) ─────────────────
                    AnimatedBuilder(
                      animation: _pulseCtrl,
                      builder: (_, child) => Transform.scale(
                        scale: 1.0 + (_pulseCtrl.value * 0.03),
                        child: child,
                      ),
                      child: PPrimaryButton(
                        label: 'Preview order',
                        onPressed: isValid ? _showPreview : null,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxl),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SideButton extends StatelessWidget {
  const _SideButton({
    required this.label,
    required this.active,
    required this.color,
    required this.onTap,
  });

  final String label;
  final bool active;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          HapticFeedback.selectionClick();
          onTap();
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 44,
          decoration: BoxDecoration(
            color: active ? color : AppColors.bgCard,
            borderRadius: AppRadius.chipRadius,
            border: Border.all(
              color: active ? color : AppColors.borderLight,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: AppTypography.label.copyWith(
              color: active ? Colors.white : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}

class _NumberField extends StatelessWidget {
  const _NumberField({
    required this.label,
    required this.controller,
    required this.hint,
    required this.suffix,
    required this.onChanged,
  });

  final String label;
  final TextEditingController controller;
  final String hint;
  final String suffix;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style:
                AppTypography.caption.copyWith(color: AppColors.textSecondary)),
        const SizedBox(height: AppSpacing.xs),
        TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          style: AppTypography.numericSm,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle:
                AppTypography.numericSm.copyWith(color: AppColors.textDisabled),
            suffixText: suffix,
            suffixStyle: AppTypography.caption
                .copyWith(color: AppColors.textSecondary),
            filled: true,
            fillColor: AppColors.bgCard,
            enabledBorder: const OutlineInputBorder(
              borderRadius: AppRadius.chipRadius,
              borderSide: BorderSide(color: AppColors.borderLight),
            ),
            focusedBorder: const OutlineInputBorder(
              borderRadius: AppRadius.chipRadius,
              borderSide: BorderSide(color: AppColors.accent, width: 1.5),
            ),
            contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md, vertical: AppSpacing.sm),
          ),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
