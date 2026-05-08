import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/router/routes.dart';
import '../../../core/storage/preferences.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/buttons/p_primary_button.dart';
import '../../auth/providers/auth_provider.dart';
import '../../strategies/data/models/strategy.dart';
import '../../strategies/providers/strategies_provider.dart';

class SetRiskAppetiteScreen extends ConsumerStatefulWidget {
  const SetRiskAppetiteScreen({super.key});

  @override
  ConsumerState<SetRiskAppetiteScreen> createState() =>
      _SetRiskAppetiteScreenState();
}

class _SetRiskAppetiteScreenState extends ConsumerState<SetRiskAppetiteScreen> {
  int _selected = 0;
  bool _confirming = false;
  PButtonState _buttonState = PButtonState.idle;

  static const _options = [
    _RiskPreset(
      label: 'Conservative',
      shortDesc:
          'This option is for users who want to minimize risk and prioritize capital preservation.',
      reviewDesc:
          'This appetite is best for experienced traders who understand high market volatility.',
      request: CreateStrategyRequest(
        name: 'Conservative',
        maxPositionSize: 500,
        maxPositionValueUsd: 2000,
        maxDailyLossUsd: 5000,
        maxDailyLossPercent: 1,
        maxWeeklyLossUsd: 10000,
        maxOpenPositions: 5,
        maxTradesPerDay: 5,
        maxConsecutiveLosses: 3,
        sessionStartHour: 7,
        sessionEndHour: 22,
        minRiskRewardRatio: 1.5,
        maxLeverage: 4,
        requireExitReason: true,
        requireOtpForExit: true,
      ),
      rows: [
        ('Percentage risk per trade', '1%'),
        ('Max leverage per asset', '4'),
        ('Daily maximum loss', '\$5,000'),
        ('Weekly maximum loss', '\$10,000'),
        ('Max trades per day', '5'),
        ('Max consecutive losses', '3'),
        ('Minimum risk/reward', '1:1.5'),
        ('Max concurrent open positions', '5'),
        ('Exit reason required', 'Yes'),
        ('OTP required for exit', 'Yes'),
      ],
    ),
    _RiskPreset(
      label: 'Balanced',
      shortDesc: 'A practical middle ground for steady disciplined trading.',
      reviewDesc:
          'Balanced rules keep trade sizing controlled while allowing measured opportunities.',
      request: CreateStrategyRequest(
        name: 'Balanced',
        maxPositionSize: 1000,
        maxPositionValueUsd: 5000,
        maxDailyLossUsd: 5000,
        maxDailyLossPercent: 2,
        maxWeeklyLossUsd: 15000,
        maxOpenPositions: 5,
        maxTradesPerDay: 8,
        maxConsecutiveLosses: 3,
        sessionStartHour: 7,
        sessionEndHour: 22,
        minRiskRewardRatio: 1.5,
        maxLeverage: 10,
        requireExitReason: true,
        requireOtpForExit: true,
      ),
      rows: [
        ('Percentage risk per trade', '2%'),
        ('Max leverage per asset', '10'),
        ('Daily maximum loss', '\$5,000'),
        ('Weekly maximum loss', '\$15,000'),
        ('Max trades per day', '8'),
        ('Max consecutive losses', '3'),
        ('Minimum risk/reward', '1:1.5'),
        ('Max concurrent open positions', '5'),
        ('Exit reason required', 'Yes'),
        ('OTP required for exit', 'Yes'),
      ],
    ),
    _RiskPreset(
      label: 'Aggressive',
      shortDesc: 'Higher limits for traders who accept larger drawdown risk.',
      reviewDesc:
          'Aggressive rules allow more exposure and require active risk monitoring.',
      request: CreateStrategyRequest(
        name: 'Aggressive',
        maxPositionSize: 2500,
        maxPositionValueUsd: 10000,
        maxDailyLossUsd: 10000,
        maxDailyLossPercent: 5,
        maxWeeklyLossUsd: 25000,
        maxOpenPositions: 10,
        maxTradesPerDay: 12,
        maxConsecutiveLosses: 5,
        sessionStartHour: 0,
        sessionEndHour: 0,
        minRiskRewardRatio: 1.2,
        maxLeverage: 20,
        requireExitReason: false,
        requireOtpForExit: false,
      ),
      rows: [
        ('Percentage risk per trade', '5%'),
        ('Max leverage per asset', '20'),
        ('Daily maximum loss', '\$10,000'),
        ('Weekly maximum loss', '\$25,000'),
        ('Max trades per day', '12'),
        ('Max consecutive losses', '5'),
        ('Minimum risk/reward', '1:1.2'),
        ('Max concurrent open positions', '10'),
        ('Exit reason required', 'No'),
        ('OTP required for exit', 'No'),
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
        maxPositionSize: 1000,
        maxPositionValueUsd: 5000,
        maxDailyLossUsd: 5000,
        maxDailyLossPercent: 2,
        maxWeeklyLossUsd: 15000,
        maxOpenPositions: 5,
        maxTradesPerDay: 8,
        maxConsecutiveLosses: 3,
        sessionStartHour: 7,
        sessionEndHour: 22,
        minRiskRewardRatio: 1.5,
        maxLeverage: 10,
        requireExitReason: true,
        requireOtpForExit: true,
      ),
      rows: [
        ('Percentage risk per trade', '2%'),
        ('Max leverage per asset', '10'),
        ('Daily maximum loss', '\$5,000'),
        ('Weekly maximum loss', '\$15,000'),
        ('Max trades per day', '8'),
        ('Max consecutive losses', '3'),
        ('Minimum risk/reward', '1:1.5'),
        ('Max concurrent open positions', '5'),
        ('Exit reason required', 'Yes'),
        ('OTP required for exit', 'Yes'),
      ],
    ),
  ];

