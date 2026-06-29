import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/errors/app_error.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/result.dart';
import '../../../core/widgets/buttons/p_primary_button.dart';
import '../../../core/widgets/feedback/p_toast.dart';
import '../data/billing_api.dart';
import '../providers/billing_provider.dart';
import '../widgets/billing_feature_list.dart';
import '../widgets/billing_other_options.dart';
import '../widgets/billing_plan_card.dart';
import '../widgets/billing_price_text.dart';
import '../widgets/billing_plan_selector.dart';
import '../widgets/billing_section_label.dart';

class BillingScreen extends ConsumerStatefulWidget {
  const BillingScreen({super.key});

  @override
  ConsumerState<BillingScreen> createState() => _BillingScreenState();
}

class _BillingScreenState extends ConsumerState<BillingScreen>
    with WidgetsBindingObserver {
  BillingCycle _selectedCycle = BillingCycle.yearly;
  PButtonState _buttonState = PButtonState.idle;
  bool _actionInProgress = false;
  bool _selectingSwitchCycle = false;
  bool _refreshBillingOnResume = false;
  bool _checkoutReturnPending = false;
  bool _refreshingBillingReturn = false;
  bool _showCoreActivated = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _refreshBillingOnResume) {
      _refreshAfterBillingReturn();
    }
  }

  @override
  Widget build(BuildContext context) {
    final subscription = ref.watch(billingSubscriptionProvider);
    final sub = subscription.valueOrNull ?? BillingSubscription.none;

    if (_showCoreActivated) {
      return BillingSuccessScreen(
        onViewInsights: () => context.go(Routes.ai),
        onGoHome: () => context.go(Routes.home),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(
        backgroundColor: AppColors.bgPrimary,
        elevation: 0,
        toolbarHeight: 50,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              color: AppColors.textPrimary),
          onPressed: () {
            if (_selectingSwitchCycle) {
              setState(() => _selectingSwitchCycle = false);
              return;
            }
            context.pop();
          },
        ),
        title: Text(
          'Billing & Subscription',
          style: AppTypography.h4.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon:
                const Icon(Icons.error_outline, color: AppColors.textSecondary),
            onPressed: () {},
          ),
        ],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: AppColors.borderLight),
        ),
      ),
      body: SafeArea(
        top: false,
        child: _Body(
          subscription: sub,
          selectedCycle: _selectedCycle,
          selectingSwitchCycle: _selectingSwitchCycle,
          buttonState: _buttonState,
          onCycleChanged: (cycle) => setState(() => _selectedCycle = cycle),
          onStartTrial: () => _startTrial(_selectedCycle),
          onSwitchPlan: () => _confirmSwitchPlan(sub.cycle),
          onConfirmSwitchPlan: _switchPlan,
        ),
      ),
    );
  }

  Future<void> _startTrial(BillingCycle cycle) async {
    if (_actionInProgress || cycle == BillingCycle.none) return;
    _setLoading(true);

    final result =
        await ref.read(billingControllerProvider).startCheckout(cycle);

    await _handleExternalBillingLaunch(result, checkout: true);
  }

  Future<void> _confirmSwitchPlan(BillingCycle currentCycle) async {
    if (_actionInProgress) return;
    final confirmed = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _SwitchPlanSheet(),
    );
    if (!mounted || confirmed != true) return;
    setState(() {
      _selectingSwitchCycle = true;
      _selectedCycle = _alternativeCycle(currentCycle);
    });
  }

  Future<void> _switchPlan() async {
    if (_actionInProgress) return;
    _setLoading(true);

    final result = await ref.read(billingControllerProvider).openPortal();

    await _handleExternalBillingLaunch(result, checkout: false);
  }

  void _setLoading(bool loading) {
    setState(() {
      _actionInProgress = loading;
      _buttonState = loading ? PButtonState.loading : PButtonState.idle;
    });
  }

  Future<void> _handleExternalBillingLaunch(
    Result<void, AppError> result, {
    required bool checkout,
  }) async {
    if (!mounted) return;

    if (result.isErr) {
      PToast.error(context, result.error.userMessage);
      _setLoading(false);
    } else {
      setState(() {
        _refreshBillingOnResume = true;
        _checkoutReturnPending = checkout;
        _selectingSwitchCycle = false;
      });
      _setLoading(false);
      Future<void>.delayed(const Duration(milliseconds: 1200), () {
        if (mounted && _refreshBillingOnResume) {
          _refreshAfterBillingReturn();
        }
      });
    }
  }

  Future<void> _refreshAfterBillingReturn() async {
    if (_refreshingBillingReturn) return;
    _refreshingBillingReturn = true;
    final expectCheckoutCompletion = _checkoutReturnPending;

    try {
      final refreshed =
          await _refreshSubscription(expectEntitled: expectCheckoutCompletion);
      if (!mounted) return;

      setState(() {
        _refreshBillingOnResume = false;
        _checkoutReturnPending = false;
        if (expectCheckoutCompletion && refreshed.entitled) {
          _showCoreActivated = true;
        }
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _refreshBillingOnResume = false;
        _checkoutReturnPending = false;
      });
    } finally {
      _refreshingBillingReturn = false;
    }
  }

  Future<BillingSubscription> _refreshSubscription({
    required bool expectEntitled,
  }) async {
    var latest = BillingSubscription.none;
    for (var attempt = 0; attempt < 4; attempt++) {
      if (attempt > 0) {
        await Future<void>.delayed(const Duration(milliseconds: 1200));
      }
      ref.invalidate(billingSubscriptionProvider);
      latest = await ref.read(billingSubscriptionProvider.future);
      if (!expectEntitled || latest.entitled) break;
    }
    return latest;
  }

  BillingCycle _alternativeCycle(BillingCycle currentCycle) {
    return currentCycle == BillingCycle.monthly
        ? BillingCycle.yearly
        : BillingCycle.monthly;
  }
}

