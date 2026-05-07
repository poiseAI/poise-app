import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../positions/data/models/position.dart';

class PortfolioHeader extends StatelessWidget {
  const PortfolioHeader({super.key, required this.summary});
  final PnlSummary summary;

  @override
  Widget build(BuildContext context) {
    final pnl = summary.totalUnrealizedPnl;
    final pnlPct = summary.totalUnrealizedPnlPct;
    final pnlColor = AppColors.pnlColor(pnl);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Portfolio',
          style: AppTypography.label.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: AppSpacing.xs),
        // P&L count-up animation (#32)
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: pnl),
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeOutCubic,
          builder: (context, value, _) {
            final sign = value >= 0 ? '+' : '';
            return Text(
              '$sign\$${value.abs().toStringAsFixed(2)}',
              style: AppTypography.numericXl.copyWith(color: pnlColor),
            );
          },
        )
            .animate()
            .fadeIn(duration: 300.ms)
            .slideY(begin: 0.1, end: 0, curve: Curves.easeOutCubic),
        const SizedBox(height: 2),
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: pnlPct),
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeOutCubic,
          builder: (context, value, _) {
            final sign = value >= 0 ? '+' : '';
            return Text(
              '$sign${value.toStringAsFixed(2)}% today',
              style: AppTypography.body.copyWith(color: pnlColor),
            );
          },
        )
            .animate(delay: 80.ms)
            .fadeIn(duration: 280.ms),
      ],
    );
  }
}
