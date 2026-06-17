import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../data/models/chat_message.dart';

class ConfirmationCard extends StatelessWidget {
  const ConfirmationCard({
    super.key,
    required this.message,
    required this.onConfirm,
    required this.onCancel,
  });

  final ConfirmationMessage message;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final isPending = message.status == ConfirmationStatus.pending;
    final isConfirmed = message.status == ConfirmationStatus.confirmed;

    Color borderColor;
    Color bgColor;
    Widget content;

    if (isConfirmed) {
      borderColor = AppColors.profitGreen.withValues(alpha: 0.4);
      bgColor = AppColors.profitGreen.withValues(alpha: 0.05);
      content = Row(
        children: [
          const Icon(Icons.check_circle_rounded,
              size: 16, color: AppColors.profitGreen),
          const SizedBox(width: AppSpacing.xs),
          Text('Confirmed',
              style:
                  AppTypography.caption.copyWith(color: AppColors.profitGreen)),
        ],
      );
    } else if (!isPending) {
      borderColor = AppColors.borderLight;
      bgColor = AppColors.bgPrimary;
      content = Text(
        'Cancelled',
        style: AppTypography.caption.copyWith(color: AppColors.textDisabled),
      );
    } else {
      borderColor = AppColors.warningAmber.withValues(alpha: 0.5);
      bgColor = AppColors.warningAmber.withValues(alpha: 0.04);
      content = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.help_outline_rounded,
                  size: 14, color: AppColors.warningAmber),
              SizedBox(width: AppSpacing.xs),
              Text('Action required',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.warningAmber,
                    fontWeight: FontWeight.w600,
                  )),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(message.actionSummary, style: AppTypography.body),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: onCancel,
                  child: Container(
                    height: 36,
                    decoration: BoxDecoration(
                      borderRadius: AppRadius.chipRadius,
                      border: Border.all(color: AppColors.borderLight),
                    ),
                    alignment: Alignment.center,
                    child: Text('Cancel',
                        style: AppTypography.label
                            .copyWith(color: AppColors.textSecondary)),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: GestureDetector(
                  onTap: onConfirm,
                  child: Container(
                    height: 36,
                    decoration: const BoxDecoration(
                      color: AppColors.accent,
                      borderRadius: AppRadius.chipRadius,
                    ),
                    alignment: Alignment.center,
                    child: Text('Confirm',
                        style:
                            AppTypography.label.copyWith(color: Colors.white)),
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: AppRadius.cardRadius,
        border: Border.all(color: borderColor, width: 1.5),
      ),
      child: content,
    )
        .animate(key: ValueKey(message.status))
        .scale(
          begin: const Offset(0.95, 0.95),
          curve: Curves.easeOutBack,
          duration: 300.ms,
        )
        .fadeIn(duration: 200.ms);
  }
}
