import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../core/errors/app_error.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/result.dart';
import '../../../core/widgets/buttons/p_primary_button.dart';
import '../../../core/widgets/feedback/p_error_state.dart';
import '../../../core/widgets/feedback/p_toast.dart';
import '../../../core/widgets/inputs/p_text_field.dart';
import '../../auth/providers/auth_provider.dart';
import '../../auth/providers/auth_state.dart';
import '../../auth/widgets/password_requirements.dart';
import '../../onboarding/screens/set_risk_appetite_screen.dart';
import '../../strategies/providers/strategies_provider.dart';
import '../data/profile_api.dart';
import '../providers/notification_preferences_provider.dart';
import '../widgets/exchange_setup_sheet.dart';

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
        showExchangeSetupSheet(
          context,
          ref,
          onManualSetup: () => context.go(Routes.exchangeConnections),
        );
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
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Profile', style: AppTypography.h1),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: AppColors.borderLight),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 18, 24, 24),
        children: [
          Text(
            name.isNotEmpty ? _titleCaseName(name) : 'Profile',
            style: AppTypography.h1.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 2),
          Text(
            authState.email,
            style: AppTypography.bodyLg.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 52,
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
          const SizedBox(height: 22),
          Text(
            'Settings',
            style: AppTypography.bodySm.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 10),
          _SettingsTile(
            icon: Icons.electrical_services_outlined,
            label: 'Exchange Connections',
            onTap: () => context.push(Routes.exchangeConnections),
          ),
          _SettingsTile(
            icon: Icons.tune_rounded,
            label: 'Risk Appetite',
            subtitle: _riskAppetiteSubtitle(ref),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const SetRiskAppetiteScreen(
                  mode: RiskAppetiteMode.settings,
                ),
              ),
            ),
          ),
          _SettingsTile(
            icon: Icons.lock_outline_rounded,
            label: 'Security',
            onTap: () => context.push(Routes.security),
          ),
          _SettingsTile(
            icon: Icons.notifications_none_rounded,
            label: 'Notifications',
            onTap: () => context.push(Routes.notificationSettings),
          ),
          _SettingsTile(
            icon: Icons.shield_outlined,
            label: 'Data & Privacy',
            onTap: () => context.push(Routes.dataPrivacy),
          ),
          const SizedBox(height: 30),
          _ProfileActionTile(
            icon: Icons.logout_rounded,
            label: 'Log out',
            onPressed: () => _showLogoutSheet(context, ref),
          ),
          const SizedBox(height: AppSpacing.sm),
          _ProfileActionTile(
            icon: Icons.delete_outline_rounded,
            label: 'Delete Account',
            color: AppColors.lossRed,
            onPressed: () => _showDeleteSheet(context, ref),
          ),
        ],
      ),
    );
  }
}

