import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../core/router/routes.dart';
import '../../../core/storage/preferences.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/buttons/p_primary_button.dart';
import '../../../core/widgets/feedback/p_error_state.dart';
import '../../../core/widgets/feedback/p_toast.dart';
import '../../../core/widgets/inputs/p_text_field.dart';
import '../../auth/providers/auth_provider.dart';
import '../../auth/providers/auth_state.dart';
import '../../auth/widgets/password_requirements.dart';
import '../../onboarding/screens/set_risk_appetite_screen.dart';
import '../data/profile_api.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool _handledInitialSheet = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_handledInitialSheet) return;
    final sheet = GoRouterState.of(context).uri.queryParameters['sheet'];
    if (sheet == 'exchange') {
      _handledInitialSheet = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        showExchangeConnectionsSheet(context, ref).whenComplete(() {
          if (mounted) context.go(Routes.profile);
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider).valueOrNull;
    if (authState is! AuthAuthenticated) {
      return const Scaffold(body: PErrorState(message: 'Not authenticated'));
    }

    final profile = ref.watch(_profileProvider);
    final name = profile.valueOrNull?.displayName.trim().isNotEmpty == true
        ? profile.valueOrNull!.displayName.trim()
        : authState.fullName.trim();

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(centerTitle: true, title: const Text('Profile')),
      body: ListView(
        padding: AppSpacing.screenPadding,
        children: [
          const SizedBox(height: AppSpacing.md),
          Text(
            name.isNotEmpty ? name : 'Profile',
            style: AppTypography.h1,
          ),
          const SizedBox(height: 2),
          Text(
            authState.email,
            style: AppTypography.body.copyWith(
              color: AppColors.textDisabled,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          SizedBox(
            height: 48,
            child: OutlinedButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => _EditProfileScreen(
                    auth: authState,
                    displayName: name,
                  ),
                ),
              ),
              child: const Text('Edit profile'),
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
            onTap: () => showExchangeConnectionsSheet(context, ref),
          ),
          _SettingsTile(
            icon: Icons.percent_rounded,
            label: 'Risk Appetite',
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const SetRiskAppetiteScreen(),
              ),
            ),
          ),
          _SettingsTile(
            icon: Icons.lock_outline_rounded,
            label: 'Security',
            onTap: () => _showSecuritySheet(context, ref, authState),
          ),
          _SettingsTile(
            icon: Icons.notifications_none_rounded,
            label: 'Notification',
            onTap: () => _showNotificationSheet(context, ref),
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
          TextButton(
            onPressed: () => _showLogoutSheet(context, ref),
            child: const Text('Log out'),
          ),
          TextButton(
            onPressed: () => _showDeleteSheet(context, ref),
            child: Text(
              'Delete Account',
              style: AppTypography.button.copyWith(color: AppColors.lossRed),
            ),
          ),
        ],
      ),
    );
  }
}

@immutable
class _ProfileInfo {
  const _ProfileInfo({required this.displayName});
  final String displayName;
}

