import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../positions/data/models/position.dart';

class PositionCard extends StatefulWidget {
  const PositionCard({
    super.key,
    required this.position,
    required this.onLockToggle,
    required this.onExitTap,
  });

  final Position position;
  final VoidCallback onLockToggle;
  final VoidCallback onExitTap;

  @override
  State<PositionCard> createState() => _PositionCardState();
}

class _PositionCardState extends State<PositionCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pressCtrl;
  late final Animation<double> _scaleAnim;
  Color? _flashColor;

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
  void didUpdateWidget(PositionCard old) {
    super.didUpdateWidget(old);
    if (widget.position.unrealizedPnl != old.position.unrealizedPnl) {
      final isUp = widget.position.unrealizedPnl > old.position.unrealizedPnl;
      setState(
        () => _flashColor = isUp ? AppColors.profitGreen : AppColors.lossRed,
      );
      Future.delayed(const Duration(milliseconds: 800), () {
        if (mounted) setState(() => _flashColor = null);
      });
    }
  }

  @override
  void dispose() {
    _pressCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pos = widget.position;
    final isLong = pos.side.toLowerCase() == 'long';
    final sideColor = isLong ? AppColors.profitGreen : AppColors.lossRed;

    return GestureDetector(
      onTapDown: (_) {
        HapticFeedback.lightImpact();
        _pressCtrl.forward();
      },
      onTapUp: (_) => _pressCtrl.reverse(),
      onTapCancel: _pressCtrl.reverse,
      onLongPress: () {
        HapticFeedback.mediumImpact();
        _showContextMenu(context);
      },
      child: AnimatedBuilder(
        animation: _scaleAnim,
        builder: (context, child) =>
            Transform.scale(scale: _scaleAnim.value, child: child),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            color: _flashColor?.withValues(alpha: 0.05) ?? AppColors.bgCard,
            borderRadius: AppRadius.cardRadius,
            border: Border.all(
              color:
                  _flashColor?.withValues(alpha: 0.4) ?? AppColors.borderLight,
              width: _flashColor != null ? 1.5 : 1,
            ),
          ),
          child: Padding(
            padding: AppSpacing.cardPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Header(pos: pos, sideColor: sideColor),
                const SizedBox(height: AppSpacing.sm),
                const Divider(height: 1),
                const SizedBox(height: AppSpacing.sm),
                _Footer(
                  pos: pos,
                  onLockToggle: widget.onLockToggle,
                  onExitTap: widget.onExitTap,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showContextMenu(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: AppRadius.sheetRadius,
      ),
      backgroundColor: AppColors.bgSurface,
      builder: (_) => _PositionContextMenu(
        position: widget.position,
        onLockToggle: widget.onLockToggle,
        onExitTap: widget.onExitTap,
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.pos, required this.sideColor});
  final Position pos;
  final Color sideColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.xs,
            ),
            decoration: BoxDecoration(
              color: sideColor.withValues(alpha: 0.1),
              borderRadius: AppRadius.chipRadius,
            ),
            child: Text(
              pos.symbol,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.label.copyWith(color: sideColor),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.xs),
        Text(
          '${pos.side.toUpperCase()} ${pos.leverage.toStringAsFixed(0)}x',
          style: AppTypography.bodySm.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(width: AppSpacing.xs),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: AppColors.accent.withValues(alpha: 0.08),
            borderRadius: AppRadius.pillRadius,
          ),
          child: Text(
            pos.source == 'external' ? 'External' : 'Poise',
            style: AppTypography.caption.copyWith(color: AppColors.accent),
          ),
        ),
        const Spacer(),
        if (pos.isLocked)
          const Icon(
            Icons.lock_rounded,
            size: 16,
            color: AppColors.warningAmber,
          ).animate().scale(
                begin: const Offset(0, 0),
                end: const Offset(1, 1),
                duration: 250.ms,
                curve: Curves.easeOutBack,
              ),
        const SizedBox(width: AppSpacing.xs),
        Flexible(
          child: TweenAnimationBuilder<double>(
            tween: Tween(
              begin: pos.unrealizedPnl - 0.01,
              end: pos.unrealizedPnl,
            ),
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeOut,
            builder: (context, value, _) {
              final sign = value >= 0 ? '+' : '';
              return FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerRight,
                child: Text(
                  '$sign\$${value.abs().toStringAsFixed(2)}',
                  maxLines: 1,
                  style: AppTypography.numericLg.copyWith(
                    color: AppColors.pnlColor(value),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer({
    required this.pos,
    required this.onLockToggle,
    required this.onExitTap,
  });

  final Position pos;
  final VoidCallback onLockToggle;
  final VoidCallback onExitTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _StatCell(
                label: 'Entry',
                value: '\$${pos.entryPrice.toStringAsFixed(2)}',
              ),
            ),
            Expanded(
              child: _StatCell(
                label: 'Mark',
                value: '\$${pos.currentPrice.toStringAsFixed(2)}',
              ),
            ),
            Expanded(
              child: _StatCell(
                label: 'Size',
                value: pos.quantity.toStringAsFixed(4),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Expanded(
              child: Text(
                pos.status.toUpperCase(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.label.copyWith(
                  color: pos.isLocked
                      ? AppColors.warningAmber
                      : AppColors.textSecondary,
                ),
              ),
            ),
            _CardIconButton(
              tooltip: pos.isLocked ? 'Unlock position' : 'Lock position',
              onTap: onLockToggle,
              icon: pos.isLocked ? Icons.lock_rounded : Icons.lock_open_rounded,
              color: pos.isLocked
                  ? AppColors.warningAmber
                  : AppColors.textDisabled,
            ),
            const SizedBox(width: AppSpacing.xs),
            _CardIconButton(
              tooltip:
                  'Edit or close this trade on your exchange. Poise will sync the update automatically.',
              onTap: () => _showExchangeOnlyNotice(context),
              icon: Icons.info_outline_rounded,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ],
    );
  }

  void _showExchangeOnlyNotice(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.bgSurface,
      shape: const RoundedRectangleBorder(borderRadius: AppRadius.sheetRadius),
      builder: (_) => SafeArea(
        child: Padding(
          padding: AppSpacing.screenPadding,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Exchange-managed trade', style: AppTypography.h3),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Edit or close this trade on your exchange. Poise will sync the update automatically.',
                style: AppTypography.body.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              FilledButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Got it'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CardIconButton extends StatelessWidget {
  const _CardIconButton({
    required this.tooltip,
    required this.onTap,
    required this.icon,
    required this.color,
  });

  final String tooltip;
  final VoidCallback onTap;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: AppColors.bgPrimary,
        borderRadius: AppRadius.pillRadius,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadius.pillRadius,
          child: SizedBox(
            width: 40,
            height: 40,
            child: Icon(icon, size: 20, color: color),
          ),
        ),
      ),
    );
  }
}

class _StatCell extends StatelessWidget {
  const _StatCell({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: 2),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(value, maxLines: 1, style: AppTypography.numericSm),
        ),
      ],
    );
  }
}

class _PositionContextMenu extends StatelessWidget {
  const _PositionContextMenu({
    required this.position,
    required this.onLockToggle,
    required this.onExitTap,
  });

  final Position position;
  final VoidCallback onLockToggle;
  final VoidCallback onExitTap;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: AppSpacing.screenPadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
            const SizedBox(height: AppSpacing.lg),
            Text(position.symbol, style: AppTypography.h3),
            const SizedBox(height: AppSpacing.md),
            ListTile(
              leading: Icon(
                position.isLocked
                    ? Icons.lock_open_rounded
                    : Icons.lock_rounded,
                color: AppColors.warningAmber,
              ),
              title: Text(
                position.isLocked ? 'Unlock position' : 'Lock position',
                style: AppTypography.body,
              ),
              onTap: () {
                Navigator.pop(context);
                onLockToggle();
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.info_outline_rounded,
                color: AppColors.textSecondary,
              ),
              title: const Text('Exchange-managed trade',
                  style: AppTypography.body),
              subtitle: const Text(
                'Edit or close this trade on your exchange. Poise will sync the update automatically.',
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: AppSpacing.md),
          ],
        ),
      ),
    );
  }
}