class BillingSuccessScreen extends ConsumerStatefulWidget {
  const BillingSuccessScreen({
    super.key,
    this.onViewInsights,
    this.onGoHome,
  });

  final VoidCallback? onViewInsights;
  final VoidCallback? onGoHome;

  @override
  ConsumerState<BillingSuccessScreen> createState() =>
      _BillingSuccessScreenState();
}

class _BillingSuccessScreenState extends ConsumerState<BillingSuccessScreen> {
  @override
  void initState() {
    super.initState();
    Future<void>.microtask(() {
      ref.invalidate(billingSubscriptionProvider);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Column(
            children: [
              const SizedBox(height: 162),
              Image.asset(
                'assets/images/checkmark.png',
                width: 200,
                height: 200,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 57),
              Text(
                'Poise Core Activated',
                textAlign: TextAlign.center,
                style: AppTypography.h2.copyWith(
                  color: AppColors.textHeading,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Your app is now fully unlocked',
                textAlign: TextAlign.center,
                style: AppTypography.body.copyWith(
                  color: AppColors.textHeading,
                ),
              ),
              const Spacer(),
              PPrimaryButton(
                label: 'View my insights',
                height: 44,
                onPressed: widget.onViewInsights ?? () => context.go(Routes.ai),
              ),
              const SizedBox(height: AppSpacing.sm),
              _SecondaryActionButton(
                label: 'Go to homepage',
                onPressed: widget.onGoHome ?? () => context.go(Routes.home),
              ),
              const SizedBox(height: 41),
            ],
          ),
        ),
      ),
    );
  }
}