final _profileProvider = FutureProvider.autoDispose<_ProfileInfo>((ref) async {
  final result = await ref.read(profileApiProvider).getProfile();
  if (result.isErr) return const _ProfileInfo(displayName: '');
  final data = result.value;
  final displayName =
      (data['full_name'] ?? data['name'] ?? data['display_name']) as String? ??
          '';
  return _ProfileInfo(displayName: displayName);
});

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
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.borderLight),
            ),
            child: Row(
              children: [
                Icon(icon, color: AppColors.textSecondary, size: 22),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    label,
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 15,
                    ),
                  ),
                ),
                const Icon(Icons.chevron_right_rounded,
                    color: AppColors.textDisabled),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EditProfileScreen extends ConsumerStatefulWidget {
  const _EditProfileScreen({
    required this.auth,
    required this.displayName,
  });

  final AuthAuthenticated auth;
  final String displayName;

  @override
  ConsumerState<_EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<_EditProfileScreen> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _emailCtrl;
  final _currentPasswordCtrl = TextEditingController();
  final _newPasswordCtrl = TextEditingController();
  final _confirmPasswordCtrl = TextEditingController();
  final _nameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _currentPasswordFocus = FocusNode();
  final _newPasswordFocus = FocusNode();
  final _confirmPasswordFocus = FocusNode();

  PButtonState _profileButtonState = PButtonState.idle;
  PButtonState _passwordButtonState = PButtonState.idle;
  PFieldState _nameState = PFieldState.idle;
  PFieldState _emailState = PFieldState.idle;
  PFieldState _currentPasswordState = PFieldState.idle;
  PFieldState _newPasswordState = PFieldState.idle;
  PFieldState _confirmPasswordState = PFieldState.idle;
  String? _nameError;
  String? _emailError;
  String? _currentPasswordError;
  String? _newPasswordError;
  String? _confirmPasswordError;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.displayName);
    _emailCtrl = TextEditingController(text: widget.auth.email);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _currentPasswordCtrl.dispose();
    _newPasswordCtrl.dispose();
    _confirmPasswordCtrl.dispose();
    _nameFocus.dispose();
    _emailFocus.dispose();
    _currentPasswordFocus.dispose();
    _newPasswordFocus.dispose();
    _confirmPasswordFocus.dispose();
    super.dispose();
  }

  bool _validateName() {
    final ok = _nameCtrl.text.trim().isNotEmpty;
    setState(() {
      _nameState = ok ? PFieldState.valid : PFieldState.error;
      _nameError = ok ? null : 'Enter your name';
    });
    return ok;
  }

  bool _validateEmail() {
    final ok = RegExp(r'^[\w.+-]+@[\w-]+\.[a-zA-Z]{2,}$')
        .hasMatch(_emailCtrl.text.trim());
    setState(() {
      _emailState = ok ? PFieldState.valid : PFieldState.error;
      _emailError = ok ? null : 'Enter a valid email address';
    });
    return ok;
  }

  bool _validateCurrentPassword() {
    final ok = _currentPasswordCtrl.text.isNotEmpty;
    setState(() {
      _currentPasswordState = ok ? PFieldState.valid : PFieldState.error;
      _currentPasswordError = ok ? null : 'Enter your current password';
    });
    return ok;
  }

  bool _validateNewPassword() {
    final ok = PasswordRequirements.isValid(_newPasswordCtrl.text);
    setState(() {
      _newPasswordState = ok ? PFieldState.valid : PFieldState.error;
      _newPasswordError = ok ? null : 'Password does not meet all requirements';
    });
    return ok;
  }

  bool _validateConfirmPassword() {
    final ok = _confirmPasswordCtrl.text == _newPasswordCtrl.text;
    setState(() {
      _confirmPasswordState = ok ? PFieldState.valid : PFieldState.error;
      _confirmPasswordError = ok ? null : 'Passwords do not match';
    });
    return ok;
  }

  Future<void> _saveProfile() async {
    final nameOk = _validateName();
    final emailOk = _validateEmail();
    if (!nameOk || !emailOk) return;

    setState(() => _profileButtonState = PButtonState.loading);
    final result = await ref.read(profileApiProvider).updateProfile(
          fullName: _nameCtrl.text.trim(),
          email: _emailCtrl.text.trim(),
        );
    if (!mounted) return;
    result.fold(
      onOk: (_) async {
        setState(() => _profileButtonState = PButtonState.success);
        ref.invalidate(_profileProvider);
        await ref.read(authProvider.notifier).refreshSession();
        if (!mounted) return;
        PToast.success(context, 'Profile updated');
        Future<void>.delayed(const Duration(milliseconds: 500), () {
          if (mounted) setState(() => _profileButtonState = PButtonState.idle);
        });
      },
      onErr: (err) {
        setState(() => _profileButtonState = PButtonState.error);
        PToast.error(context, err.userMessage);
        Future<void>.delayed(const Duration(milliseconds: 500), () {
          if (mounted) setState(() => _profileButtonState = PButtonState.idle);
        });
      },
    );
  }

  Future<void> _changePassword() async {
    final currentOk = _validateCurrentPassword();
    final newOk = _validateNewPassword();
    final confirmOk = _validateConfirmPassword();
    if (!currentOk || !newOk || !confirmOk) return;

    setState(() => _passwordButtonState = PButtonState.loading);
    final result = await ref.read(profileApiProvider).updatePassword(
          current: _currentPasswordCtrl.text,
          newPassword: _newPasswordCtrl.text,
        );
    if (!mounted) return;
    result.fold(
      onOk: (_) {
        setState(() => _passwordButtonState = PButtonState.success);
        Future<void>.delayed(const Duration(milliseconds: 450), () {
          if (!mounted) return;
          Navigator.of(context).pushReplacement(
            MaterialPageRoute<void>(
              builder: (_) => const _PasswordChangedSuccessScreen(),
            ),
          );
        });
      },
      onErr: (err) {
        setState(() => _passwordButtonState = PButtonState.error);
        PToast.error(context, err.userMessage);
        Future<void>.delayed(const Duration(milliseconds: 500), () {
          if (mounted) setState(() => _passwordButtonState = PButtonState.idle);
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(
        title: const Text('Edit profile'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: AppSpacing.screenPadding,
          children: [
            const SizedBox(height: AppSpacing.md),
            const Text('Enter Details', style: AppTypography.h2),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Update your personal details and account password.',
              style:
                  AppTypography.body.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: AppSpacing.xl),
            PTextField(
              controller: _nameCtrl,
              focusNode: _nameFocus,
              label: 'Your name',
              textInputAction: TextInputAction.next,
              fieldState: _nameState,
              errorText: _nameError,
              onChanged: (_) {
                if (_nameState != PFieldState.idle) _validateName();
              },
              onEditingComplete: () => _emailFocus.requestFocus(),
            ),
            const SizedBox(height: AppSpacing.md),
            PTextField(
              controller: _emailCtrl,
              focusNode: _emailFocus,
              label: 'Email address',
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.done,
              fieldState: _emailState,
              errorText: _emailError,
              onChanged: (_) {
                if (_emailState != PFieldState.idle) _validateEmail();
              },
              onEditingComplete: _saveProfile,
            ),
            const SizedBox(height: AppSpacing.xl),
            PPrimaryButton(
              label: 'Save changes',
              state: _profileButtonState,
              onPressed: _profileButtonState == PButtonState.loading
                  ? null
                  : _saveProfile,
            ),
            const SizedBox(height: AppSpacing.xxl),
            const Text('Change password', style: AppTypography.h2),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Create a new password for this account.',
              style:
                  AppTypography.body.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: AppSpacing.lg),
            PTextField(
              controller: _currentPasswordCtrl,
              focusNode: _currentPasswordFocus,
              label: 'Current password',
              obscureText: true,
              textInputAction: TextInputAction.next,
              fieldState: _currentPasswordState,
              errorText: _currentPasswordError,
              onChanged: (_) {
                if (_currentPasswordState != PFieldState.idle) {
                  _validateCurrentPassword();
                }
              },
              onEditingComplete: () => _newPasswordFocus.requestFocus(),
            ),
            const SizedBox(height: AppSpacing.md),
            PTextField(
              controller: _newPasswordCtrl,
              focusNode: _newPasswordFocus,
              label: 'New password',
              obscureText: true,
              textInputAction: TextInputAction.next,
              fieldState: _newPasswordState,
              errorText: _newPasswordError,
              onChanged: (_) {
                setState(() {});
                if (_newPasswordState != PFieldState.idle) {
                  _validateNewPassword();
                }
                if (_confirmPasswordState != PFieldState.idle) {
                  _validateConfirmPassword();
                }
              },
              onEditingComplete: () => _confirmPasswordFocus.requestFocus(),
            ),
            const SizedBox(height: AppSpacing.sm),
            PasswordRequirements(password: _newPasswordCtrl.text),
            const SizedBox(height: AppSpacing.md),
            PTextField(
              controller: _confirmPasswordCtrl,
              focusNode: _confirmPasswordFocus,
              label: 'Confirm password',
              hint: 'Repeat password',
              obscureText: true,
              textInputAction: TextInputAction.done,
              fieldState: _confirmPasswordState,
              errorText: _confirmPasswordError,
              onChanged: (_) {
                if (_confirmPasswordState != PFieldState.idle) {
                  _validateConfirmPassword();
                }
              },
              onEditingComplete: _changePassword,
            ),
            const SizedBox(height: AppSpacing.xl),
            PPrimaryButton(
              label: 'Change password',
              state: _passwordButtonState,
              onPressed: _passwordButtonState == PButtonState.loading
                  ? null
                  : _changePassword,
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }
}

class _PasswordChangedSuccessScreen extends StatelessWidget {
  const _PasswordChangedSuccessScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.screenPadding,
          child: Column(
            children: [
              const Spacer(flex: 2),
              Image.asset(
                'assets/images/success_lock.png',
                width: 190,
                height: 190,
                fit: BoxFit.contain,
                filterQuality: FilterQuality.high,
              ),
              const Spacer(),
              const Text(
                'Your password has been updated',
                textAlign: TextAlign.center,
                style: AppTypography.h2,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Your password has been changed successfully.',
                textAlign: TextAlign.center,
                style: AppTypography.body.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.45,
                ),
              ),
              const Spacer(flex: 2),
              PPrimaryButton(
                label: 'Done',
                onPressed: () => context.go(Routes.profile),
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> showExchangeConnectionsSheet(BuildContext context, WidgetRef ref) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => _SheetFrame(
      title: 'Exchange Connections',
      child: _ExchangeConnectionsSection(),
    ),
  );
}

class _ExchangeConnectionsSection extends ConsumerStatefulWidget {
  @override
  ConsumerState<_ExchangeConnectionsSection> createState() =>
      _ExchangeConnectionsSectionState();
}

class _ExchangeConnectionsSectionState
    extends ConsumerState<_ExchangeConnectionsSection> {
  late Future<dynamic> _future;

  @override
  void initState() {
    super.initState();
    _future = ref.read(profileApiProvider).getExchangeConnections();
  }

  void _reload() {
    setState(() {
      _future = ref.read(profileApiProvider).getExchangeConnections();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: _future,
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(AppSpacing.lg),
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        }
        final result = snap.data;
        if (result == null || result.isErr) {
          return Text(
            'Failed to load connections',
            style: AppTypography.body.copyWith(color: AppColors.textSecondary),
          );
        }
        final connections = result.value as List<Map<String, dynamic>>;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (connections.isEmpty)
              Text(
                'No exchange connected',
                style: AppTypography.body.copyWith(
                  color: AppColors.textSecondary,
                ),
              )
            else
              ...connections.map(
                (c) => _ConnectionTile(
                  id: (c['id'] as String?) ?? '',
                  exchange: (c['exchange'] as String?) ?? 'Exchange',
                  isActive: (c['is_active'] as bool?) ?? false,
                  onChanged: _reload,
                ),
              ),
            const SizedBox(height: AppSpacing.md),
            const _MagicLinkButton(),
            const SizedBox(height: AppSpacing.sm),
            OutlinedButton.icon(
              onPressed: () async {
                final created = await showDialog<bool>(
                  context: context,
                  builder: (_) => const _ExchangeConnectionDialog(),
                );
                if (created == true && mounted) _reload();
              },
              icon: const Icon(Icons.add_rounded, size: 18),
              label: const Text('Enter API keys manually'),
            ),
          ],
        );
      },
    );
  }
}

class _ConnectionTile extends ConsumerStatefulWidget {
  const _ConnectionTile({
    required this.id,
    required this.exchange,
    required this.isActive,
    required this.onChanged,
  });

  final String id;
  final String exchange;
  final bool isActive;
  final VoidCallback onChanged;

  @override
  ConsumerState<_ConnectionTile> createState() => _ConnectionTileState();
}

class _ConnectionTileState extends ConsumerState<_ConnectionTile> {
  bool _loading = false;

  Future<void> _toggle() async {
    setState(() => _loading = true);
    final api = ref.read(profileApiProvider);
    final result = widget.isActive
        ? await api.deactivateExchangeConnection(widget.id)
        : await api.activateExchangeConnection(widget.id);
    if (!mounted) return;
    setState(() => _loading = false);
    result.fold(
      onOk: (_) => widget.onChanged(),
      onErr: (err) => PToast.error(context, err.userMessage),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(widget.exchange.toUpperCase(), style: AppTypography.h4),
      subtitle: Text(widget.isActive ? 'Active' : 'Inactive'),
      trailing: _loading
          ? const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : TextButton(
              onPressed: _toggle,
              child: Text(widget.isActive ? 'Deactivate' : 'Activate'),
            ),
    );
  }
}

class _MagicLinkButton extends ConsumerStatefulWidget {
  const _MagicLinkButton();

  @override
  ConsumerState<_MagicLinkButton> createState() => _MagicLinkButtonState();
}

class _MagicLinkButtonState extends ConsumerState<_MagicLinkButton> {
  bool _loading = false;

  Future<void> _requestLink() async {
    setState(() => _loading = true);
    final result = await ref.read(profileApiProvider).requestApiKeyMagicLink();
    if (!mounted) return;
    setState(() => _loading = false);
    result.fold(
      onOk: (_) => PToast.success(context, 'Check your email - link sent'),
      onErr: (err) => PToast.error(context, err.userMessage),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: _loading ? null : _requestLink,
      icon: _loading
          ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(Icons.open_in_browser_rounded, size: 18),
      label: Text(_loading ? 'Sending link...' : 'Set up on web'),
    );
  }
}

class _ExchangeConnectionDialog extends ConsumerStatefulWidget {
  const _ExchangeConnectionDialog();

  @override
  ConsumerState<_ExchangeConnectionDialog> createState() =>
      _ExchangeConnectionDialogState();
}

class _ExchangeConnectionDialogState
    extends ConsumerState<_ExchangeConnectionDialog> {
  final _apiKeyCtrl = TextEditingController();
  final _apiSecretCtrl = TextEditingController();
  String _exchange = 'bybit';
  bool _isTestnet = true;
  bool _isSaving = false;

  @override
  void dispose() {
    _apiKeyCtrl.dispose();
    _apiSecretCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Connect ${_exchange.toUpperCase()}'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              initialValue: _exchange,
              decoration: const InputDecoration(labelText: 'Exchange'),
              items: const [
                DropdownMenuItem(value: 'bybit', child: Text('Bybit')),
                DropdownMenuItem(value: 'binance', child: Text('Binance')),
              ],
              onChanged: _isSaving
                  ? null
                  : (value) => setState(() => _exchange = value ?? 'bybit'),
            ),
            const SizedBox(height: AppSpacing.sm),
            TextField(
              controller: _apiKeyCtrl,
              decoration: const InputDecoration(labelText: 'API key'),
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: AppSpacing.sm),
            TextField(
              controller: _apiSecretCtrl,
              decoration: const InputDecoration(labelText: 'API secret'),
              obscureText: true,
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: _isTestnet,
              onChanged: _isSaving
                  ? null
                  : (value) => setState(() => _isTestnet = value),
              title: const Text('Use testnet'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSaving ? null : () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        FilledButton(
            onPressed: _isSaving ? null : _save, child: const Text('Connect')),
      ],
    );
  }

  Future<void> _save() async {
    final apiKey = _apiKeyCtrl.text.trim();
    final apiSecret = _apiSecretCtrl.text.trim();
    if (apiKey.isEmpty || apiSecret.isEmpty) {
      PToast.error(context, 'API key and secret are required');
      return;
    }
    setState(() => _isSaving = true);
    final result = await ref.read(profileApiProvider).createExchangeConnection(
          exchange: _exchange,
          apiKey: apiKey,
          apiSecret: apiSecret,
          isTestnet: _isTestnet,
        );
    if (!mounted) return;
    setState(() => _isSaving = false);
    result.fold(
      onOk: (_) {
        PToast.success(context, 'Exchange connected');
        Navigator.pop(context, true);
      },
      onErr: (err) => PToast.error(context, err.userMessage),
    );
  }
}

void _showSecuritySheet(
  BuildContext context,
  WidgetRef ref,
  AuthAuthenticated auth,
) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _SheetFrame(
      title: 'Security',
      child: _TotpTile(totpEnabled: auth.totpEnabled),
    ),
  );
}

