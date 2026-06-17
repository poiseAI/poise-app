import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../risk/data/models/risk_score.dart';

class RiskScoreBadge extends StatelessWidget {
  const RiskScoreBadge({super.key, this.score});
  final RiskScore? score;

  static Color _levelColor(String level) => switch (level.toLowerCase()) {
        'low' => AppColors.riskLow,
        'medium' => AppColors.riskMedium,
        'high' => AppColors.riskHigh,
        'critical' => AppColors.riskCritical,
        _ => AppColors.textDisabled,
      };

  @override
  Widget build(BuildContext context) {
    if (score == null) {
      return Container(
        height: 32,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
        decoration: BoxDecoration(
          color: AppColors.bgPrimary,
          borderRadius: AppRadius.chipRadius,
          border: Border.all(color: AppColors.borderLight),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 10,
              height: 10,
              child: CircularProgressIndicator(strokeWidth: 1.5),
            ),
            SizedBox(width: AppSpacing.xs),
            Text('Risk loading...'),
          ],
        ),
      );
    }

    final color = _levelColor(score!.level);

    return Container(
      height: 32,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: AppRadius.chipRadius,
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: score!.score),
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeOut,
            builder: (_, val, __) => Text(
              (val * 100).toStringAsFixed(0),
              style: AppTypography.numericSm.copyWith(color: color),
            ),
          ),
          Text(
            '% risk · ${score!.level.toUpperCase()}',
            style: AppTypography.caption.copyWith(color: color),
          ),
        ],
      ),
    ).animate().shimmer(duration: 600.ms, color: color.withValues(alpha: 0.2));
  }
}