String _titleCaseName(String value) {
  return value
      .trim()
      .split(RegExp(r'\s+'))
      .where((part) => part.isNotEmpty)
      .map((part) {
    if (part.length == 1) return part.toUpperCase();
    return part[0].toUpperCase() + part.substring(1);
  }).join(' ');
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
    this.subtitle,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Material(
        color: AppColors.bgSurface,
        borderRadius: AppRadius.cardRadius,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadius.cardRadius,
          child: Container(
            constraints: const BoxConstraints(minHeight: 60),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: 14,
            ),
            decoration: BoxDecoration(
              borderRadius: AppRadius.cardRadius,
              border: Border.all(color: AppColors.borderLight),
            ),
            child: Row(
              children: [
                Icon(icon, color: AppColors.textSecondary, size: 20),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.bodyLg.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                      if (subtitle != null && subtitle!.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          subtitle!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.caption.copyWith(
                            color: AppColors.textDisabled,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.textDisabled,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ProfileActionTile extends StatelessWidget {
  const _ProfileActionTile({
    required this.icon,
    required this.label,
    required this.onPressed,
    this.color = AppColors.textPrimary,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.bgPrimary,
      borderRadius: AppRadius.cardRadius,
      child: InkWell(
        onTap: onPressed,
        borderRadius: AppRadius.cardRadius,
        child: Container(
          constraints: const BoxConstraints(minHeight: 58),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          decoration: BoxDecoration(
            borderRadius: AppRadius.cardRadius,
            border: Border.all(
              color: color == AppColors.lossRed
                  ? AppColors.lossRed.withValues(alpha: 0.28)
                  : AppColors.borderLight,
            ),
          ),
          child: Row(
            children: [
              Icon(icon, size: 20, color: color),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.bodyLg.copyWith(color: color),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String? _riskAppetiteSubtitle(WidgetRef ref) {
  final state = ref.watch(strategiesNotifierProvider);
  if (state is StrategiesLoaded) {
    final active = state.active;
    if (active == null) return 'Not configured';
    final pct = active.maxDailyLossPercent;
    final risk = pct == null
        ? ''
        : ' - ${pct.toStringAsFixed(pct % 1 == 0 ? 0 : 1)}% risk';
    return '${active.name}$risk';
  }
  if (state is StrategiesError) return 'Could not load current setting';
  return 'Loading current setting...';
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
  final _nameFocus = FocusNode();
  final _emailFocus = FocusNode();

  PButtonState _profileButtonState = PButtonState.idle;
  PFieldState _nameState = PFieldState.idle;
  PFieldState _emailState = PFieldState.idle;
  String? _nameError;
  String? _emailError;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.displayName);
    _emailCtrl = TextEditingController(text: widget.auth.email);
    _nameCtrl.addListener(_onFieldChanged);
    _emailCtrl.addListener(_onFieldChanged);
  }

  @override
  void dispose() {
    _nameCtrl.removeListener(_onFieldChanged);
    _emailCtrl.removeListener(_onFieldChanged);
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _nameFocus.dispose();
    _emailFocus.dispose();
    super.dispose();
  }

  void _onFieldChanged() => setState(() {});

  bool get _canSave {
    final name = _nameCtrl.text.trim();
    final email = _emailCtrl.text.trim();
    final changed = name != widget.displayName.trim() ||
        email.toLowerCase() != widget.auth.email.trim().toLowerCase();
    final emailValid =
        RegExp(r'^[\w.+-]+@[\w-]+\.[a-zA-Z]{2,}$').hasMatch(email);
    return changed &&
        name.isNotEmpty &&
        emailValid &&
        _profileButtonState != PButtonState.loading;
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

  Future<void> _saveProfile() async {
    FocusScope.of(context).unfocus();
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
      onOk: (data) async {
        setState(() => _profileButtonState = PButtonState.success);
        ref.invalidate(_profileProvider);
        await ref.read(authProvider.notifier).refreshSession();
        if (!mounted) return;
        final verificationRequired =
            data['verification_required'] as bool? ?? false;
        PToast.success(
          context,
          verificationRequired
              ? 'Verification code sent to your new email'
              : 'Profile updated',
        );
        if (verificationRequired) {
          Future<void>.delayed(const Duration(milliseconds: 450), () {
            if (mounted) context.go(Routes.verifyEmail);
          });
          return;
        }
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.bgPrimary,
        appBar: AppBar(
          centerTitle: false,
          title: const Text('Edit profile', style: AppTypography.h1),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: () => Navigator.pop(context),
          ),
          bottom: const PreferredSize(
            preferredSize: Size.fromHeight(1),
            child: Divider(height: 1, color: AppColors.borderLight),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: AppSpacing.screenPadding,
            child: Column(
              children: [
                const SizedBox(height: AppSpacing.md),
                PTextField(
                  controller: _nameCtrl,
                  focusNode: _nameFocus,
                  label: 'Your name',
                  showLabelAbove: true,
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
                  showLabelAbove: true,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.done,
                  fieldState: _emailState,
                  errorText: _emailError,
                  onChanged: (_) {
                    if (_emailState != PFieldState.idle) _validateEmail();
                  },
                  onEditingComplete: _canSave ? _saveProfile : null,
                ),
                const Spacer(),
                PPrimaryButton(
                  label: 'Save changes',
                  state: _profileButtonState,
                  onPressed: _canSave ? _saveProfile : null,
                ),
                const SizedBox(height: AppSpacing.lg),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ChangePasswordScreen extends ConsumerStatefulWidget {
  const _ChangePasswordScreen();

  @override
  ConsumerState<_ChangePasswordScreen> createState() =>
      _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends ConsumerState<_ChangePasswordScreen> {
  final _currentPasswordCtrl = TextEditingController();
  final _newPasswordCtrl = TextEditingController();
  final _confirmPasswordCtrl = TextEditingController();
  final _currentPasswordFocus = FocusNode();
  final _newPasswordFocus = FocusNode();
  final _confirmPasswordFocus = FocusNode();

  PButtonState _passwordButtonState = PButtonState.idle;
  PFieldState _currentPasswordState = PFieldState.idle;
  PFieldState _newPasswordState = PFieldState.idle;
  PFieldState _confirmPasswordState = PFieldState.idle;
  String? _currentPasswordError;
  String? _newPasswordError;
  String? _confirmPasswordError;

  @override
  void dispose() {
    _currentPasswordCtrl.dispose();
    _newPasswordCtrl.dispose();
    _confirmPasswordCtrl.dispose();
    _currentPasswordFocus.dispose();
    _newPasswordFocus.dispose();
    _confirmPasswordFocus.dispose();
    super.dispose();
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
        title: const Text('Change password'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: AppSpacing.screenPadding,
          children: [
            const SizedBox(height: AppSpacing.md),
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
              showLabelAbove: true,
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
              showLabelAbove: true,
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
              showLabelAbove: true,
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

class ExchangeConnectionsScreen extends StatelessWidget {
  const ExchangeConnectionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final fromOnboarding =
        GoRouterState.of(context).uri.queryParameters['from'] == 'onboarding';
    if (fromOnboarding) return const _ExchangeOnboardingFlow();

    const exitRoute = Routes.profile;
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () =>
              context.canPop() ? context.pop() : context.go(exitRoute),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        centerTitle: false,
        title: const Text('Exchange Connections', style: AppTypography.h1),
      ),
      body: const SafeArea(
        top: false,
        child: _ExchangeConnectionsSection(fromOnboarding: false),
      ),
    );
  }
}

class _ExchangeOnboardingFlow extends ConsumerStatefulWidget {
  const _ExchangeOnboardingFlow();

  @override
  ConsumerState<_ExchangeOnboardingFlow> createState() =>
      _ExchangeOnboardingFlowState();
}

class _ExchangeOnboardingFlowState
    extends ConsumerState<_ExchangeOnboardingFlow> {
  late Future<Result<List<Map<String, dynamic>>, AppError>> _future;
  final _apiKeyCtrl = TextEditingController();
  final _apiSecretCtrl = TextEditingController();
  String? _selectedExchange;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _future = _loadConnections();
    _apiKeyCtrl.addListener(_onFormChanged);
    _apiSecretCtrl.addListener(_onFormChanged);
  }

  @override
  void dispose() {
    _apiKeyCtrl.removeListener(_onFormChanged);
    _apiSecretCtrl.removeListener(_onFormChanged);
    _apiKeyCtrl.dispose();
    _apiSecretCtrl.dispose();
    super.dispose();
  }

  void _onFormChanged() {
    if (mounted) setState(() {});
  }

  Future<Result<List<Map<String, dynamic>>, AppError>>
      _loadConnections() async {
    final result = await ref.read(profileApiProvider).getExchangeConnections();
    final connections = result.valueOrNull;
    if (mounted &&
        connections != null &&
        connections.any(_isActiveConnection)) {
      ref.read(authProvider.notifier).markHasExchangeConnection();
    }
    return result;
  }

  Future<void> _connectSelectedExchange() async {
    final exchange = _selectedExchange;
    if (exchange == null || _loading) return;

    final apiKey = _apiKeyCtrl.text.trim();
    final apiSecret = _apiSecretCtrl.text.trim();
    if (apiKey.isEmpty || apiSecret.isEmpty) {
      PToast.error(context, 'API key and secret key are required');
      return;
    }

    setState(() => _loading = true);
    final result = await ref.read(profileApiProvider).createExchangeConnection(
          exchange: exchange,
          apiKey: apiKey,
          apiSecret: apiSecret,
          isTestnet: false,
        );
    if (!mounted) return;
    setState(() => _loading = false);
    result.fold(
      onOk: (_) {
        ref.read(authProvider.notifier).markHasExchangeConnection();
        unawaited(ref.read(authProvider.notifier).refreshSession());
        context.go(Routes.baselineSync);
      },
      onErr: (err) => PToast.error(context, err.userMessage),
    );
  }

  void _openForm(String exchange) {
    setState(() {
      _selectedExchange = exchange;
      _apiKeyCtrl.clear();
      _apiSecretCtrl.clear();
    });
  }

  void _backToChooser() {
    setState(() {
      _selectedExchange = null;
      _apiKeyCtrl.clear();
      _apiSecretCtrl.clear();
      _loading = false;
    });
  }

  void _goBaseline() => context.go(Routes.baselineSync);

  bool _isActiveConnection(Map<String, dynamic> connection) =>
      (connection['is_active'] as bool?) ?? true;

  Map<String, dynamic>? _connectionFor(
    List<Map<String, dynamic>> connections,
    String exchange,
  ) {
    for (final connection in connections) {
      final name = (connection['exchange'] as String? ?? '').toLowerCase();
      if (name == exchange) return connection;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: SafeArea(
        child: FutureBuilder<Result<List<Map<String, dynamic>>, AppError>>(
          future: _future,
          builder: (context, snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(strokeWidth: 2),
              );
            }
            final result = snap.data;
            if (result == null || result.isErr) {
              return const PErrorState(message: 'Failed to load connections');
            }

            final connections = result.value;
            final selected = _selectedExchange;
            if (selected != null) {
              return _ExchangeOnboardingForm(
                exchange: selected,
                apiKeyCtrl: _apiKeyCtrl,
                apiSecretCtrl: _apiSecretCtrl,
                loading: _loading,
                canSubmit: _apiKeyCtrl.text.trim().isNotEmpty &&
                    _apiSecretCtrl.text.trim().isNotEmpty,
                onBack: _backToChooser,
                onHelp: () => _showOnboardingApiHelpSheet(context, selected),
                onSubmit: _connectSelectedExchange,
              );
            }

            return _ExchangeOnboardingChooser(
              bybitConnected: _connectionFor(connections, 'bybit') != null &&
                  _isActiveConnection(_connectionFor(connections, 'bybit')!),
              binanceConnected:
                  _connectionFor(connections, 'binance') != null &&
                      _isActiveConnection(
                        _connectionFor(connections, 'binance')!,
                      ),
              onSelectExchange: _openForm,
              onContinue:
                  connections.any(_isActiveConnection) ? _goBaseline : null,
              onLater: _goBaseline,
            );
          },
        ),
      ),
    );
  }
}

class _ExchangeOnboardingChooser extends StatelessWidget {
  const _ExchangeOnboardingChooser({
    required this.bybitConnected,
    required this.binanceConnected,
    required this.onSelectExchange,
    required this.onContinue,
    required this.onLater,
  });

  final bool bybitConnected;
  final bool binanceConnected;
  final ValueChanged<String> onSelectExchange;
  final VoidCallback? onContinue;
  final VoidCallback onLater;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(24, 34, 24, 20),
            children: [
              Text(
                'Connect your exchange',
                style: AppTypography.display2.copyWith(
                  color: AppColors.textPrimary,
                  fontSize: 24,
                  height: 1.2,
                  letterSpacing: 0,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Poise reads your futures balance and checks every trade before it reaches your exchange',
                style: AppTypography.body.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 28),
              const _SecurityCallout(),
              const SizedBox(height: 28),
              _OnboardingExchangeRow(
                exchange: 'bybit',
                connected: bybitConnected,
                onTap: () => onSelectExchange('bybit'),
              ),
              const SizedBox(height: AppSpacing.sm),
              _OnboardingExchangeRow(
                exchange: 'binance',
                connected: binanceConnected,
                onTap: () => onSelectExchange('binance'),
              ),
              const SizedBox(height: 12),
              Text(
                'Connect at least one exchange to continue',
                style: AppTypography.body.copyWith(
                  color: AppColors.textTertiary,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 18),
          child: Column(
            children: [
              PPrimaryButton(
                label: 'Continue',
                height: 44,
                onPressed: onContinue,
              ),
              const SizedBox(height: 6),
              TextButton(
                onPressed: onLater,
                child: const Text("I'll do this later"),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ExchangeOnboardingForm extends StatelessWidget {
  const _ExchangeOnboardingForm({
    required this.exchange,
    required this.apiKeyCtrl,
    required this.apiSecretCtrl,
    required this.loading,
    required this.canSubmit,
    required this.onBack,
    required this.onHelp,
    required this.onSubmit,
  });

  final String exchange;
  final TextEditingController apiKeyCtrl;
  final TextEditingController apiSecretCtrl;
  final bool loading;
  final bool canSubmit;
  final VoidCallback onBack;
  final VoidCallback onHelp;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final label = _label(exchange);
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  onPressed: loading ? null : onBack,
                  icon: const Icon(Icons.arrow_back_rounded),
                  style: IconButton.styleFrom(
                    side: const BorderSide(color: AppColors.borderLight),
                    shape: const RoundedRectangleBorder(
                      borderRadius: AppRadius.cardRadius,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Connect $label',
                      style: AppTypography.display2.copyWith(
                        color: AppColors.textPrimary,
                        fontSize: 24,
                        height: 1.2,
                        letterSpacing: 0,
                      ),
                    ),
                  ),
                  _ExchangeBadge(exchange: exchange),
                ],
              ),
              const SizedBox(height: 26),
              _ApiHelpCard(onTap: loading ? null : onHelp),
              const SizedBox(height: 24),
              PTextField(
                controller: apiKeyCtrl,
                label: 'API key',
                showLabelAbove: true,
                obscureText: true,
                enabled: !loading,
                compact: true,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 16),
              PTextField(
                controller: apiSecretCtrl,
                label: 'Secret key',
                showLabelAbove: true,
                obscureText: true,
                enabled: !loading,
                compact: true,
                textInputAction: TextInputAction.done,
              ),
              const SizedBox(height: 22),
              const _PermissionsCallout(),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 18),
          child: PPrimaryButton(
            label: 'Connect exchange',
            height: 44,
            state: loading ? PButtonState.loading : PButtonState.idle,
            onPressed: loading || !canSubmit ? null : onSubmit,
          ),
        ),
      ],
    );
  }
}

class _SecurityCallout extends StatelessWidget {
  const _SecurityCallout();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.06),
        borderRadius: AppRadius.cardRadius,
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.12)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.shield_outlined,
            size: 18,
            color: AppColors.primary,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Your keys are encrypted at rest. Poise uses read & trade access only, it can never withdraw your funds.',
              style: AppTypography.caption.copyWith(
                color: AppColors.textSecondary,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardingExchangeRow extends StatelessWidget {
  const _OnboardingExchangeRow({
    required this.exchange,
    required this.connected,
    required this.onTap,
  });

  final String exchange;
  final bool connected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final label = _label(exchange);
    return Material(
      color: AppColors.bgSurface,
      borderRadius: AppRadius.cardRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.cardRadius,
        child: Container(
          constraints: const BoxConstraints(minHeight: 60),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: AppRadius.cardRadius,
            border: Border.all(color: AppColors.borderLight),
          ),
          child: Row(
            children: [
              _ExchangeMark(exchange: exchange),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Connect exchange',
                      style: AppTypography.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              if (connected) ...[
                const _ConnectedPill(active: true),
                const SizedBox(width: 8),
              ],
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.textDisabled,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ExchangeBadge extends StatelessWidget {
  const _ExchangeBadge({required this.exchange});

  final String exchange;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: const BoxDecoration(
        color: AppColors.textPrimary,
        borderRadius: AppRadius.pillRadius,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ExchangeMark(exchange: exchange),
          const SizedBox(width: 6),
          Text(
            exchange.toUpperCase(),
            style: AppTypography.labelSm.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _ApiHelpCard extends StatelessWidget {
  const _ApiHelpCard({required this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.primary.withValues(alpha: 0.06),
      borderRadius: AppRadius.cardRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.cardRadius,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: AppRadius.cardRadius,
            border:
                Border.all(color: AppColors.primary.withValues(alpha: 0.12)),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.help_outline_rounded,
                size: 18,
                color: AppColors.primary,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'How do I get my API keys?',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'A quick, safe walkthrough',
                      style: AppTypography.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PermissionsCallout extends StatelessWidget {
  const _PermissionsCallout();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.profitGreen.withValues(alpha: 0.10),
        borderRadius: AppRadius.cardRadius,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.verified_user_outlined,
            size: 18,
            color: AppColors.profitGreen,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              "Enable Contract, Trade (Orders & Positions). Never enable Withdrawals, Poise doesn't need it.",
              style: AppTypography.caption.copyWith(
                color: AppColors.textPrimary,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> _showOnboardingApiHelpSheet(
  BuildContext context,
  String exchange,
) {
  final label = _label(exchange);
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _OnboardingApiHelpSheet(exchange: label),
  );
}

class _OnboardingApiHelpSheet extends StatelessWidget {
  const _OnboardingApiHelpSheet({required this.exchange});

  final String exchange;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          20,
          0,
          20,
          MediaQuery.viewInsetsOf(context).bottom + 16,
        ),
        child: Container(
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 16),
          decoration: const BoxDecoration(
            color: AppColors.bgPrimary,
            borderRadius: AppRadius.cardRadiusLg,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Create your $exchange key',
                        style: AppTypography.h4.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close_rounded),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                for (final entry in _onboardingApiSteps(exchange).entries) ...[
                  _ApiHelpStep(number: entry.key, text: entry.value),
                  const SizedBox(height: 8),
                ],
                const _ApiWarningRow(
                  icon: Icons.warning_amber_rounded,
                  color: AppColors.lossRed,
                  backgroundColor: AppColors.lossRedBg,
                  text:
                      'Leave Withdraw and Account Transfer unchecked. Poise never moves your funds.',
                ),
                const SizedBox(height: 8),
                _ApiWarningRow(
                  icon: Icons.warning_amber_rounded,
                  color: AppColors.warningAmber,
                  backgroundColor: AppColors.warningAmberBg,
                  text:
                      'New $exchange accounts must wait 48 hours before creating a key. The Secret is shown only once.',
                ),
                const SizedBox(height: 14),
                PPrimaryButton(
                  label: 'Got it',
                  height: 44,
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ApiHelpStep extends StatelessWidget {
  const _ApiHelpStep({required this.number, required this.text});

  final int number;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        borderRadius: AppRadius.cardRadius,
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.10),
              shape: BoxShape.circle,
            ),
            child: Text(
              '$number',
              style: AppTypography.label.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: AppTypography.caption.copyWith(
                color: AppColors.textSecondary,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ApiWarningRow extends StatelessWidget {
  const _ApiWarningRow({
    required this.icon,
    required this.color,
    required this.backgroundColor,
    required this.text,
  });

  final IconData icon;
  final Color color;
  final Color backgroundColor;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: AppRadius.cardRadius,
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: AppTypography.caption.copyWith(
                color: color,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Map<int, String> _onboardingApiSteps(String label) => {
      1: 'Log in to $label, open your profile and go to Account & Security -> API Management.',
      2: 'Tap Create New Key and choose System-generated API Keys -> API Transactions.',
      3: 'Under permissions, enable Contract, Trade (Orders & Positions).',
      4: 'Copy both the API key and Secret key, then paste them into Poise.',
    };

class _ExchangeConnectionsSection extends ConsumerStatefulWidget {
  const _ExchangeConnectionsSection({required this.fromOnboarding});

  final bool fromOnboarding;

  @override
  ConsumerState<_ExchangeConnectionsSection> createState() =>
      _ExchangeConnectionsSectionState();
}

class _ExchangeConnectionsSectionState
    extends ConsumerState<_ExchangeConnectionsSection> {
  late Future<Result<List<Map<String, dynamic>>, AppError>> _future;
  String? _expandedExchange;

  @override
  void initState() {
    super.initState();
    _future = _loadConnections();
  }

  void _reload() {
    setState(() {
      _future = _loadConnections();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Result<List<Map<String, dynamic>>, AppError>>(
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
        final connections = result.value;
        final activeConnections = connections.where(_isActiveConnection).length;
        final hasMissingExchange =
            _connectionFor(connections, 'bybit') == null ||
                _connectionFor(connections, 'binance') == null;
        _expandedExchange ??= _defaultExpanded(connections);
        return ListView(
          padding: const EdgeInsets.fromLTRB(24, 22, 24, 32),
          children: [
            Text(
              activeConnections == 0
                  ? 'Link your trading account to start trading'
                  : '$activeConnections exchange${activeConnections == 1 ? '' : 's'} connected',
              style: AppTypography.body.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            if (hasMissingExchange) ...[
              _DesktopSetupCard(
                onSendLink: _sendDesktopSetupLink,
              ),
              const SizedBox(height: AppSpacing.md),
            ],
            _ExchangeConnectionTile(
              exchange: 'bybit',
              connection: _connectionFor(connections, 'bybit'),
              expanded: _expandedExchange == 'bybit',
              onToggle: () => _toggleExpanded('bybit'),
              onChanged: _reload,
            ),
            const SizedBox(height: AppSpacing.sm),
            _ExchangeConnectionTile(
              exchange: 'binance',
              connection: _connectionFor(connections, 'binance'),
              expanded: _expandedExchange == 'binance',
              onToggle: () => _toggleExpanded('binance'),
              onChanged: _reload,
            ),
            const SizedBox(height: AppSpacing.lg),
            PPrimaryButton(
              label: widget.fromOnboarding ? 'Continue' : 'Done',
              onPressed: () => context.go(
                widget.fromOnboarding ? Routes.home : Routes.profile,
              ),
            ),
          ],
        );
      },
    );
  }

  Future<Result<List<Map<String, dynamic>>, AppError>>
      _loadConnections() async {
    final result = await ref.read(profileApiProvider).getExchangeConnections();
    final connections = result.valueOrNull;
    if (mounted &&
        connections != null &&
        connections.any(_isActiveConnection)) {
      ref.read(authProvider.notifier).markHasExchangeConnection();
    }
    return result;
  }

  Future<void> _sendDesktopSetupLink() async {
    final result = await ref.read(profileApiProvider).requestApiKeyMagicLink();
    if (!mounted) return;
    result.fold(
      onOk: (_) => PToast.success(
        context,
        'Secure desktop setup link sent to your email',
      ),
      onErr: (err) => PToast.error(context, err.userMessage),
    );
  }

  String _defaultExpanded(List<Map<String, dynamic>> connections) {
    final active = connections.where(_isActiveConnection).toList();
    if (_connectionFor(active, 'bybit') != null) return 'bybit';
    if (_connectionFor(active, 'binance') != null) return 'binance';
    if (_connectionFor(connections, 'bybit') == null) return 'bybit';
    if (_connectionFor(connections, 'binance') == null) return 'binance';
    return 'bybit';
  }

  bool _isActiveConnection(Map<String, dynamic> connection) =>
      (connection['is_active'] as bool?) ?? true;

  void _toggleExpanded(String exchange) {
    setState(() {
      _expandedExchange = _expandedExchange == exchange ? null : exchange;
    });
  }

  Map<String, dynamic>? _connectionFor(
    List<Map<String, dynamic>> connections,
    String exchange,
  ) {
    for (final connection in connections) {
      final name = (connection['exchange'] as String? ?? '').toLowerCase();
      if (name == exchange) return connection;
    }
    return null;
  }
}

class _DesktopSetupCard extends StatelessWidget {
  const _DesktopSetupCard({required this.onSendLink});
  final VoidCallback onSendLink;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpacing.cardPadding,
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.06),
        borderRadius: AppRadius.cardRadius,
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Prefer using a computer?', style: AppTypography.h4),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Connect exchange securely on desktop',
            style: AppTypography.body.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: onSendLink,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.primary),
                shape: const RoundedRectangleBorder(
                  borderRadius: AppRadius.buttonRadius,
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Use desktop instead'),
                  SizedBox(width: AppSpacing.xs),
                  Icon(Icons.open_in_new_rounded, size: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ExchangeConnectionTile extends ConsumerStatefulWidget {
  const _ExchangeConnectionTile({
    required this.exchange,
    required this.connection,
    required this.expanded,
    required this.onToggle,
    required this.onChanged,
  });

  final String exchange;
  final Map<String, dynamic>? connection;
  final bool expanded;
  final VoidCallback onToggle;
  final VoidCallback onChanged;

  @override
  ConsumerState<_ExchangeConnectionTile> createState() =>
      _ExchangeConnectionTileState();
}

class _ExchangeConnectionTileState
    extends ConsumerState<_ExchangeConnectionTile> {
  final _apiKeyCtrl = TextEditingController();
  final _apiSecretCtrl = TextEditingController();
  bool _loading = false;

  bool get _connected =>
      widget.connection != null &&
      ((widget.connection!['is_active'] as bool?) ?? true);

  @override
  void dispose() {
    _apiKeyCtrl.dispose();
    _apiSecretCtrl.dispose();
    super.dispose();
  }

  Future<void> _disconnect() async {
    final id = (widget.connection?['id'] as String?) ?? '';
    if (id.isEmpty) return;
    setState(() => _loading = true);
    final result =
        await ref.read(profileApiProvider).deactivateExchangeConnection(id);
    if (!mounted) return;
    setState(() => _loading = false);
    result.fold(
      onOk: (_) {
        PToast.success(context, '${_label(widget.exchange)} disconnected');
        widget.onChanged();
      },
      onErr: (err) => PToast.error(context, err.userMessage),
    );
  }

  Future<void> _connect() async {
    final apiKey = _apiKeyCtrl.text.trim();
    final apiSecret = _apiSecretCtrl.text.trim();
    if (apiKey.isEmpty || apiSecret.isEmpty) {
      PToast.error(context, 'API key and secret key are required');
      return;
    }
    setState(() => _loading = true);
    final result = await ref.read(profileApiProvider).createExchangeConnection(
          exchange: widget.exchange,
          apiKey: apiKey,
          apiSecret: apiSecret,
          isTestnet: false,
        );
    if (!mounted) return;
    setState(() => _loading = false);
    result.fold(
      onOk: (_) {
        _apiKeyCtrl.clear();
        _apiSecretCtrl.clear();
        ref.read(authProvider.notifier).markHasExchangeConnection();
        unawaited(ref.read(authProvider.notifier).refreshSession());
        PToast.success(context, '${_label(widget.exchange)} connected');
        widget.onChanged();
      },
      onErr: (err) => PToast.error(context, err.userMessage),
    );
  }

  @override
  Widget build(BuildContext context) {
    final label = _label(widget.exchange);
    return Material(
      color: AppColors.bgSurface,
      borderRadius: AppRadius.cardRadius,
      child: InkWell(
        onTap: _loading ? null : widget.onToggle,
        borderRadius: AppRadius.cardRadius,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            borderRadius: AppRadius.cardRadius,
            border: Border.all(color: AppColors.borderLight),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  _ExchangeMark(exchange: widget.exchange),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          label,
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        if (!_connected && !widget.expanded)
                          Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: Text(
                              'Connect exchange',
                              style: AppTypography.caption.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (_loading)
                    const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  else if (_connected) ...[
                    Flexible(child: _ConnectedPill(active: _connected)),
                    const SizedBox(width: AppSpacing.xs),
                    Icon(
                      widget.expanded
                          ? Icons.keyboard_arrow_up_rounded
                          : Icons.keyboard_arrow_down_rounded,
                      color: AppColors.textTertiary,
                    ),
                  ] else
                    Icon(
                      widget.expanded
                          ? Icons.keyboard_arrow_up_rounded
                          : Icons.keyboard_arrow_down_rounded,
                      color: AppColors.textTertiary,
                    ),
                ],
              ),
              if (widget.expanded) ...[
                const SizedBox(height: AppSpacing.md),
                if (_connected)
                  _ConnectedExchangeActions(
                    exchange: label,
                    onDisconnect: _loading
                        ? null
                        : () async {
                            final confirmed =
                                await _showDisconnectSheet(context);
                            if (confirmed == true) await _disconnect();
                          },
                  )
                else
                  _InlineExchangeForm(
                    exchange: widget.exchange,
                    apiKeyCtrl: _apiKeyCtrl,
                    apiSecretCtrl: _apiSecretCtrl,
                    loading: _loading,
                    onHelp: () => _showApiHelpSheet(context),
                    onSubmit: _connect,
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Future<bool?> _showDisconnectSheet(BuildContext context) {
    final label = _label(widget.exchange);
    return showModalBottomSheet<bool>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _SheetFrame(
        title: 'Disconnect $label',
        showClose: false,
        titleColor: AppColors.textPrimary,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Disconnecting prevents Poise from creating, managing, and monitoring in and through the $label exchange. This does not affect your trades or money.',
              style: AppTypography.body.copyWith(
                color: AppColors.textSecondary,
                height: 1.45,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Are you sure you want to disconnect the exchange?',
              style: AppTypography.body.copyWith(
                color: AppColors.textSecondary,
                height: 1.45,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            FilledButton(
              onPressed: () => Navigator.pop(context, false),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.textTertiary,
                foregroundColor: Colors.white,
              ),
              child: const Text('No'),
            ),
            const SizedBox(height: AppSpacing.sm),
            OutlinedButton(
              onPressed: () => Navigator.pop(context, true),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.lossRed,
                side: BorderSide(
                  color: AppColors.lossRed.withValues(alpha: 0.35),
                ),
              ),
              child: const Text('Disconnect'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showApiHelpSheet(BuildContext context) {
    return _showOnboardingApiHelpSheet(context, widget.exchange);
  }
}

class _ConnectedPill extends StatelessWidget {
  const _ConnectedPill({required this.active});
  final bool active;

  @override
  Widget build(BuildContext context) {
    final color = active ? AppColors.profitGreen : AppColors.textTertiary;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: AppRadius.pillRadius,
        border: Border.all(color: color.withValues(alpha: 0.28)),
      ),
      child: Text(
        active ? 'Connected' : 'Inactive',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTypography.labelSm.copyWith(color: color),
      ),
    );
  }
}

class _InlineExchangeForm extends StatelessWidget {
  const _InlineExchangeForm({
    required this.exchange,
    required this.apiKeyCtrl,
    required this.apiSecretCtrl,
    required this.loading,
    required this.onHelp,
    required this.onSubmit,
  });

  final String exchange;
  final TextEditingController apiKeyCtrl;
  final TextEditingController apiSecretCtrl;
  final bool loading;
  final VoidCallback onHelp;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _ApiHelpCard(onTap: loading ? null : onHelp),
        const SizedBox(height: AppSpacing.md),
        PTextField(
          controller: apiKeyCtrl,
          label: 'API key',
          showLabelAbove: true,
          obscureText: true,
          enabled: !loading,
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: AppSpacing.sm),
        PTextField(
          controller: apiSecretCtrl,
          label: 'Secret key',
          showLabelAbove: true,
          obscureText: true,
          enabled: !loading,
          textInputAction: TextInputAction.done,
        ),
        const SizedBox(height: AppSpacing.md),
        PPrimaryButton(
          label: 'Connect exchange',
          state: loading ? PButtonState.loading : PButtonState.idle,
          onPressed: loading ? null : onSubmit,
        ),
        const SizedBox(height: AppSpacing.sm),
        const _PermissionsCallout(),
      ],
    );
  }
}

class _ConnectedExchangeActions extends StatelessWidget {
  const _ConnectedExchangeActions({
    required this.exchange,
    required this.onDisconnect,
  });

  final String exchange;
  final VoidCallback? onDisconnect;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          '$exchange is connected. Poise can monitor balances, open positions, and risk guardrails for this account.',
          style: AppTypography.body.copyWith(
            color: AppColors.textSecondary,
            height: 1.45,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        OutlinedButton(
          onPressed: onDisconnect,
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.lossRed,
            side: BorderSide(color: AppColors.lossRed.withValues(alpha: 0.35)),
            shape: const RoundedRectangleBorder(
              borderRadius: AppRadius.buttonRadius,
            ),
          ),
          child: Text('Disconnect $exchange'),
        ),
      ],
    );
  }
}

class _ExchangeMark extends StatelessWidget {
  const _ExchangeMark({required this.exchange});
  final String exchange;

  @override
  Widget build(BuildContext context) {
    final isBinance = exchange == 'binance';
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        color: isBinance ? const Color(0xFFF3BA2F) : AppColors.textPrimary,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Icon(
        isBinance ? Icons.auto_awesome_rounded : Icons.trending_up_rounded,
        color: isBinance ? AppColors.textPrimary : Colors.white,
        size: 16,
      ),
    );
  }
}

String _label(String exchange) => exchange == 'binance' ? 'Binance' : 'Bybit';

class SecurityScreen extends StatelessWidget {
  const SecurityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(
        centerTitle: false,
        title: const Text('Security', style: AppTypography.h1),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: AppColors.borderLight),
        ),
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 22, 24, 32),
          children: [
            _SettingsActionRow(
              label: 'Change password',
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const _ChangePasswordScreen(),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            const _TotpTile(),
          ],
        ),
      ),
    );
  }
}

class _SettingsActionRow extends StatelessWidget {
  const _SettingsActionRow({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.bgSurface,
      borderRadius: AppRadius.cardRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.cardRadius,
        child: Container(
          constraints: const BoxConstraints(minHeight: 58),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          decoration: BoxDecoration(
            borderRadius: AppRadius.cardRadius,
            border: Border.all(color: AppColors.borderLight),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: AppTypography.bodyLg.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.textPrimary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TotpTile extends ConsumerStatefulWidget {
  const _TotpTile();

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
    final auth = ref.watch(authProvider).valueOrNull;
    final totpEnabled = auth is AuthAuthenticated && auth.totpEnabled;
    return Container(
      constraints: const BoxConstraints(minHeight: 70),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        borderRadius: AppRadius.cardRadius,
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Two-factor authentication',
                  style: AppTypography.bodyLg.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  totpEnabled ? 'Enabled' : 'Not enabled',
                  style: AppTypography.body.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: totpEnabled ? _disable : _setup,
            child: Text(totpEnabled ? 'Disable' : 'Set up'),
          ),
        ],
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

class NotificationSettingsScreen extends ConsumerWidget {
  const NotificationSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefsState = ref.watch(notificationPreferencesControllerProvider);
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(
        centerTitle: false,
        title: const Text('Notifications', style: AppTypography.h1),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            onPressed: () => PToast.info(context, 'Notification preferences'),
            icon: const Icon(Icons.error_outline_rounded),
          ),
        ],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: AppColors.borderLight),
        ),
      ),
      body: SafeArea(
        top: false,
        child: prefsState.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, __) => const Center(
            child: Text('Failed to load notification settings'),
          ),
          data: (prefs) {
            final appNotifications = prefs.tradeUpdates ||
                prefs.guardrails ||
                prefs.externalTrades ||
                prefs.lossLimits ||
                prefs.weeklyInsights ||
                prefs.aiFeedback;
            return ListView(
              padding: const EdgeInsets.fromLTRB(24, 22, 24, 32),
              children: [
                _PreferenceSwitch(
                  label: 'App notifications',
                  value: appNotifications,
                  onChanged: (value) => _updateNotificationPreference(
                    context,
                    ref,
                    prefs.copyWith(
                      tradeUpdates: value,
                      guardrails: value,
                      externalTrades: value,
                      lossLimits: value,
                      weeklyInsights: value,
                      aiFeedback: value,
                    ),
                  ),
                ),
                _PreferenceSwitch(
                  label: 'Email notifications (optional)',
                  value: prefs.emailNotifications,
                  onChanged: (value) => _updateNotificationPreference(
                    context,
                    ref,
                    prefs.copyWith(emailNotifications: value),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  'Notifications',
                  style: AppTypography.bodyLg.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                _PreferenceSwitch(
                  label: 'Trade executions updates',
                  value: prefs.tradeUpdates,
                  onChanged: (value) => _updateNotificationPreference(
                    context,
                    ref,
                    prefs.copyWith(tradeUpdates: value),
                  ),
                ),
                _PreferenceSwitch(
                  label: 'Guardrail warnings',
                  value: prefs.guardrails,
                  onChanged: (value) => _updateNotificationPreference(
                    context,
                    ref,
                    prefs.copyWith(guardrails: value),
                  ),
                ),
                _PreferenceSwitch(
                  label: 'Loss limit alerts',
                  value: prefs.lossLimits,
                  onChanged: (value) => _updateNotificationPreference(
                    context,
                    ref,
                    prefs.copyWith(lossLimits: value),
                  ),
                ),
                _PreferenceSwitch(
                  label: 'Weekly insights',
                  value: prefs.weeklyInsights,
                  onChanged: (value) => _updateNotificationPreference(
                    context,
                    ref,
                    prefs.copyWith(weeklyInsights: value),
                  ),
                ),
                _PreferenceSwitch(
                  label: 'Poise AI feedback',
                  value: prefs.aiFeedback,
                  onChanged: (value) => _updateNotificationPreference(
                    context,
                    ref,
                    prefs.copyWith(aiFeedback: value),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

Future<void> _updateNotificationPreference(
  BuildContext context,
  WidgetRef ref,
  NotificationPreferences prefs,
) async {
  try {
    await ref
        .read(notificationPreferencesControllerProvider.notifier)
        .save(prefs);
  } catch (e) {
    if (context.mounted) PToast.error(context, 'Failed to update preference');
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
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Container(
        constraints: const BoxConstraints(minHeight: 58),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.bgSurface,
          borderRadius: AppRadius.cardRadius,
          border: Border.all(color: AppColors.borderLight),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: AppTypography.bodyLg.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            Switch(value: value, onChanged: onChanged),
          ],
        ),
      ),
    );
  }
}

class DataPrivacyScreen extends StatelessWidget {
  const DataPrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(
        centerTitle: false,
        title: const Text('Data & privacy', style: AppTypography.h1),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            onPressed: () => PToast.info(context, 'Data and privacy'),
            icon: const Icon(Icons.error_outline_rounded),
          ),
        ],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: AppColors.borderLight),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 22, 24, 32),
        children: [
          Text(
            'Poise uses your data exclusively to operate as your Trading Operating System and help you improve discipline. We securely connect to your exchange (Binance or Bybit) using your encrypted API and secret keys.',
            style: AppTypography.bodyLg.copyWith(
              color: AppColors.textSecondary,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 22),
          Text(
            'We use this connection to:',
            style: AppTypography.bodyLg.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          const _PrivacyBulletRow(
            strong: 'Read your futures balance',
            rest: ' and support real-time trade execution.',
          ),
          const _PrivacyBulletRow(
            strong: 'Ingest all trading activity',
            rest:
                ' (historical and real-time) to establish a performance baseline.',
          ),
          const _PrivacyBulletRow(
            strong: 'Analyze trade data',
            rest:
                ' to enforce your configured risk rules and behavioral guardrails.',
          ),
          const _PrivacyBulletRow(
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
          const SizedBox(height: AppSpacing.lg),
          _PolicyRow(
            onTap: () => PToast.info(context, 'Privacy policy coming soon'),
          ),
        ],
      ),
    );
  }
}

class _PrivacyBulletRow extends StatelessWidget {
  const _PrivacyBulletRow({required this.strong, required this.rest});

  final String strong;
  final String rest;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 5,
            height: 5,
            margin: const EdgeInsets.only(top: 9, right: 10),
            decoration: const BoxDecoration(
              color: AppColors.textSecondary,
              shape: BoxShape.circle,
            ),
          ),
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

class _PolicyRow extends StatelessWidget {
  const _PolicyRow({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.bgSurface,
      borderRadius: AppRadius.cardRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.cardRadius,
        child: Container(
          constraints: const BoxConstraints(minHeight: 52),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          decoration: BoxDecoration(
            borderRadius: AppRadius.cardRadius,
            border: Border.all(color: AppColors.borderLight),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.privacy_tip_outlined,
                size: 18,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  'View data and privacy policy',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.textDisabled,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SheetFrame extends StatelessWidget {
  const _SheetFrame({
    required this.title,
    required this.child,
    this.titleColor,
    this.showClose = true,
  });

  final String title;
  final Widget child;
  final Color? titleColor;
  final bool showClose;

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
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: AppTypography.h2.copyWith(
                          color: titleColor ?? AppColors.textPrimary,
                        ),
                      ),
                    ),
                    if (showClose)
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
      body:
          'You will be signed out of Poise on this device. Any active trades or guardrails remain active on the exchange.',
      primaryLabel: 'Log out',
      primaryColor: AppColors.lossRed,
      primaryIcon: Icons.logout_rounded,
      onPrimary: () {
        Navigator.pop(context);
        ref.read(authProvider.notifier).logout();
        context.go(Routes.welcomeBack);
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
      body:
          'This will permanently delete your Poise account and all associated data. This action cannot be undone.',
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
            context.go(Routes.welcomeBack);
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
      titleColor: titleColor,
      showClose: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            body,
            style:
                AppTypography.bodyLg.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.xl),
          FilledButton.icon(
            onPressed: () async => onPrimary(),
            icon: primaryIcon == null
                ? const SizedBox.shrink()
                : Icon(primaryIcon),
            label: Text(
              primaryLabel,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            style: FilledButton.styleFrom(
              backgroundColor: color,
              foregroundColor: Colors.white,
              shape: const RoundedRectangleBorder(
                borderRadius: AppRadius.buttonRadius,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          OutlinedButton(
            onPressed: () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.textPrimary,
              side: const BorderSide(color: AppColors.borderLight),
              shape: const RoundedRectangleBorder(
                borderRadius: AppRadius.buttonRadius,
              ),
            ),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}
