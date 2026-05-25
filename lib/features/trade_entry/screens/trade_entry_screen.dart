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
import '../../../core/widgets/buttons/p_primary_button.dart';
import '../data/signal_parser.dart';
import '../providers/symbol_search_provider.dart';
import '../providers/trade_form_provider.dart';
import 'widgets/symbol_picker.dart';

class TradeEntryScreen extends ConsumerStatefulWidget {
  const TradeEntryScreen({super.key});

  @override
  ConsumerState<TradeEntryScreen> createState() => _TradeEntryScreenState();
}

class _TradeEntryScreenState extends ConsumerState<TradeEntryScreen> {
  Timer? _priceRefreshTimer;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(symbolSearchProvider.notifier).loadPopular();
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
      backgroundColor: AppColors.bgSecondary,
      appBar: AppBar(
        backgroundColor: AppColors.bgPrimary,
        leading: IconButton(
          onPressed: () => context.go(Routes.home),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        titleSpacing: 0,
        title: const Text('New Trade'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.sm),
            child: _PasteSignalButton(
              onPressed: () => _openSignalImporter(context),
            ),
          ),
        ],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: AppColors.borderLight),
        ),
      ),
      body: SafeArea(
        top: false,
        child: RefreshIndicator(
          onRefresh: notifier.loadPreflight,
          color: AppColors.accent,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            children: [
              if (form.isLoadingPreflight)
                const _InfoCard(
                  message: 'Checking exchange connection and live prices.',
                ),
              if (form.preflightError != null) ...[
                _BlockingCard(message: form.preflightError),
                const SizedBox(height: AppSpacing.md),
              ],
              _FormBlock(
                child: _MarketSetupSection(form: form, notifier: notifier),
              ),
              if (form.symbol != null) ...[
                const SizedBox(height: AppSpacing.md),
                _FormBlock(
                  child: _EntryPlanSection(form: form, notifier: notifier),
                ),
              ],
              if (form.symbol != null && form.amountTouched) ...[
                const SizedBox(height: AppSpacing.md),
                _FormBlock(
                  child: _DirectionSection(form: form, notifier: notifier),
                ),
              ],
              if (form.symbol != null && form.amountTouched) ...[
                const SizedBox(height: AppSpacing.md),
                _FormBlock(
                  child: _ExitPlanSection(form: form, notifier: notifier),
                ),
              ],
              if (formError != null && hasStarted) ...[
                const SizedBox(height: AppSpacing.md),
                _BlockingCard(message: formError),
              ],
              if (setupOnly && form.symbol != null && form.amountTouched) ...[
                const SizedBox(height: AppSpacing.md),
                const _InlineNotice(
                  icon: Icons.lock_outline_rounded,
                  color: AppColors.warningAmber,
                  message:
                      'You can review this setup now. Connect an exchange before execution.',
                ),
              ],
              const SizedBox(height: AppSpacing.lg),
              if (!canReview)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: Text(
                    formError ?? 'Choose a trading pair to continue.',
                    textAlign: TextAlign.center,
                    style: AppTypography.caption.copyWith(
                      color: AppColors.textTertiary,
                    ),
                  ),
                ),
              PPrimaryButton(
                label: form.isValidating ? 'Reviewing...' : 'Review setup',
                icon: const Icon(
                  Icons.arrow_forward_rounded,
                  color: Colors.white,
                  size: 18,
                ),
                state: form.isValidating
                    ? PButtonState.loading
                    : PButtonState.idle,
                onPressed: canReview
                    ? () async {
                        HapticFeedback.mediumImpact();
                        final ok = await notifier.validateTrade();
                        if (ok && context.mounted) {
                          context.push(Routes.tradeValidation);
                        }
                      }
                    : null,
              ),
            ],
          ),
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
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 42,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.borderLight,
                  borderRadius: BorderRadius.circular(99),
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

class _MarketSetupSection extends StatelessWidget {
  const _MarketSetupSection({
    required this.form,
    required this.notifier,
  });

  final TradeFormState form;
  final TradeForm notifier;

