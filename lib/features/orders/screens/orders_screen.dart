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

class OrdersScreen extends ConsumerWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersState = ref.watch(ordersNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _NewTradeButton(
        onPressed: () => context.go(Routes.trade),
      ),
      body: SafeArea(
        child: ordersState.when(
          loading: () => const _OrdersLoading(),
          error: (error, _) => PErrorState(
            message: error.toString(),
            onRetry: () => ref.read(ordersNotifierProvider.notifier).refresh(),
          ),
          data: (orders) {
            if (orders.isEmpty) {
              return PEmptyState(
                title: 'No trades yet',
                subtitle: 'Executed and pending trades will appear here.',
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
                  const SliverToBoxAdapter(child: _TradesHeader()),
                  SliverPadding(
                    padding: AppSpacing.screenPadding.copyWith(top: 0),
                    sliver: SliverList.separated(
                      itemCount: orders.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: AppSpacing.sm),
                      itemBuilder: (context, index) =>
                          _OrderCard(order: orders[index]),
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

class _TradesHeader extends StatelessWidget {
  const _TradesHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.screenPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Trades', style: AppTypography.h2),
                    SizedBox(height: AppSpacing.xs),
                    Text(
                      'Live order activity and execution status',
                      style: AppTypography.bodySm,
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: 'New trade',
                onPressed: () => context.go(Routes.trade),
                icon: const Icon(Icons.add_rounded),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
        ],
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  const _OrderCard({required this.order});
  final Order order;

  @override
  Widget build(BuildContext context) {
    final sideColor = order.side.toLowerCase() == 'buy'
        ? AppColors.profitGreen
        : AppColors.lossRed;
    final statusColor = _statusColor(order.status);
    final price =
        order.price == null ? 'Market' : '\$${order.price!.toStringAsFixed(2)}';

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
                '${order.orderType.toUpperCase()} - ${order.leverage.toStringAsFixed(0)}x',
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
                      label: 'Qty', value: order.quantity.toStringAsFixed(4))),
              Expanded(child: _Metric(label: 'Price', value: price)),
              Expanded(
                  child: _Metric(
                      label: order.source == 'external' ? 'Exchange SL' : 'SL',
                      value: order.source == 'external'
                          ? order.slPrice?.toStringAsFixed(2) ?? 'Pending sync'
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
          Text('Trades', style: AppTypography.h2),
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
