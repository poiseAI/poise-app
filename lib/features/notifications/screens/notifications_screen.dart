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
import '../data/models/notification_item.dart';
import '../providers/notifications_provider.dart';

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() =>
      _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  @override
  Widget build(BuildContext context) {
    final notifications = ref.watch(notificationsProvider);
    final notifier = ref.read(notificationsProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () =>
              context.canPop() ? context.pop() : context.go(Routes.home),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: const Text('Notifications'),
        actions: [
          notifications.maybeWhen(
            data: (items) => items.any((n) => !n.read)
                ? TextButton(
                    onPressed: notifier.markAllRead,
                    child: const Text('Mark all read'),
                  )
                : const SizedBox.shrink(),
            orElse: () => const SizedBox.shrink(),
          ),
        ],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: AppColors.borderLight),
        ),
      ),
      body: SafeArea(
        top: false,
        child: notifications.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(
            child: Text('Failed to load notifications',
                style: AppTypography.body
                    .copyWith(color: AppColors.textSecondary)),
          ),
          data: (items) {
            return CustomScrollView(
              slivers: [
                if (items.isNotEmpty)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 18, 16, 8),
                      child: Text(
                        'Today',
                        style: AppTypography.bodyLg.copyWith(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                if (items.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: _EmptyState(),
                  )
                else
                  SliverPadding(
                    padding: AppSpacing.screenPadding.copyWith(top: 0),
                    sliver: SliverList.separated(
                      itemCount: items.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: AppSpacing.sm),
                      itemBuilder: (_, i) {
                        final item = items[i];
                        return _NotificationTile(
                          key: ValueKey(item.id),
                          item: item,
                          index: i,
                          onDismiss: () {
                            HapticFeedback.mediumImpact();
                            notifier.dismiss(item.id);
                          },
                          onTap: () async {
                            await notifier.markRead(item.id);
                            if (context.mounted) {
                              _openNotification(context, item);
                            }
                          },
                        );
                      },
                    ),
                  ),
                const SliverToBoxAdapter(
                    child: SizedBox(height: AppSpacing.xxl)),
              ],
            );
          },
        ),
      ),
    );
  }
}

void _openNotification(BuildContext context, NotificationItem item) {
  final type = item.type;
  if (type.contains('order') || type.contains('trade')) {
    context.go(Routes.orders);
    return;
  }
  if (type.contains('position')) {
    context.go(Routes.home);
    return;
  }
  if (type.contains('risk') || type.contains('guardrail')) {
    context.go(Routes.ai, extra: item.body);
    return;
  }
  if (type.contains('api') ||
      type.contains('exchange') ||
      type.contains('sync')) {
    context.go(Routes.profile);
  }
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({
    super.key,
    required this.item,
    required this.index,
    required this.onDismiss,
    required this.onTap,
  });

  final NotificationItem item;
  final int index;
  final VoidCallback onDismiss;
  final VoidCallback onTap;

  static Color _typeColor(String type) {
    if (type.contains('risk')) return AppColors.riskHigh;
    if (type.contains('cancelled')) return AppColors.lossRed;
    if (type.contains('filled')) return AppColors.profitGreen;
    if (type.contains('position')) return AppColors.accent;
    return AppColors.textSecondary;
  }

  static IconData _typeIcon(String type) {
    if (type.contains('risk')) return Icons.warning_amber_rounded;
    if (type.contains('cancelled')) return Icons.cancel_outlined;
    if (type.contains('filled')) return Icons.check_circle_outline_rounded;
    if (type.contains('position')) return Icons.show_chart_rounded;
    return Icons.notifications_outlined;
  }

  @override
  Widget build(BuildContext context) {
    final color = _typeColor(item.type);

    return Dismissible(
      key: ValueKey(item.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.lossRed.withValues(alpha: 0.1),
          borderRadius: AppRadius.chipRadius,
        ),
        child:
            const Icon(Icons.delete_outline_rounded, color: AppColors.lossRed),
      ),
      onDismissed: (_) => onDismiss(),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.lg,
          ),
          decoration: BoxDecoration(
            color: item.read ? AppColors.bgCard : AppColors.bgSecondary,
            borderRadius: AppRadius.cardRadius,
            border: Border.all(
              color: item.read
                  ? AppColors.borderLight
                  : color.withValues(alpha: 0.25),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                  border: Border.all(color: color.withValues(alpha: 0.24)),
                ),
                child: Icon(_typeIcon(item.type), size: 22, color: color),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: AppTypography.label.copyWith(
                        color: item.read
                            ? AppColors.textSecondary
                            : AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.body,
                      style: AppTypography.bodySm
                          .copyWith(color: AppColors.textSecondary),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      _relativeTime(item.createdAt),
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textTertiary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              if (!item.read) ...[
                const SizedBox(width: AppSpacing.sm),
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    )
        .animate(delay: (index * 30).ms)
        .fadeIn(duration: 200.ms)
        .slideX(begin: 0.05, end: 0, curve: Curves.easeOut);
  }
}

String _relativeTime(String raw) {
  final parsed = DateTime.tryParse(raw);
  if (parsed == null) return '';
  final diff = DateTime.now().difference(parsed);
  if (diff.inMinutes < 1) return 'Just now';
  if (diff.inMinutes < 60) {
    final m = diff.inMinutes;
    return '$m minute${m == 1 ? '' : 's'} ago';
  }
  if (diff.inHours < 24) {
    final h = diff.inHours;
    return '$h hour${h == 1 ? '' : 's'} ago';
  }
  final d = diff.inDays;
  return '$d day${d == 1 ? '' : 's'} ago';
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.notifications_none_rounded,
              size: 64, color: AppColors.textDisabled),
          const SizedBox(height: AppSpacing.md),
          const Text('All caught up', style: AppTypography.h3)
              .animate()
              .fadeIn(duration: 300.ms),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'No notifications to show.',
            style: AppTypography.body.copyWith(color: AppColors.textSecondary),
          ).animate(delay: 100.ms).fadeIn(duration: 300.ms),
        ],
      ),
    );
  }
}
