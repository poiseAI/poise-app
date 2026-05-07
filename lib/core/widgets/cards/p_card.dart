import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_shadows.dart';
import '../../theme/app_spacing.dart';

class PCard extends StatefulWidget {
  const PCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
    this.onLongPress,
    this.color,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final Color? color;

  @override
  State<PCard> createState() => _PCardState();
}

class _PCardState extends State<PCard> with SingleTickerProviderStateMixin {
  late final AnimationController _pressCtrl;
  late final Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _pressCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 80),
      reverseDuration: const Duration(milliseconds: 150),
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.98).animate(
      CurvedAnimation(parent: _pressCtrl, curve: Curves.easeIn),
    );
  }

  @override
  void dispose() {
    _pressCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final interactive = widget.onTap != null || widget.onLongPress != null;

    return GestureDetector(
      onTapDown: interactive
          ? (_) {
              HapticFeedback.lightImpact();
              _pressCtrl.forward();
            }
          : null,
      onTapUp: interactive ? (_) => _pressCtrl.reverse() : null,
      onTapCancel: interactive ? _pressCtrl.reverse : null,
      onTap: widget.onTap,
      onLongPress: widget.onLongPress != null
          ? () {
              HapticFeedback.mediumImpact();
              widget.onLongPress!();
            }
          : null,
      child: AnimatedBuilder(
        animation: _scaleAnim,
        builder: (context, child) => Transform.scale(
          scale: _scaleAnim.value,
          child: child,
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: widget.padding ?? AppSpacing.cardPadding,
          decoration: BoxDecoration(
            color: widget.color ?? AppColors.bgCard,
            borderRadius: AppRadius.cardRadius,
            border: Border.all(color: AppColors.borderLight, width: 1),
            boxShadow: _pressCtrl.value > 0
                ? AppShadows.cardPressed
                : AppShadows.sm,
          ),
          child: widget.child,
        ),
      ),
    );
  }
}
