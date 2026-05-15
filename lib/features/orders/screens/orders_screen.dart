import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/errors/app_error.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/feedback/p_empty_state.dart';
import '../../../core/widgets/feedback/p_error_state.dart';
import '../../../core/utils/result.dart';
import '../data/models/order.dart';
import '../data/orders_api.dart';
import '../providers/orders_provider.dart';

class OrdersScreen extends ConsumerStatefulWidget {
  const OrdersScreen({super.key});

  @override
  ConsumerState<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends ConsumerState<OrdersScreen> {
  var _tab = _OrdersTab.open;

  @override
  Widget build(BuildContext context) {
    final ordersState = ref.watch(ordersNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(
        title: const Text('Trades'),
        actions: [
          IconButton(
            tooltip: 'New trade',
            onPressed: () => context.go(Routes.trade),
            icon: const Icon(Icons.add_rounded),
          ),
        ],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: AppColors.borderLight),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _NewTradeButton(
        onPressed: () => context.go(Routes.trade),
      ),
      body: SafeArea(
        top: false,
        child: ordersState.when(
          loading: () => const _OrdersLoading(),
          error: (error, _) => PErrorState(
            message: error.toString(),
            onRetry: () => ref.read(ordersNotifierProvider.notifier).refresh(),
          ),
          data: (orders) {
            final visible =
                orders.where((order) => _tab.matches(order)).toList();
            if (orders.isEmpty) {
              return PEmptyState(
                title: 'No trades yet',
                subtitle:
                    'Validated Poise trades and synced exchange trades will appear here.',
                ctaLabel: 'New Trade',
                onCtaTap: () => context.go(Routes.trade),
              );
            }

            return RefreshIndicator(
              color: AppColors.accent,
              onRefresh: () =>
                  ref.read(ordersNotifierProvider.notifier).refresh(),
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: _OrdersHeader(
                      tab: _tab,
                      onTabChanged: (tab) => setState(() => _tab = tab),
                    ),
                  ),
                  if (visible.isEmpty)
                    SliverPadding(
                      padding: AppSpacing.screenPadding.copyWith(top: 0),
                      sliver: SliverToBoxAdapter(
                        child: PEmptyState(
                          title: _tab == _OrdersTab.open
                              ? 'No open trades'
                              : 'No trade history yet',
                          subtitle: _tab == _OrdersTab.open
                              ? 'Pending and partially filled trades will appear here.'
                              : 'Filled, cancelled, and rejected trades will appear here.',
                        ),
                      ),
                    )
                  else
                    SliverPadding(
                      padding: AppSpacing.screenPadding.copyWith(top: 0),
                      sliver: SliverList.separated(
                        itemCount: visible.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: AppSpacing.sm),
                        itemBuilder: (context, index) => _OrderCard(
                          order: visible[index],
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) =>
                                  _OrderDetailsScreen(order: visible[index]),
                            ),
                          ),
                        ),
                      ),
                    ),
                  const SliverToBoxAdapter(child: SizedBox(height: 116)),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

enum _OrdersTab {
  open,
  history;

  bool matches(Order order) {
    final status = order.status.toLowerCase();
    final isOpen =
        status == 'pending' || status == 'submitted' || status == 'partial';
    return this == _OrdersTab.open ? isOpen : !isOpen;
  }
}

class _OrdersHeader extends StatelessWidget {
  const _OrdersHeader({required this.tab, required this.onTabChanged});

  final _OrdersTab tab;
  final ValueChanged<_OrdersTab> onTabChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.screenPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.md),
          Text(
            'Open trades, fills, and exchange-synced history',
            style:
                AppTypography.bodySm.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.md),
          SegmentedButton<_OrdersTab>(
            segments: const [
              ButtonSegment(
                value: _OrdersTab.open,
                label: Text('Open'),
              ),
              ButtonSegment(
                value: _OrdersTab.history,
                label: Text('History'),
              ),
            ],
            selected: {tab},
            onSelectionChanged: (selection) => onTabChanged(selection.first),
          ),
          const SizedBox(height: AppSpacing.md),
        ],
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  const _OrderCard({required this.order, required this.onTap});
  final Order order;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final sideColor = order.side.toLowerCase() == 'buy'
        ? AppColors.profitGreen
        : AppColors.lossRed;
    final statusColor = _statusColor(order.status);
    final price =
        order.price == null ? 'Market' : '\$${order.price!.toStringAsFixed(2)}';

    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.cardRadius,
      child: Container(
        padding: AppSpacing.cardPadding,
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          borderRadius: AppRadius.cardRadius,
          border: Border.all(color: AppColors.borderLight),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    order.symbol,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.h4,
                  ),
                ),
                _Pill(label: order.status.toUpperCase(), color: statusColor),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                _Pill(label: order.side.toUpperCase(), color: sideColor),
                const SizedBox(width: AppSpacing.xs),
                _Pill(
                  label: order.exchange.toUpperCase(),
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: AppSpacing.xs),
                _Pill(
                  label: order.source == 'external' ? 'EXTERNAL' : 'POISE',
                  color: AppColors.accent,
                ),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  order.orderType.toUpperCase(),
                  style: AppTypography.bodySm.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                    child: _Metric(
                        label: 'Qty',
                        value: order.quantity.toStringAsFixed(4))),
                Expanded(child: _Metric(label: 'Price', value: price)),
                Expanded(
                    child: _Metric(
                        label:
                            order.source == 'external' ? 'Exchange SL' : 'SL',
                        value: order.source == 'external'
                            ? order.slPrice?.toStringAsFixed(2) ??
                                'Pending sync'
                            : order.slPrice?.toStringAsFixed(2) ?? '-')),
              ],
            ),
            if (order.source == 'external') ...[
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Opened on ${order.exchange.toUpperCase()} and monitored by Poise.',
                style: AppTypography.caption.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _OrderDetailsScreen extends ConsumerStatefulWidget {
  const _OrderDetailsScreen({required this.order});

  final Order order;

  @override
  ConsumerState<_OrderDetailsScreen> createState() =>
      _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends ConsumerState<_OrderDetailsScreen> {
  var _tab = _OrderDetailTab.info;
  late final Future<Result<OrderInsights, AppError>> _insightsFuture;

  @override
  void initState() {
    super.initState();
    _insightsFuture =
        ref.read(ordersApiProvider).getOrderInsights(widget.order.id);
  }

  @override
  Widget build(BuildContext context) {
    final order = widget.order;
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: const Text('Trade details'),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: AppColors.borderLight),
        ),
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: AppSpacing.screenPadding,
          children: [
            const SizedBox(height: AppSpacing.md),
            SegmentedButton<_OrderDetailTab>(
              segments: const [
                ButtonSegment(
                  value: _OrderDetailTab.info,
                  label: Text('Trade Info'),
                ),
                ButtonSegment(
                  value: _OrderDetailTab.insights,
                  label: Text('Insights'),
                ),
              ],
              selected: {_tab},
              onSelectionChanged: (selection) =>
                  setState(() => _tab = selection.first),
            ),
            const SizedBox(height: AppSpacing.lg),
            if (_tab == _OrderDetailTab.info)
              _TradeInfoTab(order: order)
            else
              _TradeInsightsTab(future: _insightsFuture, order: order),
          ],
        ),
      ),
    );
  }
}

