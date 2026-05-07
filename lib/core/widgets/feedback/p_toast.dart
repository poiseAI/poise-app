import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:toastification/toastification.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';

enum ToastType { info, success, error }

abstract final class PToast {
  static void show(
    BuildContext context, {
    required String message,
    ToastType type = ToastType.info,
    Duration duration = const Duration(seconds: 3),
  }) {
    final toastType = switch (type) {
      ToastType.success => ToastificationType.success,
      ToastType.error => ToastificationType.error,
      ToastType.info => ToastificationType.info,
    };
    final accentColor = switch (type) {
      ToastType.success => AppColors.profitGreen,
      ToastType.error => AppColors.lossRed,
      ToastType.info => AppColors.accentPurple,
    };
    final icon = switch (type) {
      ToastType.success => Icons.check_circle_rounded,
      ToastType.error => Icons.error_rounded,
      ToastType.info => Icons.info_rounded,
    };

    switch (type) {
      case ToastType.success:
        HapticFeedback.lightImpact();
      case ToastType.error:
      case ToastType.info:
        HapticFeedback.mediumImpact();
    }

    toastification.show(
      context: context,
      type: toastType,
      style: ToastificationStyle.flat,
      autoCloseDuration: duration,
      alignment: Alignment.topCenter,
      title: Text(
        message,
        style: AppTypography.body.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
      icon: Icon(icon, color: accentColor),
      primaryColor: accentColor,
      backgroundColor: AppColors.bgCard,
      foregroundColor: AppColors.textPrimary,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      borderRadius: AppRadius.cardRadius,
      borderSide: BorderSide(color: accentColor.withValues(alpha: 0.28)),
      boxShadow: [
        BoxShadow(
          color: AppColors.textPrimary.withValues(alpha: 0.12),
          blurRadius: 24,
          offset: const Offset(0, 12),
        ),
      ],
      showProgressBar: false,
      closeButtonShowType: CloseButtonShowType.none,
      closeOnClick: true,
      dragToClose: true,
    );
  }

  static void success(BuildContext context, String message) =>
      show(context, message: message, type: ToastType.success);

  static void error(BuildContext context, String message) =>
      show(context, message: message, type: ToastType.error);

  static void info(BuildContext context, String message) =>
      show(context, message: message, type: ToastType.info);
}
