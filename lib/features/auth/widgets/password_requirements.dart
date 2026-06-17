import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';

class PasswordRequirements extends StatelessWidget {
  const PasswordRequirements({
    super.key,
    required this.password,
  });

  final String password;

  bool get _hasMinLength => password.length >= 8;
  bool get _hasNumber => RegExp(r'\d').hasMatch(password);
  bool get _hasUppercase => RegExp(r'[A-Z]').hasMatch(password);
  bool get _hasLowercase => RegExp(r'[a-z]').hasMatch(password);
  bool get _hasSymbol => RegExp(r'[^A-Za-z0-9]').hasMatch(password);

  static bool isValid(String password) {
    return password.length >= 8 &&
        RegExp(r'\d').hasMatch(password) &&
        RegExp(r'[A-Z]').hasMatch(password) &&
        RegExp(r'[a-z]').hasMatch(password) &&
        RegExp(r'[^A-Za-z0-9]').hasMatch(password);
  }

  @override
  Widget build(BuildContext context) {
    final requirements = [
      (label: '8 characters long', met: _hasMinLength),
      (label: '1 number', met: _hasNumber),
      (label: '1 uppercase letter', met: _hasUppercase),
      (label: '1 lowercase letter', met: _hasLowercase),
      (label: '1 symbol', met: _hasSymbol),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Requires at least:',
          style: AppTypography.labelSm.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w600,
            letterSpacing: 0,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Wrap(
          spacing: AppSpacing.xs,
          runSpacing: AppSpacing.xs,
          children: [
            for (final req in requirements)
              _RequirementChip(label: req.label, met: req.met),
          ],
        ),
      ],
    );
  }
}

class _RequirementChip extends StatelessWidget {
  const _RequirementChip({
    required this.label,
    required this.met,
  });

  final String label;
  final bool met;

  @override
  Widget build(BuildContext context) {
    final color = met ? AppColors.profitGreen : AppColors.lossRed;
    final bg = met ? AppColors.profitGreenBg : AppColors.lossRedBg;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 160),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        border: Border.all(color: color.withValues(alpha: 0.35)),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: AppTypography.labelSm.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
          letterSpacing: 0,
        ),
      ),
    );
  }
}
