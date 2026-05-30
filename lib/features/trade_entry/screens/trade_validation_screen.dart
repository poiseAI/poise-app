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

class TradeValidationScreen extends ConsumerStatefulWidget {
  const TradeValidationScreen({super.key});

  @override
  ConsumerState<TradeValidationScreen> createState() =>
      _TradeValidationScreenState();
}

class _TradeValidationScreenState extends ConsumerState<TradeValidationScreen> {
  bool _guardrailsAcknowledged = false;

  @override
  Widget build(BuildContext context) {
    final form = ref.watch(tradeFormProvider);
    final notifier = ref.read(tradeFormProvider.notifier);
    final validation = form.validation;

    if (validation == null) {
      return _ValidationMissingScreen(onBack: () => context.go(Routes.trade));
    }

    final exchangeRequired = validation.requiresExchangeConnection;
    final warningCount = _validationWarningCount(validation);
    final needsResolution = warningCount > 0;
    final canSubmit = !form.isSubmitting &&
        !validation.isBlocked &&
        (!needsResolution || _guardrailsAcknowledged);

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(
        backgroundColor: AppColors.bgPrimary,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        titleSpacing: 0,
        title: const Text('Trade validation', style: AppTypography.h2),
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                children: [
                  _ValidationSummaryGrid(validation: validation),
                  const SizedBox(height: AppSpacing.lg),
                  _GuardrailChecks(
                    validation: validation,
                    onAskAi: (item) => _openPoiseAiSheet(item, notifier),
                  ),
                  if (form.submitError != null) ...[
                    const SizedBox(height: AppSpacing.md),
                    _ErrorCard(form.submitError!),
                  ],
                ],
              ),
            ),
            _ValidationSubmitBar(
              validation: validation,
              loading: form.isSubmitting,
              canSubmit: canSubmit || exchangeRequired,
              onSubmit: () => _submitTrade(
                notifier: notifier,
                validation: validation,
                exchangeRequired: exchangeRequired,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openPoiseAiSheet(
    GuardrailResult item,
    TradeForm notifier,
  ) async {
    final action = await showModalBottomSheet<_GuardrailAiAction>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _ContextualPoiseSheet(item: item),
    );
    if (!mounted || action == null) return;

    switch (action) {
      case _GuardrailAiAction.lowerRiskSize:
        notifier.setMarginMode(MarginMode.fixed);
        notifier.setMarginValue(500);
        await notifier.validateTrade();
        if (!mounted) return;
        setState(() => _guardrailsAcknowledged = true);
      case _GuardrailAiAction.acknowledge:
        setState(() => _guardrailsAcknowledged = true);
    }
  }

  Future<void> _submitTrade({
    required TradeForm notifier,
    required TradeValidationResult validation,
    required bool exchangeRequired,
  }) async {
    if (exchangeRequired) {
      context.push(Routes.exchangeConnections);
      return;
    }

    final requiresFinalConfirmation =
        validation.dailyLimitAcknowledgementRequired ||
            validation.requiresExternalRiskReview;
    final confirmed = !requiresFinalConfirmation ||
        await _confirmTradeSubmit(context, validation);
    if (!confirmed) return;

    HapticFeedback.mediumImpact();
    await notifier.submit(bypassWarnings: _guardrailsAcknowledged);
    final latest = ref.read(tradeFormProvider);
    if (mounted && latest.lastOrder != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(
          builder: (_) => _TradeSubmittedSuccessScreen(
            symbol: latest.symbol?.symbol,
          ),
        ),
      );
    }
  }
}

