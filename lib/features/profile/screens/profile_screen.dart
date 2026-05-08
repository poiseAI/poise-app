import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/feedback/p_error_state.dart';
import '../../auth/providers/auth_provider.dart';
import '../../auth/providers/auth_state.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider).valueOrNull;
    if (authState is! AuthAuthenticated) {
      return const Scaffold(body: PErrorState(message: 'Not authenticated'));
    }

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Profile'),
      ),
      body: ListView(
        padding: AppSpacing.screenPadding,
        children: [
          const SizedBox(height: AppSpacing.md),
          Text(
            _displayName(authState.email),
            style: AppTypography.h1.copyWith(fontSize: 26),
          ),
          const SizedBox(height: 2),
          Text(
            authState.email,
            style: AppTypography.h4.copyWith(
              color: AppColors.textDisabled,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          _PillButton(
            label: 'Edit profile',
            onPressed: () => _showInfoSheet(
              context,
              title: 'Edit profile',
              body: 'Profile editing is handled from account settings on web.',
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Text(
            'Settings',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          _SettingsTile(
            icon: Icons.link_rounded,
            label: 'Exchange Connections',
            onTap: () => _showInfoSheet(
              context,
              title: 'Exchange Connections',
              body:
                  'Connect Binance or Bybit using encrypted API and secret keys.',
            ),
          ),
          _SettingsTile(
            icon: Icons.percent_rounded,
            label: 'Risk Appetite',
            onTap: () => _showInfoSheet(
              context,
              title: 'Risk Appetite',
              body: 'Review or change your active trade guardrails.',
            ),
          ),
          _SettingsTile(
            icon: Icons.lock_outline_rounded,
            label: 'Security',
            onTap: () => _showInfoSheet(
              context,
              title: 'Security',
              body: authState.totpEnabled
                  ? 'Two-factor authentication is enabled.'
                  : 'Set up two-factor authentication to protect your account.',
            ),
          ),
          _SettingsTile(
            icon: Icons.notifications_none_rounded,
            label: 'Notification',
            onTap: () => _showInfoSheet(
              context,
              title: 'Notification',
              body: 'Manage execution, guardrail, and email alerts.',
            ),
          ),
          _SettingsTile(
            icon: Icons.shield_outlined,
            label: 'Data & Privacy',
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const _DataPrivacyScreen(),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          _DangerActions(
            onLogout: () => _showLogoutSheet(context, ref),
            onDelete: () => _showDeleteSheet(context),
          ),
        ],
      ),
    );
  }

  static String _displayName(String email) {
    final local = email.split('@').first;
    if (local.isEmpty) return 'Oluwademilade Akintan';
    final parts = local
        .split(RegExp(r'[._-]+'))
        .where((part) => part.isNotEmpty)
        .map((part) => '${part[0].toUpperCase()}${part.substring(1)}')
        .toList();
    return parts.length >= 2 ? parts.join(' ') : 'Oluwademilade Akintan';
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Material(
        color: AppColors.bgSurface,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            height: 68,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.borderLight),
            ),
            child: Row(
              children: [
                Icon(icon, color: AppColors.textSecondary, size: 25),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    label,
                    style: AppTypography.h3.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PillButton extends StatelessWidget {
  const _PillButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 54,
      child: OutlinedButton(
        onPressed: onPressed,
        child: Text(label),
      ),
    );
  }
}

class _DangerActions extends StatelessWidget {
  const _DangerActions({required this.onLogout, required this.onDelete});

  final VoidCallback onLogout;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextButton(onPressed: onLogout, child: const Text('Log out')),
        TextButton(
          onPressed: onDelete,
          child: Text(
            'Delete Account',
            style: AppTypography.button.copyWith(color: AppColors.lossRed),
          ),
        ),
      ],
    );
  }
}

class _DataPrivacyScreen extends StatelessWidget {
  const _DataPrivacyScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(
        title: const Text('Data & privacy'),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: AppSpacing.md),
            child: Icon(Icons.error_outline_rounded),
          ),
        ],
      ),
      body: ListView(
        padding: AppSpacing.screenPadding,
        children: [
          Text(
            'Poise uses your data exclusively to operate as your Trading Operating System and help you improve discipline. We securely connect to your exchange (Binance or Bybit) using your encrypted API and secret keys.',
            style: AppTypography.h2.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w400,
              height: 1.4,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'We use this connection to:',
            style: AppTypography.h2.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          const _PrivacyBullet(
            strong: 'Read your futures balance',
            rest: ' and support real-time trade execution.',
          ),
          const _PrivacyBullet(
            strong: 'Ingest all trading activity',
            rest:
                ' (historical and real-time) to establish a performance baseline.',
          ),
          const _PrivacyBullet(
            strong: 'Analyze trade data',
            rest:
                ' to enforce your configured risk rules and behavioral guardrails.',
          ),
          const _PrivacyBullet(
            strong: 'Generate personalized insights',
            rest: ' and real-time feedback via Poise AI.',
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Your API keys are stored securely and your trade data is only used to provide you with execution discipline and performance analysis.',
            style: AppTypography.h2.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w400,
              height: 1.4,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          _PolicyTile(onTap: () {}),
        ],
      ),
    );
  }
}

