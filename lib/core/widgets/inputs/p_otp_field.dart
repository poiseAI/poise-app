import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinput/pinput.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_typography.dart';

enum POtpState { idle, error, success }

class POtpField extends StatefulWidget {
  const POtpField({
    super.key,
    this.length = 6,
    this.onCompleted,
    this.onChanged,
    this.state = POtpState.idle,
    this.controller,
    this.focusNode,
    this.obscureText = false,
    this.autofocus = false,
    this.enabled = true,
  });

  final int length;
  final ValueChanged<String>? onCompleted;
  final ValueChanged<String>? onChanged;
  final POtpState state;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool obscureText;
  final bool autofocus;
  final bool enabled;

  @override
  State<POtpField> createState() => _POtpFieldState();
}

class _POtpFieldState extends State<POtpField>
    with SingleTickerProviderStateMixin {
  late final AnimationController _shakeCtrl;

  @override
  void initState() {
    super.initState();
    _shakeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
  }

  @override
  void didUpdateWidget(POtpField old) {
    super.didUpdateWidget(old);
    if (widget.state == POtpState.error && old.state != POtpState.error) {
      _shakeCtrl.forward(from: 0).then((_) => _shakeCtrl.reset());
      HapticFeedback.heavyImpact();
    }
    if (widget.state == POtpState.success && old.state != POtpState.success) {
      HapticFeedback.lightImpact();
    }
  }

  @override
  void dispose() {
    _shakeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isError = widget.state == POtpState.error;
    final isSuccess = widget.state == POtpState.success;
    final activeColor = isError
        ? AppColors.lossRed
        : isSuccess
            ? AppColors.profitGreen
            : AppColors.accent;

    final base = PinTheme(
      width: 52,
      height: 58,
      textStyle: AppTypography.h3.copyWith(fontFamily: 'Orbitron'),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: AppRadius.inputRadius,
        border: Border.all(color: AppColors.borderLight, width: 1),
      ),
    );

    final focused = base.copyWith(
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: AppRadius.inputRadius,
        border: Border.all(color: activeColor, width: 2),
      ),
    );

    final submitted = base.copyWith(
      decoration: BoxDecoration(
        color: isSuccess
            ? AppColors.profitGreen.withValues(alpha: 0.08)
            : isError
                ? AppColors.lossRed.withValues(alpha: 0.08)
                : AppColors.accent.withValues(alpha: 0.06),
        borderRadius: AppRadius.inputRadius,
        border: Border.all(
          color: isSuccess
              ? AppColors.profitGreen
              : isError
                  ? AppColors.lossRed
                  : AppColors.accent.withValues(alpha: 0.4),
          width: 1.5,
        ),
      ),
    );

    return AnimatedBuilder(
      animation: _shakeCtrl,
      builder: (context, child) {
        final shake = _shakeCtrl.isAnimating
            ? 12.0 * sin(_shakeCtrl.value * 4 * pi)
            : 0.0;
        return Transform.translate(offset: Offset(shake, 0), child: child);
      },
      child: Pinput(
        length: widget.length,
        controller: widget.controller,
        focusNode: widget.focusNode,
        obscureText: widget.obscureText,
        autofocus: widget.autofocus,
        enabled: widget.enabled,
        defaultPinTheme: base,
        focusedPinTheme: focused,
        submittedPinTheme: submitted,
        keyboardType: TextInputType.number,
        onCompleted: widget.onCompleted,
        onChanged: (val) {
          HapticFeedback.selectionClick();
          widget.onChanged?.call(val);
        },
        animationDuration: const Duration(milliseconds: 120),
        animationCurve: Curves.easeOutBack,
        pinAnimationType: PinAnimationType.slide,
      ),
    );
  }
}
