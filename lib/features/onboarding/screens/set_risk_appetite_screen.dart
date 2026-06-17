import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/buttons/p_primary_button.dart';
import '../../../core/widgets/feedback/p_success_seal.dart';
import '../../auth/providers/auth_provider.dart';
import '../../billing/providers/billing_provider.dart';
import '../../strategies/data/models/strategy.dart';
import '../../strategies/providers/strategies_provider.dart';

class SetRiskAppetiteScreen extends ConsumerStatefulWidget {
  const SetRiskAppetiteScreen(
      {super.key, this.mode = RiskAppetiteMode.onboarding});

  final RiskAppetiteMode mode;

  @override
  ConsumerState<SetRiskAppetiteScreen> createState() =>
      _SetRiskAppetiteScreenState();
}

class _SetRiskAppetiteScreenState extends ConsumerState<SetRiskAppetiteScreen> {
  int? _selected;
  bool _confirming = false;
  bool _editingSettings = false;
  PButtonState _buttonState = PButtonState.idle;
  bool _initializedFromActive = false;
  CreateStrategyRequest _customRequest = _options.last.request;
  CreateStrategyRequest? _activeRequest;
  _RiskPreset? _appliedPreset;

  // TODO(KAN-19): These preset values are hardcoded defaults. Replace with
  // a backend /strategies/presets or /config endpoint when available.
  static const _options = [
    _RiskPreset(
      label: 'Conservative',
      shortDesc:
          'This option is for users who want to minimize risk and prioritize capital preservation.',
      reviewDesc:
          'This option is for users who want to minimize risk and prioritize capital preservation.',
      request: CreateStrategyRequest(
        name: 'Conservative',
        maxPositionSize: 0.5,
        maxPositionValueUsd: 2000,
        positionSizeType: 'percent_balance',
        dailyLossLimitType: 'percent_balance',
        maxDailyLossUsd: 0,
        maxDailyLossPercent: 1,
        maxWeeklyLossUsd: 5000,
        maxOpenPositions: 5,
        maxTradesPerDay: 5,
        maxConsecutiveLosses: 3,
        sessionStartHour: 7,
        sessionEndHour: 22,
        minRiskRewardRatio: 1.5,
        unfilledOrderCancelAfterMinutes: 60,
        maxLeverage: 4,
        requireExitReason: true,
        requireOtpForExit: true,
      ),
      rows: [
        ('Percentage risk per trade', '0.5% of balance'),
        ('Max leverage per asset', '4x'),
        ('Max trades per day', '5'),
        ('Daily maximum loss', '1% of balance'),
        ('Unfilled entry expires', '1 hour'),
        ('Max concurrent open positions', '5'),
        ('Max consecutive losses in a day', '3'),
      ],
    ),
    _RiskPreset(
      label: 'Balanced',
      shortDesc: 'A practical middle ground for steady disciplined trading.',
      reviewDesc:
          'Balanced rules keep trade sizing controlled while allowing measured opportunities.',
      request: CreateStrategyRequest(
        name: 'Balanced',
        maxPositionSize: 1,
        maxPositionValueUsd: 5000,
        positionSizeType: 'percent_balance',
        dailyLossLimitType: 'percent_balance',
        maxDailyLossUsd: 0,
        maxDailyLossPercent: 2,
        maxWeeklyLossUsd: 5000,
        maxOpenPositions: 5,
        maxTradesPerDay: 8,
        maxConsecutiveLosses: 3,
        sessionStartHour: 7,
        sessionEndHour: 22,
        minRiskRewardRatio: 1.5,
        unfilledOrderCancelAfterMinutes: 120,
        maxLeverage: 10,
        requireExitReason: true,
        requireOtpForExit: true,
      ),
      rows: [
        ('Percentage risk per trade', '1% of balance'),
        ('Max leverage per asset', '10x'),
        ('Max trades per day', '8'),
        ('Daily maximum loss', '2% of balance'),
        ('Unfilled entry expires', '2 hours'),
        ('Max concurrent open positions', '5'),
        ('Max consecutive losses in a day', '3'),
      ],
    ),
    _RiskPreset(
      label: 'Aggressive',
      shortDesc: 'Higher limits for traders who accept larger drawdown risk.',
      reviewDesc:
          'Aggressive rules allow more exposure and require active risk monitoring.',
      request: CreateStrategyRequest(
        name: 'Aggressive',
        maxPositionSize: 2,
        maxPositionValueUsd: 10000,
        positionSizeType: 'percent_balance',
        dailyLossLimitType: 'percent_balance',
        maxDailyLossUsd: 0,
        maxDailyLossPercent: 5,
        maxWeeklyLossUsd: 5000,
        maxOpenPositions: 10,
        maxTradesPerDay: 12,
        maxConsecutiveLosses: 5,
        sessionStartHour: 0,
        sessionEndHour: 0,
        minRiskRewardRatio: 1.2,
        unfilledOrderCancelAfterMinutes: 240,
        maxLeverage: 20,
        requireExitReason: false,
        requireOtpForExit: false,
      ),
      rows: [
        ('Percentage risk per trade', '2% of balance'),
        ('Max leverage per asset', '20x'),
        ('Max trades per day', '12'),
        ('Daily maximum loss', '5% of balance'),
        ('Unfilled entry expires', '4 hours'),
        ('Max concurrent open positions', '10'),
        ('Max consecutive losses in a day', '5'),
      ],
    ),
    _RiskPreset(
      label: 'Customizable',
      shortDesc:
          'Start from balanced defaults and adjust as your rules mature.',
      reviewDesc:
          'Custom rules use balanced defaults for now and can be refined later.',
      request: CreateStrategyRequest(
        name: 'Customizable',
        maxPositionSize: 1,
        maxPositionValueUsd: 5000,
        positionSizeType: 'percent_balance',
        dailyLossLimitType: 'percent_balance',
        maxDailyLossUsd: 0,
        maxDailyLossPercent: 2,
        maxWeeklyLossUsd: 5000,
        maxOpenPositions: 5,
        maxTradesPerDay: 8,
        maxConsecutiveLosses: 3,
        sessionStartHour: 7,
        sessionEndHour: 22,
        minRiskRewardRatio: 1.5,
        unfilledOrderCancelAfterMinutes: 120,
        maxLeverage: 10,
        requireExitReason: true,
        requireOtpForExit: true,
      ),
      rows: [
        ('Percentage risk per trade', '1% of balance'),
        ('Max leverage per asset', '10x'),
        ('Max trades per day', '8'),
        ('Daily maximum loss', '2% of balance'),
        ('Unfilled entry expires', '2 hours'),
        ('Max concurrent open positions', '5'),
        ('Max consecutive losses in a day', '3'),
      ],
    ),
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initializedFromActive) return;
    _initializedFromActive = true;
    final state = ref.read(strategiesNotifierProvider);
    if (state is StrategiesLoaded) {
      final active = state.active;
      if (active != null) _applyActiveStrategy(active);
    } else {
      _initializedFromActive = false;
    }
  }

  Future<void> _confirm() async {
    final request = _requestForSelected();
    setState(() => _buttonState = PButtonState.loading);
    final result = await ref
        .read(strategiesNotifierProvider.notifier)
        .replaceActiveWith(request);
    if (!mounted) return;

    if (result.isErr) {
      setState(() => _buttonState = PButtonState.idle);
      return;
    }

    setState(() => _buttonState = PButtonState.success);
    await Future<void>.delayed(const Duration(milliseconds: 350));
    if (!mounted) return;

    if (widget.mode == RiskAppetiteMode.settings) {
      ref.read(authProvider.notifier).markHasActiveStrategy();
    }

    setState(() {
      _buttonState = PButtonState.idle;
      _confirming = false;
      _appliedPreset = _presetForSelected();
    });
  }

  @override
  Widget build(BuildContext context) {
    final strategies = ref.watch(strategiesNotifierProvider);
    if (widget.mode == RiskAppetiteMode.settings &&
        strategies is StrategiesLoaded &&
        !_initializedFromActive) {
      final active = strategies.active;
      if (active != null) _applyActiveStrategy(active);
      _initializedFromActive = true;
    }
    if (_confirming) return _buildConfirm(context);
    if (_appliedPreset != null) {
      return _RiskAppetiteSuccessScreen(
          preset: _appliedPreset!, mode: widget.mode);
    }
    if (widget.mode == RiskAppetiteMode.settings && !_editingSettings) {
      return _buildSettingsSummary(context);
    }
    return _buildSelect(context);
  }

  Widget _buildSettingsSummary(BuildContext context) {
    final preset = _presetForSelected();
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(
        title: const Text('Risk appetite'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: AppColors.borderLight),
        ),
      ),
      body: SafeArea(
        top: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: AppSpacing.screenPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      'Your Risk Appetite determines the trading rules (Conservative, Balanced, Aggressive, or Custom) that Poise enforces to align every trade with your chosen tolerance.',
                      style: AppTypography.body.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.45,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    _RiskSummaryCard(
                      preset: preset,
                      onEdit: () => setState(() => _editingSettings = true),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, AppSpacing.lg),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton(
                  onPressed: () => setState(() => _editingSettings = true),
                  child: const Text('Change risk appetite'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelect(BuildContext context) {
    if (widget.mode == RiskAppetiteMode.onboarding) {
      return _buildOnboardingSelect(context);
    }

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(
        centerTitle: false,
        title: const Text('Change risk appetite', style: AppTypography.h1),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => setState(() => _editingSettings = false),
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: AppColors.borderLight),
        ),
      ),
      body: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, AppSpacing.sm),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Poise enforces a rule set matched to how you trade. Every trade is checked against these limits before it reaches the exchange.',
                        style: AppTypography.bodySm.copyWith(
                          color: AppColors.textPrimary,
                          height: 1.35,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      ..._options.asMap().entries.map((entry) {
                        final index = entry.key;
                        final option = entry.value;
                        final selected = index == _selected;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                          child: _RiskOnboardingCard(
                            preset: option,
                            selected: selected,
                            onTap: () {
                              if (option.label == 'Customizable') {
                                _showCoreSheet();
                                return;
                              }
                              setState(() => _selected = index);
                            },
                          ).animate(delay: (index * 35).ms).fadeIn().slideY(
                                begin: 0.04,
                                end: 0,
                                curve: Curves.easeOutCubic,
                              ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              PPrimaryButton(
                label: 'Continue',
                height: 44,
                onPressed: _selected == null
                    ? null
                    : () => setState(() => _confirming = true),
              ),
              const SizedBox(height: AppSpacing.sm),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOnboardingSelect(BuildContext context) {
    final selectedPreset = _selected == null
        ? null
        : _SetRiskAppetiteScreenState._options[_selected!];
    final canContinue =
        selectedPreset != null && selectedPreset.label != 'Customizable';

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, AppSpacing.sm),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Set your risk appetite',
                        style: TextStyle(
                          fontFamily: 'Orbitron',
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          height: 1.25,
                          letterSpacing: 0,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        'Poise enforces a rule set matched to how you trade. Every trade is checked against these limits before it reaches the exchange.',
                        style: AppTypography.bodySm.copyWith(
                          color: AppColors.textPrimary,
                          height: 1.35,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      ..._options.asMap().entries.map((entry) {
                        final index = entry.key;
                        final option = entry.value;
                        final selected = index == _selected;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                          child: _RiskOnboardingCard(
                            preset: option,
                            selected: selected,
                            onTap: () => _selectOnboardingPreset(index),
                          ).animate(delay: (index * 35).ms).fadeIn().slideY(
                                begin: 0.04,
                                end: 0,
                                curve: Curves.easeOutCubic,
                              ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              PPrimaryButton(
                label: 'Continue',
                height: 44,
                state: _buttonState,
                onPressed: canContinue && _buttonState == PButtonState.idle
                    ? _confirm
                    : null,
              ),
              const SizedBox(height: AppSpacing.sm),
            ],
          ),
        ),
      ),
    );
  }

  void _selectOnboardingPreset(int index) {
    final option = _options[index];
    if (option.label == 'Customizable') {
      _showCoreSheet();
      return;
    }
    setState(() => _selected = index);
  }

  void _showCoreSheet() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return SafeArea(
          top: false,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(24, 10, 24, 24),
            decoration: const BoxDecoration(
              color: AppColors.bgPrimary,
              borderRadius: AppRadius.sheetRadius,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 48,
                  height: 5,
                  decoration: BoxDecoration(
                    color: AppColors.borderLight,
                    borderRadius: BorderRadius.circular(AppRadius.full),
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                const Text(
                  'Custom guardrails need Poise Core',
                  textAlign: TextAlign.center,
                  style: AppTypography.h2,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Set every guardrail by hand with your own risk caps, leverage, and loss limits. It is part of Poise Core.',
                  textAlign: TextAlign.center,
                  style: AppTypography.body.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                PPrimaryButton(
                  label: 'Upgrade to Poise Core',
                  height: 44,
                  onPressed: () async {
                    Navigator.of(sheetContext).pop();
                    final result = await ref
                        .read(billingControllerProvider)
                        .startCheckout();
                    if (result.isErr && mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(result.error.userMessage)),
                      );
                    }
                  },
                ),
                const SizedBox(height: AppSpacing.md),
                TextButton(
                  onPressed: () => Navigator.of(sheetContext).pop(),
                  child: Text(
                    'Maybe later',
                    style: AppTypography.button.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildConfirm(BuildContext context) {
    final preset = _presetForSelected();
    final canCustomize = preset.label == 'Customizable';
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(
        title: Text(
          widget.mode == RiskAppetiteMode.settings
              ? 'Customize risk settings'
              : 'Risk appetite',
          style: AppTypography.h1,
        ),
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => setState(() => _confirming = false),
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: AppColors.borderLight),
        ),
      ),
      body: SafeArea(
        top: false,
        child: Padding(
          padding: AppSpacing.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Review your ${_riskLabel(preset).toLowerCase()} settings',
                style: AppTypography.bodyLg.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      if (canCustomize)
                        _CustomRiskSettingsForm(
                          request: _customRequest,
                          onChanged: (request) {
                            setState(() => _customRequest = request);
                          },
                        )
                      else
                        _RiskConfirmCard(preset: preset),
                    ],
                  ),
                ),
              ),
              PPrimaryButton(
                label: widget.mode == RiskAppetiteMode.settings
                    ? 'Confirm and save'
                    : 'Confirm configuration',
                state: _buttonState,
                onPressed:
                    _buttonState == PButtonState.loading ? null : _confirm,
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }

  _RiskPreset _presetForSelected() {
    final selected = _selected ?? 1;
    final preset = _options[selected];
    if (widget.mode == RiskAppetiteMode.settings &&
        !_editingSettings &&
        _activeRequest != null) {
      return preset.copyWith(
        request: _activeRequest,
        rows: _rowsForRequest(_activeRequest!),
      );
    }
    if (preset.label != 'Customizable') return preset;
    return preset.copyWith(
      request: _customRequest,
      rows: _rowsForRequest(_customRequest),
    );
  }

  CreateStrategyRequest _requestForSelected() => _presetForSelected().request;

  void _applyActiveStrategy(Strategy strategy) {
    _selected = _indexForStrategy(strategy);
    _activeRequest = _requestFromStrategy(strategy, name: strategy.name);
    if (_selected == _options.length - 1) {
      _customRequest = _requestFromStrategy(strategy, name: 'Customizable');
    }
  }
}

enum RiskAppetiteMode { onboarding, settings }

const _entryExpiryOptions = [30, 60, 120, 240, 720, 0];

int _indexForStrategy(Strategy strategy) {
  final byName = _SetRiskAppetiteScreenState._options.indexWhere(
    (option) => option.label.toLowerCase() == strategy.name.toLowerCase(),
  );
  if (byName != -1) return byName;

  final riskPct = strategy.maxDailyLossPercent;
  if (riskPct != null) {
    if (riskPct <= 1) return 0;
    if (riskPct >= 5) return 2;
  }
  return 1;
}

String _riskLabel(_RiskPreset preset) =>
    preset.label == 'Customizable' ? 'Custom' : preset.label;

String _summaryLabel(String label) {
  return label;
}

CreateStrategyRequest _requestFromStrategy(
  Strategy strategy, {
  required String name,
}) {
  return CreateStrategyRequest(
    name: name,
    maxPositionSize: strategy.maxPositionSize,
    maxPositionValueUsd: strategy.maxPositionValueUsd,
    positionSizeType: strategy.positionSizeType,
    dailyLossLimitType: strategy.dailyLossLimitType,
    maxDailyLossUsd: strategy.maxDailyLossUsd,
    maxDailyLossPercent: strategy.maxDailyLossPercent,
    maxWeeklyLossUsd: strategy.maxWeeklyLossUsd,
    maxOpenPositions: strategy.maxOpenPositions,
    maxTradesPerDay: strategy.maxTradesPerDay,
    maxConsecutiveLosses: strategy.maxConsecutiveLosses,
    sessionStartHour: strategy.sessionStartHour,
    sessionEndHour: strategy.sessionEndHour,
    minRiskRewardRatio: strategy.minRiskRewardRatio,
    unfilledOrderCancelAfterMinutes: strategy.unfilledOrderCancelAfterMinutes,
    maxLeverage: strategy.maxLeverage,
    requireExitReason: strategy.requireExitReason,
    requireOtpForExit: strategy.requireOtpForExit,
  );
}

List<(String, String)> _rowsForRequest(CreateStrategyRequest request) {
  final usesPercent = request.dailyLossLimitType == 'percent_balance';
  return [
    ('Percentage risk per trade', _riskPerTradeValue(request)),
    ('Max leverage per asset', '${_formatNumber(request.maxLeverage)}x'),
    ('Max trades per day', request.maxTradesPerDay.toString()),
    (
      'Daily maximum loss',
      usesPercent
          ? '${_formatNumber(request.maxDailyLossPercent ?? 0)}% of balance'
          : '\$${_formatNumber(request.maxDailyLossUsd)}',
    ),
    (
      'Unfilled entry expires',
      _entryExpiryLabel(request.unfilledOrderCancelAfterMinutes),
    ),
    ('Weekly maximum loss', '\$${_formatNumber(request.maxWeeklyLossUsd)}'),
    ('Max concurrent open positions', request.maxOpenPositions.toString()),
    (
      'Max consecutive losses in a day',
      request.maxConsecutiveLosses.toString(),
    ),
  ];
}

String _riskPerTradeValue(CreateStrategyRequest request) {
  if (request.positionSizeType == 'percent_balance') {
    return '${_formatNumber(request.maxPositionSize)}% of balance';
  }
  return '\$${_formatNumber(request.maxPositionSize)}';
}

String _entryExpiryLabel(int minutes) {
  if (minutes <= 0) return 'Off';
  if (minutes < 60) return '${minutes}m';
  final hours = minutes / 60;
  final whole =
      hours % 1 == 0 ? hours.toInt().toString() : hours.toStringAsFixed(1);
  return '$whole hour${whole == '1' ? '' : 's'}';
}

List<int> _entryExpiryOptionsFor(int selected) {
  if (_entryExpiryOptions.contains(selected)) return _entryExpiryOptions;
  return [selected, ..._entryExpiryOptions];
}

String _formatNumber(num value) {
  if (value % 1 == 0) return value.toInt().toString();
  return value.toStringAsFixed(2).replaceFirst(RegExp(r'\.?0+$'), '');
}

String _onboardingSubtitle(_RiskPreset preset) {
  return switch (preset.label) {
    'Conservative' => 'Capital first. Slow and steady',
    'Balanced' => 'Balanced risk. Consistent growth',
    'Aggressive' => 'High conviction. High stakes',
    'Customizable' => 'Your rules. Your way',
    _ => preset.shortDesc,
  };
}

List<String> _metadataChipsFor(_RiskPreset preset) {
  if (preset.label == 'Customizable') {
    return const ['Manual guardrails'];
  }
  final risk = preset.request.maxDailyLossPercent;
  return [
    'Risk: Up to ${_formatNumber(risk ?? preset.request.maxPositionSize)}%',
    'Leverage ${_formatNumber(preset.request.maxLeverage)}x',
  ];
}

List<(String, String)> _guardrailRows(_RiskPreset preset) {
  return [
    for (final row in preset.rows)
      if (_onboardingGuardrailLabels.contains(row.$1)) row,
  ];
}

const _onboardingGuardrailLabels = {
  'Percentage risk per trade',
  'Max leverage per asset',
  'Max trades per day',
  'Daily maximum loss',
  'Max concurrent open positions',
  'Max consecutive losses in a day',
};

IconData _presetIcon(_RiskPreset preset) {
  return switch (preset.label) {
    'Conservative' => Icons.verified_user_outlined,
    'Balanced' => Icons.balance_rounded,
    'Aggressive' => Icons.bolt_rounded,
    'Customizable' => Icons.tune_rounded,
    _ => Icons.shield_outlined,
  };
}

Color _presetAccent(_RiskPreset preset) {
  return switch (preset.label) {
    'Conservative' => AppColors.profitGreen,
    'Balanced' => AppColors.primary,
    'Aggressive' => AppColors.riskHigh,
    'Customizable' => AppColors.textTertiary,
    _ => AppColors.primary,
  };
}

class _RiskPreset {
  const _RiskPreset({
    required this.label,
    required this.shortDesc,
    required this.reviewDesc,
    required this.request,
    required this.rows,
  });

  final String label;
  final String shortDesc;
  final String reviewDesc;
  final CreateStrategyRequest request;
  final List<(String, String)> rows;

  _RiskPreset copyWith({
    CreateStrategyRequest? request,
    List<(String, String)>? rows,
  }) {
    return _RiskPreset(
      label: label,
      shortDesc: shortDesc,
      reviewDesc: reviewDesc,
      request: request ?? this.request,
      rows: rows ?? this.rows,
    );
  }
}

class _RiskSummaryCard extends StatelessWidget {
  const _RiskSummaryCard({required this.preset, required this.onEdit});

  final _RiskPreset preset;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final visibleRows = [
      for (final row in preset.rows)
        if (_summaryLabels.contains(row.$1)) row,
    ];
    return Container(
      width: double.infinity,
      padding: AppSpacing.cardPadding,
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: AppRadius.cardRadius,
        border: Border.all(color: AppColors.primary, width: 2),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.18),
            blurRadius: 0,
            spreadRadius: 3,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(_riskLabel(preset), style: AppTypography.h4),
          const SizedBox(height: AppSpacing.xs),
          Text(
            preset.label == 'Customizable'
                ? 'Customize your risk settings'
                : preset.shortDesc,
            style: AppTypography.bodySm.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            width: double.infinity,
            height: 44,
            child: OutlinedButton(
              onPressed: onEdit,
              child: const Text('Edit risk settings'),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          ...visibleRows.map(
            (row) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.xs),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: 9,
                ),
                decoration: BoxDecoration(
                  color: AppColors.bgSurface,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        _summaryLabel(row.$1),
                        style: AppTypography.bodySm.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text(row.$2, style: AppTypography.bodyMedium),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static const _summaryLabels = {
    'Percentage risk per trade',
    'Max leverage per asset',
    'Max trades per day',
    'Daily maximum loss',
    'Unfilled entry expires',
    'Weekly maximum loss',
    'Max concurrent open positions',
    'Max consecutive losses in a day',
  };
}

class _RiskOnboardingCard extends StatelessWidget {
  const _RiskOnboardingCard({
    required this.preset,
    required this.selected,
    required this.onTap,
  });

  final _RiskPreset preset;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isCore = preset.label == 'Customizable';
    return AnimatedContainer(
      width: double.infinity,
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOutCubic,
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: AppRadius.cardRadiusLg,
        border: Border.all(
          color: selected ? AppColors.primary : AppColors.borderLight,
          width: selected ? 1.6 : 1,
        ),
        boxShadow: selected
            ? [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.10),
                  blurRadius: 0,
                  spreadRadius: 2,
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: AppRadius.cardRadiusLg,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadius.cardRadiusLg,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _RiskIconTile(preset: preset),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            preset.label,
                            style: AppTypography.bodyMedium.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _onboardingSubtitle(preset),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.caption.copyWith(
                              color: AppColors.textPrimary,
                              height: 1.25,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _RiskRadioMark(selected: selected),
                        if (isCore) ...[
                          const SizedBox(height: AppSpacing.sm),
                          const _CorePill(),
                        ],
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.xs,
                  children: [
                    for (final chip in _metadataChipsFor(preset))
                      _RiskMetadataChip(label: chip),
                  ],
                ),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 180),
                  switchInCurve: Curves.easeOutCubic,
                  switchOutCurve: Curves.easeInCubic,
                  child: selected && !isCore
                      ? _GuardrailValues(
                          key: ValueKey('guardrails-${preset.label}'),
                          rows: _guardrailRows(preset),
                        )
                      : const SizedBox.shrink(key: ValueKey('collapsed')),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RiskIconTile extends StatelessWidget {
  const _RiskIconTile({required this.preset});

  final _RiskPreset preset;

  @override
  Widget build(BuildContext context) {
    final color = _presetAccent(preset);
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(_presetIcon(preset), color: color, size: 22),
    );
  }
}

class _RiskRadioMark extends StatelessWidget {
  const _RiskRadioMark({required this.selected});

  final bool selected;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      width: 18,
      height: 18,
      duration: const Duration(milliseconds: 160),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: selected ? AppColors.primary : AppColors.borderLight,
          width: selected ? 5 : 1.5,
        ),
      ),
    );
  }
}

class _RiskMetadataChip extends StatelessWidget {
  const _RiskMetadataChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.06),
        borderRadius: AppRadius.chipRadius,
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.12)),
      ),
      child: Text(
        label,
        style: AppTypography.labelSm.copyWith(
          color: AppColors.primaryDark,
          fontWeight: FontWeight.w700,
          letterSpacing: 0,
        ),
      ),
    );
  }
}