  @override
  Widget build(BuildContext context) {
    final symbol = form.symbol;
    final maxLeverage = _maxLeverage(form).round().clamp(1, 100).toInt();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SymbolPicker(
          selected: symbol,
          exchange: form.preflight?.exchange ?? symbol?.exchange ?? 'bybit',
        ),
        if (symbol != null) ...[
          const SizedBox(height: AppSpacing.sm),
          const _InlineNotice(
            icon: Icons.info_outline_rounded,
            color: AppColors.accent,
            message:
                'Poise will use this exact contract for price and execution.',
          ),
          const SizedBox(height: AppSpacing.sm),
          _MetricStrip(
            items: [
              (
                'Current price',
                _money(symbol.lastPrice),
                AppColors.textPrimary,
              ),
              (
                '24h move',
                '${symbol.priceChangePct >= 0 ? '+' : ''}${symbol.priceChangePct.toStringAsFixed(2)}%',
                AppColors.pnlColor(symbol.priceChangePct),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          const _FieldLabel(label: 'Margin type'),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(
                child: _ChoiceCard(
                  title: 'Isolated',
                  subtitle: 'Caps loss to allocated margin',
                  icon: Icons.lock_outline_rounded,
                  active: form.collateralMode == CollateralMode.isolated,
                  color: AppColors.accent,
                  onTap: () =>
                      notifier.setCollateralMode(CollateralMode.isolated),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _ChoiceCard(
                  title: 'Cross',
                  subtitle: 'Uses balance as collateral',
                  icon: Icons.all_inclusive_rounded,
                  active: form.collateralMode == CollateralMode.cross,
                  color: AppColors.warningAmber,
                  onTap: () => notifier.setCollateralMode(CollateralMode.cross),
                ),
              ),
            ],
          ),
          if (form.collateralModeTouched) ...[
            const SizedBox(height: AppSpacing.sm),
            _InlineNotice(
              icon: form.collateralMode == CollateralMode.isolated
                  ? Icons.lock_outline_rounded
                  : Icons.all_inclusive_rounded,
              color: form.collateralMode == CollateralMode.isolated
                  ? AppColors.accent
                  : AppColors.warningAmber,
              message: form.collateralMode == CollateralMode.isolated
                  ? 'Isolated keeps the trade contained to the margin you assign.'
                  : 'Cross can use more account balance to keep the trade open, so risk can extend past the entered margin.',
            ),
          ],
          const SizedBox(height: AppSpacing.md),
          const _FieldLabel(label: 'Leverage'),
          const SizedBox(height: AppSpacing.sm),
          _LeverageDropdown(
            value: form.leverage,
            max: maxLeverage,
            onChanged: notifier.setLeverage,
          ),
          if (form.leverageTouched) ...[
            const SizedBox(height: AppSpacing.sm),
            _InlineNotice(
              icon: Icons.speed_rounded,
              color: _leverageColor(form.leverage),
              message:
                  '${form.leverage.toStringAsFixed(0)}x multiplies both profit and loss before fees.',
            ),
          ],
        ],
      ],
    );
  }
}

class _EntryPlanSection extends StatelessWidget {
  const _EntryPlanSection({
    required this.form,
    required this.notifier,
  });

  final TradeFormState form;
  final TradeForm notifier;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: _ChoiceCard(
                title: 'Market',
                subtitle: 'Executes at the best available price',
                icon: Icons.flash_on_rounded,
                active: form.orderType == OrderType.market,
                color: AppColors.accent,
                onTap: () => notifier.setOrderType(OrderType.market),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _ChoiceCard(
                title: 'Limit',
                subtitle: 'Waits for your entry price',
                icon: Icons.pending_actions_rounded,
                active: form.orderType == OrderType.limit,
                color: AppColors.accent,
                onTap: () => notifier.setOrderType(OrderType.limit),
              ),
            ),
          ],
        ),
        if (form.orderTypeTouched) ...[
          const SizedBox(height: AppSpacing.sm),
          _InlineNotice(
            icon: form.orderType == OrderType.market
                ? Icons.flash_on_rounded
                : Icons.pending_actions_rounded,
            color: AppColors.accent,
            message: form.orderType == OrderType.market
                ? 'Market entry uses the best available live price.'
                : 'Limit entry waits for your chosen price before Poise can execute.',
          ),
        ],
        if (form.orderType == OrderType.market && form.symbol != null) ...[
          const SizedBox(height: AppSpacing.md),
          _MetricStrip(
            items: [
              (
                'Live entry',
                _money(form.symbol!.lastPrice),
                AppColors.textPrimary,
              ),
              (
                '24h move',
                '${form.symbol!.priceChangePct >= 0 ? '+' : ''}${form.symbol!.priceChangePct.toStringAsFixed(2)}%',
                AppColors.pnlColor(form.symbol!.priceChangePct),
              ),
            ],
          ),
        ],
        if (form.orderType == OrderType.limit) ...[
          const SizedBox(height: AppSpacing.md),
          _TradeNumberField(
            key: const ValueKey('limit-entry-price'),
            label: 'Limit entry price',
            prefix: '\$',
            value: form.limitPrice,
            hint: form.symbol == null ? '0.00' : _price(form.symbol!.lastPrice),
            onChanged: notifier.setLimitPrice,
          ),
        ],
        const SizedBox(height: AppSpacing.md),
        _AmountInputCard(form: form, notifier: notifier),
      ],
    );
  }
}

