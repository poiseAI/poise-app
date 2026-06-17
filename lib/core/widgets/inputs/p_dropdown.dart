import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';

class PDropdownItem<T> {
  const PDropdownItem(
      {required this.value, required this.label, this.subtitle});
  final T value;
  final String label;
  final String? subtitle;
}

class PDropdown<T> extends StatelessWidget {
  const PDropdown({
    super.key,
    required this.label,
    required this.items,
    required this.onSelected,
    this.selected,
    this.hint = 'Select',
  });

  final String label;
  final List<PDropdownItem<T>> items;
  final void Function(T value) onSelected;
  final T? selected;
  final String hint;

  @override
  Widget build(BuildContext context) {
    final selectedItem = selected != null
        ? items.where((i) => i.value == selected).firstOrNull
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTypography.label),
        const SizedBox(height: AppSpacing.xs),
        GestureDetector(
          onTap: () => _showSheet(context),
          child: Container(
            height: 52,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.bgCard,
              borderRadius: AppRadius.inputRadius,
              border: Border.all(color: AppColors.borderLight),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    selectedItem?.label ?? hint,
                    style: AppTypography.body.copyWith(
                      color: selectedItem != null
                          ? AppColors.textPrimary
                          : AppColors.textDisabled,
                    ),
                  ),
                ),
                const Icon(Icons.expand_more_rounded,
                    color: AppColors.textSecondary),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showSheet(BuildContext context) {
    HapticFeedback.lightImpact();
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: AppRadius.sheetRadius),
      backgroundColor: AppColors.bgSurface,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: AppSpacing.sm),
            Container(
              width: 36,
              height: 4,
              decoration: const BoxDecoration(
                color: AppColors.borderLight,
                borderRadius: AppRadius.pillRadius,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Padding(
              padding: AppSpacing.screenPadding,
              child: Text(label, style: AppTypography.h4),
            ),
            ...items.map((item) => ListTile(
                  title: Text(item.label, style: AppTypography.body),
                  subtitle: item.subtitle != null
                      ? Text(item.subtitle!,
                          style: AppTypography.bodySm
                              .copyWith(color: AppColors.textSecondary))
                      : null,
                  trailing: item.value == selected
                      ? const Icon(Icons.check_rounded, color: AppColors.accent)
                      : null,
                  onTap: () {
                    HapticFeedback.selectionClick();
                    Navigator.pop(context);
                    onSelected(item.value);
                  },
                )),
            const SizedBox(height: AppSpacing.md),
          ],
        ),
      ),
    );
  }
}