class _CorePill extends StatelessWidget {
  const _CorePill();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.06),
        borderRadius: AppRadius.chipRadius,
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.28)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.lock_outline_rounded,
              size: 12, color: AppColors.primary),
          const SizedBox(width: 3),
          Text(
            'Core',
            style: AppTypography.labelSm.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w700,
              letterSpacing: 0,
            ),
          ),
        ],
      ),
    );
  }
}

class _GuardrailValues extends StatelessWidget {
  const _GuardrailValues({super.key, required this.rows});

  final List<(String, String)> rows;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: AppSpacing.md),
        const Divider(height: 1, color: AppColors.borderLight),
        const SizedBox(height: AppSpacing.md),
        Text(
          'Guardrail values',
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        ...rows.map(
          (row) => Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
              decoration: BoxDecoration(
                color: AppColors.bgSurface,
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      row.$1,
                      style: AppTypography.caption.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.2,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    row.$2,
                    style: AppTypography.label.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _CustomRiskSettingsForm extends StatefulWidget {
  const _CustomRiskSettingsForm({
    required this.request,
    required this.onChanged,
  });

  final CreateStrategyRequest request;
  final ValueChanged<CreateStrategyRequest> onChanged;

  @override
  State<_CustomRiskSettingsForm> createState() =>
      _CustomRiskSettingsFormState();
}

class _CustomRiskSettingsFormState extends State<_CustomRiskSettingsForm> {
  late final TextEditingController _dailyLossCtrl;
  late final TextEditingController _weeklyLossCtrl;
  late final TextEditingController _riskPerTradeCtrl;
  late final TextEditingController _leverageCtrl;
  late final TextEditingController _tradesCtrl;
  late final TextEditingController _lossesCtrl;
  late final TextEditingController _positionsCtrl;

  @override
  void initState() {
    super.initState();
    final request = widget.request;
    _dailyLossCtrl = TextEditingController(
      text: request.dailyLossLimitType == 'fixed_usd'
          ? _formatNumber(request.maxDailyLossUsd)
          : '',
    );
    _weeklyLossCtrl =
        TextEditingController(text: _formatNumber(request.maxWeeklyLossUsd));
    _riskPerTradeCtrl =
        TextEditingController(text: _formatNumber(request.maxPositionSize));
    _leverageCtrl = TextEditingController(
      text: _formatNumber(request.maxLeverage),
    );
    _tradesCtrl =
        TextEditingController(text: request.maxTradesPerDay.toString());
    _lossesCtrl =
        TextEditingController(text: request.maxConsecutiveLosses.toString());
    _positionsCtrl =
        TextEditingController(text: request.maxOpenPositions.toString());
  }

  @override
  void dispose() {
    _dailyLossCtrl.dispose();
    _weeklyLossCtrl.dispose();
    _riskPerTradeCtrl.dispose();
    _leverageCtrl.dispose();
    _tradesCtrl.dispose();
    _lossesCtrl.dispose();
    _positionsCtrl.dispose();
    super.dispose();
  }

  void _emit(CreateStrategyRequest request) => widget.onChanged(request);

  double _doubleValue(String value, double fallback) {
    final parsed = double.tryParse(value);
    return parsed == null || parsed < 0 ? fallback : parsed;
  }

  int _intValue(String value, int fallback) {
    final parsed = int.tryParse(value);
    return parsed == null || parsed < 0 ? fallback : parsed;
  }

  @override
  Widget build(BuildContext context) {
    final request = widget.request;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Fine-tune your risk settings to align with your investment preferences and trading style.',
          style: AppTypography.bodyLg.copyWith(
            color: AppColors.textPrimary,
            height: 1.45,
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        _RiskInputField(
          label: 'Percentage risk per trade',
          controller: _riskPerTradeCtrl,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          suffix: '%',
          onChanged: (value) => _emit(
            request.copyWith(
              positionSizeType: 'percent_balance',
              maxPositionSize: _doubleValue(value, request.maxPositionSize),
            ),
          ),
        ),
        _RiskInputField(
          label: 'Max leverage per asset',
          controller: _leverageCtrl,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          onChanged: (value) => _emit(
            request.copyWith(
              maxLeverage: _doubleValue(value, request.maxLeverage),
            ),
          ),
        ),
        _RiskInputField(
          label: 'Max trades per day',
          controller: _tradesCtrl,
          keyboardType: TextInputType.number,
          onChanged: (value) => _emit(
            request.copyWith(
              maxTradesPerDay: _intValue(value, request.maxTradesPerDay),
            ),
          ),
        ),
        _EntryExpiryField(
          value: request.unfilledOrderCancelAfterMinutes,
          onChanged: (value) => _emit(
            request.copyWith(unfilledOrderCancelAfterMinutes: value),
          ),
        ),
        _RiskInputField(
          label: 'Daily maximum loss',
          controller: _dailyLossCtrl,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          prefix: '\$',
          onChanged: (value) {
            final amount = _doubleValue(value, 0);
            _emit(request.copyWith(
              dailyLossLimitType: 'fixed_usd',
              maxDailyLossUsd: amount,
              maxDailyLossPercent: null,
            ));
          },
        ),
        _RiskInputField(
          label: 'Weekly maximum loss',
          controller: _weeklyLossCtrl,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          prefix: '\$',
          onChanged: (value) => _emit(
            request.copyWith(
              maxWeeklyLossUsd: _doubleValue(value, request.maxWeeklyLossUsd),
            ),
          ),
        ),
        _RiskInputField(
          label: 'Maximum concurrent open positions',
          controller: _positionsCtrl,
          keyboardType: TextInputType.number,
          onChanged: (value) => _emit(
            request.copyWith(
              maxOpenPositions: _intValue(value, request.maxOpenPositions),
            ),
          ),
        ),
        _RiskInputField(
          label: 'Maximum consecutive losses in a day',
          controller: _lossesCtrl,
          keyboardType: TextInputType.number,
          onChanged: (value) => _emit(
            request.copyWith(
              maxConsecutiveLosses:
                  _intValue(value, request.maxConsecutiveLosses),
            ),
          ),
        ),
      ],
    );
  }
}

class _EntryExpiryField extends StatelessWidget {
  const _EntryExpiryField({
    required this.value,
    required this.onChanged,
  });

  final int value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Unfilled entry expires', style: AppTypography.bodyLg),
          const SizedBox(height: AppSpacing.sm),
          DropdownButtonFormField<int>(
            initialValue: value,
            decoration: const InputDecoration(
              suffixIcon: Tooltip(
                message:
                    'Poise cancels unfilled limit entries after this window.',
                child: Icon(
                  Icons.help_outline_rounded,
                  color: AppColors.textDisabled,
                ),
              ),
            ),
            items: [
              for (final option in _entryExpiryOptionsFor(value))
                DropdownMenuItem<int>(
                  value: option,
                  child: Text(_entryExpiryLabel(option)),
                ),
            ],
            onChanged: (next) {
              if (next != null) onChanged(next);
            },
          ),
        ],
      ),
    );
  }
}

