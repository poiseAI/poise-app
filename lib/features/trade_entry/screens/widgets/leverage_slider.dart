import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

class LeverageSlider extends StatefulWidget {
  const LeverageSlider({
    super.key,
    required this.value,
    required this.max,
    required this.onChanged,
  });

  final double value;
  final int max;
  final ValueChanged<double> onChanged;

  @override
  State<LeverageSlider> createState() => _LeverageSliderState();
}

class _LeverageSliderState extends State<LeverageSlider> {
  late double _prev;

  @override
  void initState() {
    super.initState();
    _prev = widget.value;
  }

  void _onChanged(double val) {
    final rounded = val.roundToDouble();
    if (rounded != _prev) {
      HapticFeedback.selectionClick();
      _prev = rounded;
    }
    widget.onChanged(rounded);
  }

  @override
  Widget build(BuildContext context) {
    const presets = [1, 5, 10, 25, 50, 100];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('Leverage',
                style: AppTypography.label
                    .copyWith(color: AppColors.textSecondary)),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.accent.withValues(alpha: 0.12),
                borderRadius:
                    const BorderRadius.all(Radius.circular(AppRadius.sm)),
              ),
              child: Text(
                '${widget.value.toStringAsFixed(0)}x',
                style:
                    AppTypography.numericSm.copyWith(color: AppColors.accent),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        SliderTheme(
          data: SliderThemeData(
            trackHeight: 3,
            activeTrackColor: AppColors.accent,
            inactiveTrackColor: AppColors.bgPrimary,
            thumbColor: AppColors.accent,
            overlayColor: AppColors.accent.withValues(alpha: 0.12),
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
          ),
          child: Slider(
            min: 1,
            max: widget.max.toDouble(),
            divisions: widget.max - 1,
            value: widget.value.clamp(1, widget.max.toDouble()),
            onChanged: _onChanged,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: presets
              .where((p) => p <= widget.max)
              .map(
                (p) => GestureDetector(
                  onTap: () {
                    HapticFeedback.selectionClick();
                    widget.onChanged(p.toDouble());
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm, vertical: 2),
                    decoration: BoxDecoration(
                      color: widget.value == p
                          ? AppColors.accent.withValues(alpha: 0.12)
                          : Colors.transparent,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(AppRadius.sm)),
                      border: Border.all(
                        color: widget.value == p
                            ? AppColors.accent
                            : AppColors.borderLight,
                      ),
                    ),
                    child: Text(
                      '${p}x',
                      style: AppTypography.caption.copyWith(
                        color: widget.value == p
                            ? AppColors.accent
                            : AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