class _TotpTile extends ConsumerStatefulWidget {
  const _TotpTile({required this.totpEnabled});
  final bool totpEnabled;

  @override
  ConsumerState<_TotpTile> createState() => _TotpTileState();
}

class _TotpTileState extends ConsumerState<_TotpTile> {
  Future<void> _setup() async {
    final result = await ref.read(profileApiProvider).setupTotp();
    if (!mounted) return;
    result.fold(
      onOk: (data) {
        showDialog<void>(
          context: context,
          barrierDismissible: false,
          builder: (_) => _TotpEnableDialog(
            secret: data['secret'] as String? ?? '',
            qrUrl: data['qr_url'] as String? ?? '',
            onEnabled: () => ref.read(authProvider.notifier).markTotpEnabled(),
          ),
        );
      },
      onErr: (err) => PToast.error(context, err.userMessage),
    );
  }

  Future<void> _disable() async {
    final code = await showDialog<String?>(
      context: context,
      builder: (_) => const _TotpDisableDialog(),
    );
    if (code == null || !mounted) return;
    final result = await ref.read(profileApiProvider).disableTotp(token: code);
    if (!mounted) return;
    result.fold(
      onOk: (_) {
        ref.read(authProvider.notifier).markTotpDisabled();
        PToast.success(context, '2FA disabled');
      },
      onErr: (err) => PToast.error(context, err.userMessage),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: const Text('Two-factor authentication'),
      subtitle: Text(widget.totpEnabled ? 'Enabled' : 'Not enabled'),
      trailing: TextButton(
        onPressed: widget.totpEnabled ? _disable : _setup,
        child: Text(widget.totpEnabled ? 'Disable' : 'Set up'),
      ),
    );
  }
}

