import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';

const _coreFeatures = <Widget>[
  _FeatureRow(label: 'Unlimited trade monitoring'),
  _FeatureRow(label: 'Full behavioural analysis'),
  _FeatureRow(label: 'Advanced opportunity cost breakdowns'),
  _FeatureRow(label: 'Long-term behavioural tracking'),
  _FeatureRow(label: 'Custom Guardian Mode rules'),
  _FeatureRow(label: 'Priority support access'),
];

class BillingFeatureList extends StatelessWidget {
  const BillingFeatureList({
    super.key,
    this.title = 'Everything in Poise Core',
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTypography.bodyLg.copyWith(
            color: AppColors.textHeading,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        ..._coreFeatures,
      ],
    );
  }
}

class _FeatureRow extends StatelessWidget {
  const _FeatureRow({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Container(
        height: 42,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: const BoxDecoration(
          color: AppColors.bgSurface,
          borderRadius: AppRadius.cardRadius,
        ),
        child: Text(
          label,
          style: AppTypography.bodyLabel,
        ),
      ),
    );
  }
}
