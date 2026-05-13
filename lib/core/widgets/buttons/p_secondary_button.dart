import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_typography.dart';
import 'p_primary_button.dart';

class PSecondaryButton extends StatefulWidget {
  const PSecondaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.state = PButtonState.idle,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final PButtonState state;
  final Widget? icon;

  @override
  State<PSecondaryButton> createState() => _PSecondaryButtonState();
}

class _PSecondaryButtonState extends State<PSecondaryButton>
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
  void didUpdateWidget(PSecondaryButton old) {
    super.didUpdateWidget(old);
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

  @override
  Widget build(BuildContext context) {
    final isLoading = widget.state == PButtonState.loading;
    final isSuccess = widget.state == PButtonState.success;
    final isError = widget.state == PButtonState.error;
    final collapsed = isLoading || isSuccess;

    return GestureDetector(
      onTapDown: (_) {
        if (!_isEnabled) return;
        HapticFeedback.lightImpact();
        _pressCtrl.forward();
      },
      onTapUp: (_) => _pressCtrl.reverse(),
      onTapCancel: _pressCtrl.reverse,
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
          height: 52,
          width: collapsed ? 52 : double.infinity,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius:
                collapsed ? BorderRadius.circular(26) : AppRadius.buttonRadius,
            border: Border.all(
              color: isError
                  ? AppColors.lossRed
                  : _isEnabled || isLoading || isSuccess
                      ? AppColors.accent
                      : AppColors.textDisabled.withValues(alpha: 0.4),
              width: 1.5,
            ),
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
                        color: AppColors.accent,
                      ),
                    )
                  : isSuccess
                      ? const Icon(
                          key: ValueKey('s'),
                          Icons.check_rounded,
                          color: AppColors.accent,
                          size: 22,
                        )
                      : Padding(
                          key: const ValueKey('label'),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (widget.icon != null) ...[
                                widget.icon!,
                                const SizedBox(width: 8),
                              ],
                              Flexible(
                                child: Text(
                                  widget.label,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTypography.buttonLg
                                      .copyWith(color: AppColors.accent),
                                ),
                              ),
                            ],
                          ),
                        ),
            ),
          ),
        ),
      ),
    );
  }
}
