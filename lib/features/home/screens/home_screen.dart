import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/feedback/p_loading_shimmer.dart';
import '../../auth/providers/auth_provider.dart';
import '../../auth/providers/auth_state.dart';
import '../../positions/data/models/position.dart';
import '../data/home_analytics_api.dart';
import '../providers/home_provider.dart';
import '../providers/home_state.dart';
import 'widgets/position_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeProvider);
    final showNewTrade = homeState is! HomeLoading && homeState is! HomeError;

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: showNewTrade
          ? _NewTradeButton(onPressed: () => context.go(Routes.trade))
          : null,
      body: SafeArea(
        child: switch (homeState) {
          HomeLoading() => const _LoadingBody(),
          HomeNoExchange() => const _NoExchangeBody(),
          HomeEmpty(:final summary) => _DashboardBody(
              positions: const [],
              summary: summary,
              onRefresh: () => ref.read(homeProvider.notifier).refresh(),
            ),
          HomeData(:final positions, :final summary) => _DashboardBody(
              positions: positions,
              summary: summary,
              onRefresh: () => ref.read(homeProvider.notifier).refresh(),
            ),
          HomeError(:final message) => _ErrorBody(
              message: message,
              onRetry: () => ref.read(homeProvider.notifier).refresh(),
            ),
        },
      ),
    );
  }
}

class _LoadingBody extends StatelessWidget {
  const _LoadingBody();

