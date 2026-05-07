import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../data/models/notification_item.dart';
import '../providers/notifications_provider.dart';

const _filters = ['All', 'Orders', 'Positions', 'Risk', 'System'];

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() =>
      _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  int _filterIndex = 0;

  List<NotificationItem> _filtered(List<NotificationItem> items) {
    if (_filterIndex == 0) return items;
    final filterType = switch (_filterIndex) {
      1 => 'order',
      2 => 'position',
      3 => 'risk',
      4 => 'system',
      _ => '',
    };
    return items.where((n) => n.type.contains(filterType)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final notifications = ref.watch(notificationsProvider);
    final filtered = _filtered(notifications);
    final notifier = ref.read(notificationsProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: AppSpacing.screenPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: AppSpacing.lg),
                    Row(
                      children: [
                        const Text('Notifications', style: AppTypography.h1),
                        const Spacer(),
                        if (notifications.any((n) => !n.read))
                          TextButton(
                            onPressed: notifier.markAllRead,
                            child: Text(
                              'Mark all read',
                              style: AppTypography.caption
                                  .copyWith(color: AppColors.accent),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    // Filter bar (#48)
                    SizedBox(
                      height: 36,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: _filters.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(width: AppSpacing.xs),
                        itemBuilder: (_, i) {
                          final active = _filterIndex == i;
                          return GestureDetector(
                            onTap: () {
                              HapticFeedback.selectionClick();
                              setState(() => _filterIndex = i);
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: AppSpacing.md, vertical: 6),
                              decoration: BoxDecoration(
                                color: active
                                    ? AppColors.accent
                                    : AppColors.bgCard,
                                borderRadius: AppRadius.chipRadius,
                                border: Border.all(
                                  color: active
                                      ? AppColors.accent
                                      : AppColors.borderLight,
                                ),
                              ),
                              child: Text(
                                _filters[i],
                                style: AppTypography.caption.copyWith(
                                  color: active
                                      ? Colors.white
                                      : AppColors.textSecondary,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                  ],
                ),
              ),
            ),

            if (filtered.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: _EmptyState(),
              )
            else
              SliverPadding(
                padding: AppSpacing.screenPadding.copyWith(top: 0),
                sliver: SliverList.separated(
                  itemCount: filtered.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(height: AppSpacing.xs),
                  itemBuilder: (_, i) {
                    final item = filtered[i];
                    return _NotificationTile(
                      key: ValueKey(item.id),
                      item: item,
                      index: i,
                      onDismiss: () {
                        HapticFeedback.mediumImpact();
                        notifier.dismiss(item.id);
                      },
                      onTap: () => notifier.markRead(item.id),
                    );
                  },
                ),
              ),

            const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xxl)),
          ],
        ),
      ),
    );
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
        child: const Icon(Icons.delete_outline_rounded,
            color: AppColors.lossRed),
      ),
      onDismissed: (_) => onDismiss(),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: item.read ? AppColors.bgCard : color.withValues(alpha: 0.04),
            borderRadius: AppRadius.chipRadius,
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
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(_typeIcon(item.type), size: 18, color: color),
              ),
              const SizedBox(width: AppSpacing.sm),
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
            style:
                AppTypography.body.copyWith(color: AppColors.textSecondary),
          )
              .animate(delay: 100.ms)
              .fadeIn(duration: 300.ms),
        ],
      ),
    );
  }
}
