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
import '../data/trade_api.dart';
import '../providers/trade_form_provider.dart';

class TradeValidationScreen extends ConsumerWidget {
  const TradeValidationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = ref.watch(tradeFormProvider);
    final notifier = ref.read(tradeFormProvider.notifier);
    final validation = form.validation;

    if (validation == null) {
      return _ValidationMissingScreen(onBack: () => context.go(Routes.trade));
    }

    final needsAcknowledgement = validation.hasWarnings ||
        validation.dailyLimitAcknowledgementRequired ||
        validation.requiresExternalRiskReview;
    final exchangeRequired = validation.requiresExchangeConnection;

    return Scaffold(
      backgroundColor: AppColors.bgSecondary,
      appBar: AppBar(
        backgroundColor: AppColors.bgPrimary,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        titleSpacing: 0,
        title: const Text('Review & Execute'),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: AppSpacing.md),
            child: _GuardianChip(),
          ),
        ],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: AppColors.borderLight),
        ),
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
                children: [
                  _ReviewHero(
                    form: form,
                    notifier: notifier,
                    validation: validation,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _OutcomeReview(
                      form: form, notifier: notifier, validation: validation),
                  const SizedBox(height: AppSpacing.md),
                  _GuardrailReview(validation: validation),
                  if (form.submitError != null) ...[
                    const SizedBox(height: AppSpacing.md),
                    _ErrorCard(form.submitError!),
                  ],
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
              decoration: const BoxDecoration(
                color: AppColors.bgPrimary,
                border: Border(top: BorderSide(color: AppColors.borderLight)),
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 56,
                    height: 52,
                    child: Tooltip(
                      message: 'Edit setup',
                      child: OutlinedButton(
                        onPressed:
                            form.isSubmitting ? null : () => context.pop(),
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.zero,
                        ),
                        child: const Icon(Icons.arrow_back_rounded, size: 20),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: PPrimaryButton(
                      label: validation.isBlocked
                          ? exchangeRequired
                              ? 'Connect exchange'
                              : 'Trade Blocked'
                          : form.isSubmitting
                              ? 'Submitting...'
                              : 'Execute Trade',
                      state: form.isSubmitting
                          ? PButtonState.loading
                          : PButtonState.idle,
                      onPressed: form.isSubmitting ||
                              (validation.isBlocked && !exchangeRequired)
                          ? null
                          : () async {
                              if (exchangeRequired) {
                                context.push(Routes.exchangeConnections);
                                return;
                              }
                              final bypassWarnings = needsAcknowledgement &&
                                  await _confirmGuardrailOverride(
                                    context,
                                    validation,
                                  );
                              if (needsAcknowledgement && !bypassWarnings) {
                                return;
                              }
                              HapticFeedback.mediumImpact();
                              await notifier.submit(
                                bypassWarnings: bypassWarnings,
                              );
                              final latest = ref.read(tradeFormProvider);
                              if (context.mounted && latest.lastOrder != null) {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute<void>(
                                    builder: (_) => _TradeOrderSuccessScreen(
                                      symbol: latest.symbol?.symbol,
                                      side: latest.side,
                                    ),
                                  ),
                                );
                              }
                            },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<bool> _confirmGuardrailOverride(
  BuildContext context,
  TradeValidationResult validation,
) async {
  final items = _guardrailAcknowledgementItems(validation);
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Continue anyway?'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'This violates your guardrails. Continuing will cost discipline score points.',
              style: AppTypography.body.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            if (items.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.md),
              for (final item in items) ...[
                Text(item.title, style: AppTypography.bodyMedium),
                const SizedBox(height: 2),
                Text(
                  item.message,
                  style: AppTypography.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
              ],
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Go back'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('Continue anyway'),
        ),
      ],
    ),
  );
  return confirmed ?? false;
}

List<({String title, String message})> _guardrailAcknowledgementItems(
  TradeValidationResult validation,
) {
  return [
    if (validation.dailyLimitAcknowledgementRequired)
      (
        title: 'Daily risk budget',
        message:
            'Projected loss becomes ${_money(validation.projectedDailyLossUsd)} of ${_money(validation.dailyLossLimitUsd)}.',
      ),
    if (validation.requiresExternalRiskReview)
      (
        title: 'External positions',
        message:
            '${validation.externalOpenPositions} open exchange position${validation.externalOpenPositions == 1 ? '' : 's'} need review.',
      ),
    for (final item in validation.guardrailWarnings)
      (title: item.title, message: item.message),
  ];
}

class _ValidationMissingScreen extends StatelessWidget {
  const _ValidationMissingScreen({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(title: const Text('Trade Validation')),
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.screenPadding,
          child: Column(
            children: [
              const Spacer(),
              const Text('Trade validation is not ready',
                  style: AppTypography.h3),
              const SizedBox(height: AppSpacing.md),
              PPrimaryButton(label: 'Back to trade', onPressed: onBack),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReviewHero extends StatelessWidget {
  const _ReviewHero({
    required this.form,
    required this.notifier,
    required this.validation,
  });

  final TradeFormState form;
  final TradeForm notifier;
  final TradeValidationResult validation;

  @override
  Widget build(BuildContext context) {
    final sideColor =
        form.side == OrderSide.long ? AppColors.profitGreen : AppColors.lossRed;
    final sideLabel = form.side == OrderSide.long ? 'LONG' : 'SHORT';
    final symbol = form.symbol?.symbol ?? 'Trade';
    final notional = notifier.quantity * notifier.entryPrice;

    return Container(
      padding: AppSpacing.cardPadding,
      decoration: BoxDecoration(
        color: AppColors.bgPrimary,
        borderRadius: AppRadius.cardRadius,
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: sideColor.withValues(alpha: 0.1),
                  borderRadius: AppRadius.pillRadius,
                ),
                child: Text(
                  sideLabel,
                  style: AppTypography.label.copyWith(color: sideColor),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(child: Text(symbol, style: AppTypography.h2)),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            '${form.leverage.toStringAsFixed(0)}x · ${_label(form.collateralMode.name)} · ${_label(form.orderType.name)}',
            style: AppTypography.body.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: _HeroMetric(
                  label: 'Your margin',
                  value: _money(notifier.marginAmount),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _HeroMetric(
                  label: 'Notional',
                  value:
                      _money(notional > 0 ? notional : validation.positionSize),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          _RiskRewardBar(validation: validation),
        ],
      ),
    );
  }
}

class _RiskRewardBar extends StatelessWidget {
  const _RiskRewardBar({required this.validation});

  final TradeValidationResult validation;

  @override
  Widget build(BuildContext context) {
    final ok = _rrValue(validation.riskRewardRatio) >= 1.5;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: (ok ? AppColors.profitGreen : AppColors.warningAmber)
            .withValues(alpha: 0.08),
        borderRadius: AppRadius.cardRadius,
        border: Border.all(
          color: (ok ? AppColors.profitGreen : AppColors.warningAmber)
              .withValues(alpha: 0.25),
        ),
      ),
      child: Row(
        children: [
          const Text('Risk : Reward', style: AppTypography.label),
          const Spacer(),
          Text(
            validation.riskRewardRatio,
            style: AppTypography.numericSm.copyWith(
              color: ok ? AppColors.profitGreen : AppColors.warningAmber,
            ),
          ),
        ],
      ),
    );
  }
}

class _OutcomeReview extends StatelessWidget {
  const _OutcomeReview({
    required this.form,
    required this.notifier,
    required this.validation,
  });

  final TradeFormState form;
  final TradeForm notifier;
  final TradeValidationResult validation;

  @override
  Widget build(BuildContext context) {
    final entry = notifier.entryPrice;
    final sl = form.slPrice;
    final tp = form.takeProfit1;
    final stopCaption = sl == null
        ? 'Stop loss missing'
        : 'Stop at ${_money(sl)} · ${_roiLabel(form, entry, sl)} ROI · ${_moveLabel(form, entry, sl)} move';
    final tpCaption = tp == null
        ? 'Take profit missing'
        : 'Target ${_money(tp)} · ${_roiLabel(form, entry, tp)} ROI · ${_moveLabel(form, entry, tp)} move';

    return Column(
      children: [
        _OutcomeCard(
          title: 'If Stop Loss Hits',
          status: 'LOSS',
          value: '-${_money(validation.possibleLoss)}',
          caption: stopCaption,
          color: AppColors.lossRed,
        ),
        const SizedBox(height: AppSpacing.sm),
        _OutcomeCard(
          title: 'If TP1 Hits',
          status: 'PROFIT',
          value: '+${_money(validation.possibleProfit)}',
          caption: tpCaption,
          color: AppColors.profitGreen,
        ),
      ],
    );
  }
}

class _GuardrailReview extends StatelessWidget {
  const _GuardrailReview({required this.validation});

  final TradeValidationResult validation;

  @override
  Widget build(BuildContext context) {
    final exchangeRequired = validation.requiresExchangeConnection;
    final warnings = validation.guardrailWarnings;
    final warningCount = warnings.length +
        (validation.dailyLimitAcknowledgementRequired ? 1 : 0) +
        (validation.requiresExternalRiskReview ? 1 : 0);
    final color = exchangeRequired
        ? AppColors.warningAmber
        : warningCount > 0
            ? AppColors.warningAmber
            : AppColors.profitGreen;
    final title = exchangeRequired
        ? 'Connect exchange'
        : warningCount > 0
            ? '$warningCount guardrail warning${warningCount == 1 ? '' : 's'}'
            : 'Guardrails OK';

    return Container(
      padding: AppSpacing.cardPadding,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: AppRadius.cardRadius,
        border: Border.all(color: color.withValues(alpha: 0.28)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _StatusBubble(
                icon: exchangeRequired
                    ? Icons.link_rounded
                    : warningCount > 0
                        ? Icons.warning_amber_rounded
                        : Icons.check_rounded,
                color: color,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(child: Text(title, style: AppTypography.h4)),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            exchangeRequired
                ? 'Connect an exchange before execution.'
                : warningCount > 0
                    ? 'You can continue after confirming.'
                    : 'This setup is inside your rules.',
            style: AppTypography.bodySm.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          if (validation.dailyLimitAcknowledgementRequired)
            _GuardrailLine(
              title: 'Daily risk budget',
              message:
                  'After trade ${_money(validation.projectedDailyLossUsd)} of ${_money(validation.dailyLossLimitUsd)}',
              color: AppColors.warningAmber,
              warning: true,
            ),
          if (validation.requiresExternalRiskReview)
            _GuardrailLine(
              title: 'External positions',
              message:
                  '${validation.externalOpenPositions} open exchange position${validation.externalOpenPositions == 1 ? '' : 's'} need review',
              color: AppColors.warningAmber,
              warning: true,
            ),
          for (final item in warnings)
            _GuardrailLine(
              title: item.title,
              message: item.message,
              color: AppColors.warningAmber,
              warning: true,
            ),
          if (!exchangeRequired && warningCount == 0) ...[
            _GuardrailLine(
              title: 'Risk per trade',
              message: '${validation.riskPct.toStringAsFixed(2)}% at risk',
              color: AppColors.profitGreen,
            ),
            const _GuardrailLine(
              title: 'Daily trade limit',
              message: 'Within your current daily rule',
              color: AppColors.profitGreen,
            ),
            const _GuardrailLine(
              title: 'Stop loss distance',
              message: 'Stop loss is present before execution',
              color: AppColors.profitGreen,
            ),
          ],
        ],
      ),
    );
  }
}

class _TradeOrderSuccessScreen extends ConsumerWidget {
  const _TradeOrderSuccessScreen({
    required this.symbol,
    required this.side,
  });

  final String? symbol;
  final OrderSide side;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sideLabel = side == OrderSide.long ? 'LONG' : 'SHORT';
    final sideColor =
        side == OrderSide.long ? AppColors.profitGreen : AppColors.lossRed;

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Trade Executed'),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: AppSpacing.md),
            child: _GuardianChip(),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.screenPadding,
          child: Column(
            children: [
              const Spacer(),
              Container(
                width: 86,
                height: 86,
                decoration: BoxDecoration(
                  color: AppColors.accent.withValues(alpha: 0.09),
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.brand50),
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: AppColors.accent,
                  size: 38,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              const Text(
                'Trade Executed',
                textAlign: TextAlign.center,
                style: AppTypography.h1,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text.rich(
                TextSpan(
                  text: 'Your ${symbol ?? 'trade'} ',
                  children: [
                    TextSpan(
                      text: sideLabel,
                      style: TextStyle(
                        color: sideColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const TextSpan(
                      text: ' position is live. Guardian Mode is watching.',
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
                style: AppTypography.bodyLg.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              PPrimaryButton(
                label: 'View in Orders',
                onPressed: () => context.go(Routes.orders),
              ),
              const SizedBox(height: AppSpacing.sm),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton.icon(
                  onPressed: () {
                    ref.read(tradeFormProvider.notifier).resetDraft();
                    context.go(Routes.trade);
                  },
                  icon: const Icon(Icons.add_rounded),
                  label: const Text('New Trade'),
                ),
              ),
              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeroMetric extends StatelessWidget {
  const _HeroMetric({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        borderRadius: AppRadius.cardRadius,
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTypography.caption),
          const SizedBox(height: AppSpacing.xs),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(value, style: AppTypography.numericMd),
          ),
        ],
      ),
    );
  }
}

class _OutcomeCard extends StatelessWidget {
  const _OutcomeCard({
    required this.title,
    required this.status,
    required this.value,
    required this.caption,
    required this.color,
  });

  final String title;
  final String status;
  final String value;
  final String caption;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: AppSpacing.cardPadding,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.07),
        borderRadius: AppRadius.cardRadius,
        border: Border.all(color: color.withValues(alpha: 0.28)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(title, style: AppTypography.label)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: AppRadius.chipRadius,
                ),
                child: Text(
                  status,
                  style: AppTypography.label.copyWith(color: color),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(value, style: AppTypography.numericLg.copyWith(color: color)),
          const SizedBox(height: AppSpacing.xs),
          Text(
            caption,
            style: AppTypography.caption.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _GuardrailLine extends StatelessWidget {
  const _GuardrailLine({
    required this.title,
    required this.message,
    required this.color,
    this.warning = false,
  });

  final String title;
  final String message;
  final Color color;
  final bool warning;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _StatusBubble(
            icon: warning ? Icons.priority_high_rounded : Icons.check_rounded,
            color: color,
            small: true,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.bodyMedium),
                const SizedBox(height: 2),
                Text(
                  message,
                  style: AppTypography.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusBubble extends StatelessWidget {
  const _StatusBubble({
    required this.icon,
    required this.color,
    this.small = false,
  });

  final IconData icon;
  final Color color;
  final bool small;

  @override
  Widget build(BuildContext context) {
    final size = small ? 24.0 : 40.0;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: color, size: small ? 14 : 20),
    );
  }
}

class _GuardianChip extends StatelessWidget {
  const _GuardianChip();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.accent.withValues(alpha: 0.08),
        borderRadius: AppRadius.pillRadius,
        border: Border.all(color: AppColors.brand50),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: const BoxDecoration(
              color: AppColors.profitGreen,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            'Guardian',
            style: AppTypography.label.copyWith(color: AppColors.accent),
          ),
        ],
      ),
    );
  }
}

class _ErrorCard extends StatelessWidget {
  const _ErrorCard(this.message);

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpacing.cardPadding,
      decoration: BoxDecoration(
        color: AppColors.lossRed.withValues(alpha: 0.08),
        borderRadius: AppRadius.cardRadius,
        border: Border.all(color: AppColors.lossRed.withValues(alpha: 0.35)),
      ),
      child: Text(
        message,
        style: AppTypography.body.copyWith(color: AppColors.lossRed),
      ),
    );
  }
}

String _label(String value) {
  if (value.isEmpty) return value;
  return '${value[0].toUpperCase()}${value.substring(1)}';
}

String _money(double value) => '\$${value.abs().toStringAsFixed(2)}';

String _roiLabel(TradeFormState form, double entry, double price) {
  if (entry <= 0) return '0.00%';
  final move = form.side == OrderSide.long
      ? (price - entry) / entry
      : (entry - price) / entry;
  return '${(move * form.leverage * 100).toStringAsFixed(2)}%';
}

String _moveLabel(TradeFormState form, double entry, double price) {
  if (entry <= 0) return '0.00%';
  final move = form.side == OrderSide.long
      ? (price - entry) / entry
      : (entry - price) / entry;
  return '${(move * 100).toStringAsFixed(2)}%';
}

double _rrValue(String raw) {
  final matches = RegExp(r'([0-9]+(?:\.[0-9]+)?)').allMatches(raw).toList();
  if (matches.isEmpty) return 0;
  return double.tryParse(matches.last.group(1) ?? '') ?? 0;
}
