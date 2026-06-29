import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../data/billing_api.dart';
import 'billing_price_text.dart';

class BillingOtherOptions extends StatelessWidget {
  const BillingOtherOptions({
    required this.currentCycle,
    required this.onSwitch,
    super.key,
  });

  final BillingCycle currentCycle;
  final VoidCallback onSwitch;

  @override
  Widget build(BuildContext context) {
    final alternativeCycle = currentCycle == BillingCycle.monthly
        ? BillingCycle.yearly
        : BillingCycle.monthly;
    final isAlternativeYearly = alternativeCycle == BillingCycle.yearly;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Other options',
          style: AppTypography.body.copyWith(
            color: AppColors.textHeading,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.bgPrimary,
            borderRadius: AppRadius.cardRadius,
            border: Border.all(color: AppColors.borderLight),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isAlternativeYearly ? 'Yearly' : 'Monthly',
                      style: AppTypography.bodyLg.copyWith(
                        color: AppColors.textLabel,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    BillingPriceText(cycle: alternativeCycle),
                    const SizedBox(height: 2),
                    Text(
                      isAlternativeYearly
                          ? 'Equivalent to \$65/month'
                          : 'Billed monthly',
                      style: AppTypography.bodySm.copyWith(
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: onSwitch,
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(0, 36),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Switch',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios,
                      size: 14,
                      color: AppColors.primary,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
