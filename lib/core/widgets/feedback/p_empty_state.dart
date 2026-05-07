import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../buttons/p_primary_button.dart';

class PEmptyState extends StatelessWidget {
  const PEmptyState({
    super.key,
    required this.title,
    required this.subtitle,
    this.animationAsset,
    this.ctaLabel,
    this.onCtaTap,
  });

  final String title;
  final String subtitle;
  final String? animationAsset;
  final String? ctaLabel;
  final VoidCallback? onCtaTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: AppSpacing.screenPadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (animationAsset != null)
              Lottie.asset(
                animationAsset!,
                width: 180,
                height: 180,
                repeat: true,
              )
            else
              const Icon(
                Icons.inbox_outlined,
                size: 64,
                color: AppColors.textDisabled,
              ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              title,
              style: AppTypography.h3,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              subtitle,
              style: AppTypography.body.copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            if (ctaLabel != null && onCtaTap != null) ...[
              const SizedBox(height: AppSpacing.xl),
              PPrimaryButton(label: ctaLabel!, onPressed: onCtaTap),
            ],
          ],
        ),
      ),
    );
  }
}
