import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../data/billing_api.dart';

class BillingPriceText extends StatelessWidget {
  const BillingPriceText({required this.cycle, super.key});

  final BillingCycle cycle;

  @override
  Widget build(BuildContext context) {
    final isYearly = cycle == BillingCycle.yearly;
    final price = isYearly ? '\$790' : '\$79';
    final interval = isYearly ? '/ year' : '/ month';

    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: price,
            style: AppTypography.numeric.copyWith(
              color: AppColors.primary,
            ),
          ),
          TextSpan(
            text: interval,
            style: AppTypography.body.copyWith(
              color: AppColors.textTertiary,
            ),
          ),
        ],
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}
