import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

enum BadgeVariant { open, pending, filled, locked, cancelled }

class PBadge extends StatelessWidget {
  const PBadge({super.key, required this.variant});

  final BadgeVariant variant;

  static PBadge fromString(String status) {
    final v = switch (status.toLowerCase()) {
      'open'      => BadgeVariant.open,
      'pending'   => BadgeVariant.pending,
      'filled'    => BadgeVariant.filled,
      'locked'    => BadgeVariant.locked,
      'cancelled' => BadgeVariant.cancelled,
      _           => BadgeVariant.pending,
    };
    return PBadge(variant: v);
  }

  @override
  Widget build(BuildContext context) {
    final (label, fg, bg) = switch (variant) {
      BadgeVariant.open      => ('Open',      AppColors.profitGreen, AppColors.profitGreen.withValues(alpha: 0.12)),
      BadgeVariant.pending   => ('Pending',   AppColors.warningAmber, AppColors.warningAmber.withValues(alpha: 0.12)),
      BadgeVariant.filled    => ('Filled',    AppColors.accent, AppColors.accent.withValues(alpha: 0.12)),
      BadgeVariant.locked    => ('Locked',    AppColors.textSecondary, AppColors.borderLight),
      BadgeVariant.cancelled => ('Cancelled', AppColors.lossRed, AppColors.lossRed.withValues(alpha: 0.12)),
    };

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(color: bg, borderRadius: AppRadius.chipRadius),
      child: Text(
        label,
        style: AppTypography.labelSm.copyWith(color: fg),
      ),
    );
  }
}
