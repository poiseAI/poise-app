import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

class TpSlSection extends StatefulWidget {
  const TpSlSection({
    super.key,
    required this.tpLevels,
    required this.slPrice,
    required this.onAddTp,
    required this.onRemoveTp,
    required this.onSlChanged,
  });

  final List<double> tpLevels;
  final double? slPrice;
  final ValueChanged<double> onAddTp;
  final ValueChanged<int> onRemoveTp;
  final ValueChanged<double?> onSlChanged;

  @override
  State<TpSlSection> createState() => _TpSlSectionState();
}

class _TpSlSectionState extends State<TpSlSection> {
  bool _expanded = false;
  final _tpCtrl = TextEditingController();
  final _slCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.slPrice != null) {
      _slCtrl.text = widget.slPrice!.toStringAsFixed(2);
    }
    _slCtrl.addListener(_onSlChanged);
  }

  void _onSlChanged() {
    final val = double.tryParse(_slCtrl.text);
    widget.onSlChanged(val);
  }

  void _addTp() {
    final val = double.tryParse(_tpCtrl.text);
    if (val != null && val > 0) {
      widget.onAddTp(val);
      _tpCtrl.clear();
    }
  }

  @override
  void dispose() {
    _tpCtrl.dispose();
    _slCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOutCubic,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          borderRadius: AppRadius.cardRadius,
          border: Border.all(color: AppColors.borderLight),
        ),
        child: Column(
          children: [
            GestureDetector(
              onTap: () => setState(() => _expanded = !_expanded),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Row(
                  children: [
                    const Icon(Icons.tune_rounded,
                        size: 16, color: AppColors.textSecondary),
                    const SizedBox(width: AppSpacing.xs),
                    Text('TP / SL',
                        style: AppTypography.label
                            .copyWith(color: AppColors.textSecondary)),
                    if (widget.tpLevels.isNotEmpty || widget.slPrice != null) ...[
                      const SizedBox(width: AppSpacing.xs),
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: AppColors.accent,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                    const Spacer(),
                    AnimatedRotation(
                      turns: _expanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 200),
                      child: const Icon(Icons.keyboard_arrow_down_rounded,
                          size: 18, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
            ),
            if (_expanded)
              Padding(
                padding: const EdgeInsets.fromLTRB(
                    AppSpacing.md, 0, AppSpacing.md, AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Divider(height: 1),
                    const SizedBox(height: AppSpacing.md),
                    // SL field
                    _PriceField(
                      label: 'Stop Loss',
                      controller: _slCtrl,
                      color: AppColors.lossRed,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    // TP levels
                    Text('Take Profit levels',
                        style: AppTypography.caption
                            .copyWith(color: AppColors.textSecondary)),
                    const SizedBox(height: AppSpacing.xs),
                    ...widget.tpLevels.asMap().entries.map((e) {
                      return _TpRow(
                        index: e.key,
                        price: e.value,
                        onRemove: () => widget.onRemoveTp(e.key),
                      )
                          .animate()
                          .slideY(
                            begin: -0.3,
                            end: 0,
                            duration: 200.ms,
                            curve: Curves.easeOutCubic,
                          )
                          .fadeIn(duration: 200.ms);
                    }),
                    const SizedBox(height: AppSpacing.xs),
                    Row(
                      children: [
                        Expanded(
                          child: _PriceField(
                            label: 'Add TP level',
                            controller: _tpCtrl,
                            color: AppColors.profitGreen,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        GestureDetector(
                          onTap: _addTp,
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: AppColors.profitGreen.withValues(alpha: 0.12),
                              borderRadius: AppRadius.chipRadius,
                            ),
                            child: const Icon(Icons.add_rounded,
                                size: 18, color: AppColors.profitGreen),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _TpRow extends StatelessWidget {
  const _TpRow(
      {required this.index, required this.price, required this.onRemove});
  final int index;
  final double price;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: AppColors.profitGreen.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              '${index + 1}',
              style: AppTypography.caption.copyWith(color: AppColors.profitGreen),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Text('\$${price.toStringAsFixed(2)}', style: AppTypography.numericSm),
          const Spacer(),
          GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              onRemove();
            },
            child: const Icon(Icons.close_rounded,
                size: 16, color: AppColors.textDisabled),
          ),
        ],
      ),
    );
  }
}

class _PriceField extends StatelessWidget {
  const _PriceField(
      {required this.label,
      required this.controller,
      required this.color});
  final String label;
  final TextEditingController controller;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      style: AppTypography.numericSm,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: AppTypography.caption.copyWith(color: AppColors.textSecondary),
        prefixText: '\$ ',
        prefixStyle: AppTypography.numericSm.copyWith(color: AppColors.textSecondary),
        filled: true,
        fillColor: color.withValues(alpha: 0.04),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.chipRadius,
          borderSide: BorderSide(color: color.withValues(alpha: 0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.chipRadius,
          borderSide: BorderSide(color: color, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
      ),
    );
  }
}
