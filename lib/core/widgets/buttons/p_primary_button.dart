import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_typography.dart';

enum PButtonState { idle, loading, success, error }

class PPrimaryButton extends StatefulWidget {
  const PPrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.state = PButtonState.idle,
    this.icon,
    this.height = 52,
    this.borderRadius,
    this.textStyle,
    this.disabledLabelColor,
  });

  final String label;
  final VoidCallback? onPressed;
  final PButtonState state;
  final Widget? icon;
  final double height;
  final BorderRadius? borderRadius;
  final TextStyle? textStyle;
  final Color? disabledLabelColor;

  @override
  State<PPrimaryButton> createState() => _PPrimaryButtonState();
}

class _PPrimaryButtonState extends State<PPrimaryButton>
    with TickerProviderStateMixin {
  late final AnimationController _pressCtrl;
  late final AnimationController _shakeCtrl;
  late final Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _pressCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 80),
      reverseDuration: const Duration(milliseconds: 120),
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _pressCtrl, curve: Curves.easeIn),
    );
    _shakeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void didUpdateWidget(PPrimaryButton old) {
    super.didUpdateWidget(old);
    if (widget.state == PButtonState.loading &&
        old.state != PButtonState.loading) {
      HapticFeedback.mediumImpact();
    }
    if (widget.state == PButtonState.error && old.state != PButtonState.error) {
      _shakeCtrl.forward(from: 0).then((_) => _shakeCtrl.reset());
      HapticFeedback.mediumImpact();
    }
  }

  @override
  void dispose() {
    _pressCtrl.dispose();
    _shakeCtrl.dispose();
    super.dispose();
  }

  bool get _isEnabled =>
      widget.onPressed != null && widget.state == PButtonState.idle;

  void _onTapDown(TapDownDetails _) {
    if (!_isEnabled) return;
    HapticFeedback.lightImpact();
    _pressCtrl.forward();
  }

  void _onTapUp(TapUpDetails _) => _pressCtrl.reverse();
  void _onTapCancel() => _pressCtrl.reverse();

  @override
  Widget build(BuildContext context) {
    final isLoading = widget.state == PButtonState.loading;
    final isSuccess = widget.state == PButtonState.success;
    final isError = widget.state == PButtonState.error;
    final radius = widget.borderRadius ?? AppRadius.buttonRadius;
    final isDisabled =
        widget.onPressed == null && widget.state == PButtonState.idle;

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: _isEnabled ? widget.onPressed : null,
      child: AnimatedBuilder(
        animation: Listenable.merge([_scaleAnim, _shakeCtrl]),
        builder: (context, child) {
          final shake = _shakeCtrl.isAnimating
              ? 8.0 * sin(_shakeCtrl.value * 3 * pi)
              : 0.0;
          return Transform.translate(
            offset: Offset(shake, 0),
            child: Transform.scale(scale: _scaleAnim.value, child: child),
          );
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          height: widget.height,
          width: double.infinity,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: isError
                ? AppColors.lossRed
                : _isEnabled || isLoading || isSuccess
                    ? AppColors.accent
                    : AppColors.bgCardElevated,
            borderRadius: radius,
          ),
          child: Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: isLoading
                  ? const SizedBox(
                      key: ValueKey('l'),
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: Colors.white,
                      ),
                    )
                  : isSuccess
                      ? const Icon(
                          key: ValueKey('s'),
                          Icons.check_rounded,
                          color: Colors.white,
                          size: 22,
                        )
                      : _LabelRow(
                          key: const ValueKey('label'),
                          label: widget.label,
                          icon: widget.icon,
                          textStyle: widget.textStyle,
                          color: isDisabled
                              ? widget.disabledLabelColor ??
                                  AppColors.textDisabled
                              : Colors.white,
                        ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LabelRow extends StatelessWidget {
  const _LabelRow({
    super.key,
    required this.label,
    this.icon,
    this.textStyle,
    required this.color,
  });
  final String label;
  final Widget? icon;
  final TextStyle? textStyle;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[icon!, const SizedBox(width: 8)],
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: (textStyle ?? AppTypography.buttonLg).copyWith(
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