class _PrivacyBullet extends StatelessWidget {
  const _PrivacyBullet({required this.strong, required this.rest});

  final String strong;
  final String rest;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '•  ',
            style: AppTypography.h2.copyWith(color: AppColors.textSecondary),
          ),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: AppTypography.h2.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w400,
                  height: 1.4,
                ),
                children: [
                  TextSpan(
                    text: strong,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  TextSpan(text: rest),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PolicyTile extends StatelessWidget {
  const _PolicyTile({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.bgSurface,
      borderRadius: BorderRadius.circular(12),
      child: ListTile(
        onTap: onTap,
        minTileHeight: 66,
        title: Text(
          'View data and privacy policy',
          style: AppTypography.h2.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w400,
          ),
        ),
        trailing: const Icon(Icons.chevron_right_rounded),
      ),
    );
  }
}

void _showInfoSheet(
  BuildContext context, {
  required String title,
  required String body,
}) {
  showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (context) => _ActionSheet(
      title: title,
      body: body,
      primaryLabel: 'Done',
      onPrimary: () => Navigator.pop(context),
    ),
  );
}

void _showLogoutSheet(BuildContext context, WidgetRef ref) {
  showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (context) => _ActionSheet(
      title: 'Log out',
      body: 'Are you sure you want to log out?',
      primaryLabel: 'Log out',
      onPrimary: () {
        Navigator.pop(context);
        ref.read(authProvider.notifier).logout();
      },
      secondaryLabel: 'No',
      onSecondary: () => Navigator.pop(context),
    ),
  );
}

void _showDeleteSheet(BuildContext context) {
  showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (context) => _ActionSheet(
      title: 'Delete Account',
      titleColor: AppColors.lossRed,
      body: 'Are you sure you want to delete your account?',
      primaryLabel: 'Delete account',
      primaryColor: AppColors.lossRed,
      primaryIcon: Icons.delete_outline_rounded,
      onPrimary: () => Navigator.pop(context),
      secondaryLabel: 'No',
      onSecondary: () => Navigator.pop(context),
    ),
  );
}

class _ActionSheet extends StatelessWidget {
  const _ActionSheet({
    required this.title,
    required this.body,
    required this.primaryLabel,
    required this.onPrimary,
    this.secondaryLabel,
    this.onSecondary,
    this.titleColor,
    this.primaryColor,
    this.primaryIcon,
  });

  final String title;
  final String body;
  final String primaryLabel;
  final VoidCallback onPrimary;
  final String? secondaryLabel;
  final VoidCallback? onSecondary;
  final Color? titleColor;
  final Color? primaryColor;
  final IconData? primaryIcon;

  @override
  Widget build(BuildContext context) {
    final color = primaryColor ?? AppColors.primary;
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.all(AppSpacing.sm),
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: const BoxDecoration(
          color: AppColors.bgPrimary,
          borderRadius: BorderRadius.all(Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              title,
              style: AppTypography.h1.copyWith(
                color: titleColor ?? AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              body,
              style: AppTypography.h2.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            if (secondaryLabel != null)
              _SheetButton(
                label: secondaryLabel!,
                onPressed: onSecondary,
                color: AppColors.textSecondary,
              ),
            if (secondaryLabel != null) const SizedBox(height: AppSpacing.md),
            _SheetButton(
              label: primaryLabel,
              onPressed: onPrimary,
              color: color,
              icon: primaryIcon,
            ),
          ],
        ),
      ),
    );
  }
}

class _SheetButton extends StatelessWidget {
  const _SheetButton({
    required this.label,
    required this.onPressed,
    required this.color,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final Color color;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: icon == null ? const SizedBox.shrink() : Icon(icon),
        label: Text(label),
        style: OutlinedButton.styleFrom(
          foregroundColor: color,
          side: BorderSide(color: color.withValues(alpha: 0.45)),
        ),
      ),
    );
  }
}