class _TotpEnableDialog extends ConsumerStatefulWidget {
  const _TotpEnableDialog({
    required this.secret,
    required this.qrUrl,
    required this.onEnabled,
  });
  final String secret;
  final String qrUrl;
  final VoidCallback onEnabled;

  @override
  ConsumerState<_TotpEnableDialog> createState() => _TotpEnableDialogState();
}

class _TotpEnableDialogState extends ConsumerState<_TotpEnableDialog> {
  final _codeCtrl = TextEditingController();
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _codeCtrl.dispose();
    super.dispose();
  }

  Future<void> _enable() async {
    final code = _codeCtrl.text.trim();
    if (code.length != 6) {
      setState(() => _error = 'Enter the 6-digit code');
      return;
    }
    setState(() {
      _loading = true;
      _error = null;
    });
    final result = await ref.read(profileApiProvider).enableTotp(
          secret: widget.secret,
          token: code,
        );
    if (!mounted) return;
    setState(() => _loading = false);
    result.fold(
      onOk: (_) {
        Navigator.pop(context);
        widget.onEnabled();
        PToast.success(context, '2FA enabled successfully');
      },
      onErr: (err) => setState(() => _error = err.userMessage),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Set up 2FA'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.qrUrl.isNotEmpty)
              Center(
                child: QrImageView(
                  data: widget.qrUrl,
                  version: QrVersions.auto,
                  size: 180,
                  backgroundColor: Colors.white,
                ),
              ),
            const SizedBox(height: AppSpacing.md),
            const Text('Enter this secret key:', style: AppTypography.bodySm),
            const SizedBox(height: AppSpacing.xs),
            SelectableText(widget.secret, style: AppTypography.bodyMedium),
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: _codeCtrl,
              keyboardType: TextInputType.number,
              maxLength: 6,
              decoration: InputDecoration(
                hintText: '000000',
                errorText: _error,
                counterText: '',
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _loading ? null : () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
            onPressed: _loading ? null : _enable, child: const Text('Enable')),
      ],
    );
  }
}

