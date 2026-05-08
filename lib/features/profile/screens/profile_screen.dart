import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../core/storage/preferences.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/feedback/p_toast.dart';
import '../../../core/widgets/feedback/p_error_state.dart';
import '../../../core/widgets/p_app_bar.dart';
import '../../auth/providers/auth_provider.dart';
import '../../auth/providers/auth_state.dart';
import '../../strategies/providers/strategies_provider.dart';
import '../data/profile_api.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider).valueOrNull;
    if (authState is! AuthAuthenticated) {
      return const Scaffold(
        body: PErrorState(message: 'Not authenticated'),
      );
    }

    return Scaffold(
      appBar: const PAppBar(title: 'Profile'),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: ListView(
        padding: AppSpacing.screenPadding,
        children: [
          const SizedBox(height: AppSpacing.md),
          const _SectionHeader(title: 'Account'),
          _InfoTile(label: 'Email', value: authState.email),
          _TotpTile(totpEnabled: authState.totpEnabled),
          const SizedBox(height: AppSpacing.md),
          const _SectionHeader(title: 'Risk strategy'),
          _StrategyStatusTile(),
          const SizedBox(height: AppSpacing.md),
          const _SectionHeader(title: 'Exchange connections'),
          _ExchangeConnectionsSection(),
          const SizedBox(height: AppSpacing.md),
          const _SectionHeader(title: 'Notifications'),
          _NotificationPreferencesSection(),
          const SizedBox(height: AppSpacing.xl),
          _SignOutButton(),
        ],
      ),
    );
  }
}

// ── Strategy status tile — reads from StrategiesNotifier, not auth flag ──────

class _StrategyStatusTile extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strategiesState = ref.watch(strategiesNotifierProvider);
    final bool hasActive =
        strategiesState is StrategiesLoaded && strategiesState.active != null;
    final String strategyName =
        strategiesState is StrategiesLoaded && strategiesState.active != null
            ? strategiesState.active!.name
            : 'Not set';

    return _InfoTile(
      label: 'Active strategy',
      value: hasActive ? strategyName : 'Not set',
      valueColor: hasActive ? AppColors.profitGreen : AppColors.warningAmber,
    );
  }
}

