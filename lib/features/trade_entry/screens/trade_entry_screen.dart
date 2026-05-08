import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/buttons/p_primary_button.dart';
import '../providers/trade_form_provider.dart';
import '../providers/symbol_search_provider.dart';
import 'widgets/leverage_slider.dart';
import 'widgets/order_type_toggle.dart';
import 'widgets/symbol_picker.dart';
import 'widgets/tp_sl_section.dart';

class TradeEntryScreen extends ConsumerStatefulWidget {
  const TradeEntryScreen({super.key});

  @override
  ConsumerState<TradeEntryScreen> createState() => _TradeEntryScreenState();
}

class _TradeEntryScreenState extends ConsumerState<TradeEntryScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(symbolSearchProvider.notifier).loadPopular();
    });
  }

  @override
  Widget build(BuildContext context) {
    final form = ref.watch(tradeFormProvider);
    final notifier = ref.read(tradeFormProvider.notifier);
    final preflight = form.preflight;
    final blocked = preflight != null && !preflight.allowed;
    final formError = form.validationError ?? notifier.localValidationError;

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: notifier.loadPreflight,
          color: AppColors.accent,
          child: ListView(
            padding: AppSpacing.screenPadding,
            children: [
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  IconButton(
                    onPressed: () => context.go(Routes.home),
                    icon: const Icon(Icons.arrow_back_rounded),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  const Expanded(
                    child: Text('Open a new trade', style: AppTypography.h1),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              _BalanceRow(form: form),
              const SizedBox(height: AppSpacing.md),
              SymbolPicker(
                selected: form.symbol,
                exchange: form.preflight?.exchange ??
                    form.symbol?.exchange ??
                    'bybit',
              ),
              const SizedBox(height: AppSpacing.md),
              _RiskStatusCard(form: form),
              if (form.isLoadingPreflight) ...[
                const SizedBox(height: AppSpacing.md),
                const _InfoCard(
                    message:
                        'Checking exchange connection and live guardrails...'),
              ],
              if (form.preflightError != null) ...[
                const SizedBox(height: AppSpacing.md),
                _BlockingCard(message: form.preflightError),
              ],
              if (blocked) ...[
                const SizedBox(height: AppSpacing.md),
                _BlockingCard(message: preflight.blockingReason),
              ],
              const SizedBox(height: AppSpacing.xl),
              const Text('Execution mode', style: AppTypography.h3),
              const SizedBox(height: AppSpacing.sm),
              OrderTypeToggle(
                selected: form.orderType,
                onChanged: notifier.setOrderType,
              ),
              if (form.orderType == OrderType.limit) ...[
                const SizedBox(height: AppSpacing.md),
                _NumberField(
                  label: 'Limit price',
                  prefix: '\$',
                  onChanged: (v) => notifier.setLimitPrice(double.tryParse(v)),
                ),
              ],
              const SizedBox(height: AppSpacing.xl),
              const Text('Margin', style: AppTypography.h3),
              const SizedBox(height: AppSpacing.sm),
              _MarginControl(form: form, notifier: notifier),
              const SizedBox(height: AppSpacing.xl),
              const Text('Leverage', style: AppTypography.h3),
              const SizedBox(height: AppSpacing.sm),
              LeverageSlider(
                value: form.leverage,
                max: _maxLeverage(form).round(),
                onChanged: notifier.setLeverage,
              ),
              const SizedBox(height: AppSpacing.xl),
              TpSlSection(
                stopLoss: form.slPrice,
                takeProfit1: form.takeProfit1,
                takeProfit2: form.takeProfit2,
                autoProgression: form.autoStopLossProgression,
                onStopLossChanged: notifier.setSlPrice,
                onTakeProfit1Changed: notifier.setTakeProfit1,
                onTakeProfit2Changed: notifier.setTakeProfit2,
                onAutoProgressionChanged: notifier.setAutoStopLossProgression,
              ),
              const SizedBox(height: AppSpacing.xl),
              Row(
                children: [
                  Expanded(
                    child: _SideButton(
                      label: 'Buy/Long',
                      active: form.side == OrderSide.long,
                      color: AppColors.profitGreen,
                      onTap: () => notifier.setSide(OrderSide.long),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: _SideButton(
                      label: 'Sell/Short',
                      active: form.side == OrderSide.short,
                      color: AppColors.lossRed,
                      onTap: () => notifier.setSide(OrderSide.short),
                    ),
                  ),
                ],
              ),
              if (formError != null) ...[
                const SizedBox(height: AppSpacing.md),
                _BlockingCard(message: formError),
              ],
              const SizedBox(height: AppSpacing.xl),
              PPrimaryButton(
                label: form.isValidating ? 'Reviewing...' : 'Review trade',
                state: form.isValidating
                    ? PButtonState.loading
                    : PButtonState.idle,
                onPressed: notifier.isValid && !form.isValidating
                    ? () async {
                        HapticFeedback.mediumImpact();
                        final ok = await notifier.validateTrade();
                        if (ok && context.mounted) {
                          context.push(Routes.tradeValidation);
                        }
                      }
                    : null,
              ),
              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        ),
      ),
    );
  }

  double _maxLeverage(TradeFormState form) {
    final fromRule = form.preflight?.maxLeverage ?? 10;
    final fromSymbol = (form.symbol?.maxLeverage ?? fromRule).toDouble();
    return fromRule < fromSymbol ? fromRule : fromSymbol;
  }
}

class _BalanceRow extends StatelessWidget {
  const _BalanceRow({required this.form});
  final TradeFormState form;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text('Available balance:',
            style: AppTypography.body.copyWith(color: AppColors.textSecondary)),
        const Spacer(),
        Text(
          '${form.availableBalance.toStringAsFixed(0)} ${form.balanceCurrency}',
          style: AppTypography.numericMd.copyWith(color: AppColors.textPrimary),
        ),
      ],
    );
  }
}

