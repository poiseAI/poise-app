import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../data/billing_api.dart';
import 'billing_price_text.dart';

class BillingPlanCard extends StatelessWidget {
  const BillingPlanCard({required this.subscription, super.key});

  final BillingSubscription subscription;

  @override
  Widget build(BuildContext context) {
    final cycle = subscription.cycle == BillingCycle.none
        ? BillingCycle.yearly
        : subscription.cycle;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.billingSelectedBg,
        borderRadius: AppRadius.cardRadius,
        border: Border.all(color: AppColors.billingSelectedBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: BillingPriceText(cycle: cycle)),
              const SizedBox(width: AppSpacing.sm),
              const _Badge(
                label: 'Current plan',
                backgroundColor: AppColors.badgeInfoBg,
                borderColor: AppColors.badgeInfoBorder,
                textColor: AppColors.badgeInfoText,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.bgPrimary,
              borderRadius: AppRadius.cardRadius,
              border: Border.all(color: AppColors.borderLight),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (subscription.isTrialing)
                  const _Badge(
                    label: 'Free trial',
                    backgroundColor: AppColors.badgeWarningBg,
                    borderColor: AppColors.badgeWarningBorder,
                    textColor: AppColors.badgeWarningText,
                  ),
                if (subscription.isTrialing)
                  const SizedBox(height: AppSpacing.md),
                _UsageStats(subscription: subscription),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          const Divider(height: 1, color: AppColors.borderLight),
          const SizedBox(height: AppSpacing.md),
          _RenewalRow(subscription: subscription),
        ],
      ),
    );
  }
}

class _UsageStats extends StatelessWidget {
  const _UsageStats({required this.subscription});

  final BillingSubscription subscription;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatTile(
            label: 'Trades used',
            value: _formatCount(
              subscription.tradesUsed,
              subscription.tradesLimit,
            ),
          ),
        ),
        Expanded(
          child: _StatTile(
            label: 'Days remaining',
            value: _formatDays(
              subscription.trialDaysRemaining,
              subscription.trialDaysTotal,
            ),
          ),
        ),
      ],
    );
  }

  String _formatCount(int? used, int? total) {
    if (used != null && total != null) return '$used/$total';
    if (used != null) return used.toString();
    if (total != null) return '/$total';
    return '-';
  }

  String _formatDays(int? remaining, int? total) {
    if (remaining != null && total != null) return '$remaining of $total';
    if (remaining != null) return remaining.toString();
    if (total != null) return '0 of $total';
    return '-';
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.bodySm.copyWith(
            color: AppColors.textHeading,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: AppTypography.bodyLg.copyWith(
            color: AppColors.textLabel,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _RenewalRow extends StatelessWidget {
  const _RenewalRow({required this.subscription});

  final BillingSubscription subscription;

  @override
  Widget build(BuildContext context) {
    final renews = subscription.currentPeriodEnd != null
        ? _formatDate(subscription.currentPeriodEnd!)
        : '-';

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: AppRadius.cardRadius,
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Renews:',
            style: AppTypography.bodySm.copyWith(
              color: AppColors.textHeading,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            renews,
            style: AppTypography.bodyLg.copyWith(
              color: AppColors.textLabel,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final d = date.toLocal();
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${months[d.month - 1]} ${d.day}, ${d.year}';
  }
}

class _Badge extends StatelessWidget {
  const _Badge({
    required this.label,
    required this.backgroundColor,
    required this.borderColor,
    required this.textColor,
  });

  final String label;
  final Color backgroundColor;
  final Color borderColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: AppRadius.chipRadius,
        border: Border.all(color: borderColor),
      ),
      child: Text(
        label,
        style: AppTypography.bodySm.copyWith(
          color: textColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