enum _OrderDetailTab { info, insights }

class _TradeInfoTab extends StatelessWidget {
  const _TradeInfoTab({required this.order});

  final Order order;

  @override
  Widget build(BuildContext context) {
    final pnl = order.realizedPnl ?? order.unrealizedPnl;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: AppSpacing.cardPadding,
          decoration: BoxDecoration(
            color: AppColors.profitGreen.withValues(alpha: 0.08),
            borderRadius: AppRadius.cardRadius,
            border: Border.all(
              color: AppColors.profitGreen.withValues(alpha: 0.18),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _Pill(
                      label: order.side.toUpperCase(),
                      color: order.side.toLowerCase() == 'buy'
                          ? AppColors.profitGreen
                          : AppColors.lossRed,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(order.symbol, style: AppTypography.h3),
                    const SizedBox(height: AppSpacing.xs),
                    _Pill(
                      label: order.status.toUpperCase(),
                      color: _statusColor(order.status),
                    ),
                  ],
                ),
              ),
              if (pnl != null)
                Text(
                  _money(pnl, signed: true),
                  style: AppTypography.numericMd.copyWith(
                    color: AppColors.pnlColor(pnl),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        _SectionCard(
          children: [
            _DetailRow(
              label: 'Data Source',
              value: order.source == 'external' ? 'Exchange' : 'Poise',
            ),
            _DetailRow(label: 'Exchange', value: order.exchange.toUpperCase()),
            _DetailRow(
              label: 'Execution Mode',
              value: order.orderType.toUpperCase(),
            ),
            _DetailRow(
              label: 'Quantity',
              value: order.quantity.toStringAsFixed(4),
            ),
            _DetailRow(
              label: 'Leverage',
              value:
                  '${order.leverage.toStringAsFixed(order.leverage % 1 == 0 ? 0 : 1)}x',
            ),
            _DetailRow(
              label: 'Entry Price',
              value: _price(order.entryPrice ?? order.price),
            ),
            _DetailRow(label: 'Stop Loss Price', value: _price(order.slPrice)),
            _DetailRow(
              label: 'Take Profit Price',
              value: order.tpLevels.isEmpty
                  ? '-'
                  : order.tpLevels.map(_price).join(', '),
            ),
            _DetailRow(label: 'Open Time', value: order.createdAt),
            _DetailRow(label: 'Close Time', value: order.closedAt ?? '-'),
          ],
        ),
        if (order.exchangeOrderId != null) ...[
          const SizedBox(height: AppSpacing.md),
          _SectionCard(
            children: [
              _DetailRow(
                label: 'Exchange order ID',
                value: order.exchangeOrderId!,
              ),
            ],
          ),
        ],
      ],
    );
  }
}