class _AmountInputCard extends StatelessWidget {
  const _AmountInputCard({
    required this.form,
    required this.notifier,
  });

  final TradeFormState form;
  final TradeForm notifier;

  @override
  Widget build(BuildContext context) {
    final fixedActive = form.amountInputMode == AmountInputMode.margin &&
        form.marginMode == MarginMode.fixed;
    final pctActive = form.amountInputMode == AmountInputMode.margin &&
        form.marginMode == MarginMode.percentage;
    final qtyActive = form.amountInputMode == AmountInputMode.quantity;

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
          const _FieldLabel(label: 'Amount'),
          const SizedBox(height: AppSpacing.sm),
          _SegmentedTabs(
            tabs: [
              (
                label: '\$ Margin',
                active: fixedActive,
                onTap: () => notifier.setMarginMode(MarginMode.fixed),
              ),
              (
                label: '% Balance',
                active: pctActive,
                onTap: () => notifier.setMarginMode(MarginMode.percentage),
              ),
              (
                label: 'Quantity',
                active: qtyActive,
                onTap: () =>
                    notifier.setAmountInputMode(AmountInputMode.quantity),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          if (fixedActive)
            _TradeNumberField(
              key: const ValueKey('margin-amount'),
              label: 'Margin amount',
              prefix: '\$',
              value: form.marginValue,
              hint: '0.00',
              onChanged: (value) => notifier.setMarginValue(value ?? 0),
            )
          else if (pctActive) ...[
            Slider(
              value: form.marginValue.clamp(1, 100),
              min: 1,
              max: 100,
              divisions: 99,
              label: '${form.marginValue.toStringAsFixed(0)}%',
              onChanged: notifier.setMarginValue,
            ),
            Row(
              children: [
                Text(
                  '${form.marginValue.toStringAsFixed(0)}% of balance',
                  style: AppTypography.bodyMedium,
                ),
                const Spacer(),
                Text(
                  _money(notifier.marginAmount),
                  style: AppTypography.numericSm,
                ),
              ],
            ),
          ] else
            _TradeNumberField(
              key: const ValueKey('quantity'),
              label: 'Quantity',
              value: form.quantity,
              hint: form.symbol == null ? '0.0000' : form.symbol!.baseAsset,
              onChanged: (value) => notifier.setQuantity(value ?? 0),
            ),
          if (form.amountTouched) ...[
            const SizedBox(height: AppSpacing.sm),
            _InlineNotice(
              icon: Icons.calculate_outlined,
              color: AppColors.accent,
              message: _amountHelper(form),
            ),
            const SizedBox(height: AppSpacing.md),
            _AmountMathPanel(form: form, notifier: notifier),
          ],
        ],
      ),
    );
  }
}

class _AmountMathPanel extends StatelessWidget {
  const _AmountMathPanel({
    required this.form,
    required this.notifier,
  });

  final TradeFormState form;
  final TradeForm notifier;

