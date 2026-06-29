import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../data/signal_parser.dart';
import '../providers/symbol_search_provider.dart';
import '../providers/trade_form_provider.dart';
import 'widgets/symbol_picker.dart';

class TradeEntryScreen extends ConsumerStatefulWidget {
  const TradeEntryScreen({super.key, this.initialExchange});

  final String? initialExchange;

  @override
  ConsumerState<TradeEntryScreen> createState() => _TradeEntryScreenState();
}

class _TradeEntryScreenState extends ConsumerState<TradeEntryScreen> {
  Timer? _priceRefreshTimer;

  @override
  void initState() {
    super.initState();
    final initialExchange = _normalizeExchange(widget.initialExchange);
    ref.read(selectedTradeExchangeProvider.notifier).state = initialExchange;
    Future.microtask(() {
      ref
          .read(symbolSearchProvider.notifier)
          .loadPopular(exchange: initialExchange);
    });
    _priceRefreshTimer = Timer.periodic(const Duration(seconds: 8), (_) {
      final form = ref.read(tradeFormProvider);
      if (form.symbol == null) return;
      unawaited(ref.read(tradeFormProvider.notifier).refreshSelectedPrice());
    });
  }

  @override
  void dispose() {
    _priceRefreshTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final form = ref.watch(tradeFormProvider);
    final notifier = ref.read(tradeFormProvider.notifier);
    final formError = form.validationError ?? notifier.localValidationError;
    final canReview = notifier.isValid && !form.isValidating;
    final setupOnly = notifier.requiresExchangeForExecution;
    final hasStarted = form.symbolTouched ||
        form.orderTypeTouched ||
        form.amountTouched ||
        form.collateralModeTouched ||
        form.leverageTouched ||
        form.directionTouched ||
        form.exitPlanTouched;

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(
        backgroundColor: AppColors.bgPrimary,
        centerTitle: false,
        leading: IconButton(
          onPressed: () => context.go(Routes.home),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        titleSpacing: 0,
        title: const Text('New Trade', style: AppTypography.h2),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.sm),
            child: IconButton(
              tooltip: 'Paste signal',
              onPressed: () => _openSignalImporter(context),
              icon: const Icon(Icons.content_paste_rounded, size: 20),
            ),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => notifier.loadPreflight(),
                color: AppColors.accent,
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(24, 14, 24, 24),
                  children: [
                    if (form.isLoadingPreflight)
                      const _InfoCard(
                        message:
                            'Checking exchange connection and live prices.',
                      ),
                    if (form.preflightError != null) ...[
                      _BlockingCard(message: form.preflightError),
                      const SizedBox(height: AppSpacing.md),
                    ],
                    if (_preflightNotice(form) != null) ...[
                      _TradeAlertBanner(message: _preflightNotice(form)!),
                      const SizedBox(height: AppSpacing.md),
                    ],
                    _TradingPairHeader(form: form),
                    const SizedBox(height: 20),
                    _MarginTypePanel(form: form, notifier: notifier),
                    const SizedBox(height: AppSpacing.md),
                    _SharedCollateralRow(form: form),
                    const SizedBox(height: 20),
                    _LeveragePanel(form: form, notifier: notifier),
                    const SizedBox(height: 20),
                    _EntryTypePanel(form: form, notifier: notifier),
                    if (form.orderType == OrderType.limit) ...[
                      const SizedBox(height: 18),
                      _TradeNumberField(
                        key: const ValueKey('limit-entry-price'),
                        label: 'Limit price',
                        prefix: '\$',
                        value: form.limitPrice,
                        hint: form.symbol == null
                            ? '\$'
                            : _price(form.symbol!.lastPrice),
                        onChanged: notifier.setLimitPrice,
                      ),
                    ],
                    const SizedBox(height: 20),
                    _MarginAmountPanel(form: form, notifier: notifier),
                    const SizedBox(height: 20),
                    _RiskStatusCard(form: form),
                    const SizedBox(height: 20),
                    _TradeTpSlPanel(form: form, notifier: notifier),
                    const SizedBox(height: 20),
                    _TradeSideRow(form: form, notifier: notifier),
                    if (formError != null && hasStarted) ...[
                      const SizedBox(height: AppSpacing.md),
                      _BlockingCard(message: formError),
                    ],
                    if (setupOnly &&
                        form.symbol != null &&
                        form.amountTouched) ...[
                      const SizedBox(height: AppSpacing.md),
                      const _InlineNotice(
                        icon: Icons.lock_outline_rounded,
                        color: AppColors.warningAmber,
                        message:
                            'You can review this setup now. Connect an exchange before execution.',
                      ),
                    ],
                    const SizedBox(height: 28),
                  ],
                ),
              ),
            ),
            _TradeReviewBar(
              enabled: canReview,
              loading: form.isValidating,
              message: canReview
                  ? null
                  : formError ?? 'Complete all fields above to review trade',
              onPressed: () async {
                HapticFeedback.mediumImpact();
                final ok = await notifier.validateTrade();
                if (ok && context.mounted) {
                  context.push(Routes.tradeValidation);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openSignalImporter(BuildContext context) async {
    final notifier = ref.read(tradeFormProvider.notifier);
    final clipboard = await Clipboard.getData(Clipboard.kTextPlain);
    final text = clipboard?.text?.trim();
    if (text != null && text.isNotEmpty) {
      notifier.setSignalText(text);
      final ready = await _prepareSignalReview();
      if (ready && context.mounted) {
        context.push(Routes.tradeValidation);
        return;
      }
    }
    if (!context.mounted) return;
    final ready = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Consumer(
        builder: (context, ref, _) {
          final form = ref.watch(tradeFormProvider);
          final sheetNotifier = ref.read(tradeFormProvider.notifier);
          return _SignalImporterSheet(
            form: form,
            notifier: sheetNotifier,
            onReview: _prepareSignalReview,
          );
        },
      ),
    );
    if (ready == true && context.mounted) {
      context.push(Routes.tradeValidation);
    }
  }

  Future<bool> _prepareSignalReview() async {
    final notifier = ref.read(tradeFormProvider.notifier);
    if (ref.read(tradeFormProvider).preflight == null) {
      await notifier.loadPreflight();
    }
    notifier.parseSignal();
    final parsed = ref.read(tradeFormProvider).parsedSignal;
    if (parsed == null || !parsed.hasContent) {
      return false;
    }
    await notifier.applyParsedSignal();
    final localError = notifier.localValidationError;
    if (localError != null) {
      notifier.setSignalError(localError);
      return false;
    }
    final ok = await notifier.validateTrade();
    if (!ok) {
      notifier.setSignalError(
        ref.read(tradeFormProvider).validationError ??
            notifier.localValidationError ??
            'Check the signal before continuing.',
      );
    }
    return ok;
  }
}

class _SignalImporterSheet extends StatelessWidget {
  const _SignalImporterSheet({
    required this.form,
    required this.notifier,
    required this.onReview,
  });

  final TradeFormState form;
  final TradeForm notifier;
  final Future<bool> Function() onReview;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.sizeOf(context).height * 0.86,
          ),
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
          decoration: const BoxDecoration(
            color: AppColors.bgSecondary,
            borderRadius: AppRadius.sheetRadius,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 42,
                height: 4,
                decoration: const BoxDecoration(
                  color: AppColors.borderLight,
                  borderRadius: AppRadius.pillRadius,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  const Expanded(
                    child: Text('Paste Signal', style: AppTypography.h3),
                  ),
                  IconButton(
                    tooltip: 'Close',
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),
              Flexible(
                child: SingleChildScrollView(
                  child: _SignalParserCard(
                    form: form,
                    notifier: notifier,
                    onReview: onReview,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SignalParserCard extends StatefulWidget {
  const _SignalParserCard({
    required this.form,
    required this.notifier,
    required this.onReview,
  });

  final TradeFormState form;
  final TradeForm notifier;
  final Future<bool> Function() onReview;

  @override
  State<_SignalParserCard> createState() => _SignalParserCardState();
}

class _SignalParserCardState extends State<_SignalParserCard> {
  late final TextEditingController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(text: widget.form.signalText);
  }

  @override
  void didUpdateWidget(covariant _SignalParserCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.form.signalText == _ctrl.text) return;
    _ctrl.value = TextEditingValue(
      text: widget.form.signalText,
      selection: TextSelection.collapsed(
        offset: widget.form.signalText.length,
      ),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final parsed = widget.form.parsedSignal;

    return Container(
      padding: AppSpacing.cardPadding,
      decoration: BoxDecoration(
        color: AppColors.bgPrimary,
        borderRadius: AppRadius.cardRadius,
        border: Border.all(color: AppColors.brand50),
        boxShadow: [
          BoxShadow(
            color: AppColors.brand900.withValues(alpha: 0.04),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const _IconBubble(
                icon: Icons.auto_awesome_rounded,
                color: AppColors.accent,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  'Import signal',
                  style: AppTypography.h4.copyWith(letterSpacing: 0),
                ),
              ),
              if (widget.form.signalText.isNotEmpty)
                TextButton(
                  onPressed: widget.notifier.clearSignal,
                  child: const Text('Clear'),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          TextField(
            controller: _ctrl,
            minLines: 3,
            maxLines: 6,
            textCapitalization: TextCapitalization.characters,
            style: AppTypography.body,
            decoration: InputDecoration(
              hintText:
                  'BTCUSDT LONG\nEntry 67420  SL 66000\nTP1 69000  TP2 70500  10x isolated',
              hintStyle: AppTypography.body.copyWith(
                color: AppColors.textDisabled,
                height: 1.35,
              ),
              filled: true,
              fillColor: AppColors.bgSurface,
              enabledBorder: const OutlineInputBorder(
                borderRadius: AppRadius.cardRadius,
                borderSide: BorderSide(color: AppColors.borderLight),
              ),
              focusedBorder: const OutlineInputBorder(
                borderRadius: AppRadius.cardRadius,
                borderSide: BorderSide(color: AppColors.accent, width: 1.4),
              ),
            ),
            onChanged: widget.notifier.setSignalText,
          ),
          const SizedBox(height: AppSpacing.sm),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: widget.form.signalText.trim().isEmpty ||
                      widget.form.isApplyingSignal ||
                      widget.form.isValidating
                  ? null
                  : () async {
                      final ready = await widget.onReview();
                      if (ready && context.mounted) {
                        Navigator.of(context).pop(true);
                      }
                    },
              icon: widget.form.isApplyingSignal || widget.form.isValidating
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.arrow_forward_rounded, size: 18),
              label: Text(
                widget.form.isApplyingSignal || widget.form.isValidating
                    ? 'Preparing...'
                    : 'Review setup',
              ),
            ),
          ),
          if (widget.form.signalError != null) ...[
            const SizedBox(height: AppSpacing.sm),
            _InlineNotice(
              message: widget.form.signalError!,
              color: AppColors.warningAmber,
              icon: Icons.info_outline_rounded,
            ),
          ],
          if (parsed != null) ...[
            const SizedBox(height: AppSpacing.md),
            _ParsedSignalSummary(parsed: parsed),
          ],
        ],
      ),
    );
  }
}

class _ParsedSignalSummary extends StatelessWidget {
  const _ParsedSignalSummary({required this.parsed});

  final TradeSignalParse parsed;

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
          Row(
            children: [
              const Text('Signal found', style: AppTypography.label),
              const Spacer(),
              Text(
                parsed.isActionable ? 'Ready' : 'Needs a little more',
                style: AppTypography.label.copyWith(
                  color: parsed.isActionable
                      ? AppColors.profitGreen
                      : AppColors.warningAmber,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: [
              if (parsed.symbol != null) _SignalChip(parsed.symbol!),
              if (parsed.side != null) _SignalChip(parsed.side!.toUpperCase()),
              if (parsed.entryPrice != null)
                _SignalChip('Entry ${_money(parsed.entryPrice!)}'),
              if (parsed.stopLoss != null)
                _SignalChip('SL ${_money(parsed.stopLoss!)}'),
              if (parsed.takeProfits.isNotEmpty)
                _SignalChip('TP ${_money(parsed.takeProfits.first)}'),
              if (parsed.takeProfits.length > 1)
                _SignalChip('TP2 ${_money(parsed.takeProfits[1])}'),
              if (parsed.leverage != null)
                _SignalChip('${parsed.leverage!.toStringAsFixed(0)}x'),
              if (parsed.collateralMode != null)
                _SignalChip(parsed.collateralMode!),
              if (parsed.marginAmount != null)
                _SignalChip('Margin ${_money(parsed.marginAmount!)}'),
            ],
          ),
          if (parsed.missingFields.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Missing ${parsed.missingFields.join(', ')}',
              style: AppTypography.caption.copyWith(
                color: AppColors.warningAmber,
              ),
            ),
          ],
          for (final warning in parsed.warnings) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              warning,
              style: AppTypography.caption.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _SharedCollateralRow extends StatelessWidget {
  const _SharedCollateralRow({required this.form});

  final TradeFormState form;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'Shared collateral',
          style: AppTypography.bodySm.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            '${_money(form.availableBalance)} ${form.balanceCurrency}',
            textAlign: TextAlign.right,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.bodySm.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
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
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: AppRadius.cardRadius,
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Row(
        children: [
          Expanded(
            child: _RiskMetricItem(
              label: 'Risk per trade',
              value: '${pf?.riskPerTradePct.toStringAsFixed(0) ?? 2}%',
            ),
          ),
          Container(
            width: 1,
            height: 28,
            color: AppColors.borderLight,
          ),
          Expanded(
            child: _RiskMetricItem(
              label: 'Max leverage',
              value: '${pf?.maxLeverage.toStringAsFixed(0) ?? 10}x',
            ),
          ),
          Container(
            width: 1,
            height: 28,
            color: AppColors.borderLight,
          ),
          Expanded(
            child: _RiskMetricItem(
              label: 'Trades today',
              value: '${pf?.tradesToday ?? 0} / ${pf?.maxTradesPerDay ?? 5}',
            ),
          ),
        ],
      ),
    );
  }
}

class _RiskMetricItem extends StatelessWidget {
  const _RiskMetricItem({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: AppTypography.caption.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppTypography.bodyMedium.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _TradingPairHeader extends StatelessWidget {
  const _TradingPairHeader({required this.form});

  final TradeFormState form;

  @override
  Widget build(BuildContext context) {
    return _LabeledBlock(
      label: 'Trading pair',
      child: SymbolPicker(
        selected: form.symbol,
        exchange: form.preflight?.exchange ?? form.symbol?.exchange ?? 'bybit',
      ),
    );
  }
}

class _MarginTypePanel extends StatelessWidget {
  const _MarginTypePanel({
    required this.form,
    required this.notifier,
  });

  final TradeFormState form;
  final TradeForm notifier;

  @override
  Widget build(BuildContext context) {
    return _LabeledBlock(
      label: 'Margin type',
      child: _DropdownTile(
        label: form.collateralMode == CollateralMode.cross
            ? 'Cross margin'
            : 'Isolated margin',
        onTap: () => _showMarginTypeSheet(context, form, notifier),
      ),
    );
  }
}

Future<void> _showMarginTypeSheet(
  BuildContext context,
  TradeFormState form,
  TradeForm notifier,
) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _MarginTypeSheet(
      selected: form.collateralMode,
      onSelected: notifier.setCollateralMode,
    ),
  );
}

class _DropdownTile extends StatelessWidget {
  const _DropdownTile({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.bgPrimary,
      borderRadius: AppRadius.cardRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.cardRadius,
        child: Container(
          height: 52,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            borderRadius: AppRadius.cardRadius,
            border: Border.all(color: AppColors.borderLight),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.body.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
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

class _MarginTypeSheet extends StatelessWidget {
  const _MarginTypeSheet({
    required this.selected,
    required this.onSelected,
  });

  final CollateralMode selected;
  final ValueChanged<CollateralMode> onSelected;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          0,
          AppSpacing.md,
          AppSpacing.md,
        ),
        child: Container(
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
                  const Expanded(
                    child: Text('Margin type', style: AppTypography.h4),
                  ),
                  IconButton(
                    tooltip: 'Close',
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              _MarginTypeOption(
                title: 'Cross Margin',
                subtitle: 'Your entire balance is collateral',
                selected: selected == CollateralMode.cross,
                onTap: () {
                  onSelected(CollateralMode.cross);
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: AppSpacing.sm),
              _MarginTypeOption(
                title: 'Isolated Margin',
                subtitle: 'Only allocated margin is at risk',
                selected: selected == CollateralMode.isolated,
                onTap: () {
                  onSelected(CollateralMode.isolated);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MarginTypeOption extends StatelessWidget {
  const _MarginTypeOption({
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.bgPrimary,
      borderRadius: AppRadius.cardRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.cardRadius,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: AppRadius.cardRadius,
            border: Border.all(
              color: selected ? AppColors.primary : AppColors.borderLight,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTypography.bodyMedium),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: AppTypography.bodySm.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              if (selected)
                const Icon(
                  Icons.check_circle_rounded,
                  color: AppColors.primary,
                  size: 20,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EntryTypePanel extends StatelessWidget {
  const _EntryTypePanel({
    required this.form,
    required this.notifier,
  });

  final TradeFormState form;
  final TradeForm notifier;

  @override
  Widget build(BuildContext context) {
    return _LabeledBlock(
      label: 'Entry Type',
      child: Row(
        children: [
          Expanded(
            child: _EntryTypeCard(
              label: 'Market',
              description: 'Executes instantly at the current available price.',
              selected: form.orderType == OrderType.market,
              onTap: () => notifier.setOrderType(OrderType.market),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: _EntryTypeCard(
              label: 'Limit',
              description:
                  'Executes only when price reaches your specified level.',
              selected: form.orderType == OrderType.limit,
              onTap: () => notifier.setOrderType(OrderType.limit),
            ),
          ),
        ],
      ),
    );
  }
}

class _EntryTypeCard extends StatelessWidget {
  const _EntryTypeCard({
    required this.label,
    required this.description,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final String description;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected
          ? AppColors.primary.withValues(alpha: 0.08)
          : AppColors.bgPrimary,
      borderRadius: AppRadius.cardRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.cardRadius,
        child: Container(
          height: 96,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: AppRadius.cardRadius,
            border: Border.all(
              color: selected ? AppColors.primary : AppColors.borderLight,
              width: selected ? 1.4 : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Container(
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: selected
                            ? AppColors.primary
                            : AppColors.borderLight,
                        width: 1.4,
                      ),
                    ),
                    child: selected
                        ? Center(
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                            ),
                          )
                        : null,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),
              Expanded(
                child: Text(
                  description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.bodySm.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.25,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MarginAmountPanel extends StatelessWidget {
  const _MarginAmountPanel({
    required this.form,
    required this.notifier,
  });

  final TradeFormState form;
  final TradeForm notifier;

  @override
  Widget build(BuildContext context) {
    final isPercentage = form.marginMode == MarginMode.percentage;
    final entry = notifier.entryPrice;
    final estimatedQuantity =
        entry <= 0 ? 0.0 : (notifier.marginAmount * form.leverage) / entry;
    final notional = notifier.marginAmount * form.leverage;

    return _LabeledBlock(
      label: 'Trade amount',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SegmentedTabs(
            tabs: [
              (
                label: 'Percentage',
                active: isPercentage,
                onTap: () => notifier.setMarginMode(MarginMode.percentage),
              ),
              (
                label: 'Fixed amount',
                active: !isPercentage,
                onTap: () => notifier.setMarginMode(MarginMode.fixed),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          _MarginAmountInputField(
            value: form.marginValue,
            isPercentage: isPercentage,
            onChanged: (value) => notifier.setMarginValue(value ?? 0),
          ),
          if (form.amountTouched &&
              form.symbol != null &&
              form.marginValue > 0) ...[
            const SizedBox(height: AppSpacing.sm),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: 13,
              ),
              decoration: const BoxDecoration(
                color: AppColors.bgSurface,
                borderRadius: AppRadius.cardRadius,
              ),
              child: Row(
                children: [
                  Text(
                    '~ ${_compactQuantity(estimatedQuantity)} ${form.symbol?.baseAsset ?? ''}',
                    style: AppTypography.bodySm.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'Notional Value = ${_money(notional)}',
                    style: AppTypography.bodySm.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _LeveragePanel extends StatelessWidget {
  const _LeveragePanel({
    required this.form,
    required this.notifier,
  });

  final TradeFormState form;
  final TradeForm notifier;

  @override
  Widget build(BuildContext context) {
    final max = _maxLeverage(form).round().clamp(1, 100).toInt();
    final value = form.leverage.clamp(1.0, max.toDouble()).toDouble();
    return _LabeledBlock(
      label: 'Leverage',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '${value.toStringAsFixed(0)}x',
                style: AppTypography.h4.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              _TinyRiskPill(
                label: _leverageRiskLabel(value),
                color: _leverageColor(value),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: AppColors.primary,
              inactiveTrackColor: AppColors.borderLight,
              thumbColor: AppColors.primary,
              overlayColor: AppColors.primary.withValues(alpha: 0.12),
              tickMarkShape: const RoundSliderTickMarkShape(),
              activeTickMarkColor: AppColors.primary,
              inactiveTickMarkColor: AppColors.borderLight,
              trackHeight: 4,
            ),
            child: Slider(
              value: value,
              min: 1,
              max: max.toDouble(),
              divisions: max - 1,
              label: '${value.toStringAsFixed(0)}x',
              onChanged: (next) => notifier.setLeverage(next),
            ),
          ),
        ],
      ),
    );
  }
}

class _TradeTpSlPanel extends StatelessWidget {
  const _TradeTpSlPanel({
    required this.form,
    required this.notifier,
  });

  final TradeFormState form;
  final TradeForm notifier;

  @override
  Widget build(BuildContext context) {
    final entry = notifier.entryPrice;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Stop Loss', style: AppTypography.bodyMedium),
        const SizedBox(height: AppSpacing.sm),
        _SlField(
          value: form.slPrice,
          hint: entry > 0 ? _price(entry * _slMultiplier(form.side)) : '0.00',
          onChanged: notifier.setSlPrice,
        ),
        const SizedBox(height: 28),
        Row(
          children: [
            const Expanded(
              child: Text('Take Profit', style: AppTypography.bodyMedium),
            ),
            if (form.takeProfit2 != null)
              TextButton(
                onPressed: () => notifier.setTakeProfit2(null),
                child: const Text('Remove TP2'),
              )
            else
              TextButton(
                onPressed: () {
                  final defaultPrice = entry <= 0
                      ? 0.0
                      : _roundPrice(
                          entry * _tpMultiplier(form.side, 2),
                        );
                  notifier.setTakeProfit2(defaultPrice);
                },
                child: const Text('Add TP2'),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        _TpCard(
          level: 1,
          value: form.takeProfit1,
          entry: entry,
          side: form.side,
          leverage: form.leverage,
          margin: notifier.marginAmount,
          onChanged: notifier.setTakeProfit1,
        ),
        if (form.takeProfit2 != null) ...[
          const SizedBox(height: AppSpacing.sm),
          _TpCard(
            level: 2,
            value: form.takeProfit2,
            entry: entry,
            side: form.side,
            leverage: form.leverage,
            margin: notifier.marginAmount,
            onChanged: notifier.setTakeProfit2,
          ),
        ],
        const SizedBox(height: 28),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Automatic Stop Loss progression',
                    style: AppTypography.bodyMedium,
                  ),
                  Text(
                    'Move SL to breakeven when TP1 is hit',
                    style: AppTypography.bodySm.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Switch(
              value: form.autoStopLossProgression,
              onChanged: notifier.setAutoStopLossProgression,
              activeThumbColor: AppColors.primary,
            ),
          ],
        ),
      ],
    );
  }
}

class _TradeSideRow extends StatelessWidget {
  const _TradeSideRow({
    required this.form,
    required this.notifier,
  });

  final TradeFormState form;
  final TradeForm notifier;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _DirectionButton(
            label: 'Buy/Long',
            color: AppColors.profitGreen,
            active: form.directionTouched && form.side == OrderSide.long,
            onTap: () => notifier.setSide(OrderSide.long),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: _DirectionButton(
            label: 'Sell/Short',
            color: AppColors.lossRed,
            active: form.directionTouched && form.side == OrderSide.short,
            onTap: () => notifier.setSide(OrderSide.short),
          ),
        ),
      ],
    );
  }
}

class _DirectionButton extends StatelessWidget {
  const _DirectionButton({
    required this.label,
    required this.color,
    required this.active,
    required this.onTap,
  });

  final String label;
  final Color color;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: FilledButton(
        onPressed: onTap,
        style: FilledButton.styleFrom(
          backgroundColor: active ? color : color.withValues(alpha: 0.12),
          foregroundColor: active ? Colors.white : color,
          disabledBackgroundColor: AppColors.bgCard,
          shape: const StadiumBorder(),
          textStyle: AppTypography.button.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        child: Text(label),
      ),
    );
  }
}

class _TradeReviewBar extends StatelessWidget {
  const _TradeReviewBar({
    required this.enabled,
    required this.loading,
    required this.onPressed,
    this.message,
  });

  final bool enabled;
  final bool loading;
  final VoidCallback onPressed;
  final String? message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 26),
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
            child: FilledButton.icon(
              onPressed: enabled ? onPressed : null,
              icon: loading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const SizedBox.shrink(),
              label: Text(loading ? 'Reviewing...' : 'Review trade summary'),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                disabledBackgroundColor: AppColors.bgCardElevated,
                foregroundColor: Colors.white,
                disabledForegroundColor: AppColors.textDisabled,
                textStyle: AppTypography.button,
                shape: const StadiumBorder(),
              ),
            ),
          ),
          if (message != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              message!,
              textAlign: TextAlign.center,
              style: AppTypography.caption.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _LabeledBlock extends StatelessWidget {
  const _LabeledBlock({
    required this.label,
    required this.child,
  });

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTypography.bodyMedium),
        const SizedBox(height: AppSpacing.sm),
        child,
      ],
    );
  }
}

class _MarginAmountInputField extends StatefulWidget {
  const _MarginAmountInputField({
    required this.value,
    required this.isPercentage,
    required this.onChanged,
  });

  final double value;
  final bool isPercentage;
  final ValueChanged<double?> onChanged;

  @override
  State<_MarginAmountInputField> createState() =>
      _MarginAmountInputFieldState();
}

class _MarginAmountInputFieldState extends State<_MarginAmountInputField> {
  late final TextEditingController _ctrl;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(text: _amountText(widget.value));
    _focusNode = FocusNode();
  }

  @override
  void didUpdateWidget(covariant _MarginAmountInputField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_focusNode.hasFocus && oldWidget.isPercentage == widget.isPercentage) {
      return;
    }
    if (oldWidget.value == widget.value &&
        oldWidget.isPercentage == widget.isPercentage) {
      return;
    }
    final next = _amountText(widget.value);
    if (_ctrl.text == next) return;
    _ctrl.value = TextEditingValue(
      text: next,
      selection: TextSelection.collapsed(offset: next.length),
    );
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _ctrl,
      focusNode: _focusNode,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
      ],
      style: AppTypography.h2.copyWith(fontWeight: FontWeight.w700),
      decoration: InputDecoration(
        hintText: widget.isPercentage ? '0' : '0.00',
        prefixText: widget.isPercentage ? null : '\$',
        suffixText: widget.isPercentage ? '%' : null,
        hintStyle: AppTypography.h2.copyWith(color: AppColors.textDisabled),
        filled: true,
        fillColor: AppColors.bgCard,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        enabledBorder: const OutlineInputBorder(
          borderRadius: AppRadius.cardRadius,
          borderSide: BorderSide(color: AppColors.borderLight),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: AppRadius.cardRadius,
          borderSide: BorderSide(color: AppColors.primary, width: 1.4),
        ),
      ),
      onChanged: (value) => widget.onChanged(double.tryParse(value)),
    );
  }
}

class _TinyRiskPill extends StatelessWidget {
  const _TinyRiskPill({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: AppRadius.pillRadius,
        border: Border.all(color: color.withValues(alpha: 0.45)),
      ),
      child: Text(
        label,
        style: AppTypography.bodySm.copyWith(color: color),
      ),
    );
  }
}

class _TpCard extends StatelessWidget {
  const _TpCard({
    required this.level,
    required this.value,
    required this.entry,
    required this.side,
    required this.leverage,
    required this.margin,
    required this.onChanged,
  });

  final int level;
  final double? value;
  final double entry;
  final OrderSide side;
  final double leverage;
  final double margin;
  final ValueChanged<double?> onChanged;

  @override
  Widget build(BuildContext context) {
    final profit = value == null || entry <= 0 || margin <= 0
        ? 0.0
        : _pnlFor(side, margin, leverage, entry, value!);
    final roi = margin <= 0 ? 0.0 : profit / margin * 100;
    final move = entry <= 0 || value == null
        ? 0.0
        : ((value! - entry).abs() / entry) * 100;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('TP $level', style: AppTypography.bodyMedium),
        const SizedBox(height: AppSpacing.sm),
        _GreenPriceField(
          value: value,
          onChanged: onChanged,
        ),
        if (value != null && value! > 0 && entry > 0 && margin > 0) ...[
          const SizedBox(height: AppSpacing.sm),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.profitGreen.withValues(alpha: 0.08),
              borderRadius: AppRadius.cardRadius,
              border: Border.all(
                color: AppColors.profitGreen.withValues(alpha: 0.35),
              ),
            ),
            child: Column(
              children: [
                _CalcRow('ROI on your margin', '+${_formatPct(roi)}'),
                const SizedBox(height: AppSpacing.sm),
                _CalcRow('Price move needed', '+${_formatPct(move)}'),
                Divider(
                  height: 20,
                  color: AppColors.profitGreen.withValues(alpha: 0.22),
                ),
                _CalcRow('You take home', '+${_money(profit)}', bold: true),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _GreenPriceField extends StatelessWidget {
  const _GreenPriceField({
    required this.value,
    required this.onChanged,
  });

  final double? value;
  final ValueChanged<double?> onChanged;

  @override
  Widget build(BuildContext context) {
    return _CompactNumberField(
      value: value,
      hint: '1,000',
      prefix: '\$',
      borderColor: AppColors.profitGreen.withValues(alpha: 0.35),
      focusedBorderColor: AppColors.profitGreen.withValues(alpha: 0.55),
      onChanged: onChanged,
    );
  }
}

class _SlField extends StatelessWidget {
  const _SlField({
    required this.value,
    required this.hint,
    required this.onChanged,
  });

  final double? value;
  final String hint;
  final ValueChanged<double?> onChanged;

  @override
  Widget build(BuildContext context) {
    return _CompactNumberField(
      value: value,
      hint: hint,
      prefix: '\$',
      borderColor: AppColors.lossRed.withValues(alpha: 0.35),
      focusedBorderColor: AppColors.lossRed.withValues(alpha: 0.55),
      onChanged: onChanged,
    );
  }
}

class _CompactNumberField extends StatefulWidget {
  const _CompactNumberField({
    required this.value,
    required this.hint,
    required this.onChanged,
    required this.borderColor,
    required this.focusedBorderColor,
    this.prefix,
  });

  final double? value;
  final String hint;
  final ValueChanged<double?> onChanged;
  final Color borderColor;
  final Color focusedBorderColor;
  final String? prefix;

  @override
  State<_CompactNumberField> createState() => _CompactNumberFieldState();
}

class _CompactNumberFieldState extends State<_CompactNumberField> {
  late final TextEditingController _ctrl;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _ctrl = TextEditingController(
      text: widget.value == null || widget.value! <= 0
          ? ''
          : _price(widget.value!),
    );
  }

  @override
  void didUpdateWidget(covariant _CompactNumberField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_focusNode.hasFocus) return;
    if (oldWidget.value == widget.value) return;
    final next =
        widget.value == null || widget.value! <= 0 ? '' : _price(widget.value!);
    if (_ctrl.text == next) return;
    _ctrl.value = TextEditingValue(
      text: next,
      selection: TextSelection.collapsed(offset: next.length),
    );
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEmpty = widget.value == null || widget.value! <= 0;
    return TextField(
      controller: _ctrl,
      focusNode: _focusNode,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
      ],
      style: AppTypography.body,
      decoration: InputDecoration(
        hintText: isEmpty && widget.prefix != null
            ? '${widget.prefix}${widget.hint}'
            : widget.hint,
        prefixText: isEmpty ? null : widget.prefix,
        hintStyle: AppTypography.body.copyWith(color: AppColors.textDisabled),
        filled: true,
        fillColor: AppColors.bgCard,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.cardRadius,
          borderSide: BorderSide(color: widget.borderColor, width: 1.2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.cardRadius,
          borderSide: BorderSide(color: widget.focusedBorderColor, width: 1.5),
        ),
      ),
      onChanged: (value) => widget.onChanged(double.tryParse(value)),
    );
  }
}

class _CalcRow extends StatelessWidget {
  const _CalcRow(this.label, this.value, {this.bold = false});

  final String label;
  final String value;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: AppTypography.bodySm.copyWith(
              color: AppColors.profitGreen,
            ),
          ),
        ),
        Text(
          value,
          style: AppTypography.bodySm.copyWith(
            color: AppColors.profitGreen,
            fontWeight: bold ? FontWeight.w700 : FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _TradeAlertBanner extends StatelessWidget {
  const _TradeAlertBanner({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.warningAmber.withValues(alpha: 0.08),
        borderRadius: AppRadius.cardRadius,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.error_outline_rounded,
            color: AppColors.warningAmber,
            size: 16,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              message,
              style: AppTypography.bodySm.copyWith(
                color: AppColors.textSecondary,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TradeNumberField extends StatefulWidget {
  const _TradeNumberField({
    super.key,
    required this.label,
    required this.onChanged,
    this.value,
    this.prefix,
    this.hint,
  });

  final String label;
  final double? value;
  final String? prefix;
  final String? hint;
  final ValueChanged<double?> onChanged;

  @override
  State<_TradeNumberField> createState() => _TradeNumberFieldState();
}

class _TradeNumberFieldState extends State<_TradeNumberField> {
  late final TextEditingController _ctrl;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(text: _format(widget.value));
    _focusNode = FocusNode();
  }

  @override
  void didUpdateWidget(covariant _TradeNumberField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_focusNode.hasFocus) return;
    if (oldWidget.value == widget.value) return;
    final nextText = _format(widget.value);
    if (_ctrl.text == nextText) return;
    _ctrl.value = TextEditingValue(
      text: nextText,
      selection: TextSelection.collapsed(offset: nextText.length),
    );
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label, style: AppTypography.bodyMedium),
        const SizedBox(height: AppSpacing.xs),
        TextField(
          controller: _ctrl,
          focusNode: _focusNode,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
          ],
          style: AppTypography.numeric,
          decoration: InputDecoration(
            hintText: widget.hint,
            prefixText: widget.prefix,
            filled: true,
            fillColor: AppColors.bgCard,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: 14,
            ),
            enabledBorder: const OutlineInputBorder(
              borderRadius: AppRadius.cardRadius,
              borderSide: BorderSide(color: AppColors.borderLight),
            ),
            focusedBorder: const OutlineInputBorder(
              borderRadius: AppRadius.cardRadius,
              borderSide: BorderSide(color: AppColors.borderLight, width: 1.5),
            ),
          ),
          onChanged: (value) => widget.onChanged(double.tryParse(value)),
        ),
      ],
    );
  }

  String _format(double? value) {
    if (value == null || value == 0) return '';
    return _price(value);
  }
}

class _SegmentedTabs extends StatelessWidget {
  const _SegmentedTabs({required this.tabs});

  final List<({String label, bool active, VoidCallback onTap})> tabs;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        borderRadius: AppRadius.pillRadius,
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Row(
        children: tabs
            .map(
              (tab) => Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: tab.onTap,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    alignment: Alignment.center,
                    height: 38,
                    decoration: BoxDecoration(
                      color:
                          tab.active ? AppColors.bgPrimary : Colors.transparent,
                      borderRadius: AppRadius.pillRadius,
                      border: Border.all(
                        color: tab.active
                            ? AppColors.borderLight
                            : Colors.transparent,
                      ),
                    ),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        tab.label,
                        style: AppTypography.label.copyWith(
                          color: tab.active
                              ? AppColors.primary
                              : AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _InlineNotice extends StatelessWidget {
  const _InlineNotice({
    required this.message,
    required this.color,
    required this.icon,
  });

  final String message;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: AppRadius.chipRadius,
        border: Border.all(color: color.withValues(alpha: 0.22)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: Text(
              message,
              style: AppTypography.caption.copyWith(
                color: AppColors.textSecondary,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _IconBubble extends StatelessWidget {
  const _IconBubble({
    required this.icon,
    required this.color,
  });

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, size: 18, color: color),
    );
  }
}

// ignore: unused_element
class _PasteSignalButton extends StatelessWidget {
  const _PasteSignalButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.content_paste_rounded, size: 18),
      label: const Text('Paste signal'),
      style: TextButton.styleFrom(
        foregroundColor: AppColors.accent,
        textStyle: AppTypography.label,
        padding: const EdgeInsets.symmetric(horizontal: 10),
      ),
    );
  }
}

class _SignalChip extends StatelessWidget {
  const _SignalChip(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.bgPrimary,
        borderRadius: AppRadius.pillRadius,
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Text(
        label,
        style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
      ),
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.error_outline_rounded, color: AppColors.lossRed),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              message ?? 'Trading is temporarily unavailable.',
              style: AppTypography.body.copyWith(color: AppColors.lossRed),
            ),
          ),
        ],
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
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
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

double _maxLeverage(TradeFormState form) {
  final symbolMax = (form.symbol?.maxLeverage ?? 100).toDouble();
  final ruleMax = form.preflight?.maxLeverage;
  if (ruleMax == null || ruleMax <= 0) return symbolMax;
  return symbolMax < ruleMax ? symbolMax : ruleMax;
}

Color _leverageColor(double leverage) {
  if (leverage <= 5) return AppColors.profitGreen;
  if (leverage <= 15) return AppColors.warningAmber;
  return AppColors.lossRed;
}

String _leverageRiskLabel(double leverage) {
  if (leverage <= 7) return 'Low risk';
  if (leverage <= 20) return 'Moderate risk';
  return 'High risk';
}

String _amountText(double value) {
  if (value <= 0) return '';
  if (value % 1 == 0) return value.toStringAsFixed(0);
  return value.toStringAsFixed(2).replaceFirst(RegExp(r'\.?0+$'), '');
}

String? _preflightNotice(TradeFormState form) {
  final preflight = form.preflight;
  if (preflight == null || preflight.allowed) return null;
  final reason = (preflight.blockingReason ?? '').toLowerCase();

  if (_isExchangeConnectionBlock(reason)) return null;

  final tradeLimitReached = preflight.maxTradesPerDay > 0 &&
      preflight.tradesToday >= preflight.maxTradesPerDay;
  final lossLimitReached = preflight.dailyLossLimitUsd > 0 &&
      preflight.dailyAvailableBalanceUsd <= 0 &&
      reason.contains('daily') &&
      reason.contains('loss');

  if (tradeLimitReached && lossLimitReached) {
    return 'Your daily trade limit and loss limit have both been reached. Proceeding will log this trade as a rule violation.';
  }
  if (tradeLimitReached &&
      (reason.contains('trade') || reason.contains('trades per day'))) {
    return 'You\'ve reached your daily trade limit (${preflight.tradesToday}/${preflight.maxTradesPerDay}). Proceeding will log this trade as a rule violation.';
  }
  if (lossLimitReached) {
    return 'Your daily loss limit of ${_money(preflight.dailyLossLimitUsd)} has been reached. Proceeding will log this trade as a rule violation.';
  }
  return preflight.blockingReason;
}

bool _isExchangeConnectionBlock(String reason) {
  return reason.contains('exchange') ||
      reason.contains('api key') ||
      reason.contains('connection');
}

String _normalizeExchange(String? value) {
  final normalized = value?.trim().toLowerCase();
  if (normalized == 'binance') return 'binance';
  return 'bybit';
}

double _tpMultiplier(OrderSide side, int level) {
  if (side == OrderSide.long) {
    return switch (level) {
      1 => 1.04,
      2 => 1.08,
      _ => 1.12,
    };
  }
  return switch (level) {
    1 => 0.96,
    2 => 0.92,
    _ => 0.88,
  };
}

double _slMultiplier(OrderSide side) => side == OrderSide.long ? 0.98 : 1.02;

double _roundPrice(double value) {
  if (value >= 100) return double.parse(value.toStringAsFixed(2));
  if (value >= 1) return double.parse(value.toStringAsFixed(4));
  return double.parse(value.toStringAsFixed(6));
}

String _money(double value) => '\$${value.abs().toStringAsFixed(2)}';

String _price(double value) {
  if (value >= 100) return value.toStringAsFixed(2);
  if (value >= 1) return _trimFixed(value, 4);
  return _trimFixed(value, 6);
}

String _formatPct(num value) {
  if (value % 1 == 0) return '${value.toInt()}%';
  return '${value.toStringAsFixed(2).replaceFirst(RegExp(r'\.?0+$'), '')}%';
}

String _compactQuantity(double value) {
  if (value <= 0) return '0';
  if (value >= 100) return value.toStringAsFixed(0);
  if (value >= 1) return _trimFixed(value, 4);
  if (value >= 0.01) return _trimFixed(value, 6);
  return _trimFixed(value, 8);
}

String _trimFixed(double value, int fractionDigits) {
  final text = value.toStringAsFixed(fractionDigits);
  final trimmed = text.replaceFirst(RegExp(r'\.?0+$'), '');
  return trimmed.isEmpty ? '0' : trimmed;
}

double _pnlFor(
  OrderSide side,
  double margin,
  double leverage,
  double entry,
  double price,
) {
  if (entry <= 0 || margin <= 0) return 0;
  final move = side == OrderSide.long
      ? (price - entry) / entry
      : (entry - price) / entry;
  return margin * leverage * move;
}
