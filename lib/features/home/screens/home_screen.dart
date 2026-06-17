import 'dart:async';

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
import '../../../core/websocket/ws_message.dart';
import '../../../core/websocket/ws_service.dart';
import '../../../core/widgets/feedback/p_loading_shimmer.dart';
import '../../auth/providers/auth_provider.dart';
import '../../auth/providers/auth_state.dart';
import '../../notifications/providers/notifications_provider.dart';
import '../../positions/data/models/position.dart';
import '../../profile/widgets/exchange_setup_sheet.dart';
import '../data/home_analytics_api.dart';
import '../providers/home_provider.dart';
import '../providers/home_state.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeProvider);

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: SafeArea(
        child: switch (homeState) {
          HomeLoading() => const _LoadingBody(),
          HomeNoExchange() => _DashboardBody(
              positions: const [],
              summary: const PnlSummary(),
              hasExchange: false,
              onRefresh: () => ref.read(homeProvider.notifier).refresh(),
            ),
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
                PShimmerBox(width: double.infinity, height: 220),
                SizedBox(height: AppSpacing.md),
                PShimmerBox(width: double.infinity, height: 132),
              ],
            ),
          ),
        ),
      ],
    );
  }
}


class _ConnectExchangeSection extends StatelessWidget {
  const _ConnectExchangeSection({required this.onConnect});
  final VoidCallback onConnect;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 16, 14, 16),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.14),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Connect your exchange',
                  style: AppTypography.h4.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Connect exchange to start trading',
                  style: AppTypography.bodySm.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          FilledButton(
            onPressed: onConnect,
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              shape: const StadiumBorder(),
              textStyle: AppTypography.button,
            ),
            child: const Text('Connect'),
          ),
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
    this.hasExchange = true,
  });

  final List<Position> positions;
  final PnlSummary summary;
  final Future<void> Function() onRefresh;
  final bool hasExchange;

  @override
  ConsumerState<_DashboardBody> createState() => _DashboardBodyState();
}

class _DashboardBodyState extends ConsumerState<_DashboardBody> {
  String _period = 'today';
  StreamSubscription<WsMessage>? _wsSub;
  Timer? _analyticsRefreshDebounce;

  @override
  void initState() {
    super.initState();
    _wsSub = ref.read(wsServiceProvider).stream.listen((msg) {
      if (msg is WsPositionUpdate || msg is WsOrderUpdate) {
        _scheduleAnalyticsRefresh();
      }
    });
  }

  @override
  void dispose() {
    _wsSub?.cancel();
    _analyticsRefreshDebounce?.cancel();
    super.dispose();
  }

  void _scheduleAnalyticsRefresh() {
    _analyticsRefreshDebounce?.cancel();
    _analyticsRefreshDebounce = Timer(const Duration(milliseconds: 800), () {
      if (!mounted) return;
      ref.invalidate(homeAnalyticsProvider(_period));
    });
  }