class _ValidationMissingScreen extends StatelessWidget {
  const _ValidationMissingScreen({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(title: const Text('Trade validation')),
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.screenPadding,
          child: Column(
            children: [
              const Spacer(),
              const Text(
                'Trade validation is not ready',
                style: AppTypography.h3,
              ),
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

class _ValidationSummaryGrid extends StatelessWidget {
  const _ValidationSummaryGrid({required this.validation});

  final TradeValidationResult validation;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Summary', style: AppTypography.h2),
        const SizedBox(height: AppSpacing.sm),
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
                value: _money(validation.positionSize),
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
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 90),
      padding: AppSpacing.cardPadding,
      decoration: BoxDecoration(
        color: AppColors.bgPrimary,
        borderRadius: AppRadius.cardRadius,
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment:
            centered ? CrossAxisAlignment.center : CrossAxisAlignment.start,
        children: [
          Text(
            label,
            textAlign: centered ? TextAlign.center : TextAlign.start,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: centered ? Alignment.center : Alignment.centerLeft,
            child: Text(
              value,
              style: AppTypography.numericLg.copyWith(
                color: valueColor ?? AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GuardrailChecks extends StatelessWidget {
  const _GuardrailChecks({
    required this.validation,
    required this.onAskAi,
  });

  final TradeValidationResult validation;
  final ValueChanged<GuardrailResult> onAskAi;

  @override
  Widget build(BuildContext context) {
    final items = _guardrailItems(validation);
    final riskItems = items.where((item) => !_isBehavioralGuardrail(item));
    final behavioralItems = items.where(_isBehavioralGuardrail);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (items.isEmpty) ...[
          const Text('Risk guardrails check', style: AppTypography.h2),
          const SizedBox(height: AppSpacing.sm),
          const _CleanGuardrailCard(),
        ] else ...[
          if (riskItems.isNotEmpty) ...[
            const Text('Risk guardrails check', style: AppTypography.h2),
            const SizedBox(height: AppSpacing.sm),
            for (final item in riskItems) ...[
              _GuardrailCard(
                item: item,
                onAskAi: () => onAskAi(item),
              ),
              const SizedBox(height: AppSpacing.sm),
            ],
          ],
          if (behavioralItems.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            const Text('Behavioural Analysis', style: AppTypography.h2),
            const SizedBox(height: AppSpacing.sm),
            for (final item in behavioralItems) ...[
              _GuardrailCard(
                item: item,
                onAskAi: () => onAskAi(item),
              ),
              const SizedBox(height: AppSpacing.sm),
            ],
          ],
        ],
      ],
    );
  }
}

class _GuardrailCard extends StatelessWidget {
  const _GuardrailCard({
    required this.item,
    required this.onAskAi,
  });

  final GuardrailResult item;
  final VoidCallback onAskAi;

  @override
  Widget build(BuildContext context) {
    final color = _guardrailTone(item);
    return Container(
      width: double.infinity,
      padding: AppSpacing.cardPadding,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: AppRadius.cardRadius,
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: color,
                size: 24,
              ),
              const Spacer(),
              OutlinedButton(
                onPressed: onAskAi,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(color: AppColors.brand100),
                  shape: const StadiumBorder(),
                ),
                child: const Text('Ask Poise AI'),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(item.title, style: AppTypography.h3),
          const SizedBox(height: 2),
          Text(
            item.message,
            style: AppTypography.body.copyWith(
              color: AppColors.textSecondary,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}

class _CleanGuardrailCard extends StatelessWidget {
  const _CleanGuardrailCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: AppSpacing.cardPadding,
      decoration: BoxDecoration(
        color: AppColors.bgPrimary,
        borderRadius: AppRadius.cardRadius,
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.shield_outlined,
            color: AppColors.primary,
            size: 42,
          ),
          const SizedBox(height: AppSpacing.md),
          const Text('No guardrails triggered', style: AppTypography.h3),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'You\'re all set and ready to roll!',
            textAlign: TextAlign.center,
            style: AppTypography.body.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _ValidationSubmitBar extends StatelessWidget {
  const _ValidationSubmitBar({
    required this.validation,
    required this.loading,
    required this.canSubmit,
    required this.onSubmit,
  });

  final TradeValidationResult validation;
  final bool loading;
  final bool canSubmit;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final exchangeRequired = validation.requiresExchangeConnection;
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 16),
      decoration: const BoxDecoration(
        color: AppColors.bgPrimary,
        border: Border(top: BorderSide(color: AppColors.borderLight)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          PPrimaryButton(
            label: validation.isBlocked
                ? exchangeRequired
                    ? 'Connect exchange'
                    : 'Trade blocked'
                : loading
                    ? 'Submitting...'
                    : 'Submit trade',
            state: loading ? PButtonState.loading : PButtonState.idle,
            onPressed: canSubmit ? onSubmit : null,
          ),
        ],
      ),
    );
  }
}

enum _GuardrailAiAction { lowerRiskSize, acknowledge }

class _ContextualPoiseSheet extends StatelessWidget {
  const _ContextualPoiseSheet({required this.item});

  final GuardrailResult item;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.only(
          left: AppSpacing.md,
          right: AppSpacing.md,
          bottom: MediaQuery.viewInsetsOf(context).bottom + AppSpacing.md,
        ),
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.sizeOf(context).height * 0.82,
          ),
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
          decoration: const BoxDecoration(
            color: AppColors.bgPrimary,
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 34,
                  height: 3,
                  decoration: const BoxDecoration(
                    color: AppColors.borderLight,
                    borderRadius: AppRadius.pillRadius,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  const Expanded(
                      child: Text('Poise AI', style: AppTypography.h3)),
                  IconButton(
                    tooltip: 'Close',
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              _AiMessageBubble(
                text: _aiExplanation(item),
              ),
              const SizedBox(height: AppSpacing.sm),
              const _AiMessageBubble(
                text:
                    'Do you want to confirm this trade using the adjusted risk, or are you confident in your original setup?',
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Suggestions',
                style: AppTypography.caption.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Wrap(
                spacing: AppSpacing.xs,
                runSpacing: AppSpacing.xs,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.pop(
                      context,
                      _GuardrailAiAction.lowerRiskSize,
                    ),
                    child: const Text('Adjust to \$500 margin and proceed'),
                  ),
                  OutlinedButton(
                    onPressed: () => Navigator.pop(
                      context,
                      _GuardrailAiAction.acknowledge,
                    ),
                    child: const Text('I am confident in the risk'),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      minLines: 1,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: 'Type a message',
                        hintStyle: AppTypography.body.copyWith(
                          color: AppColors.textDisabled,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                          vertical: AppSpacing.sm,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: AppColors.primary,
                    child: IconButton(
                      tooltip: 'Send',
                      color: Colors.white,
                      icon: const Icon(Icons.arrow_forward_rounded, size: 18),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AiMessageBubble extends StatelessWidget {
  const _AiMessageBubble({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpacing.cardPadding,
      decoration: const BoxDecoration(
        color: Color(0xFFEFF6FF),
        borderRadius: AppRadius.cardRadius,
      ),
      child: Text(
        text,
        style: AppTypography.body.copyWith(
          color: AppColors.textSecondary,
          height: 1.45,
        ),
      ),
    );
  }
}

class _TradeSubmittedSuccessScreen extends ConsumerWidget {
  const _TradeSubmittedSuccessScreen({required this.symbol});

  final String? symbol;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.screenPadding,
          child: Column(
            children: [
              const Spacer(flex: 2),
              Image.asset(
                'assets/images/success_bag.png',
                width: 150,
                height: 150,
                fit: BoxFit.contain,
                filterQuality: FilterQuality.high,
              ),
              const SizedBox(height: AppSpacing.lg),
              const Text(
                'Trade Submitted Successfully',
                textAlign: TextAlign.center,
                style: AppTypography.h2,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Your ${symbol ?? 'trade'} order has been successfully submitted. Tap below to check the trade status.',
                textAlign: TextAlign.center,
                style: AppTypography.body.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.45,
                ),
              ),
              const Spacer(flex: 2),
              PPrimaryButton(
                label: 'View trade',
                onPressed: () => context.go(Routes.orders),
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
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

Future<bool> _confirmTradeSubmit(
  BuildContext context,
  TradeValidationResult validation,
) async {
  final dailyLimitPct = validation.dailyLossLimitUsd <= 0
      ? null
      : (validation.possibleLoss / validation.dailyLossLimitUsd * 100)
          .clamp(0, 999)
          .toDouble();
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Are you sure?'),
      content: Text(
        dailyLimitPct == null
            ? 'Submitting this trade will use part of your daily loss limit. Do you want to proceed?'
            : 'Submitting this trade will use ${_formatLimitPct(dailyLimitPct)} of your daily loss limit. Do you want to proceed?',
        style: AppTypography.body.copyWith(
          color: AppColors.textSecondary,
          height: 1.45,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Go back'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('Submit trade'),
        ),
      ],
    ),
  );
  return confirmed ?? false;
}

List<GuardrailResult> _guardrailItems(TradeValidationResult validation) {
  return [
    if (validation.dailyLimitAcknowledgementRequired)
      GuardrailResult(
        title: 'Daily risk budget',
        message:
            'Projected loss becomes ${_money(validation.projectedDailyLossUsd)} of ${_money(validation.dailyLossLimitUsd)}.',
        severity: 'warning',
      ),
    if (validation.requiresExternalRiskReview)
      GuardrailResult(
        title: 'External positions',
        message:
            '${validation.externalOpenPositions} open exchange position${validation.externalOpenPositions == 1 ? '' : 's'} need review.',
        severity: 'warning',
      ),
    ...validation.guardrailWarnings,
  ];
}

int _validationWarningCount(TradeValidationResult validation) {
  return _guardrailItems(validation).length;
}

String _aiExplanation(GuardrailResult item) {
  if (item.aiPrompt != null && item.aiPrompt!.trim().isNotEmpty) {
    return item.aiPrompt!;
  }
  return 'Based on your risk profile, ${item.message.toLowerCase()} Reducing your margin can bring this setup back within your configured guardrails.';
}

bool _isBehavioralGuardrail(GuardrailResult item) {
  final category = item.category?.toLowerCase();
  if (category != null &&
      (category.contains('behavior') || category.contains('behaviour'))) {
    return true;
  }
  final text =
      '${item.title} ${item.message} ${item.aiPrompt ?? ''}'.toLowerCase();
  return text.contains('behaviour') ||
      text.contains('behavior') ||
      text.contains('revenge') ||
      text.contains('emotional') ||
      text.contains('overtrade') ||
      text.contains('bypass') ||
      text.contains('cooldown') ||
      text.contains('session boundary') ||
      text.contains('trading session');
}

Color _guardrailTone(GuardrailResult item) {
  if (_isBehavioralGuardrail(item)) return AppColors.warningAmber;
  if (item.severity.toLowerCase() == 'warning') return AppColors.lossRed;
  return AppColors.lossRed;
}

String _formatLimitPct(double value) {
  if (value >= 10 || value % 1 == 0) return '${value.toStringAsFixed(0)}%';
  return '${value.toStringAsFixed(1)}%';
}

String _money(double value) => '\$${value.abs().toStringAsFixed(2)}';
