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
  });

  final TextEditingController? controller;
  final String label;
  final String? hint;
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
    if (widget.obscureText) {
      return GestureDetector(
        onTap: () => setState(() => _obscured = !_obscured),
        child: Padding(
          padding: const EdgeInsets.only(right: 4),
          child: Icon(
            _obscured
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            size: 20,
            color: AppColors.textSecondary,
          ),
        ),
      );
    }
    if (widget.fieldState == PFieldState.valid) {
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

    return AnimatedBuilder(
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
        style: AppTypography.body,
        decoration: InputDecoration(
          labelText: widget.label,
          hintText: widget.hint,
          errorText: isError ? widget.errorText : null,
          suffixIcon: _buildSuffix(),
          suffixIconConstraints:
              const BoxConstraints(minWidth: 44, minHeight: 44),
          counterText: '',
        ),
      ),
    );
  }
}
