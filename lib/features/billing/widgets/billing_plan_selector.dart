import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../data/billing_api.dart';

class BillingPlanSelector extends StatelessWidget {
  const BillingPlanSelector({
    required this.selectedCycle,
    required this.onChanged,
    super.key,
  });

  final BillingCycle selectedCycle;
  final ValueChanged<BillingCycle> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _PlanCard(
            label: 'Monthly',
            price: '\$79',
            interval: '/ month',
            subtext: 'Billed monthly',
            selected: selectedCycle == BillingCycle.monthly,
            onTap: () => onChanged(BillingCycle.monthly),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: _PlanCard(
            label: 'Yearly',
            price: '\$790',
            interval: '/ year',
            subtext: 'Equivalent to \$65/month',
            selected: selectedCycle == BillingCycle.yearly,
            onTap: () => onChanged(BillingCycle.yearly),
          ),
        ),
      ],
    );
  }
}

class _PlanCard extends StatelessWidget {
  const _PlanCard({
    required this.label,
    required this.price,
    required this.interval,
    required this.subtext,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final String price;
  final String interval;
  final String subtext;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 98,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.bgPrimary,
          borderRadius: AppRadius.cardRadius,
          border: Border.all(
            color: selected
                ? AppColors.billingSelectedBorder
                : AppColors.borderLight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  label,
                  style: AppTypography.body.copyWith(
                    color: AppColors.textLabel,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                _Checkbox(selected: selected),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            Text.rich(
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
            ),
            const SizedBox(height: 2),
            Text(
              subtext,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.bodySm.copyWith(
                color: AppColors.textTertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Checkbox extends StatelessWidget {
  const _Checkbox({required this.selected});

  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        color: selected ? AppColors.primary : AppColors.bgPrimary,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: selected ? AppColors.primary : AppColors.borderLight,
        ),
      ),
      child: selected
          ? const Icon(
              Icons.check,
              size: 12,
              color: Colors.white,
            )
          : null,
    );
  }
}
