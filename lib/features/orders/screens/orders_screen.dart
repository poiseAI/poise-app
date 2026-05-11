import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/feedback/p_empty_state.dart';
import '../../../core/widgets/feedback/p_error_state.dart';
import '../data/models/order.dart';
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
                          onTap: () =>
                              _showOrderDetails(context, visible[index]),
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

void _showOrderDetails(BuildContext context, Order order) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.bgCard,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => SafeArea(
      child: Padding(
        padding: AppSpacing.screenPadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(order.symbol, style: AppTypography.h3),
            const SizedBox(height: AppSpacing.xs),
            Text(
              '${order.exchange.toUpperCase()} • ${order.source.toUpperCase()} • ${order.status.toUpperCase()}',
              style:
                  AppTypography.bodySm.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: AppSpacing.lg),
            _DetailRow(label: 'Side', value: order.side.toUpperCase()),
            _DetailRow(label: 'Type', value: order.orderType.toUpperCase()),
            _DetailRow(
                label: 'Quantity', value: order.quantity.toStringAsFixed(4)),
            _DetailRow(
              label: 'Price',
              value: order.price == null
                  ? 'Market'
                  : '\$${order.price!.toStringAsFixed(2)}',
            ),
            _DetailRow(
                label: 'Stop loss',
                value: order.slPrice?.toStringAsFixed(2) ?? '-'),
            _DetailRow(
              label: 'Take profits',
              value: order.tpLevels.isEmpty
                  ? '-'
                  : order.tpLevels
                      .map((tp) => tp.toStringAsFixed(2))
                      .join(', '),
            ),
            _DetailRow(
                label: 'Exchange order ID',
                value: order.exchangeOrderId ?? 'Pending sync'),
            _DetailRow(label: 'Created', value: order.createdAt),
          ],
        ),
      ),
    ),
  );
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