class _RiskInputField extends StatelessWidget {
  const _RiskInputField({
    required this.label,
    required this.controller,
    required this.keyboardType,
    required this.onChanged,
    this.prefix,
    this.suffix,
  });

  final String label;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final ValueChanged<String> onChanged;
  final String? prefix;
  final String? suffix;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTypography.bodyLg),
          const SizedBox(height: AppSpacing.sm),
          TextField(
            controller: controller,
            keyboardType: keyboardType,
            style: AppTypography.bodyLg,
            decoration: InputDecoration(
              prefixText: prefix,
              suffixText: suffix,
              suffixIcon: const Icon(
                Icons.help_outline_rounded,
                color: AppColors.textDisabled,
              ),
            ),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class _RiskConfirmCard extends StatelessWidget {
  const _RiskConfirmCard({required this.preset});

  final _RiskPreset preset;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpacing.cardPadding,
      decoration: BoxDecoration(
        borderRadius: AppRadius.cardRadius,
        border: Border.all(color: AppColors.primary, width: 2),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.18),
            blurRadius: 0,
            spreadRadius: 3,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(_riskLabel(preset), style: AppTypography.h4),
          const SizedBox(height: AppSpacing.xs),
          Text(
            preset.reviewDesc,
            style: AppTypography.bodySm.copyWith(
              color: AppColors.textPrimary,
              height: 1.45,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          ...preset.rows.map(
            (row) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.xs),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: 9,
                ),
                decoration: BoxDecoration(
                  color: AppColors.bgSurface,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Flexible(
                            child: Text(
                              row.$1,
                              style: AppTypography.bodySm.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Tooltip(
                            message: _riskTooltip(row.$1),
                            child: const Icon(
                              Icons.help_outline_rounded,
                              size: 16,
                              color: AppColors.textDisabled,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text(row.$2, style: AppTypography.bodyMedium),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

String _riskTooltip(String label) {
  return switch (label) {
    'Percentage risk per trade' =>
      'The maximum account percentage Poise allows on one trade.',
    'Max leverage per asset' =>
      'The highest leverage allowed when opening a trade.',
    'Max trades per day' => 'The maximum number of trades allowed in one day.',
    'Daily maximum loss' =>
      'The daily loss threshold where Poise stops new trades.',
    'Unfilled entry expires' =>
      'Poise cancels unfilled limit entries after this window.',
    'Max concurrent open positions' =>
      'The maximum number of positions that can stay open at once.',
    'Max consecutive losses in a day' =>
      'The number of same-day losses allowed before trading is blocked.',
    _ => 'This setting helps Poise enforce your trading guardrails.',
  };
}

class _RiskAppetiteSuccessScreen extends ConsumerWidget {
  const _RiskAppetiteSuccessScreen({required this.preset, required this.mode});

  final _RiskPreset preset;
  final RiskAppetiteMode mode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, AppSpacing.sm),
          child: Column(
            children: [
              const Spacer(flex: 3),
              const PSuccessSeal()
                  .animate()
                  .fadeIn(
                    duration: 260.ms,
                  )
                  .scale(
                    begin: const Offset(0.92, 0.92),
                    end: const Offset(1, 1),
                    curve: Curves.easeOutBack,
                  ),
              const SizedBox(height: AppSpacing.xl),
              Text(
                '${_riskLabel(preset)} rules applied',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'Orbitron',
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  height: 1.25,
                  letterSpacing: 0,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Poise will now guard every trade against these limits. You can fine-tune them anytime in Settings.',
                textAlign: TextAlign.center,
                style: AppTypography.bodySm.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.35,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (final chip in _successChipsFor(preset))
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.check_rounded,
                              size: 16,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              chip,
                              style: AppTypography.bodySm.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              const Spacer(flex: 4),
              PPrimaryButton(
                label: mode == RiskAppetiteMode.onboarding
                    ? 'Connect your exchange'
                    : 'Done',
                height: 44,
                onPressed: () {
                  if (mode == RiskAppetiteMode.onboarding) {
                    ref.read(authProvider.notifier).markHasActiveStrategy();
                    context.go('${Routes.exchangeConnections}?from=onboarding');
                  } else {
                    Navigator.of(context).pop();
                  }
                },
              ),
              const SizedBox(height: AppSpacing.sm),
            ],
          ),
        ),
      ),
    );
  }
}

List<String> _successChipsFor(_RiskPreset preset) {
  return [
    '${_dailyLossCapLabel(preset.request)} daily loss cap',
    '${_formatNumber(preset.request.maxLeverage)}x max leverage',
    '${preset.request.maxTradesPerDay} trades / day',
  ];
}

String _dailyLossCapLabel(CreateStrategyRequest request) {
  if (request.dailyLossLimitType == 'percent_balance' &&
      request.maxDailyLossPercent != null) {
    return '${_formatNumber(request.maxDailyLossPercent!)}%';
  }
  return '\$${_formatNumber(request.maxDailyLossUsd)}';
}
