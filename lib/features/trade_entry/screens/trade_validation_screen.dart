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
      return Scaffold(
        backgroundColor: AppColors.bgPrimary,
        body: SafeArea(
          child: Padding(
            padding: AppSpacing.screenPadding,
            child: Column(
              children: [
                const Spacer(),
                const Text('Trade validation is not ready',
                    style: AppTypography.h3),
                const SizedBox(height: AppSpacing.md),
                PPrimaryButton(
                  label: 'Back to trade',
                  onPressed: () => context.go(Routes.trade),
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: AppSpacing.screenPadding,
                children: [
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => context.pop(),
                        icon: const Icon(Icons.arrow_back_rounded),
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      const Expanded(
                        child:
                            Text('Trade validation', style: AppTypography.h1),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  const Text('Summary', style: AppTypography.h3),
                  const SizedBox(height: AppSpacing.sm),
                  _SummaryGrid(validation: validation),
                  const SizedBox(height: AppSpacing.xl),
                  _GuardrailPanel(validation: validation),
                  if (form.submitError != null) ...[
                    const SizedBox(height: AppSpacing.md),
                    _ErrorCard(form.submitError!),
                  ],
                ],
              ),
            ),
            Container(
              padding: AppSpacing.screenPadding,
              decoration: const BoxDecoration(
                color: AppColors.bgPrimary,
                border: Border(top: BorderSide(color: AppColors.borderLight)),
              ),
              child: PPrimaryButton(
                label: validation.isBlocked
                    ? 'Trade blocked'
                    : form.isSubmitting
                        ? 'Submitting...'
                        : 'Submit trade',
                state: form.isSubmitting
                    ? PButtonState.loading
                    : PButtonState.idle,
                onPressed: validation.isBlocked || form.isSubmitting
                    ? null
                    : () async {
                        HapticFeedback.mediumImpact();
                        if (validation.hasWarnings) {
                          final confirmed = await _confirmWarning(context);
                          if (confirmed != true) return;
                        }
                        await notifier.submit(bypassWarnings: true);
                        final latest = ref.read(tradeFormProvider);
                        if (context.mounted && latest.lastOrder != null) {
                          _showSuccess(context);
                        }
                      },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool?> _confirmWarning(BuildContext context) {
    return showModalBottomSheet<bool>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        padding: AppSpacing.screenPadding,
        decoration: const BoxDecoration(
          color: AppColors.bgCard,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppSpacing.md),
              const Text('Are you sure?', style: AppTypography.h2),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Submitting this trade will continue after one or more guardrail warnings. Do you want to proceed?',
                style: AppTypography.bodyLg
                    .copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: AppSpacing.xl),
              OutlinedButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Go back'),
              ),
              const SizedBox(height: AppSpacing.sm),
              FilledButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Submit trade'),
              ),
              const SizedBox(height: AppSpacing.md),
            ],
          ),
        ),
      ),
    );
  }

  void _showSuccess(BuildContext context) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text('Order placed'),
        content: const Text('Your Poise trade has been submitted.'),
        actions: [
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              context.go(Routes.orders);
            },
            child: const Text('View trades'),
          ),
        ],
      ),
    );
  }
}

class _SummaryGrid extends StatelessWidget {
  const _SummaryGrid({required this.validation});
  final TradeValidationResult validation;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _SummaryTile(
                label: 'Risk',
                value: '${validation.riskPct.toStringAsFixed(2)}%',
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _SummaryTile(
                label: 'Position Size',
                value: _money(validation.margin),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Expanded(
              child: _SummaryTile(
                label: 'Risk-to-Reward Ratio',
                value: validation.riskRewardRatio,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _SummaryTile(
                label: 'Possible Loss',
                value: '-${_money(validation.possibleLoss)}',
                valueColor: AppColors.lossRed,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        _SummaryTile(
          label: 'Possible Profit',
          value: '+${_money(validation.possibleProfit)}',
          valueColor: AppColors.profitGreen,
          centered: true,
        ),
      ],
    );
  }
}

class _SummaryTile extends StatelessWidget {
  const _SummaryTile({
    required this.label,
    required this.value,
    this.valueColor,
    this.centered = false,
  });

  final String label;
  final String value;
  final Color? valueColor;
  final bool centered;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 86,
      width: double.infinity,
      padding: AppSpacing.cardPadding,
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: AppRadius.cardRadius,
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment:
            centered ? CrossAxisAlignment.center : CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: AppTypography.body.copyWith(color: AppColors.textSecondary),
            textAlign: centered ? TextAlign.center : TextAlign.left,
          ),
          const SizedBox(height: AppSpacing.xs),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: AppTypography.numericMd
                  .copyWith(color: valueColor ?? AppColors.textPrimary),
            ),
          ),
        ],
      ),
    );
  }
}

class _GuardrailPanel extends StatelessWidget {
  const _GuardrailPanel({required this.validation});
  final TradeValidationResult validation;

  @override
  Widget build(BuildContext context) {
    if (!validation.isBlocked && !validation.hasWarnings) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Risk guardrails check', style: AppTypography.h3),
          const SizedBox(height: AppSpacing.sm),
          Container(
            height: 280,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.bgCard,
              borderRadius: AppRadius.cardRadius,
              border: Border.all(color: AppColors.borderLight),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.check_circle_outline_rounded,
                    size: 76, color: AppColors.accent),
                const SizedBox(height: AppSpacing.md),
                const Text('No guardrails triggered', style: AppTypography.h3),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'You’re all set and ready to roll!',
                  style: AppTypography.body
                      .copyWith(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
        ],
      );
    }

    final items = validation.isBlocked
        ? validation.blockingGuardrails
        : validation.warningGuardrails;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          validation.isBlocked
              ? 'Risk guardrails check'
              : 'Behavioural Analysis',
          style: AppTypography.h3,
        ),
        const SizedBox(height: AppSpacing.sm),
        for (final item in items) ...[
          _GuardrailTile(item: item),
          const SizedBox(height: AppSpacing.sm),
        ],
      ],
    );
  }
}

class _GuardrailTile extends StatelessWidget {
  const _GuardrailTile({required this.item});
  final GuardrailResult item;

  @override
  Widget build(BuildContext context) {
    final blocked = item.severity == 'block' || item.severity == 'blocked';
    final color = blocked ? AppColors.lossRed : AppColors.warningAmber;
    return Container(
      padding: AppSpacing.cardPadding,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: AppRadius.cardRadius,
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(blocked ? Icons.block_rounded : Icons.warning_amber_rounded,
                  color: color),
              const SizedBox(width: AppSpacing.sm),
              Expanded(child: Text(item.title, style: AppTypography.h4)),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(item.message,
              style:
                  AppTypography.body.copyWith(color: AppColors.textSecondary)),
          if (!blocked) ...[
            const SizedBox(height: AppSpacing.md),
            OutlinedButton(
              onPressed: () => context.go(
                Routes.ai,
                extra: item.aiPrompt ?? item.message,
              ),
              child: const Text('Ask Poise AI'),
            ),
          ],
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
      child: Text(message,
          style: AppTypography.body.copyWith(color: AppColors.lossRed)),
    );
  }
}

String _money(double value) => '\$${value.abs().toStringAsFixed(2)}';