class _SecondaryActionButton extends StatelessWidget {
  const _SecondaryActionButton({
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.bgPrimary,
      borderRadius: AppRadius.buttonRadius,
      child: InkWell(
        onTap: onPressed,
        borderRadius: AppRadius.buttonRadius,
        child: Container(
          height: 44,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: AppRadius.buttonRadius,
            border: Border.all(color: const Color(0xFFD0D5DD)),
          ),
          child: Text(
            label,
            style: AppTypography.buttonLg.copyWith(
              color: AppColors.textHeading,
              height: 1.5,
            ),
          ),
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({
    required this.subscription,
    required this.selectedCycle,
    required this.selectingSwitchCycle,
    required this.buttonState,
    required this.onCycleChanged,
    required this.onStartTrial,
    required this.onSwitchPlan,
    required this.onConfirmSwitchPlan,
  });

  final BillingSubscription subscription;
  final BillingCycle selectedCycle;
  final bool selectingSwitchCycle;
  final PButtonState buttonState;
  final ValueChanged<BillingCycle> onCycleChanged;
  final VoidCallback onStartTrial;
  final VoidCallback onSwitchPlan;
  final VoidCallback onConfirmSwitchPlan;

  @override
  Widget build(BuildContext context) {
    final isCore = subscription.entitled;

    if (selectingSwitchCycle) {
      return _SwitchCycleBody(
        selectedCycle: selectedCycle,
        buttonState: buttonState,
        onCycleChanged: onCycleChanged,
        onSwitchPlans: onConfirmSwitchPlan,
      );
    }

    if (!isCore) {
      return _UpgradeBody(
        selectedCycle: selectedCycle,
        buttonState: buttonState,
        onCycleChanged: onCycleChanged,
        onStartTrial: onStartTrial,
      );
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        14,
        AppSpacing.lg,
        AppSpacing.lg,
      ),
      children:
          subscription.isTrialing ? _trialContent() : _activeContent(context),
    );
  }

  List<Widget> _trialContent() {
    return [
      const BillingSectionLabel('Current plan'),
      const SizedBox(height: AppSpacing.md),
      BillingPlanCard(subscription: subscription),
      const SizedBox(height: AppSpacing.xl),
      const BillingFeatureList(),
      const SizedBox(height: AppSpacing.xl),
      BillingOtherOptions(
        currentCycle: subscription.cycle,
        onSwitch: onSwitchPlan,
      ),
      const SizedBox(height: AppSpacing.xxl),
    ];
  }

  List<Widget> _activeContent(BuildContext context) {
    return [
      _ActivePlanCard(subscription: subscription),
      const SizedBox(height: AppSpacing.xl),
      const BillingSectionLabel('Manage plan'),
      const SizedBox(height: AppSpacing.md),
      _ManagePlanRow(
        label: 'Change plan',
        onTap: onSwitchPlan,
      ),
      const SizedBox(height: AppSpacing.sm),
      _ManagePlanRow(
        label: 'Cancel subscription',
        onTap: onConfirmSwitchPlan,
      ),
    ];
  }
}

class _ActivePlanCard extends StatelessWidget {
  const _ActivePlanCard({required this.subscription});

  final BillingSubscription subscription;

  @override
  Widget build(BuildContext context) {
    final isYearly = subscription.cycle == BillingCycle.yearly;

    return Container(
      width: double.infinity,
      height: 184,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.primaryDark,
        borderRadius: AppRadius.cardRadius,
        border: Border.all(color: AppColors.primary),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          const Positioned.fill(child: _ActivePlanPattern()),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isYearly ? 'Annual Plan' : 'Monthly Plan',
                          style: AppTypography.bodyMedium.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Poise Core Features gated',
                          style: AppTypography.bodySm.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const _ActiveBadge(),
                ],
              ),
              const Spacer(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '\$79',
                    style: AppTypography.h1.copyWith(
                      color: Colors.white,
                      fontSize: 28,
                      height: 1,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 2),
                    child: Text(
                      '/ month',
                      style: AppTypography.body.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Divider(
                height: 1,
                color: Colors.white.withValues(alpha: 0.55),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Renews:',
                style: AppTypography.bodySm.copyWith(color: Colors.white),
              ),
              const SizedBox(height: 2),
              Text(
                _billingDate(subscription.currentPeriodEnd),
                style: AppTypography.bodyLg.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActivePlanPattern extends StatelessWidget {
  const _ActivePlanPattern();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _ActivePlanPatternPainter());
  }
}

class _ActivePlanPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withValues(alpha: 0.06)
      ..style = PaintingStyle.fill;

    for (var i = -1; i < 5; i++) {
      final left = size.width * 0.28 + (i * 58);
      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(left, -44, 48, size.height + 80),
        const Radius.circular(4),
      );
      canvas.save();
      canvas.translate(left + 24, size.height / 2);
      canvas.rotate(-0.22);
      canvas.translate(-(left + 24), -size.height / 2);
      canvas.drawRRect(rect, paint);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ActiveBadge extends StatelessWidget {
  const _ActiveBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: const BoxDecoration(
        color: Color(0xFFD1FADF),
        borderRadius: AppRadius.chipRadius,
      ),
      child: Text(
        'Active',
        style: AppTypography.bodySm.copyWith(
          color: const Color(0xFF067647),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _ManagePlanRow extends StatelessWidget {
  const _ManagePlanRow({
    required this.label,
    required this.onTap,
  });

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.bgSurface,
      borderRadius: AppRadius.cardRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.cardRadius,
        child: Container(
          height: 52,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: AppTypography.body.copyWith(
                    color: AppColors.textHeading,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.textPrimary,
                size: 28,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _UpgradeBody extends StatelessWidget {
  const _UpgradeBody({
    required this.selectedCycle,
    required this.buttonState,
    required this.onCycleChanged,
    required this.onStartTrial,
  });

  final BillingCycle selectedCycle;
  final PButtonState buttonState;
  final ValueChanged<BillingCycle> onCycleChanged;
  final VoidCallback onStartTrial;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              14,
              AppSpacing.lg,
              AppSpacing.lg,
            ),
            children: [
              const BillingSectionLabel('Upgrade to Poise Core'),
              const SizedBox(height: AppSpacing.md),
              BillingPlanSelector(
                selectedCycle: selectedCycle,
                onChanged: onCycleChanged,
              ),
              const SizedBox(height: AppSpacing.xl),
              const BillingFeatureList(),
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.sm,
            AppSpacing.lg,
            AppSpacing.lg,
          ),
          child: PPrimaryButton(
            label: 'Start free trial',
            state: buttonState,
            height: 44,
            onPressed: onStartTrial,
          ),
        ),
      ],
    );
  }
}

class _SwitchCycleBody extends StatelessWidget {
  const _SwitchCycleBody({
    required this.selectedCycle,
    required this.buttonState,
    required this.onCycleChanged,
    required this.onSwitchPlans,
  });

  final BillingCycle selectedCycle;
  final PButtonState buttonState;
  final ValueChanged<BillingCycle> onCycleChanged;
  final VoidCallback onSwitchPlans;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              34,
              AppSpacing.lg,
              AppSpacing.lg,
            ),
            children: [
              Text(
                'Select billing cycle',
                style: AppTypography.h1.copyWith(
                  color: AppColors.textHeading,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Unlock all features and maximize your trading discipline',
                style: AppTypography.bodyLg.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.35,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              _CycleOptionCard(
                cycle: BillingCycle.monthly,
                selected: selectedCycle == BillingCycle.monthly,
                onTap: () => onCycleChanged(BillingCycle.monthly),
              ),
              const SizedBox(height: AppSpacing.sm),
              _CycleOptionCard(
                cycle: BillingCycle.yearly,
                selected: selectedCycle == BillingCycle.yearly,
                onTap: () => onCycleChanged(BillingCycle.yearly),
              ),
              const SizedBox(height: AppSpacing.lg),
              const BillingFeatureList(),
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.sm,
            AppSpacing.lg,
            AppSpacing.lg,
          ),
          child: PPrimaryButton(
            label: 'Switch plans',
            state: buttonState,
            height: 44,
            onPressed: onSwitchPlans,
          ),
        ),
      ],
    );
  }
}

class _CycleOptionCard extends StatelessWidget {
  const _CycleOptionCard({
    required this.cycle,
    required this.selected,
    required this.onTap,
  });

  final BillingCycle cycle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isYearly = cycle == BillingCycle.yearly;
    return Material(
      color: selected ? AppColors.billingSelectedBg : AppColors.bgPrimary,
      borderRadius: AppRadius.cardRadiusLg,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.cardRadiusLg,
        child: Container(
          height: 98,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: AppRadius.cardRadiusLg,
            border: Border.all(
              color: selected
                  ? AppColors.billingSelectedBorder
                  : AppColors.borderLight,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isYearly ? 'Yearly' : 'Monthly',
                      style: AppTypography.body.copyWith(
                        color: AppColors.textLabel,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    BillingPriceText(cycle: cycle),
                    const SizedBox(height: 2),
                    Text(
                      isYearly ? 'Equivalent to \$65/month' : 'Billed monthly',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.bodySm.copyWith(
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),
              _CycleRadio(selected: selected),
            ],
          ),
        ),
      ),
    );
  }
}

class _CycleRadio extends StatelessWidget {
  const _CycleRadio({required this.selected});

  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: selected ? AppColors.primary : const Color(0xFFD0D5DD),
          width: 1.5,
        ),
      ),
      child: selected
          ? Center(
              child: Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
            )
          : null,
    );
  }
}

class _SwitchPlanSheet extends StatelessWidget {
  const _SwitchPlanSheet();

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
          padding: const EdgeInsets.fromLTRB(24, 18, 24, 24),
          decoration: const BoxDecoration(
            color: AppColors.bgPrimary,
            borderRadius: BorderRadius.all(Radius.circular(18)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text('Switch Plan', style: AppTypography.h2),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context, false),
                    icon: const Icon(
                      Icons.close_rounded,
                      color: AppColors.textDisabled,
                    ),
                  ),
                ],
              ),
              Image.asset(
                'assets/images/hand-error.png',
                height: 224,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Switch Plan',
                textAlign: TextAlign.center,
                style: AppTypography.h1.copyWith(
                  color: AppColors.textHeading,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Are you sure you want to switch this plan?',
                textAlign: TextAlign.center,
                style: AppTypography.bodyLg.copyWith(
                  color: AppColors.textHeading,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              PPrimaryButton(
                label: 'Continue',
                height: 44,
                onPressed: () => Navigator.pop(context, true),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String _billingDate(DateTime? date) {
  if (date == null) return '-';
  final d = date.toLocal();
  const months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];
  return '${months[d.month - 1]} ${d.day}, ${d.year}';
}
