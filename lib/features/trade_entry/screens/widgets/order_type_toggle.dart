import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_typography.dart';
import '../../providers/trade_form_provider.dart';

class OrderTypeToggle extends StatelessWidget {
  const OrderTypeToggle({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final OrderType selected;
  final ValueChanged<OrderType> onChanged;

  static const _types = [OrderType.market, OrderType.limit];
  static const _labels = ['Market execution', 'Price limit'];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        borderRadius: AppRadius.cardRadius,
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Row(
        children: List.generate(_types.length, (i) {
          final active = selected == _types[i];
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(_types[i]),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOut,
                decoration: BoxDecoration(
                  color: active ? AppColors.bgPrimary : Colors.transparent,
                  borderRadius: AppRadius.cardRadius,
                  border: Border.all(
                    color: active ? AppColors.borderLight : Colors.transparent,
                  ),
                  boxShadow: active
                      ? [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          )
                        ]
                      : null,
                ),
                alignment: Alignment.center,
                child: Text(
                  _labels[i],
                  style: AppTypography.label.copyWith(
                    color: active
                        ? AppColors.textPrimary
                        : AppColors.textSecondary,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