class _TradeInsightsTab extends StatelessWidget {
  const _TradeInsightsTab({required this.future, required this.order});

  final Future<Result<OrderInsights, AppError>> future;
  final Order order;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Result<OrderInsights, AppError>>(
      future: future,
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(AppSpacing.xl),
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        }
        final result = snap.data;
        if (result == null || result.isErr) {
          return const PErrorState(message: 'Could not load trade insights');
        }
        return _InsightsContent(order: order, insights: result.value);
      },
    );
  }
}

class _InsightsContent extends StatelessWidget {
  const _InsightsContent({required this.order, required this.insights});

  final Order order;
  final OrderInsights insights;

  @override
  Widget build(BuildContext context) {
    final score = insights.adherenceScore.clamp(0, 100);
    final color = score >= 80
        ? AppColors.profitGreen
        : score >= 60
            ? AppColors.warningAmber
            : AppColors.lossRed;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Adherence\nScore',
                style: AppTypography.h2.copyWith(height: 1.15),
              ),
            ),
            const Expanded(child: Divider(color: AppColors.borderLight)),
            const SizedBox(width: AppSpacing.md),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '$score',
                  style: AppTypography.display1.copyWith(color: color),
                ),
                const Text('of 100', style: AppTypography.h3),
              ],
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        _AiSummaryCard(insights: insights),
        const SizedBox(height: AppSpacing.xl),
        if (insights.opportunityCost != null) ...[
          Text(
            'Opportunity cost',
            style: AppTypography.bodyLg.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          _OpportunityCard(cost: insights.opportunityCost!),
          const SizedBox(height: AppSpacing.xl),
        ],
        const Text('Today\'s adherence', style: AppTypography.bodyLg),
        const SizedBox(height: AppSpacing.md),
        Center(
          child: SizedBox(
            width: 154,
            height: 154,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CircularProgressIndicator(
                  value: score / 100,
                  strokeWidth: 14,
                  strokeCap: StrokeCap.round,
                  backgroundColor: AppColors.bgSecondary,
                  color: color,
                ),
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        insights.adherenceLabel,
                        style: AppTypography.bodySm.copyWith(color: color),
                      ),
                      Text('$score%', style: AppTypography.numericMd),
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
          childAspectRatio: 2.2,
          crossAxisSpacing: AppSpacing.sm,
          mainAxisSpacing: AppSpacing.sm,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            for (final metric in insights.metrics)
              _InsightMetricTile(metric: metric),
          ],
        ),
      ],
    );
  }
}

