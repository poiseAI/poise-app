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
    final canSubmit = !form.isSubmitting && !validation.isBlocked;

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(
        backgroundColor: AppColors.bgPrimary,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        titleSpacing: 0,
        title: const Text('Trade review', style: AppTypography.h2),
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(24, 18, 24, 24),
                children: [
                  _ValidationSummaryGrid(form: form, validation: validation),
                  const SizedBox(height: 28),
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

    HapticFeedback.mediumImpact();
    final bypassWarnings = _guardrailsAcknowledged ||
        validation.hasWarnings ||
        validation.dailyLimitAcknowledgementRequired ||
        validation.requiresExternalRiskReview;
    await notifier.submit(bypassWarnings: bypassWarnings);
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
  const _ValidationSummaryGrid({
    required this.form,
    required this.validation,
  });

  final TradeFormState form;
  final TradeValidationResult validation;

  @override
  Widget build(BuildContext context) {
    final symbol = form.symbol;
    final side = form.side == OrderSide.long ? 'Long' : 'Short';
    final sideColor =
        form.side == OrderSide.long ? AppColors.profitGreen : AppColors.lossRed;
    final qty = form.amountInputMode == AmountInputMode.quantity
        ? form.quantity
        : form.marginValue > 0 && form.leverage > 0 && form.symbol != null
            ? validation.positionSize / form.symbol!.lastPrice
            : 0.0;
    final notional = validation.positionSize;
    final tpProfits = _tpProfitRows(form, validation);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ReviewPill(label: side, color: sideColor),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    _displayPair(symbol),
                    style: AppTypography.h2.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Margin',
                  style: AppTypography.bodySm.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  _money(validation.margin),
                  style: AppTypography.h1.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${_formatQty(qty)} ${symbol?.baseAsset ?? ''}',
                  style: AppTypography.bodySm.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${_money(notional)} Notional',
                  style: AppTypography.bodySm.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 28),
        Row(
          children: [
            Expanded(
              child: _InfoTile(
                label: 'Margin type',
                value: form.collateralMode == CollateralMode.cross
                    ? 'Cross'
                    : 'Isolated',
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            Expanded(
              child: _InfoTile(
                label: 'Leverage',
                value: '${form.leverage.toStringAsFixed(0)}x',
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            Expanded(
              child: _InfoTile(
                label: 'Entry type',
                value: form.orderType == OrderType.limit ? 'Limit' : 'Market',
              ),
            ),
          ],
        ),
        const SizedBox(height: 26),
        _OutcomeCard(
          title: 'Possible Loss',
          value: '-${_money(validation.possibleLoss)}',
          caption:
              'If loss stops at ${_money(form.slPrice ?? 0)} or ${symbol?.baseAsset ?? 'price'} moves ${_lossMove(form)}',
          color: AppColors.lossRed,
        ),
        for (final row in tpProfits) ...[
          const SizedBox(height: AppSpacing.sm),
          _OutcomeCard(
            title: row.label,
            value: '+${_money(row.profit)}',
            caption:
                'If target hits ${_money(row.price)} or moves ${_formatSignedPct(row.movePct)}',
            color: AppColors.profitGreen,
          ),
        ],
      ],
    );
  }
}

class _ReviewPill extends StatelessWidget {
  const _ReviewPill({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: AppRadius.pillRadius,
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Text(
        label,
        style: AppTypography.bodySm.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      decoration: BoxDecoration(
        borderRadius: AppRadius.cardRadius,
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTypography.bodySm.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: AppTypography.body.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _OutcomeCard extends StatelessWidget {
  const _OutcomeCard({
    required this.title,
    required this.value,
    required this.caption,
    required this.color,
  });

  final String title;
  final String value;
  final String caption;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: AppRadius.cardRadius,
        border: Border.all(color: color.withValues(alpha: 0.16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTypography.body),
          const SizedBox(height: AppSpacing.xs),
          Text(
            value,
            style: AppTypography.h3.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            caption,
            style: AppTypography.bodySm.copyWith(
              color: AppColors.textSecondary,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Review guardrails', style: AppTypography.bodyMedium),
        const SizedBox(height: AppSpacing.md),
        if (items.isEmpty)
          const _GuardrailCard.clean(
            title: 'Leverage limit',
            message: 'This trade is within your configured leverage limit',
          )
        else
          for (final item in items) ...[
            _GuardrailCard(item: item, onAskAi: () => onAskAi(item)),
            const SizedBox(height: AppSpacing.sm),
          ],
      ],
    );
  }
}

class _GuardrailCard extends StatelessWidget {
  const _GuardrailCard({
    required this.item,
    required this.onAskAi,
  })  : cleanTitle = null,
        cleanMessage = null;

  const _GuardrailCard.clean({
    required String title,
    required String message,
  })  : item = null,
        onAskAi = null,
        cleanTitle = title,
        cleanMessage = message;

  final GuardrailResult? item;
  final VoidCallback? onAskAi;
  final String? cleanTitle;
  final String? cleanMessage;

  @override
  Widget build(BuildContext context) {
    final isClean = item == null;
    final color = isClean ? AppColors.profitGreen : AppColors.warningAmber;
    final title = item?.title ?? cleanTitle ?? 'Guardrail';
    final message = item?.message ?? cleanMessage ?? '';
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: AppRadius.cardRadius,
        border: Border.all(color: color.withValues(alpha: 0.45)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            isClean
                ? Icons.check_circle_outline_rounded
                : Icons.warning_amber_rounded,
            color: color,
            size: 20,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.bodyMedium.copyWith(
                    color: isClean
                        ? const Color(0xFF027A48)
                        : const Color(0xFFB54708),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  message,
                  style: AppTypography.bodySm.copyWith(
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
    final hasWarnings = validation.hasWarnings ||
        validation.dailyLimitAcknowledgementRequired ||
        validation.requiresExternalRiskReview;
    final label = validation.isBlocked
        ? exchangeRequired
            ? 'Connect exchange'
            : 'Trade blocked'
        : loading
            ? 'Submitting...'
            : hasWarnings
                ? 'Submit trade anyway'
                : 'Submit trade';
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 26),
      decoration: const BoxDecoration(
        color: AppColors.bgPrimary,
        border: Border(top: BorderSide(color: AppColors.borderLight)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.infinity,
            height: 44,
            child: FilledButton(
              onPressed: canSubmit ? onSubmit : null,
              style: FilledButton.styleFrom(
                backgroundColor:
                    hasWarnings ? AppColors.warningAmber : AppColors.primary,
                disabledBackgroundColor: AppColors.bgCardElevated,
                foregroundColor: Colors.white,
                disabledForegroundColor: AppColors.textDisabled,
                shape: const StadiumBorder(),
                textStyle: AppTypography.button,
              ),
              child: loading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(label),
            ),
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
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
          child: Column(
            children: [
              const Spacer(),
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
                'Your trade order has been successfully submitted. Tap below to view the trade status.',
                textAlign: TextAlign.center,
                style: AppTypography.body.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.45,
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 44,
                child: FilledButton(
                  onPressed: () => context.go(Routes.orders),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: const StadiumBorder(),
                    textStyle: AppTypography.button,
                  ),
                  child: const Text('View trade'),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              SizedBox(
                width: double.infinity,
                height: 44,
                child: OutlinedButton(
                  onPressed: () => context.go(Routes.home),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.borderLight),
                    shape: const StadiumBorder(),
                    textStyle: AppTypography.button,
                  ),
                  child: const Text('Go to home'),
                ),
              ),
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

String _aiExplanation(GuardrailResult item) {
  if (item.aiPrompt != null && item.aiPrompt!.trim().isNotEmpty) {
    return item.aiPrompt!;
  }
  return 'Based on your risk profile, ${item.message.toLowerCase()} Reducing your margin can bring this setup back within your configured guardrails.';
}

String _money(double value) => '\$${value.abs().toStringAsFixed(2)}';

String _displayPair(dynamic symbol) {
  if (symbol == null) return 'BTC/USDT';
  final base = symbol.baseAsset as String? ?? '';
  final quote = symbol.quoteAsset as String? ?? '';
  if (base.isNotEmpty && quote.isNotEmpty) return '$base/$quote';
  return symbol.symbol as String? ?? 'BTC/USDT';
}

String _formatQty(double value) {
  if (value <= 0) return '0.0000';
  if (value >= 1) return value.toStringAsFixed(4);
  return value.toStringAsFixed(6);
}

String _formatSignedPct(double value) {
  final sign = value >= 0 ? '+' : '-';
  return '$sign${value.abs().toStringAsFixed(2)}%';
}

String _lossMove(TradeFormState form) {
  final entry = form.orderType == OrderType.limit
      ? form.limitPrice
      : form.symbol?.lastPrice;
  final sl = form.slPrice;
  if (entry == null || entry <= 0 || sl == null || sl <= 0) return '-';
  final pct = (sl - entry) / entry * 100;
  return _formatSignedPct(pct);
}

List<({String label, double price, double profit, double movePct})>
    _tpProfitRows(
  TradeFormState form,
  TradeValidationResult validation,
) {
  final entry = form.orderType == OrderType.limit
      ? form.limitPrice
      : form.symbol?.lastPrice;
  final tps = [
    form.takeProfit1,
    form.takeProfit2,
    form.takeProfit3,
  ].whereType<double>().toList();
  if (entry == null || entry <= 0 || tps.isEmpty) {
    return [
      (
        label: 'Possible Profit',
        price: 0,
        profit: validation.possibleProfit,
        movePct: 0,
      ),
    ];
  }
  return [
    for (var i = 0; i < tps.length; i++)
      (
        label:
            tps.length == 1 ? 'Possible Profit' : 'TP${i + 1} Possible Profit',
        price: tps[i],
        profit: _tpProfit(form, entry, tps[i]),
        movePct: ((tps[i] - entry).abs() / entry) * 100,
      ),
  ];
}

double _tpProfit(TradeFormState form, double entry, double price) {
  final margin = form.marginMode == MarginMode.fixed
      ? form.marginValue
      : form.availableBalance * (form.marginValue / 100);
  if (entry <= 0 || margin <= 0) return 0;
  final move = form.side == OrderSide.long
      ? (price - entry) / entry
      : (entry - price) / entry;
  return (margin * form.leverage * move).abs();
}