// ── 2FA setup tile — shows status + setup button when disabled ───────────────

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
        final secret = data['secret'] as String? ?? '';
        final qrUrl = data['qr_url'] as String? ?? '';
        showDialog<void>(
          context: context,
          barrierDismissible: false,
          builder: (_) => _TotpEnableDialog(
            secret: secret,
            qrUrl: qrUrl,
            onEnabled: () {
              if (mounted) ref.read(authProvider.notifier).markTotpEnabled();
            },
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
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.xs),
      padding: AppSpacing.cardPadding,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        border: Border.all(color: colorScheme.outline),
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '2FA',
            style: AppTypography.body.copyWith(color: colorScheme.onSurface),
          ),
          if (widget.totpEnabled)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Enabled',
                  style:
                      AppTypography.body.copyWith(color: AppColors.profitGreen),
                ),
                const SizedBox(width: AppSpacing.sm),
                TextButton(
                  onPressed: _disable,
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    'Disable',
                    style: AppTypography.body.copyWith(
                      color: AppColors.lossRed,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            )
          else
            TextButton(
              onPressed: _setup,
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                'Set up',
                style: AppTypography.body.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
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
    final colorScheme = Theme.of(context).colorScheme;

    return AlertDialog(
      title: const Text('Set up 2FA'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.qrUrl.isNotEmpty)
              Center(
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: colorScheme.outline),
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                  ),
                  child: QrImageView(
                    data: widget.qrUrl,
                    version: QrVersions.auto,
                    size: 180,
                    backgroundColor: Colors.white,
                    eyeStyle: const QrEyeStyle(
                      eyeShape: QrEyeShape.square,
                      color: Colors.black,
                    ),
                    dataModuleStyle: const QrDataModuleStyle(
                      dataModuleShape: QrDataModuleShape.square,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            if (widget.qrUrl.isNotEmpty) const SizedBox(height: AppSpacing.md),
            const Text(
              '1. Scan the QR code with Google/Microsoft/Apple Authenticator or enter the secret key manually.',
              style: AppTypography.bodySm,
            ),
            const SizedBox(height: AppSpacing.sm),
            const Text('2. Enter this secret key:',
                style: AppTypography.bodySm),
            const SizedBox(height: AppSpacing.xs),
            Container(
              width: double.infinity,
              padding: AppSpacing.cardPadding,
              decoration: BoxDecoration(
                color: colorScheme.surface,
                border: Border.all(color: colorScheme.outline),
                borderRadius: const BorderRadius.all(Radius.circular(6)),
              ),
              child: SelectableText(
                widget.secret,
                style: AppTypography.bodyMedium.copyWith(
                  color: colorScheme.onSurface,
                  fontFamily: 'monospace',
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            const Text(
              '3. Enter the 6-digit code shown in your app:',
              style: AppTypography.bodySm,
            ),
            const SizedBox(height: AppSpacing.xs),
            TextField(
              controller: _codeCtrl,
              keyboardType: TextInputType.number,
              maxLength: 6,
              style: AppTypography.body.copyWith(color: colorScheme.onSurface),
              cursorColor: colorScheme.primary,
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
          onPressed: _loading ? null : _enable,
          child: _loading
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Enable'),
        ),
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
    final colorScheme = Theme.of(context).colorScheme;

    return AlertDialog(
      title: const Text('Disable 2FA'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Enter the 6-digit code from your authenticator app to confirm.',
            style: AppTypography.bodySm,
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: _codeCtrl,
            keyboardType: TextInputType.number,
            maxLength: 6,
            autofocus: true,
            style: AppTypography.body.copyWith(color: colorScheme.onSurface),
            cursorColor: colorScheme.primary,
            decoration: InputDecoration(
              hintText: '000000',
              errorText: _error,
              counterText: '',
            ),
            onSubmitted: (_) => _submit(),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, null),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _submit,
          style: FilledButton.styleFrom(backgroundColor: AppColors.lossRed),
          child: const Text('Disable'),
        ),
      ],
    );
  }
}

// ── Section header ────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Text(
        title.toUpperCase(),
        style: AppTypography.labelSm.copyWith(
          color: colorScheme.onSurfaceVariant,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({required this.label, required this.value, this.valueColor});
  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.xs),
      padding: AppSpacing.cardPadding,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        border: Border.all(color: colorScheme.outline),
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTypography.body.copyWith(color: colorScheme.onSurface),
          ),
          Text(
            value,
            style: AppTypography.body.copyWith(
              color: valueColor ?? colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
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
              padding: EdgeInsets.all(AppSpacing.md),
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
        if (connections.isEmpty) {
          return _ExchangeEmptyCard(
            onAdd: () => _showAddExchangeDialog(context),
          );
        }
        final activeCount =
            connections.where((c) => (c['is_active'] as bool?) ?? false).length;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (connections.length > 1) ...[
              _ExchangeClarityNote(
                text: activeCount > 1
                    ? '$activeCount exchanges are active. Each trade will show its exchange so external and Poise trades stay easy to separate.'
                    : '${connections.length} exchanges connected. Activate the exchange you want Poise to use for new trades.',
              ),
              const SizedBox(height: AppSpacing.sm),
            ],
            ...connections.map((c) => _ConnectionTile(
                  id: (c['id'] as String?) ?? '',
                  exchange: (c['exchange'] as String?) ?? 'Exchange',
                  isActive: (c['is_active'] as bool?) ?? false,
                  onChanged: _reload,
                )),
            const SizedBox(height: AppSpacing.sm),
            const _MagicLinkButton(),
            const SizedBox(height: AppSpacing.xs),
            OutlinedButton.icon(
              onPressed: () => _showAddExchangeDialog(context),
              icon: const Icon(Icons.add_rounded, size: 18),
              label: const Text('Enter API keys manually'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showAddExchangeDialog(BuildContext context) async {
    final created = await showDialog<bool>(
      context: context,
      builder: (_) => const _ExchangeConnectionDialog(),
    );
    if (created == true && mounted) _reload();
  }
}

class _ExchangeClarityNote extends StatelessWidget {
  const _ExchangeClarityNote({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: AppSpacing.cardPadding,
      decoration: BoxDecoration(
        color: AppColors.brand50.withValues(alpha: 0.35),
        border: Border.all(color: AppColors.brand100),
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline_rounded,
              color: AppColors.primary, size: 20),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              text,
              style: AppTypography.bodySm.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
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
    final result = widget.isActive
        ? await ref
            .read(profileApiProvider)
            .deactivateExchangeConnection(widget.id)
        : await ref
            .read(profileApiProvider)
            .activateExchangeConnection(widget.id);
    if (!mounted) return;
    setState(() => _loading = false);
    result.fold(
      onOk: (_) => widget.onChanged(),
      onErr: (err) => PToast.error(context, err.userMessage),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.xs),
      padding: AppSpacing.cardPadding,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        border: Border.all(color: colorScheme.outline),
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.exchange,
                style:
                    AppTypography.body.copyWith(color: colorScheme.onSurface),
              ),
              Text(
                widget.isActive ? 'Active' : 'Inactive',
                style: AppTypography.bodySm.copyWith(
                  color: widget.isActive
                      ? AppColors.profitGreen
                      : colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          _loading
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : TextButton(
                  onPressed: _toggle,
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    widget.isActive ? 'Deactivate' : 'Activate',
                    style: AppTypography.body.copyWith(
                      color: widget.isActive
                          ? AppColors.lossRed
                          : AppColors.profitGreen,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}

class _ExchangeEmptyCard extends StatelessWidget {
  const _ExchangeEmptyCard({required this.onAdd});
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: AppSpacing.cardPadding,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        border: Border.all(color: colorScheme.outline),
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'No exchange connected',
            style: AppTypography.body
                .copyWith(color: colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Connect Bybit or Binance to start trading.',
            style: AppTypography.bodySm
                .copyWith(color: colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: AppSpacing.md),
          const _MagicLinkButton(),
          const SizedBox(height: AppSpacing.xs),
          OutlinedButton.icon(
            onPressed: onAdd,
            icon: const Icon(Icons.add_rounded, size: 18),
            label: const Text('Enter API keys manually'),
          ),
        ],
      ),
    );
  }
}

/// Button that requests a magic link email for web-based API key setup.
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
      onOk: (_) => PToast.success(
        context,
        'Check your email — link sent',
      ),
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
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.black,
              ),
            )
          : const Icon(Icons.open_in_browser_rounded, size: 18),
      label: Text(_loading ? 'Sending link…' : 'Set up on web'),
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.profitGreen,
        foregroundColor: Colors.black,
      ),
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
    final colorScheme = Theme.of(context).colorScheme;

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
              style: AppTypography.body.copyWith(color: colorScheme.onSurface),
              cursorColor: colorScheme.primary,
              decoration: const InputDecoration(labelText: 'API key'),
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: AppSpacing.sm),
            TextField(
              controller: _apiSecretCtrl,
              style: AppTypography.body.copyWith(color: colorScheme.onSurface),
              cursorColor: colorScheme.primary,
              decoration: const InputDecoration(labelText: 'API secret'),
              obscureText: true,
            ),
            const SizedBox(height: AppSpacing.sm),
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
          onPressed: _isSaving ? null : _save,
          child: _isSaving
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Connect'),
        ),
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

class _NotificationPreferencesSection extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefsState = ref.watch(appPreferencesProvider);
    return prefsState.when(
      loading: () => const Center(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.md),
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
      error: (_, __) => Text(
        'Failed to load notification settings',
        style: AppTypography.body.copyWith(color: AppColors.textSecondary),
      ),
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
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.xs),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        border: Border.all(color: colorScheme.outline),
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      ),
      child: SwitchListTile(
        contentPadding: EdgeInsets.zero,
        value: value,
        onChanged: onChanged,
        title: Text(
          label,
          style: AppTypography.body.copyWith(color: colorScheme.onSurface),
        ),
      ),
    );
  }
}

class _SignOutButton extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextButton(
      onPressed: () => ref.read(authProvider.notifier).logout(),
      child: Text(
        'Sign out',
        style: AppTypography.button.copyWith(color: AppColors.lossRed),
      ),
    );
  }
}
