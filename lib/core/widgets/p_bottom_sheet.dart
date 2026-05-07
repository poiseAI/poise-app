import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';

/// Show a modal bottom sheet using smooth_sheets with Poise defaults.
/// Callers get a drag handle, rounded top corners, and backdrop blur.
Future<T?> showPBottomSheet<T>({
  required BuildContext context,
  required Widget child,
  bool isDismissible = true,
  bool showHandle = true,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isDismissible: isDismissible,
    enableDrag: isDismissible,
    isScrollControlled: true,
    useSafeArea: true,
    barrierColor: Colors.black54,
    backgroundColor: AppColors.transparent,
    builder: (_) => _PSheet(showHandle: showHandle, child: child),
  );
}

class _PSheet extends StatelessWidget {
  const _PSheet({required this.child, required this.showHandle});
  final Widget child;
  final bool showHandle;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.bgSurface,
        borderRadius: AppRadius.sheetRadius,
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 24,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showHandle) ...[
              const SizedBox(height: AppSpacing.sm),
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: const BoxDecoration(
                    color: AppColors.borderLight,
                    borderRadius: AppRadius.pillRadius,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
            ],
            child,
          ],
        ),
      ),
    );
  }
}