  Future<void> _confirm() async {
    final preset = _options[_selected];
    setState(() => _buttonState = PButtonState.loading);
    final result = await ref
        .read(strategiesNotifierProvider.notifier)
        .replaceActiveWith(preset.request);
    if (!mounted) return;

    if (result.isErr) {
      setState(() => _buttonState = PButtonState.idle);
      return;
    }

    setState(() => _buttonState = PButtonState.success);
    await Future<void>.delayed(const Duration(milliseconds: 350));
    if (!mounted) return;
    await Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => const _RiskAppetiteSuccessScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _confirming ? _buildConfirm(context) : _buildSelect(context);
  }

  Widget _buildSelect(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.xl),
              const Text('Risk Appetite', style: AppTypography.h2),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Each risk appetite has specific trading rules that dictate how Poise enforces limits and guardrails.',
                style: AppTypography.body.copyWith(
                  color: AppColors.textPrimary,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              Text(
                'Select an option',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              ..._options.asMap().entries.map((entry) {
                final index = entry.key;
                final option = entry.value;
                final selected = index == _selected;
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: _RiskSelectCard(
                    preset: option,
                    selected: selected,
                    onTap: () => setState(() => _selected = index),
                  ).animate(delay: (index * 45).ms).fadeIn().slideY(
                        begin: 0.06,
                        end: 0,
                        curve: Curves.easeOutCubic,
                      ),
                );
              }),
              const Spacer(),
              PPrimaryButton(
                label: 'Continue',
                onPressed: () => setState(() => _confirming = true),
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConfirm(BuildContext context) {
    final preset = _options[_selected];
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(
        title: const Text('Confirm configuration'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => setState(() => _confirming = false),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  style: AppTypography.body.copyWith(
                    color: AppColors.textPrimary,
                    height: 1.45,
                  ),
                  children: [
                    const TextSpan(
                        text: 'Please review your risk settings for a '),
                    TextSpan(
                      text: '${preset.label} Appetite',
                      style: const TextStyle(color: AppColors.primary),
                    ),
                    const TextSpan(text: ' below.'),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              _RiskConfirmCard(preset: preset),
              const Spacer(),
              PPrimaryButton(
                label: 'Confirm',
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
}

class _RiskSelectCard extends StatelessWidget {
  const _RiskSelectCard({
    required this.preset,
    required this.selected,
    required this.onTap,
  });

  final _RiskPreset preset;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: AppRadius.cardRadius,
        border: Border.all(
          color: selected ? AppColors.primary : AppColors.borderLight,
          width: selected ? 2 : 1,
        ),
        boxShadow: selected
            ? [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.18),
                  blurRadius: 0,
                  spreadRadius: 3,
                ),
              ]
            : null,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.cardRadius,
        child: Padding(
          padding: AppSpacing.cardPadding,
          child: Column(
            crossAxisAlignment:
                selected ? CrossAxisAlignment.start : CrossAxisAlignment.center,
            children: [
              Text(preset.label, style: AppTypography.h4),
              if (selected) ...[
                const SizedBox(height: AppSpacing.xs),
                Text(
                  preset.shortDesc,
                  style: AppTypography.bodySm.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.45,
                  ),
                ),
              ],
            ],
          ),
        ),
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
          Text(preset.label, style: AppTypography.h4),
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
                      child: Text(
                        row.$1,
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
}

class _RiskAppetiteSuccessScreen extends ConsumerWidget {
  const _RiskAppetiteSuccessScreen();

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
                'assets/images/success_rocket.png',
                width: 190,
                height: 190,
                fit: BoxFit.contain,
                filterQuality: FilterQuality.high,
              ).animate().fadeIn(duration: 260.ms).scale(
                    begin: const Offset(0.92, 0.92),
                    end: const Offset(1, 1),
                    curve: Curves.easeOutBack,
                  ),
              const Spacer(),
              const Text(
                'Risk Appetite Successfully Set',
                textAlign: TextAlign.center,
                style: AppTypography.h2,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Click continue below to proceed',
                textAlign: TextAlign.center,
                style: AppTypography.body.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const Spacer(flex: 2),
              PPrimaryButton(
                label: 'Continue',
                onPressed: () async {
                  final prefs = await ref.read(appPreferencesProvider.future);
                  await prefs.setOnboardingComplete();
                  ref.read(authProvider.notifier).markHasActiveStrategy();
                  if (context.mounted) context.go(Routes.home);
                },
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }
}
