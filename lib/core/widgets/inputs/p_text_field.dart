import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';

enum PFieldState { idle, valid, error }

class PTextField extends StatefulWidget {
  const PTextField({
    super.key,
    this.controller,
    required this.label,
    this.hint,
    this.showLabelAbove = false,
    this.keyboardType,
    this.obscureText = false,
    this.fieldState = PFieldState.idle,
    this.errorText,
    this.onChanged,
    this.onEditingComplete,
    this.textInputAction,
    this.focusNode,
    this.maxLength,
    this.enabled = true,
    this.autofocus = false,
    this.compact = false,
    this.showObscureToggle = true,
    this.showValidationIcon = true,
  });

  final TextEditingController? controller;
  final String label;
  final String? hint;
  final bool showLabelAbove;
  final TextInputType? keyboardType;
  final bool obscureText;
  final PFieldState fieldState;
  final String? errorText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onEditingComplete;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final int? maxLength;
  final bool enabled;
  final bool autofocus;
  final bool compact;
  final bool showObscureToggle;
  final bool showValidationIcon;

  @override
  State<PTextField> createState() => _PTextFieldState();
}

class _PTextFieldState extends State<PTextField>
    with SingleTickerProviderStateMixin {
  late final AnimationController _shakeCtrl;
  bool _obscured = true;

  @override
  void initState() {
    super.initState();
    _obscured = widget.obscureText;
    _shakeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void didUpdateWidget(PTextField old) {
    super.didUpdateWidget(old);
    if (widget.fieldState == PFieldState.error &&
        old.fieldState != PFieldState.error) {
      _shakeCtrl.forward(from: 0).then((_) => _shakeCtrl.reset());
      HapticFeedback.mediumImpact();
    }
  }

  @override
  void dispose() {
    _shakeCtrl.dispose();
    super.dispose();
  }

  Widget _buildSuffix() {
    final iconColor = Theme.of(context).colorScheme.onSurfaceVariant;

    if (widget.fieldState == PFieldState.error) {
      return const Padding(
        padding: EdgeInsets.only(right: 4),
        child: Icon(
          Icons.error_outline_rounded,
          size: 20,
          color: AppColors.lossRed,
        ),
      );
    }
    if (widget.obscureText && widget.showObscureToggle) {
      return IconButton(
        tooltip: _obscured ? 'Show value' : 'Hide value',
        onPressed: widget.enabled
            ? () => setState(() => _obscured = !_obscured)
            : null,
        icon: Icon(
          _obscured ? Icons.visibility_off_outlined : Icons.visibility_outlined,
          size: 20,
          color: widget.enabled ? iconColor : AppColors.textDisabled,
        ),
      );
    }
    if (widget.fieldState == PFieldState.valid && widget.showValidationIcon) {
      return Padding(
        padding: const EdgeInsets.only(right: 4),
        child: const Icon(
          Icons.check_circle_outline_rounded,
          size: 20,
          color: AppColors.profitGreen,
        )
            .animate()
            .scale(
              begin: const Offset(0.6, 0.6),
              end: const Offset(1, 1),
              duration: 200.ms,
              curve: Curves.easeOutBack,
            )
            .fadeIn(duration: 150.ms),
      );
    }
    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    final isError = widget.fieldState == PFieldState.error;
    final colorScheme = Theme.of(context).colorScheme;
    final inputRadius = BorderRadius.circular(widget.compact ? 8 : 12);
    final outlineColor =
        isError ? AppColors.lossRed : Theme.of(context).colorScheme.outline;
    final focusColor = isError ? AppColors.lossRed : AppColors.primary;

    final field = AnimatedBuilder(
      animation: _shakeCtrl,
      builder: (context, child) {
        final shake = _shakeCtrl.isAnimating
            ? 20.0 * sin(_shakeCtrl.value * 3 * pi)
            : 0.0;
        return Transform.translate(offset: Offset(shake, 0), child: child);
      },
      child: TextFormField(
        controller: widget.controller,
        focusNode: widget.focusNode,
        obscureText: widget.obscureText ? _obscured : false,
        keyboardType: widget.keyboardType,
        textInputAction: widget.textInputAction,
        onEditingComplete: widget.onEditingComplete,
        onChanged: widget.onChanged,
        maxLength: widget.maxLength,
        enabled: widget.enabled,
        autofocus: widget.autofocus,
        cursorColor: AppColors.primary,
        style: AppTypography.body.copyWith(color: colorScheme.onSurface),
        decoration: InputDecoration(
          labelText: widget.showLabelAbove ? null : widget.label,
          hintText: widget.hint,
          errorText: isError ? widget.errorText : null,
          suffixIcon: _buildSuffix(),
          suffixIconConstraints: BoxConstraints(
            minWidth: widget.compact ? 40 : 44,
            minHeight: widget.compact ? 48 : 44,
          ),
          counterText: '',
          isDense: widget.compact,
          constraints:
              widget.compact ? const BoxConstraints.tightFor(height: 48) : null,
          contentPadding: widget.compact
              ? const EdgeInsets.symmetric(horizontal: 14, vertical: 13)
              : null,
          border: widget.compact
              ? OutlineInputBorder(
                  borderRadius: inputRadius,
                  borderSide: BorderSide(
                    color: outlineColor,
                  ),
                )
              : null,
          enabledBorder: widget.compact
              ? OutlineInputBorder(
                  borderRadius: inputRadius,
                  borderSide: BorderSide(
                    color: outlineColor,
                  ),
                )
              : null,
          focusedBorder: widget.compact
              ? OutlineInputBorder(
                  borderRadius: inputRadius,
                  borderSide: BorderSide(
                    color: focusColor,
                    width: 1.5,
                  ),
                )
              : null,
          errorBorder: widget.compact
              ? OutlineInputBorder(
                  borderRadius: inputRadius,
                  borderSide: const BorderSide(
                    color: AppColors.lossRed,
                    width: 1,
                  ),
                )
              : null,
          focusedErrorBorder: widget.compact
              ? OutlineInputBorder(
                  borderRadius: inputRadius,
                  borderSide: const BorderSide(
                    color: AppColors.lossRed,
                    width: 1.5,
                  ),
                )
              : null,
        ),
      ),
    );

    if (!widget.showLabelAbove) return field;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          widget.label,
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        field,
      ],
    );
  }
}