  Future<void> _refreshAll() async {
    ref.invalidate(homeAnalyticsProvider(_period));
    await Future.wait<dynamic>([
      widget.onRefresh(),
      ref.read(homeAnalyticsProvider(_period).future).then<void>(
            (_) {},
            onError: (_, __) {},
          ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final analytics = ref.watch(homeAnalyticsProvider(_period)).valueOrNull;

    return RefreshIndicator(
      color: AppColors.accent,
      onRefresh: _refreshAll,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
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
                  if (!widget.hasExchange) ...[
                    const SizedBox(height: AppSpacing.md),
                    _ConnectExchangeSection(
                      onConnect: () => showExchangeSetupSheet(
                        context,
                        ref,
                        onManualSetup: () =>
                            context.go(Routes.exchangeConnections),
                      ),
                    ),
                  ],
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
                  const _ExploreMoreInsightsSection(),
                ],
              ),
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
    final unreadCount = ref.watch(notificationUnreadCountProvider);

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
        Stack(
          clipBehavior: Clip.none,
          children: [
            IconButton(
              tooltip: 'Notifications',
              onPressed: () => context.go(Routes.notifications),
              icon: const Icon(
                Icons.notifications_none_rounded,
                color: AppColors.textPrimary,
                size: 24,
              ),
            ),
            if (unreadCount > 0)
              Positioned(
                right: 9,
                top: 9,
                child: Container(
                  width: unreadCount > 9 ? 18 : 10,
                  height: unreadCount > 9 ? 18 : 10,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: unreadCount > 9
                      ? Text(
                          '9+',
                          style: AppTypography.labelSm.copyWith(
                            color: Colors.white,
                            fontSize: 8,
                            height: 1,
                          ),
                        )
                      : null,
                ),
              ),
          ],
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
            color: selected ? AppColors.primary : AppColors.textSecondary,
          ),
          side: BorderSide(
            color: selected ? AppColors.primary : AppColors.borderLight,
            width: 1.5,
          ),
          selectedColor: AppColors.primary.withValues(alpha: 0.08),
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
    final hasData =
        analytics != null || positions.isNotEmpty || summary.dayPnl != 0;
    final adherence = hasData
        ? (analytics?.adherenceScore ??
            _adherenceScore(summary, positions.length))
        : 0;
    final pnlColor = AppColors.pnlColor(dayPnl);
    final streak = analytics?.compliantTradeStreak ?? 0;
    final tradesClosedToday = analytics?.tradesClosedToday ??
        summary.positionCount.clamp(positions.length, 999);
    final adherenceChangePct = analytics?.adherenceChangePct ?? 0.0;

    // Left badge: "No trades yet" or "↑/↓ X% vs yesterday"
    final Widget leftBadge;
    if (!hasData) {
      leftBadge = _HeroBadge(
        text: 'No trades yet',
        textColor: AppColors.textSecondary,
        bgColor: Colors.white.withValues(alpha: 0.92),
      );
    } else {
      final isPos = adherenceChangePct >= 0;
      final arrow = isPos ? '↑' : '↓';
      final badgeColor = isPos ? AppColors.profitGreen : AppColors.lossRed;
      leftBadge = _HeroBadge(
        text: '$arrow ${adherenceChangePct.abs().toStringAsFixed(0)}% vs yesterday',
        textColor: badgeColor,
        bgColor: Colors.white.withValues(alpha: 0.92),
      );
    }

    return Container(
      width: double.infinity,
      padding: AppSpacing.cardPaddingLg,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: AppRadius.cardRadiusLg,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.12),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          const Positioned.fill(child: _HeroPattern()),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _HeroMetric(
                      label: 'Adherence score',
                      value: hasData ? '$adherence%' : '—',
                      valueColor: Colors.white,
                      footerWidget: leftBadge,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: _HeroMetric(
                      label: "Today's PnL",
                      value: _money(dayPnl, signed: true),
                      valueColor: pnlColor,
                      footerWidget: Text(
                        '$tradesClosedToday trades closed',
                        style: AppTypography.bodySm.copyWith(
                          color: Colors.white.withValues(alpha: 0.7),
                        ),
                        textAlign: TextAlign.right,
                      ),
                      alignEnd: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              Divider(color: Colors.white.withValues(alpha: 0.28), height: 1),
              const SizedBox(height: AppSpacing.md),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '$streak',
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      height: 1.0,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.local_fire_department_rounded,
                    color: Color(0xFFFF7043),
                    size: 20,
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                hasData
                    ? 'Disciplined trades in a row'
                    : 'Your streak begins with your first disciplined trade',
                style: AppTypography.bodySm.copyWith(
                  color: Colors.white.withValues(alpha: 0.65),
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: 280.ms).slideY(begin: 0.04, end: 0);
  }
}

class _HeroPattern extends StatelessWidget {
  const _HeroPattern();

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.hardEdge,
      children: [
        Positioned(
          right: 24,
          top: -40,
          bottom: -24,
          child: Transform.rotate(
            angle: -0.2,
            child: Container(
              width: 112,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.04),
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ),
        Positioned(
          right: 78,
          top: 42,
          bottom: -48,
          child: Transform.rotate(
            angle: -0.2,
            child: Container(
              width: 96,
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
          bottom: 18,
          child: Transform.rotate(
            angle: -0.2,
            child: Container(
              width: 56,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.035),
                borderRadius: AppRadius.cardRadiusLg,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _HeroMetric extends StatelessWidget {
  const _HeroMetric({
    required this.label,
    required this.value,
    required this.valueColor,
    required this.footerWidget,
    this.alignEnd = false,
  });

  final String label;
  final String value;
  final Color valueColor;
  final Widget footerWidget;
  final bool alignEnd;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          alignEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.bodySm.copyWith(
            color: Colors.white.withValues(alpha: 0.75),
          ),
          textAlign: alignEnd ? TextAlign.right : TextAlign.left,
        ),
        const SizedBox(height: 4),
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
        const SizedBox(height: 6),
        footerWidget,
      ],
    );
  }
}

class _HeroBadge extends StatelessWidget {
  const _HeroBadge({
    required this.text,
    required this.textColor,
    required this.bgColor,
  });

  final String text;
  final Color textColor;
  final Color bgColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: AppTypography.labelSm.copyWith(
          color: textColor,
          fontWeight: FontWeight.w600,
          letterSpacing: 0,
        ),
      ),
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
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextSpan(
                    text: ' if your latest $symbol trade had followed plan.'),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          InkWell(
            onTap: () => context.go(Routes.orders),
            borderRadius: AppRadius.cardRadius,
            child: Container(
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
                            color: AppColors.primary,
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
    final visibleItems = items.take(3).toList();
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
          for (final item in visibleItems) ...[
            _OpportunityCostRow(item: item),
            if (item != visibleItems.last)
              const SizedBox(height: AppSpacing.sm),
          ],
          const SizedBox(height: AppSpacing.sm),
          Center(
            child: TextButton.icon(
              onPressed: () => context.go(Routes.orders),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primary,
                textStyle: AppTypography.bodyMedium,
              ),
              label: const Text('View contributing trades'),
              iconAlignment: IconAlignment.end,
              icon: const Icon(Icons.chevron_right_rounded, size: 18),
            ),
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
    final disciplineTiles = _disciplineTiles(analytics, score);

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
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: AppSpacing.sm,
              mainAxisSpacing: AppSpacing.sm,
              mainAxisExtent: 84,
            ),
            itemCount: disciplineTiles.length,
            itemBuilder: (context, i) => _DisciplineTile(
              label: disciplineTiles[i].label,
              value: '${disciplineTiles[i].value.toStringAsFixed(0)}%',
              color: disciplineTiles[i].color,
            ),
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
    final patterns = analytics?.riskPatterns ?? const <RiskPattern>[];
    final visiblePatterns = patterns.take(3).toList();
    return _SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Current risk pattern', style: AppTypography.h3),
          const SizedBox(height: AppSpacing.md),
          if (visiblePatterns.isNotEmpty)
            for (final pattern in visiblePatterns) ...[
              _PatternRow(
                label: pattern.label,
                status: pattern.status,
                color: _patternColor(pattern.level),
              ),
              if (pattern != visiblePatterns.last)
                const SizedBox(height: AppSpacing.sm),
            ]
          else ...[
            _PatternRow(
              label: 'Trade frequency',
              status: flags.any((f) => f.label.contains('Blocked'))
                  ? 'Elevated'
                  : 'Normal',
              color: flags.any((f) => f.label.contains('Blocked'))
                  ? AppColors.lossRed
                  : AppColors.profitGreen,
            ),
            const SizedBox(height: AppSpacing.sm),
            _PatternRow(
              label: 'Position size variance',
              status: flags.any((f) => f.label.contains('Position size'))
                  ? 'Elevated'
                  : 'Normal',
              color: flags.any((f) => f.label.contains('Position size'))
                  ? AppColors.lossRed
                  : AppColors.profitGreen,
            ),
            const SizedBox(height: AppSpacing.sm),
            _PatternRow(
              label: 'Behaviour after losses',
              status:
                  flags.any((f) => f.label.toLowerCase().contains('revenge'))
                      ? 'Moderate'
                      : 'Normal',
              color: flags.any((f) => f.label.toLowerCase().contains('revenge'))
                  ? AppColors.warningAmber
                  : AppColors.profitGreen,
            ),
          ],
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
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: AppSpacing.sm,
              mainAxisSpacing: AppSpacing.sm,
              mainAxisExtent: 148,
            ),
            itemCount: 4,
            itemBuilder: (context, i) {
              return [
                _GuardrailTile(
                  title: _guardrail(analytics, 'Daily loss limit')?.label ??
                      'Daily loss limit',
                  subtitle:
                      _guardrail(analytics, 'Daily loss limit')?.description ??
                          'Resets at midnight',
                  value: _guardrailValue(
                      _guardrail(analytics, 'Daily loss limit')),
                  progress:
                      _guardrail(analytics, 'Daily loss limit')?.progress ?? 0,
                  color: _guardrailColor(
                    _guardrail(analytics, 'Daily loss limit')?.status,
                  ),
                ),
                _GuardrailTile(
                  title: _guardrail(analytics, 'Weekly loss limit')?.label ??
                      'Weekly loss limit',
                  subtitle:
                      _guardrail(analytics, 'Weekly loss limit')?.description ??
                          'Resets Monday',
                  value: _guardrailValue(
                    _guardrail(analytics, 'Weekly loss limit'),
                    fallback: '\$0 / \$0',
                  ),
                  progress:
                      _guardrail(analytics, 'Weekly loss limit')?.progress ?? 0,
                  color: _guardrailColor(
                    _guardrail(analytics, 'Weekly loss limit')?.status,
                  ),
                ),
                _GuardrailTile(
                  title: 'Consecutive losses',
                  subtitle: "Today's streak",
                  value: _guardrailValue(
                    _guardrail(analytics, 'Consecutive losses'),
                    fallback: 'No limit data',
                  ),
                  progress:
                      _guardrail(analytics, 'Consecutive losses')?.progress ??
                          0,
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
              ][i];
            },
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

class _ExploreMoreInsightsSection extends StatelessWidget {
  const _ExploreMoreInsightsSection();

  @override
  Widget build(BuildContext context) {
    const cards = [
      (
        title: 'Discipline Score Trend',
        subtitle: 'High discipline vs low discipline outcomes',
      ),
      (
        title: 'PnL vs Discipline Mismatch',
        subtitle: 'High discipline vs low discipline outcomes',
      ),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Explore more insights', style: AppTypography.h3),
        const SizedBox(height: AppSpacing.md),
        SizedBox(
          height: 134,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            itemCount: cards.length,
            separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.sm),
            itemBuilder: (context, index) => _InsightPreviewCard(
              title: cards[index].title,
              subtitle: cards[index].subtitle,
              onTap: () => context.go(Routes.orders),
            ),
          ),
        ),
      ],
    );
  }
}

class _InsightPreviewCard extends StatelessWidget {
  const _InsightPreviewCard({
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width - 72;
    return SizedBox(
      width: width.clamp(260.0, 320.0).toDouble(),
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.cardRadiusLg,
        child: Container(
          padding: AppSpacing.cardPadding,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.06),
            borderRadius: AppRadius.cardRadiusLg,
            border: Border.all(color: AppColors.borderLight),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(title, style: AppTypography.bodyMedium),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.bodySm.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    const _StatusPill(
                      label: 'Active',
                      color: AppColors.profitGreen,
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.textSecondary,
              ),
            ],
          ),
        ),
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

class _DisciplineTile extends StatelessWidget {
  const _DisciplineTile({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.numericSm.copyWith(
              color: color,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _OpportunityCostRow extends StatelessWidget {
  const _OpportunityCostRow({required this.item});

  final OpportunityItem item;

  @override
  Widget build(BuildContext context) {
    final symbol = item.symbol.isNotEmpty ? ' - ${item.symbol}' : '';
    final color = item.value < 0 ? AppColors.lossRed : AppColors.profitGreen;
    return Container(
      width: double.infinity,
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
                Text(item.label, style: AppTypography.bodyMedium),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  '${item.count} trade${item.count == 1 ? '' : 's'}$symbol',
                  style: AppTypography.bodySm.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Text(
            _money(item.value),
            style: AppTypography.numericSm.copyWith(
              color: color,
              fontWeight: FontWeight.w800,
            ),
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

List<({String label, double value, Color color})> _disciplineTiles(
  HomeAnalytics? analytics,
  int fallbackScore,
) {
  const labels = [
    'Risk Discipline',
    'Stop Loss Discipline',
    'Take Profit Discipline',
    'Behavioural Discipline',
  ];
  final fallbackValues = <String, double>{
    'Risk Discipline': fallbackScore.toDouble(),
    'Stop Loss Discipline': 100,
    'Take Profit Discipline': fallbackScore.toDouble(),
    'Behavioural Discipline':
        (100 - ((analytics?.disciplineFlags.length ?? 0) * 12))
            .clamp(0, 100)
            .toDouble(),
  };

  return [
    for (final label in labels)
      (
        label: label,
        value: _disciplineMetricValue(analytics, label) ??
            fallbackValues[label] ??
            fallbackScore.toDouble(),
        color: _disciplineMetricColor(
          _disciplineMetricValue(analytics, label) ??
              fallbackValues[label] ??
              fallbackScore.toDouble(),
        ),
      ),
  ];
}

double? _disciplineMetricValue(HomeAnalytics? analytics, String label) {
  final item = analytics?.adherence.items
      .where((metric) => metric.label == label)
      .firstOrNull;
  if (item == null) return null;
  if (item.unit == 'percent') return item.value;
  return item.progress * 100;
}

Color _disciplineMetricColor(double value) {
  if (value >= 80) return AppColors.profitGreen;
  if (value >= 60) return AppColors.warningAmber;
  return AppColors.lossRed;
}

Color _patternColor(String level) {
  return switch (level.toLowerCase()) {
    'elevated' => AppColors.lossRed,
    'moderate' => AppColors.warningAmber,
    _ => AppColors.profitGreen,
  };
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

Color _guardrailColor(String? status) {
  return switch (status) {
    'breached' => AppColors.lossRed,
    'elevated' => AppColors.lossRed,
    'moderate' => AppColors.warningAmber,
    _ => AppColors.profitGreen,
  };
}