  @override
  Widget build(BuildContext context) {
    final entry = notifier.entryPrice;
    final margin = notifier.marginAmount;
    final quantity = notifier.quantity;
    final notional = entry > 0 ? quantity * entry : margin * form.leverage;

    return _MetricStrip(
      items: [
        ('Margin used', _money(margin), AppColors.textPrimary),
        ('Notional', _money(notional), AppColors.textPrimary),
        (
          'Quantity',
          form.symbol == null
              ? quantity.toStringAsFixed(4)
              : '${quantity.toStringAsFixed(6)} ${form.symbol!.baseAsset}',
          AppColors.textPrimary,
        ),
      ],
    );
  }
}

class _ExitPlanSection extends StatelessWidget {
  const _ExitPlanSection({
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
        _TradeNumberField(
          key: const ValueKey('take-profit-1'),
          label: 'Take profit 1',
          prefix: '\$',
          value: form.takeProfit1,
          hint:
              entry > 0 ? _price(entry * _tpMultiplier(form.side, 1)) : '0.00',
          borderColor: AppColors.profitGreen.withValues(alpha: 0.45),
          onChanged: notifier.setTakeProfit1,
        ),
        const SizedBox(height: AppSpacing.sm),
        if (form.takeProfit2 == null)
          OutlinedButton.icon(
            onPressed: entry <= 0
                ? null
                : () => notifier.setTakeProfit2(
                      _roundPrice(entry * _tpMultiplier(form.side, 2)),
                    ),
            icon: const Icon(Icons.add_rounded, size: 18),
            label: const Text('Add TP 2'),
          )
        else
          _TradeNumberField(
            key: const ValueKey('take-profit-2'),
            label: 'Take profit 2',
            prefix: '\$',
            value: form.takeProfit2,
            borderColor: AppColors.profitGreen.withValues(alpha: 0.35),
            onChanged: notifier.setTakeProfit2,
            trailing: IconButton(
              tooltip: 'Remove TP 2',
              onPressed: () => notifier.setTakeProfit2(null),
              icon: const Icon(Icons.close_rounded, size: 18),
            ),
          ),
        const SizedBox(height: AppSpacing.sm),
        SwitchListTile.adaptive(
          contentPadding: const EdgeInsets.symmetric(horizontal: 0),
          value: form.autoStopLossProgression,
          onChanged: notifier.setAutoStopLossProgression,
          title: const Text('Profit trailing', style: AppTypography.bodyMedium),
          subtitle: Text(
            'Stop follows price to lock in gains automatically.',
            style: AppTypography.caption.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        _TradeNumberField(
          key: const ValueKey('stop-loss'),
          label: 'Stop loss',
          prefix: '\$',
          value: form.slPrice,
          hint: entry > 0 ? _price(entry * _slMultiplier(form.side)) : '0.00',
          borderColor: AppColors.lossRed.withValues(alpha: 0.45),
          onChanged: notifier.setSlPrice,
        ),
        if (form.exitPlanTouched) ...[
          const SizedBox(height: AppSpacing.md),
          _ExitMathPanel(form: form, notifier: notifier),
        ],
      ],
    );
  }
}

class _ExitMathPanel extends StatelessWidget {
  const _ExitMathPanel({
    required this.form,
    required this.notifier,
  });

  final TradeFormState form;
  final TradeForm notifier;

  @override
  Widget build(BuildContext context) {
    final entry = notifier.entryPrice;
    final margin = notifier.marginAmount;
    final tp = form.takeProfit1;
    final sl = form.slPrice;
    final tpPnl = tp == null ? null : _pnlAt(form, margin, entry, tp);
    final slPnl = sl == null ? null : _pnlAt(form, margin, entry, sl);
    final rr = tpPnl == null || slPnl == null || slPnl >= 0
        ? null
        : tpPnl.abs() / slPnl.abs();

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _OutcomeMiniCard(
                title: 'If stop hits',
                value: slPnl == null ? '-' : '-${_money(slPnl.abs())}',
                caption: sl == null
                    ? 'Add a stop loss'
                    : '${_roiLabel(form, entry, sl)} ROI',
                color: AppColors.lossRed,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _OutcomeMiniCard(
                title: 'If TP1 hits',
                value: tpPnl == null ? '-' : '+${_money(tpPnl.abs())}',
                caption: tp == null
                    ? 'Add a target'
                    : '${_roiLabel(form, entry, tp)} ROI',
                color: AppColors.profitGreen,
              ),
            ),
          ],
        ),
        if (rr != null) ...[
          const SizedBox(height: AppSpacing.sm),
          _InlineNotice(
            icon: Icons.balance_rounded,
            color: rr >= 1.5 ? AppColors.profitGreen : AppColors.warningAmber,
            message:
                'Risk : Reward is 1 : ${rr.toStringAsFixed(2)} based on TP1 and stop loss.',
          ),
        ],
      ],
    );
  }
}

