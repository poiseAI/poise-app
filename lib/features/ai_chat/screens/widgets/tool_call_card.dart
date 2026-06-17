import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../data/models/chat_message.dart';

class ToolCallCard extends StatelessWidget {
  const ToolCallCard({super.key, required this.toolCall});
  final AiToolCallInfo toolCall;

  static String _humanName(String name) {
    return name
        .replaceAll('_', ' ')
        .split(' ')
        .map((w) => w.isEmpty ? '' : '${w[0].toUpperCase()}${w.substring(1)}')
        .join(' ');
  }

  @override
  Widget build(BuildContext context) {
    final isDone = !toolCall.isLoading;

    return Container(
      margin: const EdgeInsets.only(top: AppSpacing.xs),
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
      decoration: BoxDecoration(
        color: AppColors.bgPrimary,
        borderRadius: AppRadius.chipRadius,
        border: Border.all(
          color: isDone
              ? AppColors.profitGreen.withValues(alpha: 0.3)
              : AppColors.accentPurple.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: isDone
                ? const Icon(Icons.check_circle_rounded,
                        size: 14,
                        color: AppColors.profitGreen,
                        key: ValueKey('done'))
                    .animate()
                    .scale(begin: const Offset(0, 0), curve: Curves.easeOutBack)
                : SizedBox(
                    width: 14,
                    height: 14,
                    key: const ValueKey('loading'),
                    child: CircularProgressIndicator(
                      strokeWidth: 1.5,
                      color: AppColors.accentPurple.withValues(alpha: 0.8),
                    ),
                  ),
          ),
          const SizedBox(width: AppSpacing.xs),
          Text(
            _humanName(toolCall.name),
            style: AppTypography.caption.copyWith(
              color: isDone ? AppColors.profitGreen : AppColors.accentPurple,
            ),
          ),
        ],
      ),
    )
        .animate()
        .slideY(begin: 0.3, end: 0, duration: 200.ms, curve: Curves.easeOut)
        .fadeIn(duration: 200.ms);
  }
}