class _RiskStatusCard extends StatelessWidget {
  const _RiskStatusCard({required this.form});
  final TradeFormState form;

  @override
  Widget build(BuildContext context) {
    final pf = form.preflight;
    return Container(
      padding: AppSpacing.cardPadding,
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: AppRadius.cardRadius,
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Risk status', style: AppTypography.h3),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: [
              _Chip('Exchange: ${(pf?.exchange ?? 'bybit').toUpperCase()}'),
              _Chip(
                  'Risk per trade: ${(pf?.riskPerTradePct ?? 2).toStringAsFixed(0)}%'),
              _Chip(
                  'Max leverage: ${(pf?.maxLeverage ?? 10).toStringAsFixed(0)}x'),
              _Chip(
                  'Trades today: ${pf?.tradesToday ?? 0} / ${pf?.maxTradesPerDay ?? 5}'),
            ],
          ),
        ],
      ),
    );
  }
}

class _MarginControl extends StatelessWidget {
  const _MarginControl({required this.form, required this.notifier});
  final TradeFormState form;
  final TradeForm notifier;

  @override
  Widget build(BuildContext context) {
    final isPct = form.marginMode == MarginMode.percentage;
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _Segment(
                label: 'Percentage',
                active: isPct,
                onTap: () => notifier.setMarginMode(MarginMode.percentage),
              ),
            ),
            Expanded(
              child: _Segment(
                label: 'Fixed amount',
                active: !isPct,
                onTap: () => notifier.setMarginMode(MarginMode.fixed),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        if (isPct) ...[
          Slider(
            value: form.marginValue.clamp(1, 100),
            min: 1,
            max: 100,
            divisions: 99,
            onChanged: notifier.setMarginValue,
          ),
          Row(
            children: [
              Text(
                  '${notifier.marginAmount.toStringAsFixed(0)} ${form.balanceCurrency}',
                  style: AppTypography.numericSm),
              const Spacer(),
              Text('${form.marginValue.toStringAsFixed(0)}%',
                  style: AppTypography.numericSm),
            ],
          ),
        ] else
          _NumberField(
            label: 'Margin amount',
            prefix: '\$',
            onChanged: (v) => notifier.setMarginValue(double.tryParse(v) ?? 0),
          ),
      ],
    );
  }
}

class _Segment extends StatelessWidget {
  const _Segment(
      {required this.label, required this.active, required this.onTap});
  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        height: 46,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active ? AppColors.bgCard : AppColors.bgSecondary,
          borderRadius: AppRadius.chipRadius,
          border: Border.all(
              color: active ? AppColors.accent : AppColors.borderLight),
        ),
        child: Text(label,
            style: AppTypography.label.copyWith(
              color: active ? AppColors.accent : AppColors.textSecondary,
            )),
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
    return FilledButton.icon(
      onPressed: onTap,
      icon: Icon(active
          ? Icons.check_box_rounded
          : Icons.check_box_outline_blank_rounded),
      label: FittedBox(child: Text(label)),
      style: FilledButton.styleFrom(
        backgroundColor: active ? color : color.withValues(alpha: 0.12),
        foregroundColor: active ? Colors.white : color,
        minimumSize: const Size.fromHeight(58),
        shape: const StadiumBorder(),
      ),
    );
  }
}

class _NumberField extends StatelessWidget {
  const _NumberField(
      {required this.label, required this.onChanged, this.prefix});
  final String label;
  final String? prefix;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      style: AppTypography.numericSm,
      decoration: InputDecoration(
        labelText: label,
        prefixText: prefix,
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
      ),
      onChanged: onChanged,
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip(this.label);
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: AppRadius.pillRadius,
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Text(label, style: AppTypography.bodyMedium),
    );
  }
}

class _BlockingCard extends StatelessWidget {
  const _BlockingCard({this.message});
  final String? message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpacing.cardPadding,
      decoration: BoxDecoration(
        color: AppColors.lossRed.withValues(alpha: 0.08),
        borderRadius: AppRadius.cardRadius,
        border: Border.all(color: AppColors.lossRed.withValues(alpha: 0.3)),
      ),
      child: Text(
        message ?? 'Trading is temporarily unavailable.',
        style: AppTypography.body.copyWith(color: AppColors.lossRed),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpacing.cardPadding,
      decoration: BoxDecoration(
        color: AppColors.accent.withValues(alpha: 0.08),
        borderRadius: AppRadius.cardRadius,
        border: Border.all(color: AppColors.accent.withValues(alpha: 0.25)),
      ),
      child: Text(
        message,
        style: AppTypography.body.copyWith(color: AppColors.accent),
      ),
    );
  }
}
