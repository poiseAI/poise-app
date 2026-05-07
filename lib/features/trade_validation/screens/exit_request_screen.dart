import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/buttons/p_primary_button.dart';
import '../providers/exit_request_provider.dart';

// Icon hints for well-known reason names (case-insensitive prefix match)
IconData _iconFor(String name) {
  final n = name.toLowerCase();
  if (n.contains('stop loss')) return Icons.trending_down_rounded;
  if (n.contains('take profit')) return Icons.trending_up_rounded;
  if (n.contains('strategy')) return Icons.swap_horiz_rounded;
  if (n.contains('risk')) return Icons.warning_amber_rounded;
  return Icons.more_horiz_rounded;
}

class ExitRequestScreen extends ConsumerStatefulWidget {
  const ExitRequestScreen({super.key, required this.positionId});
  final String positionId;

  @override
  ConsumerState<ExitRequestScreen> createState() => _ExitRequestScreenState();
}

class _ExitRequestScreenState extends ConsumerState<ExitRequestScreen> {
  final _descCtrl = TextEditingController();

  @override
  void dispose() {
    _descCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final form = ref.watch(exitRequestProvider(widget.positionId));
    final notifier = ref.read(exitRequestProvider(widget.positionId).notifier);
    final reasonsAsync = ref.watch(exitReasonsProvider);

    ref.listen(exitRequestProvider(widget.positionId), (_, next) {
      if (next.submitted) {
        context.go(Routes.positionExitOtpPath(widget.positionId));
      }
    });

    final canSubmit =
        form.reasonId.isNotEmpty && !form.isSubmitting;

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(
        backgroundColor: AppColors.bgPrimary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => context.pop(),
        ),
        title: const Text('Request exit', style: AppTypography.h4),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Position ${widget.positionId}',
                style: AppTypography.bodySm
                    .copyWith(color: AppColors.textSecondary),
              ).animate().fadeIn(duration: 250.ms),
              const SizedBox(height: AppSpacing.lg),
              const Text('Why are you exiting?', style: AppTypography.h3)
                  .animate(delay: 40.ms)
                  .fadeIn(duration: 250.ms)
                  .slideY(begin: 0.1, end: 0),
              const SizedBox(height: AppSpacing.md),

              // Reason list — loaded from API
              reasonsAsync.when(
                loading: () => const Padding(
                  padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
                  child: Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
                error: (_, __) => Text(
                  'Could not load exit reasons. Please try again.',
                  style: AppTypography.body
                      .copyWith(color: AppColors.textSecondary),
                ),
                data: (reasons) => Column(
                  children: reasons.asMap().entries.map((entry) {
                    final r = entry.value;
                    final active = form.reasonId == r.id;
                    return GestureDetector(
                      onTap: () {
                        HapticFeedback.selectionClick();
                        notifier.setReason(r.id);
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        margin: const EdgeInsets.only(bottom: AppSpacing.xs),
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.md,
                            vertical: AppSpacing.sm),
                        decoration: BoxDecoration(
                          color: active
                              ? AppColors.lossRed.withValues(alpha: 0.06)
                              : AppColors.bgCard,
                          borderRadius: AppRadius.chipRadius,
                          border: Border.all(
                            color: active
                                ? AppColors.lossRed.withValues(alpha: 0.4)
                                : AppColors.borderLight,
                            width: active ? 1.5 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              _iconFor(r.name),
                              size: 18,
                              color: active
                                  ? AppColors.lossRed
                                  : AppColors.textSecondary,
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Text(
                              r.name,
                              style: AppTypography.body.copyWith(
                                color: active
                                    ? AppColors.lossRed
                                    : AppColors.textPrimary,
                              ),
                            ),
                            const Spacer(),
                            if (active)
                              const Icon(
                                Icons.check_circle_rounded,
                                size: 18,
                                color: AppColors.lossRed,
                              )
                                  .animate()
                                  .scale(
                                    begin: const Offset(0, 0),
                                    curve: Curves.easeOutBack,
                                  ),
                          ],
                        ),
                      ),
                    )
                        .animate(delay: (entry.key * 40).ms)
                        .fadeIn(duration: 220.ms)
                        .slideY(begin: 0.08, end: 0, curve: Curves.easeOutCubic);
                  }).toList(),
                ),
              ),

              const SizedBox(height: AppSpacing.md),

              // Description — required, min 10 chars per backend validation
              _DescriptionField(
                controller: _descCtrl,
                onChanged: notifier.setDescription,
              ),

              if (form.error != null) ...[
                Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: AppColors.lossRed.withValues(alpha: 0.08),
                    borderRadius: AppRadius.chipRadius,
                    border: Border.all(
                        color: AppColors.lossRed.withValues(alpha: 0.3)),
                  ),
                  child: Text(
                    form.error!,
                    style: AppTypography.caption
                        .copyWith(color: AppColors.lossRed),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
              ],

              PPrimaryButton(
                label: 'Request exit',
                state: form.isSubmitting
                    ? PButtonState.loading
                    : PButtonState.idle,
                onPressed: canSubmit ? notifier.submit : null,
              )
                  .animate(delay: 200.ms)
                  .fadeIn(duration: 250.ms),

              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }
}

class _DescriptionField extends StatelessWidget {
  const _DescriptionField(
      {required this.controller, required this.onChanged});
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Description (required)',
          style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: AppSpacing.xs),
        TextField(
          controller: controller,
          maxLines: 3,
          style: AppTypography.body,
          decoration: InputDecoration(
            hintText: 'Describe the reason for exit (min 10 characters)…',
            hintStyle:
                AppTypography.body.copyWith(color: AppColors.textDisabled),
            filled: true,
            fillColor: AppColors.bgCard,
            enabledBorder: const OutlineInputBorder(
              borderRadius: AppRadius.chipRadius,
              borderSide: BorderSide(color: AppColors.borderLight),
            ),
            focusedBorder: const OutlineInputBorder(
              borderRadius: AppRadius.chipRadius,
              borderSide: BorderSide(color: AppColors.accent, width: 1.5),
            ),
            contentPadding: const EdgeInsets.all(AppSpacing.md),
          ),
          onChanged: onChanged,
        ),
        const SizedBox(height: AppSpacing.md),
      ],
    );
  }
}