  @override
  Widget build(BuildContext context) {
    return const CustomScrollView(
      slivers: [
        SliverPadding(
          padding: AppSpacing.screenPadding,
          sliver: SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: AppSpacing.lg),
                Row(
                  children: [
                    PShimmerBox(
                        width: 56, height: 56, radius: AppRadius.pillRadius),
                    SizedBox(width: AppSpacing.md),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        PShimmerLine(width: 120, height: 20),
                        SizedBox(height: AppSpacing.xs),
                        PShimmerLine(width: 150, height: 18),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: AppSpacing.xl),
                PShimmerBox(width: double.infinity, height: 224),
                SizedBox(height: AppSpacing.md),
                PShimmerBox(width: double.infinity, height: 168),
                SizedBox(height: AppSpacing.md),
                PPositionListShimmer(count: 2),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _NoExchangeBody extends StatelessWidget {
  const _NoExchangeBody();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.screenPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.lg),
          const _HomeHeader(),
          const Spacer(),
          Center(
            child: Column(
              children: [
                const Icon(
                  Icons.link_off_rounded,
                  size: 56,
                  color: AppColors.textDisabled,
                ),
                const SizedBox(height: AppSpacing.md),
                const Text('No exchange connected', style: AppTypography.h3),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Connect your exchange to start seeing live trade guardrails.',
                  style: AppTypography.body.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.xl),
                FilledButton(
                  onPressed: () =>
                      context.go('${Routes.profile}?sheet=exchange'),
                  child: const Text('Connect exchange'),
                ),
              ],
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}

class _DashboardBody extends ConsumerStatefulWidget {
  const _DashboardBody({
    required this.positions,
    required this.summary,
    required this.onRefresh,
  });

  final List<Position> positions;
  final PnlSummary summary;
  final Future<void> Function() onRefresh;

  @override
  ConsumerState<_DashboardBody> createState() => _DashboardBodyState();
}

class _DashboardBodyState extends ConsumerState<_DashboardBody> {
  String _period = 'today';

  @override
  Widget build(BuildContext context) {
    final analytics = ref.watch(homeAnalyticsProvider(_period)).valueOrNull;

    return RefreshIndicator(
      color: AppColors.accent,
      onRefresh: widget.onRefresh,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: AppSpacing.screenPadding,
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AppSpacing.lg),
                  const _HomeHeader(),
                  const SizedBox(height: AppSpacing.xl),
                  _PeriodTabs(
                    selected: _period,
                    onChanged: (period) => setState(() => _period = period),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _AdherenceHero(
                    summary: widget.summary,
                    positions: widget.positions,
                    analytics: analytics,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _CostlyMistakeCard(
                    summary: widget.summary,
                    analytics: analytics,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _OpportunityCostCard(
                    summary: widget.summary,
                    analytics: analytics,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _AdherenceDetailCard(
                    positionCount: widget.positions.length,
                    analytics: analytics,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _RiskPatternCard(analytics: analytics),
                  const SizedBox(height: AppSpacing.md),
                  _GuardrailStatusCard(
                    openPositions: widget.positions.length,
                    analytics: analytics,
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  const Text('Recent Activity', style: AppTypography.h3),
                  const SizedBox(height: AppSpacing.sm),
                ],
              ),
            ),
          ),
          if (widget.positions.isEmpty)
            SliverPadding(
              padding: AppSpacing.screenPadding.copyWith(top: 0),
              sliver: const SliverToBoxAdapter(
                child: _EmptyCurrentTrades(),
              ),
            )
          else
            SliverPadding(
              padding: AppSpacing.screenPadding.copyWith(top: 0),
              sliver: SliverList.separated(
                itemCount: widget.positions.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(height: AppSpacing.sm),
                itemBuilder: (context, i) {
                  final position = widget.positions[i];
                  return PositionCard(
                    position: position,
                    onLockToggle: () =>
                        ref.read(homeProvider.notifier).toggleLock(position.id),
                    onExitTap: () => context.go(
                      Routes.positionExitPath(position.id),
                    ),
                  ).animate(delay: (i * 35).ms).fadeIn(duration: 280.ms).slideY(
                        begin: 0.08,
                        end: 0,
                        curve: Curves.easeOutCubic,
                      );
                },
              ),
            ),
          const SliverToBoxAdapter(child: SizedBox(height: 116)),
        ],
      ),
    );
  }
}

class _HomeHeader extends ConsumerWidget {
  const _HomeHeader();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider).valueOrNull;
    final email = authState is AuthAuthenticated ? authState.email : '';
    final identity = _maskedIdentity(email);
    final initial = email.isNotEmpty ? email[0].toUpperCase() : '?';

    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: const BoxDecoration(
            color: AppColors.bgSecondary,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(
            initial,
            style: AppTypography.h3.copyWith(color: AppColors.textSecondary),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                identity,
                style: AppTypography.h4.copyWith(fontWeight: FontWeight.w700),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                _greeting(),
                style: AppTypography.body.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          tooltip: 'Notifications',
          onPressed: () => context.go(Routes.notifications),
          icon: const Icon(
            Icons.notifications_none_rounded,
            color: AppColors.textPrimary,
            size: 24,
          ),
        ),
      ],
    );
  }

  static String _maskedIdentity(String email) {
    if (email.isEmpty) return 'Poise user';
    final local = email.split('@').first.trim();
    if (local.isEmpty) return 'Poise user';
    final visible = local.length >= 4 ? local.substring(0, 4) : local;
    return '$visible**@***';
  }

  static String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }
}

class _PeriodTabs extends StatelessWidget {
  const _PeriodTabs({
    required this.selected,
    required this.onChanged,
  });

  final String selected;
  final ValueChanged<String> onChanged;
  static const _periods = {
    'today': 'Today',
    'weekly': 'Weekly',
    'custom': 'Custom',
  };

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.sm,
      children: _periods.entries.map((entry) {
        final selected = entry.key == this.selected;
        return ChoiceChip(
          selected: selected,
          showCheckmark: false,
          label: Text(entry.value),
          labelStyle: AppTypography.bodyMedium.copyWith(
            color: selected ? const Color(0xFF0057FF) : AppColors.textSecondary,
          ),
          side: BorderSide(
            color: selected ? const Color(0xFF0057FF) : AppColors.borderLight,
            width: 1.5,
          ),
          selectedColor: const Color(0xFFEAF2FF),
          backgroundColor: AppColors.bgCard,
          shape: const StadiumBorder(),
          onSelected: (_) {
            HapticFeedback.selectionClick();
            onChanged(entry.key);
          },
        );
      }).toList(),
    );
  }
}