class _AiSummaryCard extends StatelessWidget {
  const _AiSummaryCard({required this.insights});

  final OrderInsights insights;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: AppSpacing.cardPadding,
      decoration: const BoxDecoration(
        color: Color(0xFFEFF6FF),
        borderRadius: AppRadius.cardRadiusLg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.auto_awesome_rounded, color: Color(0xFF0057FF)),
              const SizedBox(width: AppSpacing.xs),
              Text(
                'AI Summary',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            insights.aiSummary,
            style: AppTypography.body.copyWith(
              color: AppColors.textSecondary,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}

class _OpportunityCard extends StatelessWidget {
  const _OpportunityCard({required this.cost});

  final OrderOpportunityCost cost;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: AppSpacing.cardPadding,
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: AppRadius.cardRadius,
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(cost.label, style: AppTypography.h3)),
              Text(
                _money(cost.value, signed: true),
                style: AppTypography.numericMd.copyWith(
                  color: AppColors.lossRed,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Container(
            width: double.infinity,
            padding: AppSpacing.cardPadding,
            decoration: BoxDecoration(
              color: AppColors.warningAmber.withValues(alpha: 0.08),
              borderRadius: AppRadius.cardRadius,
            ),
            child: Text(
              cost.description,
              style: AppTypography.body.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InsightMetricTile extends StatelessWidget {
  const _InsightMetricTile({required this.metric});

  final OrderInsightMetric metric;

  @override
  Widget build(BuildContext context) {
    final color = metric.score >= 80
        ? AppColors.profitGreen
        : metric.score >= 60
            ? AppColors.warningAmber
            : AppColors.lossRed;
    return Container(
      padding: AppSpacing.cardPadding,
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: AppRadius.cardRadius,
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            metric.label,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.caption.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            '${metric.score}%',
            style: AppTypography.bodyMedium.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: AppSpacing.cardPadding,
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: AppRadius.cardRadius,
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style:
                  AppTypography.body.copyWith(color: AppColors.textSecondary),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: AppTypography.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: 2),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(value, maxLines: 1, style: AppTypography.numericSm),
        ),
      ],
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.label, required this.color});
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
        border: Border.all(color: color.withValues(alpha: 0.28)),
      ),
      child: Text(
        label,
        style: AppTypography.label.copyWith(color: color),
      ),
    );
  }
}

class _OrdersLoading extends StatelessWidget {
  const _OrdersLoading();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: AppSpacing.screenPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: AppSpacing.lg),
          SizedBox(height: AppSpacing.md),
          _LoadingCard(),
          SizedBox(height: AppSpacing.sm),
          _LoadingCard(),
          SizedBox(height: AppSpacing.sm),
          _LoadingCard(),
        ],
      ),
    );
  }
}

class _LoadingCard extends StatelessWidget {
  const _LoadingCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 116,
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: AppRadius.cardRadius,
        border: Border.all(color: AppColors.borderLight),
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
        height: 58,
        child: FilledButton.icon(
          onPressed: onPressed,
          icon: const Icon(Icons.add_rounded, size: 26),
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

String _price(double? value) =>
    value == null ? '-' : '\$${value.toStringAsFixed(2)}';

String _money(double value, {bool signed = false}) {
  final prefix = signed && value > 0 ? '+' : '';
  return '$prefix\$${value.toStringAsFixed(2)}';
}

Color _statusColor(String status) {
  final normalized = status.toLowerCase();
  if (normalized.contains('filled') || normalized.contains('open')) {
    return AppColors.profitGreen;
  }
  if (normalized.contains('pending') || normalized.contains('new')) {
    return AppColors.warningAmber;
  }
  if (normalized.contains('cancel')) return AppColors.statusCancelled;
  if (normalized.contains('reject') || normalized.contains('fail')) {
    return AppColors.lossRed;
  }
  return AppColors.textSecondary;
}
