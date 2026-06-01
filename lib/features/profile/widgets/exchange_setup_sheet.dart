import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/feedback/p_toast.dart';
import '../data/profile_api.dart';

Future<void> showExchangeSetupSheet(
  BuildContext context,
  WidgetRef ref, {
  required VoidCallback onManualSetup,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _ExchangeSetupSheet(onManualSetup: onManualSetup),
  );
}

class _ExchangeSetupSheet extends ConsumerStatefulWidget {
  const _ExchangeSetupSheet({required this.onManualSetup});

  final VoidCallback onManualSetup;

  @override
  ConsumerState<_ExchangeSetupSheet> createState() =>
      _ExchangeSetupSheetState();
}

class _ExchangeSetupSheetState extends ConsumerState<_ExchangeSetupSheet> {
  bool _sendingLink = false;

  Future<void> _sendWebLink() async {
    if (_sendingLink) return;
    HapticFeedback.mediumImpact();
    setState(() => _sendingLink = true);
    final result = await ref.read(profileApiProvider).requestApiKeyMagicLink();
    if (!mounted) return;
    setState(() => _sendingLink = false);
    result.fold(
      onOk: (_) {
        PToast.success(
          context,
          'Secure web setup link sent to your email',
        );
        Navigator.pop(context);
      },
      onErr: (err) => PToast.error(context, err.userMessage),
    );
  }

  void _openManualSetup() {
    Navigator.pop(context);
    widget.onManualSetup();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: AppSpacing.md,
          right: AppSpacing.md,
          bottom: MediaQuery.viewInsetsOf(context).bottom + AppSpacing.md,
        ),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: const BoxDecoration(
            color: AppColors.bgPrimary,
            borderRadius: AppRadius.cardRadiusLg,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Connect exchange',
                      style: AppTypography.h2,
                    ),
                  ),
                  IconButton(
                    onPressed:
                        _sendingLink ? null : () => Navigator.pop(context),
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Use the secure web flow for the quickest setup, or enter your exchange API keys in the app.',
                style: AppTypography.body.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              _SetupOption(
                icon: Icons.language_rounded,
                title: 'Set up on web',
                body:
                    'We will email a single-use link to the web setup page so you can paste API keys on a larger screen.',
                accent: AppColors.primary,
                trailing: _sendingLink
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.arrow_forward_rounded),
                onTap: _sendingLink ? null : _sendWebLink,
              ),
              const SizedBox(height: AppSpacing.sm),
              _SetupOption(
                icon: Icons.key_rounded,
                title: 'Enter keys manually',
                body:
                    'Connect Bybit or Binance directly from this device using encrypted API key storage.',
                accent: AppColors.textSecondary,
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: _sendingLink ? null : _openManualSetup,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Poise only needs trade and balance permissions. Never enable withdrawal permissions.',
                style: AppTypography.caption.copyWith(
                  color: AppColors.textTertiary,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SetupOption extends StatelessWidget {
  const _SetupOption({
    required this.icon,
    required this.title,
    required this.body,
    required this.accent,
    required this.trailing,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String body;
  final Color accent;
  final Widget trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.bgSurface,
      borderRadius: AppRadius.cardRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.cardRadius,
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            borderRadius: AppRadius.cardRadius,
            border: Border.all(color: AppColors.borderLight),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: accent, size: 18),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTypography.h4),
                    const SizedBox(height: 3),
                    Text(
                      body,
                      style: AppTypography.bodySm.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              IconTheme(
                data: IconThemeData(color: accent, size: 22),
                child: trailing,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