class _AdherenceHero extends StatelessWidget {
  const _AdherenceHero({
    required this.summary,
    required this.positions,
    this.analytics,
  });
  final PnlSummary summary;
  final List<Position> positions;
  final HomeAnalytics? analytics;

  @override
  Widget build(BuildContext context) {
    final dayPnl = analytics?.todayPnl ??
        (summary.dayPnl != 0 ? summary.dayPnl : summary.totalUnrealizedPnl);
    final adherence =
        analytics?.adherenceScore ?? _adherenceScore(summary, positions.length);
    final pnlColor = AppColors.pnlColor(dayPnl);

    return Stack(
      children: [
        Container(
          width: double.infinity,
          padding: AppSpacing.cardPaddingLg,
          decoration: BoxDecoration(
            color: const Color(0xFF004CE6),
            borderRadius: AppRadius.cardRadiusLg,
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF0057FF).withValues(alpha: 0.12),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: const _HeroPattern(),
        ),
        Container(
          width: double.infinity,
          padding: AppSpacing.cardPaddingLg,
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _HeroMetric(
                      label: 'Adherence score',
                      value: '$adherence%',
                      valueColor: Colors.white,
                      footer:
                          '${(analytics?.adherenceChangePct ?? 0).toStringAsFixed(0)}% vs yesterday',
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: _HeroMetric(
                      label: 'Today\'s PnL',
                      value: _money(dayPnl, signed: true),
                      valueColor: pnlColor,
                      footer:
                          '${analytics?.tradesClosedToday ?? summary.positionCount.clamp(positions.length, 999)} trades closed',
                      alignEnd: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              Divider(color: Colors.white.withValues(alpha: 0.28), height: 1),
              const SizedBox(height: AppSpacing.lg),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '${analytics?.compliantTradeStreak ?? 0}\nCompliant trades in a row',
                      style: AppTypography.bodyLg.copyWith(
                        color: Colors.white,
                        height: 1.5,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.local_fire_department_rounded,
                    color: Color(0xFFFF7043),
                    size: 36,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ).animate().fadeIn(duration: 280.ms).slideY(begin: 0.04, end: 0);
  }
}

class _HeroPattern extends StatelessWidget {
  const _HeroPattern();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 176,
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          Positioned(
            right: 24,
            top: -24,
            child: Transform.rotate(
              angle: -0.2,
              child: Container(
                width: 112,
                height: 180,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.04),
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),
          Positioned(
            right: 78,
            bottom: -36,
            child: Transform.rotate(
              angle: -0.2,
              child: Container(
                width: 96,
                height: 170,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),
          Positioned(
            left: 110,
            top: 16,
            child: Transform.rotate(
              angle: -0.2,
              child: Container(
                width: 56,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.035),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroMetric extends StatelessWidget {
  const _HeroMetric({
    required this.label,
    required this.value,
    required this.valueColor,
    required this.footer,
    this.alignEnd = false,
  });

  final String label;
  final String value;
  final Color valueColor;
  final String footer;
  final bool alignEnd;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          alignEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.body.copyWith(color: Colors.white),
          textAlign: alignEnd ? TextAlign.right : TextAlign.left,
        ),
        const SizedBox(height: AppSpacing.sm),
        FittedBox(
          alignment: alignEnd ? Alignment.centerRight : Alignment.centerLeft,
          fit: BoxFit.scaleDown,
          child: Text(
            value,
            style: AppTypography.display1.copyWith(
              color: valueColor,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.xs,
          ),
          decoration: BoxDecoration(
            color: alignEnd
                ? Colors.transparent
                : AppColors.profitGreen.withValues(alpha: 0.12),
            borderRadius: AppRadius.pillRadius,
          ),
          child: Text(
            footer,
            style: AppTypography.bodyMedium.copyWith(
              color: alignEnd ? Colors.white : const Color(0xFF087D55),
            ),
            textAlign: alignEnd ? TextAlign.right : TextAlign.left,
          ),
        ),
      ],
    );
  }
}

class _CostlyMistakeCard extends StatelessWidget {
  const _CostlyMistakeCard({required this.summary, this.analytics});
  final PnlSummary summary;
  final HomeAnalytics? analytics;

  @override
  Widget build(BuildContext context) {
    final mistake = analytics?.mostCostlyMistake;
    if (mistake == null) {
      return const _SectionCard(
        child: _NoAnalyticsMessage(
          title: 'Most costly mistake',
          message: 'No completed trade mistakes have been detected yet.',
        ),
      );
    }
    final missed = mistake.missedPnl;
    final symbol = mistake.symbol.isNotEmpty ? mistake.symbol : 'Unknown pair';
    final reason = mistake.reason;
    return _SectionCard(
      borderColor: AppColors.lossRed.withValues(alpha: 0.28),
      backgroundColor: AppColors.lossRed.withValues(alpha: 0.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Most costly mistake', style: AppTypography.h3),
          const SizedBox(height: AppSpacing.xs),
          RichText(
            text: TextSpan(
              style:
                  AppTypography.bodyLg.copyWith(color: AppColors.textSecondary),
              children: [
                const TextSpan(text: 'You would have earned an extra '),
                TextSpan(
                  text: _money(missed, signed: true),
                  style: const TextStyle(
                    color: Color(0xFF0057FF),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextSpan(
                    text: ' if your latest $symbol trade had followed plan.'),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Container(
            width: double.infinity,
            padding: AppSpacing.cardPadding,
            decoration: const BoxDecoration(
              color: AppColors.bgCard,
              borderRadius: AppRadius.cardRadius,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${_money(missed, signed: true)} missed',
                        style: AppTypography.h2.copyWith(
                          color: AppColors.profitGreen,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        '$symbol - latest',
                        style: AppTypography.body.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        'Tap to view trade',
                        style: AppTypography.bodyMedium.copyWith(
                          color: const Color(0xFF0057FF),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                _StatusPill(
                  label: reason,
                  color: AppColors.warningAmber,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OpportunityCostCard extends StatelessWidget {
  const _OpportunityCostCard({required this.summary, this.analytics});
  final PnlSummary summary;
  final HomeAnalytics? analytics;

  @override
  Widget build(BuildContext context) {
    final cost = analytics?.opportunityCostTotal ?? 0;
    final items = analytics?.opportunityItems ?? const [];
    final first = items.isNotEmpty ? items[0] : null;
    final second = items.length > 1 ? items[1] : null;
    if (first == null && second == null) {
      return const _SectionCard(
        child: _NoAnalyticsMessage(
          title: 'Opportunity cost',
          message: 'No opportunity-cost events have been measured yet.',
        ),
      );
    }
    return _SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Opportunity cost', style: AppTypography.h3),
                    Text(
                      'What your decisions cost today',
                      style: AppTypography.body.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                _money(cost),
                style: AppTypography.numericLg.copyWith(
                  color: AppColors.lossRed,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: _SmallInsightCard(
                  title: first?.label ?? 'Early exit',
                  subtitle:
                      '${first?.count ?? 0} trade - ${first?.symbol.isNotEmpty == true ? first!.symbol : 'Unknown pair'}',
                  value: _money(first?.value ?? 0),
                  color: const Color(0xFFD46A00),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _SmallInsightCard(
                  title: second?.label ?? 'Outside session',
                  subtitle:
                      '${second?.count ?? 0} trade - ${second?.symbol.isNotEmpty == true ? second!.symbol : 'Unknown pair'}',
                  value: _money(second?.value ?? 0),
                  color: AppColors.lossRed,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AdherenceDetailCard extends StatelessWidget {
  const _AdherenceDetailCard({required this.positionCount, this.analytics});
  final int positionCount;
  final HomeAnalytics? analytics;

  @override
  Widget build(BuildContext context) {
    final score = analytics?.adherenceScore ??
        _adherenceScore(const PnlSummary(), positionCount);
    final pct = score / 100.0;
    final label = score >= 80
        ? 'Excellent'
        : score >= 65
            ? 'Good'
            : 'Fair';
    final color = score >= 80
        ? AppColors.profitGreen
        : score >= 65
            ? AppColors.warningAmber
            : AppColors.lossRed;

    return _SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Today\'s adherence', style: AppTypography.h3),
          const SizedBox(height: AppSpacing.md),
          Center(
            child: SizedBox(
              width: 172,
              height: 172,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CircularProgressIndicator(
                    value: pct,
                    strokeWidth: 18,
                    strokeCap: StrokeCap.round,
                    backgroundColor: AppColors.bgSecondary,
                    color: color,
                  ),
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          label,
                          style: AppTypography.bodyMedium.copyWith(
                            color: color,
                          ),
                        ),
                        Text('$score%', style: AppTypography.numericLg),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          GridView.count(
            crossAxisCount: 2,
            childAspectRatio: 2.4,
            crossAxisSpacing: AppSpacing.sm,
            mainAxisSpacing: AppSpacing.sm,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _AdherenceTile(
                label: 'Daily loss limit',
                value: _guardrailProgress(analytics, 'Daily loss limit'),
                progress:
                    _guardrail(analytics, 'Daily loss limit')?.progress ?? 0,
                color: _guardrailColor(
                    _guardrail(analytics, 'Daily loss limit')?.status),
              ),
              _AdherenceTile(
                label: 'Trades today',
                value: '${analytics?.tradesClosedToday ?? 0}',
                progress: score / 100.0,
                color: color,
              ),
              _AdherenceTile(
                label: 'Open positions',
                value: '$positionCount',
                progress: (_guardrail(analytics, 'Open positions')?.progress ??
                    (positionCount / 5).clamp(0, 1).toDouble()),
                color: AppColors.profitGreen,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          _SnapshotStatusRow(
            metric: _guardrail(analytics, 'Balance snapshot'),
          ),
        ],
      ),
    );
  }
}

class _RiskPatternCard extends StatelessWidget {
  const _RiskPatternCard({this.analytics});
  final HomeAnalytics? analytics;

  @override
  Widget build(BuildContext context) {
    final flags = analytics?.disciplineFlags ?? const <DisciplineFlag>[];
    final source = analytics?.sourceBreakdown;
    return _SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Current risk pattern', style: AppTypography.h3),
          const SizedBox(height: AppSpacing.md),
          _PatternRow(
              label: 'Trade frequency',
              status: flags.any((f) => f.label.contains('Blocked'))
                  ? 'Elevated'
                  : 'Normal',
              color: flags.any((f) => f.label.contains('Blocked'))
                  ? AppColors.lossRed
                  : AppColors.profitGreen),
          const SizedBox(height: AppSpacing.sm),
          _PatternRow(
              label: 'Position size variance',
              status: flags.any((f) => f.label.contains('Position size'))
                  ? 'Elevated'
                  : 'Normal',
              color: flags.any((f) => f.label.contains('Position size'))
                  ? AppColors.lossRed
                  : AppColors.profitGreen),
          const SizedBox(height: AppSpacing.sm),
          _PatternRow(
            label: 'Behaviour after losses',
            status: flags.any((f) => f.label.toLowerCase().contains('revenge'))
                ? 'Moderate'
                : 'Normal',
            color: flags.any((f) => f.label.toLowerCase().contains('revenge'))
                ? AppColors.warningAmber
                : AppColors.profitGreen,
          ),
          const SizedBox(height: AppSpacing.sm),
          _PatternRow(
            label: 'External trade review',
            status: (source?.externalOpen ?? 0) > 0
                ? '${source!.externalOpen} open'
                : 'Clear',
            color: (source?.externalOpen ?? 0) > 0
                ? AppColors.warningAmber
                : AppColors.profitGreen,
          ),
          const SizedBox(height: AppSpacing.md),
          if (flags.isEmpty)
            const _NoAnalyticsMessage(
              title: 'No risk pattern detected',
              message:
                  'Poise will show patterns after enough trade history is available.',
            )
          else
            ...flags.take(2).map(
                  (flag) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: _DisciplineFlagCallout(flag: flag),
                  ),
                ),
        ],
      ),
    );
  }
}

class _DisciplineFlagCallout extends StatelessWidget {
  const _DisciplineFlagCallout({required this.flag});
  final DisciplineFlag flag;

  @override
  Widget build(BuildContext context) {
    final color = flag.severity == 'elevated'
        ? AppColors.lossRed
        : AppColors.warningAmber;
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
          Text(flag.label,
              style: AppTypography.bodyMedium.copyWith(color: color)),
          const SizedBox(height: AppSpacing.xs),
          Text(
            flag.description,
            style: AppTypography.body.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}

class _GuardrailStatusCard extends StatelessWidget {
  const _GuardrailStatusCard({required this.openPositions, this.analytics});
  final int openPositions;
  final HomeAnalytics? analytics;

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppColors.profitGreen,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              const Text('Live guardrail status', style: AppTypography.h3),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          GridView.count(
            crossAxisCount: 2,
            childAspectRatio: 1.22,
            crossAxisSpacing: AppSpacing.sm,
            mainAxisSpacing: AppSpacing.sm,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _GuardrailTile(
                title: _guardrail(analytics, 'Daily loss limit')?.label ??
                    'Daily loss limit',
                subtitle:
                    _guardrail(analytics, 'Daily loss limit')?.description ??
                        'Resets at midnight',
                value:
                    _guardrailValue(_guardrail(analytics, 'Daily loss limit')),
                progress:
                    _guardrail(analytics, 'Daily loss limit')?.progress ?? 0,
                color: _guardrailColor(
                  _guardrail(analytics, 'Daily loss limit')?.status,
                ),
              ),
              _GuardrailTile(
                title: 'Consecutive losses',
                subtitle: 'Today\'s streak',
                value: _guardrailValue(
                  _guardrail(analytics, 'Consecutive losses'),
                  fallback: 'No limit data',
                ),
                progress:
                    _guardrail(analytics, 'Consecutive losses')?.progress ?? 0,
                color: _guardrailColor(
                  _guardrail(analytics, 'Consecutive losses')?.status,
                ),
              ),
              _GuardrailTile(
                title: 'Trades today',
                subtitle: 'Max per day',
                value: _guardrailValue(
                  _guardrail(analytics, 'Trades today'),
                  fallback: '${analytics?.tradesClosedToday ?? 0}',
                ),
                progress: _guardrail(analytics, 'Trades today')?.progress ??
                    ((analytics?.tradesClosedToday ?? 0) / 5)
                        .clamp(0, 1)
                        .toDouble(),
                color: _guardrailColor(
                  _guardrail(analytics, 'Trades today')?.status,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          _SnapshotStatusRow(
            metric: _guardrail(analytics, 'Balance snapshot'),
          ),
          const SizedBox(height: AppSpacing.sm),
          _WideGuardrailTile(
            title: 'Open positions',
            subtitle: 'Concurrent limit',
            value: _guardrailValue(
              _guardrail(analytics, 'Open positions'),
              fallback: '$openPositions',
            ),
            progress: _guardrail(analytics, 'Open positions')?.progress ??
                (openPositions / 5).clamp(0, 1).toDouble(),
            color: _guardrailColor(
              _guardrail(analytics, 'Open positions')?.status,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.child,
    this.borderColor = AppColors.borderLight,
    this.backgroundColor = AppColors.bgCard,
  });

  final Widget child;
  final Color borderColor;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: AppSpacing.cardPadding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: AppRadius.cardRadiusLg,
        border: Border.all(color: borderColor),
      ),
      child: child,
    );
  }
}

class _NoAnalyticsMessage extends StatelessWidget {
  const _NoAnalyticsMessage({
    required this.title,
    required this.message,
  });

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTypography.h3),
        const SizedBox(height: AppSpacing.xs),
        Text(
          message,
          style: AppTypography.body.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }
}

class _SmallInsightCard extends StatelessWidget {
  const _SmallInsightCard({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.color,
  });

  final String title;
  final String subtitle;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpacing.cardPadding,
      decoration: const BoxDecoration(
        color: AppColors.bgPrimary,
        borderRadius: AppRadius.cardRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTypography.bodyMedium),
          const SizedBox(height: AppSpacing.xs),
          Text(
            subtitle,
            style: AppTypography.bodySm.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(value, style: AppTypography.numericMd.copyWith(color: color)),
        ],
      ),
    );
  }
}

class _AdherenceTile extends StatelessWidget {
  const _AdherenceTile({
    required this.label,
    required this.value,
    required this.color,
    required this.progress,
  });

  final String label;
  final String value;
  final Color color;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: const BoxDecoration(
        color: AppColors.bgPrimary,
        borderRadius: AppRadius.cardRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Expanded(child: Text(label, style: AppTypography.bodyMedium)),
              Text(value, style: AppTypography.numericSm),
            ],
          ),
          LinearProgressIndicator(
            value: progress.clamp(0.0, 1.0),
            minHeight: 4,
            borderRadius: AppRadius.pillRadius,
            color: color,
            backgroundColor: AppColors.borderLight,
          ),
        ],
      ),
    );
  }
}

class _PatternRow extends StatelessWidget {
  const _PatternRow({
    required this.label,
    required this.status,
    required this.color,
  });

  final String label;
  final String status;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: const BoxDecoration(
        color: AppColors.bgPrimary,
        borderRadius: AppRadius.cardRadius,
      ),
      child: Row(
        children: [
          Expanded(child: Text(label, style: AppTypography.body)),
          _StatusPill(label: status, color: color),
        ],
      ),
    );
  }
}

class _SnapshotStatusRow extends StatelessWidget {
  const _SnapshotStatusRow({required this.metric});

  final GuardrailMetric? metric;

  @override
  Widget build(BuildContext context) {
    final complete = metric?.status == 'normal';
    final color = complete ? AppColors.textTertiary : AppColors.warningAmber;
    return Row(
      children: [
        Icon(
          complete ? Icons.check_circle_outline_rounded : Icons.sync_rounded,
          size: 16,
          color: color,
        ),
        const SizedBox(width: AppSpacing.xs),
        Expanded(
          child: Text(
            metric?.description ?? 'UTC all-exchange baseline syncing',
            style: AppTypography.caption.copyWith(color: color),
          ),
        ),
      ],
    );
  }
}

class _GuardrailTile extends StatelessWidget {
  const _GuardrailTile({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.progress,
    required this.color,
  });

  final String title;
  final String subtitle;
  final String value;
  final double progress;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpacing.cardPadding,
      decoration: const BoxDecoration(
        color: AppColors.bgPrimary,
        borderRadius: AppRadius.cardRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTypography.bodyMedium),
          Text(
            subtitle,
            style:
                AppTypography.bodySm.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(value, style: AppTypography.numericSm),
          const SizedBox(height: AppSpacing.sm),
          _SegmentBar(value: progress, color: color),
        ],
      ),
    );
  }
}

class _WideGuardrailTile extends StatelessWidget {
  const _WideGuardrailTile({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.progress,
    required this.color,
  });

  final String title;
  final String subtitle;
  final String value;
  final double progress;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpacing.cardPadding,
      decoration: const BoxDecoration(
        color: AppColors.bgPrimary,
        borderRadius: AppRadius.cardRadius,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.bodyMedium),
                Text(
                  subtitle,
                  style: AppTypography.bodySm.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          SizedBox(
            width: 150,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(value, style: AppTypography.numericSm),
                const SizedBox(height: AppSpacing.sm),
                _SegmentBar(value: progress, color: color),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SegmentBar extends StatelessWidget {
  const _SegmentBar({required this.value, required this.color});
  final double value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final active = (value.clamp(0.0, 1.0) * 12).ceil();
    return Row(
      children: List.generate(12, (index) {
        return Expanded(
          child: Container(
            height: 8,
            margin: EdgeInsets.only(right: index == 11 ? 0 : 3),
            decoration: BoxDecoration(
              color: index < active ? color : AppColors.borderLight,
              borderRadius: AppRadius.pillRadius,
            ),
          ),
        );
      }),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.label, required this.color});
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: AppRadius.pillRadius,
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Text(
        label,
        style: AppTypography.bodyMedium.copyWith(color: color),
      ),
    );
  }
}

class _EmptyCurrentTrades extends StatelessWidget {
  const _EmptyCurrentTrades();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: AppSpacing.cardPaddingLg,
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: AppRadius.cardRadiusLg,
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.inventory_2_outlined,
            size: 42,
            color: AppColors.textDisabled,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'No activity yet',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _NewTradeButton extends StatelessWidget {
  const _NewTradeButton({required this.onPressed});
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.screenH,
      child: SizedBox(
        width: double.infinity,
        height: 48,
        child: FilledButton.icon(
          onPressed: onPressed,
          icon: const Icon(Icons.add_rounded, size: 20),
          label: const Text('New Trade'),
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFF0057FF),
            foregroundColor: Colors.white,
            textStyle: AppTypography.buttonLg,
            shape: const StadiumBorder(),
          ),
        ),
      ),
    );
  }
}

class _ErrorBody extends StatelessWidget {
  const _ErrorBody({required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.screenPadding,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.wifi_off_rounded,
            size: 56,
            color: AppColors.textDisabled,
          ),
          const SizedBox(height: AppSpacing.md),
          const Text('Unable to load', style: AppTypography.h3),
          const SizedBox(height: AppSpacing.xs),
          Text(
            message,
            style: AppTypography.body.copyWith(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xl),
          FilledButton(
            onPressed: onRetry,
            child: const Text('Try again'),
          ),
        ],
      ),
    );
  }
}

int _adherenceScore(PnlSummary summary, int openPositions) {
  final base = summary.dayPnl >= 0 ? 74 : 62;
  return (base - openPositions.clamp(0, 5)).clamp(45, 96);
}

String _money(double value, {bool signed = false}) {
  final sign = signed && value >= 0
      ? '+'
      : value < 0
          ? '-'
          : '';
  return '$sign\$${value.abs().toStringAsFixed(0)}';
}

GuardrailMetric? _guardrail(HomeAnalytics? analytics, String label) {
  final guardrails = analytics?.guardrails ?? const [];
  for (final item in guardrails) {
    if (item.label == label) return item;
  }
  return null;
}

String _guardrailValue(GuardrailMetric? metric, {String? fallback}) {
  if (metric == null) return fallback ?? '\$0 / \$0';
  if (metric.unit == 'status') {
    return metric.status == 'normal' ? 'Complete' : 'Incomplete';
  }
  if (metric.unit == 'usd') {
    return '${_money(metric.value)} / ${_money(metric.limit)}';
  }
  return '${metric.value.toStringAsFixed(0)} / ${metric.limit.toStringAsFixed(0)}';
}

String _guardrailProgress(HomeAnalytics? analytics, String label) {
  final g = _guardrail(analytics, label);
  if (g == null) return '—';
  return '${(g.progress * 100).toStringAsFixed(0)}%';
}

Color _guardrailColor(String? status) {
  return switch (status) {
    'breached' => AppColors.lossRed,
    'elevated' => AppColors.lossRed,
    'moderate' => AppColors.warningAmber,
    _ => AppColors.profitGreen,
  };
}
