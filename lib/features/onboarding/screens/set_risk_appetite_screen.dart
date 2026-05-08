import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  int? _selected; // 0=Conservative, 1=Moderate, 2=Aggressive
  PButtonState _buttonState = PButtonState.idle;

  static const _options = [
    (
      label: 'Conservative',
      desc: 'Max 1% per trade · 2% daily loss',
      color: AppColors.riskLow,
    ),
    (
      label: 'Moderate',
      desc: 'Max 2% per trade · 5% daily loss',
      color: AppColors.riskMedium,
    ),
    (
      label: 'Aggressive',
      desc: 'Max 5% per trade · 10% daily loss',
      color: AppColors.riskHigh,
    ),
  ];

  // Risk profile presets
  static const _presets = [
    CreateStrategyRequest(
      name: 'Conservative',
      maxPositionSize: 500,
      maxPositionValueUsd: 2000,
      maxDailyLossUsd: 100,
      maxOpenPositions: 3,
      maxLeverage: 5,
      requireExitReason: true,
      requireOtpForExit: true,
    ),
    CreateStrategyRequest(
      name: 'Moderate',
      maxPositionSize: 1000,
      maxPositionValueUsd: 5000,
      maxDailyLossUsd: 250,
      maxOpenPositions: 5,
      maxLeverage: 10,
      requireExitReason: true,
      requireOtpForExit: true,
    ),
    CreateStrategyRequest(
      name: 'Aggressive',
      maxPositionSize: 2500,
      maxPositionValueUsd: 10000,
      maxDailyLossUsd: 500,
      maxOpenPositions: 10,
      maxLeverage: 20,
      requireExitReason: false,
      requireOtpForExit: false,
    ),
  ];

  Future<void> _confirm() async {
    if (_selected == null) return;

    setState(() => _buttonState = PButtonState.loading);

    final result = await ref
        .read(strategiesNotifierProvider.notifier)
        .createAndActivate(_presets[_selected!]);

    if (!mounted) return;

    if (result.isErr) {
      setState(() => _buttonState = PButtonState.idle);
      return;
    }

    setState(() => _buttonState = PButtonState.success);
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const _AppetiteConfiguredSheet(),
    );
    if (!mounted) return;
    final prefs = await ref.read(appPreferencesProvider.future);
    await prefs.setOnboardingComplete();
    if (!mounted) return;
    // Mark strategy active after confirmation; router redirect handles navigation.
    ref.read(authProvider.notifier).markHasActiveStrategy();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.xl),
              const Text('Set your risk\nappetite',
                      style: AppTypography.display2)
                  .animate()
                  .fadeIn(duration: 300.ms)
                  .slideY(begin: 0.08, end: 0, curve: Curves.easeOutCubic),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'We\'ll use this to protect your trades.',
                style: AppTypography.bodyLg
                    .copyWith(color: AppColors.textSecondary),
              )
                  .animate(delay: 80.ms)
                  .fadeIn(duration: 280.ms)
                  .slideY(begin: 0.06, end: 0),
              const SizedBox(height: AppSpacing.xxl),
              ..._options.asMap().entries.map((entry) {
                final i = entry.key;
                final opt = entry.value;
                final isSelected = _selected == i;

                return Padding(
                  padding: EdgeInsets.only(
                    bottom: i < _options.length - 1 ? AppSpacing.sm : 0,
                  ),
                  child: _RiskOptionCard(
                    label: opt.label,
                    desc: opt.desc,
                    accentColor: opt.color,
                    selected: isSelected,
                    onTap: () => setState(() => _selected = i),
                  )
                      .animate(delay: (120 + i * 60).ms)
                      .fadeIn(duration: 280.ms)
                      .slideY(begin: 0.06, end: 0, curve: Curves.easeOutCubic),
                );
              }),
              const Spacer(),
              PPrimaryButton(
                label: 'Confirm',
                state: _buttonState,
                onPressed: _selected != null ? _confirm : null,
              ).animate(delay: 320.ms).fadeIn(duration: 250.ms),
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }
}

class _AppetiteConfiguredSheet extends StatelessWidget {
  const _AppetiteConfiguredSheet();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.all(AppSpacing.sm),
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.lg,
          AppSpacing.lg,
          AppSpacing.xl,
        ),
        decoration: const BoxDecoration(
          color: AppColors.bgPrimary,
          borderRadius: BorderRadius.all(Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const Text('Poise AI', style: AppTypography.h4),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close_rounded),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xxl),
            Center(
              child: Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: AppColors.brand50.withValues(alpha: 0.55),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: AppColors.primary,
                  size: 34,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            const Text(
              'Risk appetite configured',
              textAlign: TextAlign.center,
              style: AppTypography.h2,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Your guardrails are active. Poise will use these limits to review trades before execution.',
              textAlign: TextAlign.center,
              style: AppTypography.body.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            PPrimaryButton(
              label: 'Continue',
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}

class _RiskOptionCard extends StatelessWidget {
  const _RiskOptionCard({
    required this.label,
    required this.desc,
    required this.accentColor,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final String desc;
  final Color accentColor;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        color:
            selected ? accentColor.withValues(alpha: 0.06) : AppColors.bgCard,
        borderRadius: AppRadius.cardRadius,
        border: Border.all(
          color: selected ? accentColor : AppColors.borderLight,
          width: selected ? 1.5 : 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.cardRadius,
        child: Padding(
          padding: AppSpacing.cardPadding,
          child: Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: selected ? accentColor : AppColors.textDisabled,
                    width: selected ? 5 : 1.5,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label, style: AppTypography.h4),
                    const SizedBox(height: 2),
                    Text(
                      desc,
                      style: AppTypography.bodySm
                          .copyWith(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
              if (selected)
                Icon(Icons.check_rounded, color: accentColor, size: 18)
                    .animate()
                    .scale(
                      begin: const Offset(0, 0),
                      end: const Offset(1, 1),
                      duration: 200.ms,
                      curve: Curves.easeOutBack,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