class _TotpDisableDialog extends StatefulWidget {
  const _TotpDisableDialog();

  @override
  State<_TotpDisableDialog> createState() => _TotpDisableDialogState();
}

class _TotpDisableDialogState extends State<_TotpDisableDialog> {
  final _codeCtrl = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _codeCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    final code = _codeCtrl.text.trim();
    if (code.length != 6) {
      setState(() => _error = 'Enter the 6-digit code from your app');
      return;
    }
    Navigator.pop(context, code);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Disable 2FA'),
      content: TextField(
        controller: _codeCtrl,
        keyboardType: TextInputType.number,
        maxLength: 6,
        autofocus: true,
        decoration: InputDecoration(
          hintText: '000000',
          errorText: _error,
          counterText: '',
        ),
        onSubmitted: (_) => _submit(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, null),
          child: const Text('Cancel'),
        ),
        FilledButton(onPressed: _submit, child: const Text('Disable')),
      ],
    );
  }
}

void _showNotificationSheet(BuildContext context, WidgetRef ref) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _SheetFrame(
      title: 'Notification',
      child: _NotificationPreferencesSection(),
    ),
  );
}

class _NotificationPreferencesSection extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefsState = ref.watch(appPreferencesProvider);
    return prefsState.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => const Text('Failed to load notification settings'),
      data: (prefs) => Column(
        children: [
          _PreferenceSwitch(
            label: 'Trade execution updates',
            value: prefs.tradeUpdateNotifications,
            onChanged: (value) async {
              await prefs.setTradeUpdateNotifications(value);
              ref.invalidate(appPreferencesProvider);
            },
          ),
          _PreferenceSwitch(
            label: 'Guardrail warnings',
            value: prefs.guardrailNotifications,
            onChanged: (value) async {
              await prefs.setGuardrailNotifications(value);
              ref.invalidate(appPreferencesProvider);
            },
          ),
          _PreferenceSwitch(
            label: 'External trade capture',
            value: prefs.externalTradeNotifications,
            onChanged: (value) async {
              await prefs.setExternalTradeNotifications(value);
              ref.invalidate(appPreferencesProvider);
            },
          ),
          _PreferenceSwitch(
            label: 'Email notifications',
            value: prefs.emailNotifications,
            onChanged: (value) async {
              await prefs.setEmailNotifications(value);
              ref.invalidate(appPreferencesProvider);
            },
          ),
        ],
      ),
    );
  }
}