class _DirectionSection extends StatelessWidget {
  const _DirectionSection({
    required this.form,
    required this.notifier,
  });

  final TradeFormState form;
  final TradeForm notifier;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: _ChoiceCard(
                title: 'Long',
                subtitle: 'Buy. Profit if price rises.',
                icon: Icons.north_rounded,
                active: form.side == OrderSide.long,
                color: AppColors.profitGreen,
                onTap: () => notifier.setSide(OrderSide.long),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _ChoiceCard(
                title: 'Short',
                subtitle: 'Sell. Profit if price falls.',
                icon: Icons.south_rounded,
                active: form.side == OrderSide.short,
                color: AppColors.lossRed,
                onTap: () => notifier.setSide(OrderSide.short),
              ),
            ),
          ],
        ),
        if (form.directionTouched) ...[
          const SizedBox(height: AppSpacing.sm),
          _InlineNotice(
            icon: form.side == OrderSide.long
                ? Icons.north_rounded
                : Icons.south_rounded,
            color: form.side == OrderSide.long
                ? AppColors.profitGreen
                : AppColors.lossRed,
            message: form.side == OrderSide.long
                ? 'Long setups need a stop below entry and targets above entry.'
                : 'Short setups need a stop above entry and targets below entry.',
          ),
        ],
      ],
    );
  }
}

class _FormBlock extends StatelessWidget {
  const _FormBlock({
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpacing.cardPadding,
      decoration: BoxDecoration(
        color: AppColors.bgPrimary,
        borderRadius: AppRadius.cardRadius,
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [child],
      ),
    );
  }
}

class _LeverageDropdown extends StatelessWidget {
  const _LeverageDropdown({
    required this.value,
    required this.max,
    required this.onChanged,
  });

  final double value;
  final int max;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    final options = <int>{1, 2, 3, 5, 10, 15, 20, 25, 50, 100}
        .where((item) => item <= max)
        .toList();
    final current = value.round().clamp(1, max);
    if (!options.contains(current)) options.add(current);
    options.sort();

    return DropdownButtonFormField<int>(
      key: ValueKey('leverage-$current-$max'),
      initialValue: current,
      borderRadius: BorderRadius.circular(12),
      icon: const Icon(Icons.keyboard_arrow_down_rounded),
      decoration: const InputDecoration(
        labelText: 'Leverage',
        filled: true,
        fillColor: AppColors.bgCard,
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.cardRadius,
          borderSide: BorderSide(color: AppColors.borderLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.cardRadius,
          borderSide: BorderSide(color: AppColors.accent, width: 1.4),
        ),
      ),
      items: options
          .map(
            (item) => DropdownMenuItem<int>(
              value: item,
              child: Text(
                '${item}x',
                style: AppTypography.numericSm.copyWith(
                  color: item == current
                      ? AppColors.accent
                      : AppColors.textPrimary,
                ),
              ),
            ),
          )
          .toList(),
      onChanged: (next) {
        if (next == null) return;
        HapticFeedback.selectionClick();
        onChanged(next.toDouble());
      },
    );
  }
}

