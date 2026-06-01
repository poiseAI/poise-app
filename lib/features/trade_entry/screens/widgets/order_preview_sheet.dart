import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/buttons/p_primary_button.dart';
import '../../providers/trade_form_provider.dart';

class OrderPreviewSheet extends ConsumerStatefulWidget {
  const OrderPreviewSheet({super.key});

  @override
  ConsumerState<OrderPreviewSheet> createState() => _OrderPreviewSheetState();
}

class _OrderPreviewSheetState extends ConsumerState<OrderPreviewSheet> {
  bool _submitted = false;

  @override
  Widget build(BuildContext context) {
    final form = ref.watch(tradeFormProvider);
    final notifier = ref.read(tradeFormProvider.notifier);

    ref.listen(tradeFormProvider, (prev, next) {
      if (prev?.isSubmitting == true && !next.isSubmitting) {
        if (next.lastOrder != null) {
          setState(() => _submitted = true);
          final nav = Navigator.of(context);
          Future.delayed(const Duration(milliseconds: 1500), () {
            if (mounted) nav.pop();
          });
        }
      }
    });

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: AppRadius.sheetRadius,
      ),
      child: SafeArea(
        child: Padding(
          padding: AppSpacing.screenPadding,
          child: _submitted
              ? _SuccessBody()
              : _PreviewBody(form: form, notifier: notifier),
        ),
      ),
    );
  }
}

class _SuccessBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: AppSpacing.lg),
        Container(
          width: 64,
          height: 64,
          decoration: const BoxDecoration(
            color: AppColors.profitGreen,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.check_rounded, color: Colors.white, size: 32),
        )
            .animate()
            .scale(begin: const Offset(0.5, 0.5), curve: Curves.easeOutBack),
        const SizedBox(height: AppSpacing.md),
        const Text('Order placed!', style: AppTypography.h3)
            .animate(delay: 150.ms)
            .fadeIn(),
        const SizedBox(height: AppSpacing.xl),
      ],
    );
  }
}

class _PreviewBody extends StatelessWidget {
  const _PreviewBody({required this.form, required this.notifier});
  final TradeFormState form;
  final TradeForm notifier;

  @override
  Widget build(BuildContext context) {
    final sym = form.symbol!;
    final items = [
      ('Symbol', sym.symbol),
      ('Side', form.side.name.toUpperCase()),
      ('Type', form.orderType.name.toUpperCase()),
      ('Quantity', form.quantity.toStringAsFixed(4)),
      ('Leverage', '${form.leverage.toStringAsFixed(0)}x'),
      if (form.limitPrice != null)
        ('Limit price', '\$${form.limitPrice!.toStringAsFixed(2)}'),
      if (form.slPrice != null)
        ('Stop loss', '\$${form.slPrice!.toStringAsFixed(2)}'),
    ];

    final sideColor =
        form.side == OrderSide.long ? AppColors.profitGreen : AppColors.lossRed;

    return Column(
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
        Row(
          children: [
            const Text('Order Preview', style: AppTypography.h3),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm, vertical: 4),
              decoration: BoxDecoration(
                color: sideColor.withValues(alpha: 0.1),
                borderRadius: AppRadius.chipRadius,
              ),
              child: Text(
                form.side == OrderSide.long ? 'BUY' : 'SELL',
                style: AppTypography.label.copyWith(color: sideColor),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        ...items.asMap().entries.map((e) {
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: Row(
              children: [
                Text(e.value.$1,
                    style: AppTypography.bodySm
                        .copyWith(color: AppColors.textSecondary)),
                const Spacer(),
                Text(e.value.$2, style: AppTypography.label),
              ],
            ),
          )
              .animate(delay: (e.key * 40).ms)
              .fadeIn(duration: 200.ms)
              .slideX(begin: 0.05, end: 0);
        }),
        if (form.takeProfit1 != null || form.takeProfit2 != null) ...[
          Row(
            children: [
              Text('Take profit',
                  style: AppTypography.bodySm
                      .copyWith(color: AppColors.textSecondary)),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (form.takeProfit1 != null) form.takeProfit1!,
                  if (form.takeProfit2 != null) form.takeProfit2!,
                ]
                    .map((p) => Text('\$${p.toStringAsFixed(2)}',
                        style: AppTypography.label
                            .copyWith(color: AppColors.profitGreen)))
                    .toList(),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
        if (form.submitError != null) ...[
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: AppColors.lossRed.withValues(alpha: 0.08),
              borderRadius: AppRadius.chipRadius,
              border:
                  Border.all(color: AppColors.lossRed.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.error_outline_rounded,
                    size: 16, color: AppColors.lossRed),
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: Text(
                    form.submitError!,
                    style: AppTypography.caption
                        .copyWith(color: AppColors.lossRed),
                  ),
                ),
              ],
            ),
          ).animate().slideY(begin: -0.3, end: 0).fadeIn(duration: 200.ms),
          const SizedBox(height: AppSpacing.sm),
        ],
        const SizedBox(height: AppSpacing.md),
        PPrimaryButton(
          label: 'Confirm order',
          state: form.isSubmitting ? PButtonState.loading : PButtonState.idle,
          onPressed: () => notifier.submit(bypassWarnings: true),
        ),
        const SizedBox(height: AppSpacing.sm),
      ],
    );
  }
}