class _PreferenceSwitch extends StatelessWidget {
  const _PreferenceSwitch({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      contentPadding: EdgeInsets.zero,
      value: value,
      onChanged: onChanged,
      title: Text(label, style: AppTypography.body),
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
            style: AppTypography.bodyLg.copyWith(
              color: AppColors.textSecondary,
              height: 1.45,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'We use this connection to:',
            style: AppTypography.bodyLg.copyWith(
              color: AppColors.textSecondary,
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
            style: AppTypography.bodyLg.copyWith(
              color: AppColors.textSecondary,
              height: 1.45,
            ),
          ),
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
          const Text('•  ', style: AppTypography.bodyLg),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: AppTypography.bodyLg.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.45,
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

class _SheetFrame extends StatelessWidget {
  const _SheetFrame({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: AppSpacing.sm,
          right: AppSpacing.sm,
          bottom: MediaQuery.viewInsetsOf(context).bottom + AppSpacing.sm,
        ),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: const BoxDecoration(
            color: AppColors.bgPrimary,
            borderRadius: BorderRadius.all(Radius.circular(28)),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Text(title, style: AppTypography.h2),
                    const Spacer(),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close_rounded),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                child,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void _showLogoutSheet(BuildContext context, WidgetRef ref) {
  showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (context) => _ConfirmSheet(
      title: 'Log out',
      body: 'Are you sure you want to log out?',
      primaryLabel: 'Log out',
      onPrimary: () {
        Navigator.pop(context);
        ref.read(authProvider.notifier).logout();
      },
    ),
  );
}

void _showDeleteSheet(BuildContext context, WidgetRef ref) {
  showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (context) => _ConfirmSheet(
      title: 'Delete Account',
      titleColor: AppColors.lossRed,
      body: 'Are you sure you want to delete your account?',
      primaryLabel: 'Delete account',
      primaryColor: AppColors.lossRed,
      primaryIcon: Icons.delete_outline_rounded,
      onPrimary: () async {
        final result = await ref.read(profileApiProvider).deleteAccount();
        if (!context.mounted) return;
        result.fold(
          onOk: (_) {
            Navigator.pop(context);
            ref.read(authProvider.notifier).logout();
          },
          onErr: (err) => PToast.error(context, err.userMessage),
        );
      },
    ),
  );
}

class _ConfirmSheet extends StatelessWidget {
  const _ConfirmSheet({
    required this.title,
    required this.body,
    required this.primaryLabel,
    required this.onPrimary,
    this.titleColor,
    this.primaryColor,
    this.primaryIcon,
  });

  final String title;
  final String body;
  final String primaryLabel;
  final FutureOr<void> Function() onPrimary;
  final Color? titleColor;
  final Color? primaryColor;
  final IconData? primaryIcon;

  @override
  Widget build(BuildContext context) {
    final color = primaryColor ?? AppColors.primary;
    return _SheetFrame(
      title: title,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            body,
            style:
                AppTypography.bodyLg.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.xl),
          OutlinedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No'),
          ),
          const SizedBox(height: AppSpacing.md),
          OutlinedButton.icon(
            onPressed: () async => onPrimary(),
            icon: primaryIcon == null
                ? const SizedBox.shrink()
                : Icon(primaryIcon),
            label: Text(primaryLabel),
            style: OutlinedButton.styleFrom(foregroundColor: color),
          ),
        ],
      ),
    );
  }
}
