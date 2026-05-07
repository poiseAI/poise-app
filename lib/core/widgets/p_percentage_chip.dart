import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

class PPercentageChip extends StatelessWidget {
  const PPercentageChip({super.key, required this.value});

  final double value;

  @override
  Widget build(BuildContext context) {
    final isPositive = value >= 0;
    final color = isPositive ? AppColors.profitGreen : AppColors.lossRed;
    final sign = isPositive ? '+' : '';

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: AppRadius.chipRadius,
      ),
      child: Text(
        '$sign${value.toStringAsFixed(2)}%',
        style: AppTypography.numericSm.copyWith(
          color: color,
          fontFeatures: const [FontFeature.tabularFigures()],
        ),
      ),
    );
  }
}
