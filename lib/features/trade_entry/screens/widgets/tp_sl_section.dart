import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

class TpSlSection extends StatelessWidget {
  const TpSlSection({
    super.key,
    required this.stopLoss,
    required this.takeProfit1,
    required this.takeProfit2,
    required this.autoProgression,
    required this.onStopLossChanged,
    required this.onTakeProfit1Changed,
    required this.onTakeProfit2Changed,
    required this.onAutoProgressionChanged,
  });

  final double? stopLoss;
  final double? takeProfit1;
  final double? takeProfit2;
  final bool autoProgression;
  final ValueChanged<double?> onStopLossChanged;
  final ValueChanged<double?> onTakeProfit1Changed;
  final ValueChanged<double?> onTakeProfit2Changed;
  final ValueChanged<bool> onAutoProgressionChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpacing.cardPadding,
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: AppRadius.cardRadius,
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('TP/SL', style: AppTypography.h4),
              const Spacer(),
              Text('Add TP2',
                  style: AppTypography.label.copyWith(color: AppColors.accent)),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          _PriceField(
            label: 'Stop Loss',
            initialValue: stopLoss,
            onChanged: onStopLossChanged,
          ),
          const SizedBox(height: AppSpacing.md),
          _PriceField(
            label: 'Take Profit',
            hint: 'TP1',
            initialValue: takeProfit1,
            onChanged: onTakeProfit1Changed,
          ),
          const SizedBox(height: AppSpacing.md),
          _PriceField(
            label: 'Take Profit 2',
            hint: 'Optional',
            initialValue: takeProfit2,
            onChanged: onTakeProfit2Changed,
          ),
          const SizedBox(height: AppSpacing.sm),
          SwitchListTile.adaptive(
            contentPadding: EdgeInsets.zero,
            value: autoProgression,
            onChanged: onAutoProgressionChanged,
            title: const Text(
              'Automatic Stop Loss progression',
              style: AppTypography.body,
            ),
          ),
        ],
      ),
    );
  }
}

class _PriceField extends StatefulWidget {
  const _PriceField({
    required this.label,
    required this.initialValue,
    required this.onChanged,
    this.hint,
  });

  final String label;
  final String? hint;
  final double? initialValue;
  final ValueChanged<double?> onChanged;

  @override
  State<_PriceField> createState() => _PriceFieldState();
}

class _PriceFieldState extends State<_PriceField> {
  late final TextEditingController _ctrl;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _ctrl = TextEditingController(
      text: _format(widget.initialValue),
    );
  }

  @override
  void didUpdateWidget(covariant _PriceField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_focusNode.hasFocus) return;
    if (oldWidget.initialValue == widget.initialValue) return;
    final nextText = _format(widget.initialValue);
    if (_ctrl.text == nextText) return;
    _ctrl.value = TextEditingValue(
      text: nextText,
      selection: TextSelection.collapsed(offset: nextText.length),
    );
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _ctrl,
      focusNode: _focusNode,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      style: AppTypography.numericSm,
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.hint ?? '1,000',
        prefixText: '\$',
        filled: true,
        fillColor: AppColors.bgPrimary,
        enabledBorder: const OutlineInputBorder(
          borderRadius: AppRadius.chipRadius,
          borderSide: BorderSide(color: AppColors.borderLight),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: AppRadius.chipRadius,
          borderSide: BorderSide(color: AppColors.accent, width: 1.5),
        ),
      ),
      onChanged: (value) => widget.onChanged(double.tryParse(value)),
    );
  }

  String _format(double? value) {
    if (value == null) return '';
    if (value >= 100) return value.toStringAsFixed(2);
    if (value >= 1) return _trimFixed(value, 4);
    return _trimFixed(value, 6);
  }

  String _trimFixed(double value, int fractionDigits) {
    final text = value.toStringAsFixed(fractionDigits);
    final trimmed = text.replaceFirst(RegExp(r'\.?0+$'), '');
    return trimmed.isEmpty ? '0' : trimmed;
  }
}