class _ChoiceCard extends StatelessWidget {
  const _ChoiceCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.active,
    required this.color,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final bool active;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: active ? color.withValues(alpha: 0.08) : AppColors.bgCard,
      borderRadius: AppRadius.cardRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.cardRadius,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          constraints: const BoxConstraints(minHeight: 108),
          padding: const EdgeInsets.all(AppSpacing.sm),
          decoration: BoxDecoration(
            borderRadius: AppRadius.cardRadius,
            border: Border.all(
              color: active ? color : AppColors.borderLight,
              width: active ? 1.4 : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon,
                      size: 20, color: active ? color : AppColors.textTertiary),
                  const Spacer(),
                  Icon(
                    active
                        ? Icons.radio_button_checked_rounded
                        : Icons.radio_button_unchecked_rounded,
                    size: 18,
                    color: active ? color : AppColors.textDisabled,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.h4.copyWith(
                  color: active ? color : AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                subtitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.caption.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
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
    this.borderColor,
    this.trailing,
  });

  final String label;
  final double? value;
  final String? prefix;
  final String? hint;
  final Color? borderColor;
  final Widget? trailing;
  final ValueChanged<double?> onChanged;

  @override
  State<_TradeNumberField> createState() => _TradeNumberFieldState();
}

class _TradeNumberFieldState extends State<_TradeNumberField> {
  late final TextEditingController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(text: _format(widget.value));
  }

  @override
  void didUpdateWidget(covariant _TradeNumberField oldWidget) {
    super.didUpdateWidget(oldWidget);
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
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final border = widget.borderColor ?? AppColors.borderLight;
    return TextField(
      controller: _ctrl,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
      ],
      style: AppTypography.numeric,
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.hint,
        prefixText: widget.prefix,
        suffixIcon: widget.trailing,
        filled: true,
        fillColor: AppColors.bgCard,
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.cardRadius,
          borderSide: BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.cardRadius,
          borderSide: BorderSide(color: border, width: 1.5),
        ),
      ),
      onChanged: (value) => widget.onChanged(double.tryParse(value)),
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
        borderRadius: BorderRadius.circular(8),
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
                      borderRadius: BorderRadius.circular(6),
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
                              ? AppColors.textPrimary
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

class _MetricStrip extends StatelessWidget {
  const _MetricStrip({required this.items});

  final List<(String, String, Color)> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        borderRadius: AppRadius.cardRadius,
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Wrap(
        spacing: AppSpacing.md,
        runSpacing: AppSpacing.sm,
        children: items
            .map(
              (item) => ConstrainedBox(
                constraints: const BoxConstraints(minWidth: 92),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.$1,
                      style: AppTypography.caption.copyWith(
                        color: AppColors.textTertiary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.$2,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.numericSm.copyWith(color: item.$3),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _OutcomeMiniCard extends StatelessWidget {
  const _OutcomeMiniCard({
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
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.07),
        borderRadius: AppRadius.cardRadius,
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTypography.label.copyWith(color: color)),
          const SizedBox(height: AppSpacing.xs),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: AppTypography.numericLg.copyWith(color: color),
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            caption,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.caption.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel({
    required this.label,
  });

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label.toUpperCase(),
                style: AppTypography.label.copyWith(
                  color: AppColors.textTertiary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
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
  return (form.symbol?.maxLeverage ?? 100).toDouble();
}

Color _leverageColor(double leverage) {
  if (leverage <= 5) return AppColors.profitGreen;
  if (leverage <= 15) return AppColors.warningAmber;
  return AppColors.lossRed;
}

String _amountHelper(TradeFormState form) {
  if (form.amountInputMode == AmountInputMode.quantity) {
    return 'Poise estimates required margin from quantity, entry price, and leverage.';
  }
  if (form.marginMode == MarginMode.percentage) {
    return 'This uses the selected percentage of synced available balance.';
  }
  return 'Poise converts this margin into position size using entry price and leverage.';
}

double _pnlAt(TradeFormState form, double margin, double entry, double price) {
  if (entry <= 0 || margin <= 0) return 0;
  final move = form.side == OrderSide.long
      ? (price - entry) / entry
      : (entry - price) / entry;
  return margin * move * form.leverage;
}

String _roiLabel(TradeFormState form, double entry, double price) {
  if (entry <= 0) return '0.00%';
  final move = form.side == OrderSide.long
      ? (price - entry) / entry
      : (entry - price) / entry;
  return '${(move * form.leverage * 100).toStringAsFixed(2)}%';
}

double _tpMultiplier(OrderSide side, int level) {
  if (side == OrderSide.long) return level == 1 ? 1.04 : 1.08;
  return level == 1 ? 0.96 : 0.92;
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
  if (value >= 1) return value.toStringAsFixed(4);
  return value.toStringAsFixed(6);
}
