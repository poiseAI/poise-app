import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

class BillingSectionLabel extends StatelessWidget {
  const BillingSectionLabel(this.label, {super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: AppTypography.body.copyWith(
        color: AppColors.textHeading,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
