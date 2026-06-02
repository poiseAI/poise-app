import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/buttons/p_primary_button.dart';
import '../../../core/widgets/inputs/p_otp_field.dart';
import '../providers/auth_provider.dart';
import '../providers/session_lock_provider.dart';

class AppLockScreen extends ConsumerStatefulWidget {
  const AppLockScreen({super.key});

  @override
  ConsumerState<AppLockScreen> createState() => _AppLockScreenState();
}

class _AppLockScreenState extends ConsumerState<AppLockScreen> {
  final _pinCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  final _pinFocus = FocusNode();
  final _confirmFocus = FocusNode();

  @override
  void dispose() {
    _pinCtrl.dispose();
    _confirmCtrl.dispose();
    _pinFocus.dispose();
    _confirmFocus.dispose();
    super.dispose();
  }

  Future<void> _unlock() async {
    if (ref.read(sessionLockProvider).isBusy) return;
    final ok = await ref
        .read(sessionLockProvider.notifier)
        .unlockWithPin(_pinCtrl.text);
    if (!mounted || ok) return;
    _pinCtrl.clear();
    _pinFocus.requestFocus();
  }

  Future<void> _setupPin() async {
    if (ref.read(sessionLockProvider).isBusy) return;
    final ok = await ref.read(sessionLockProvider.notifier).setupPin(
          pin: _pinCtrl.text,
          confirmPin: _confirmCtrl.text,
        );
    if (!mounted || ok) return;
    _confirmCtrl.clear();
    if (_pinCtrl.text.length == SessionLockController.pinLength) {
      _confirmFocus.requestFocus();
    } else {
      _pinCtrl.clear();
      _pinFocus.requestFocus();
    }
  }

  Future<void> _forgotPin() async {
    HapticFeedback.mediumImpact();
    await ref.read(authProvider.notifier).logout();
    if (mounted) context.go(Routes.welcomeBack);
  }

  @override
  Widget build(BuildContext context) {
    final lock = ref.watch(sessionLockProvider);
    final isChecking = lock.mode == SessionLockMode.checking;
    final isSetup = lock.needsSetup;
    final title = isChecking
        ? 'Checking session'
        : isSetup
            ? 'Create your PIN'
            : 'Enter your PIN';
    final subtitle = isChecking
        ? 'Preparing your secure app lock.'
        : isSetup
            ? 'Set a brief local PIN for reopening Poise after time away.'
            : 'Welcome back. Unlock Poise to continue.';
    final buttonLabel = isSetup ? 'Save PIN' : 'Unlock';
    final buttonState = lock.isBusy ? PButtonState.loading : PButtonState.idle;
    final pinReady = _pinCtrl.text.length == SessionLockController.pinLength;
    final confirmReady =
        _confirmCtrl.text.length == SessionLockController.pinLength;
    final canSubmit = isSetup ? pinReady && confirmReady : pinReady;

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: AppColors.bgPrimary,
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) => SingleChildScrollView(
              padding: AppSpacing.screenPadding,
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: constraints.maxHeight * 0.12),
                    const Center(child: _LockMark()),
                    const SizedBox(height: AppSpacing.xl),
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: AppTypography.h1,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      subtitle,
                      textAlign: TextAlign.center,
                      style: AppTypography.bodyLg.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    SizedBox(
                      height: constraints.maxHeight > 720
                          ? AppSpacing.xxl
                          : AppSpacing.xl,
                    ),
                    if (isChecking)
                      const Center(
                        child: SizedBox(
                          width: 28,
                          height: 28,
                          child: CircularProgressIndicator(strokeWidth: 2.5),
                        ),
                      )
                    else ...[
                      POtpField(
                        length: SessionLockController.pinLength,
                        controller: _pinCtrl,
                        focusNode: _pinFocus,
                        obscureText: true,
                        autofocus: true,
                        enabled: !lock.isBusy,
                        state: _pinState(lock),
                        onChanged: (_) {
                          ref.read(sessionLockProvider.notifier).clearError();
                          setState(() {});
                        },
                        onCompleted: (_) {
                          if (isSetup) {
                            _confirmFocus.requestFocus();
                          } else {
                            _unlock();
                          }
                        },
                      ),
                      if (isSetup) ...[
                        const SizedBox(height: AppSpacing.md),
                        POtpField(
                          length: SessionLockController.pinLength,
                          controller: _confirmCtrl,
                          focusNode: _confirmFocus,
                          obscureText: true,
                          enabled: !lock.isBusy,
                          state: _confirmState(lock),
                          onChanged: (_) {
                            ref.read(sessionLockProvider.notifier).clearError();
                            setState(() {});
                          },
                          onCompleted: (_) => _setupPin(),
                        ),
                      ],
                    ],
                    if (lock.errorText != null) ...[
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        lock.errorText!,
                        textAlign: TextAlign.center,
                        style: AppTypography.bodySm.copyWith(
                          color: AppColors.lossRed,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                    const SizedBox(height: AppSpacing.xl),
                    if (!isChecking) ...[
                      PPrimaryButton(
                        label: buttonLabel,
                        state: buttonState,
                        onPressed: canSubmit
                            ? isSetup
                                ? _setupPin
                                : _unlock
                            : null,
                      ),
                      const SizedBox(height: AppSpacing.xxl),
                      Center(
                        child: TextButton.icon(
                          onPressed: lock.isBusy ? null : _forgotPin,
                          icon: const Icon(Icons.logout_rounded, size: 18),
                          label: const Text('Forgot PIN? Log in again'),
                        ),
                      ),
                    ],
                    const SizedBox(height: AppSpacing.lg),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  POtpState _pinState(SessionLockState lock) {
    if (lock.errorText == null) return POtpState.idle;
    if (lock.needsSetup && lock.errorText!.contains('match')) {
      return POtpState.idle;
    }
    return POtpState.error;
  }

  POtpState _confirmState(SessionLockState lock) {
    if (lock.errorText == null) return POtpState.idle;
    return lock.errorText!.contains('match') ? POtpState.error : POtpState.idle;
  }
}

class _LockMark extends StatelessWidget {
  const _LockMark();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 82,
      height: 82,
      decoration: BoxDecoration(
        color: AppColors.brand500,
        borderRadius: BorderRadius.circular(AppRadius.xxl),
        boxShadow: [
          BoxShadow(
            color: AppColors.brand500.withValues(alpha: 0.18),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Icon(
        Icons.lock_rounded,
        size: 42,
        color: Colors.white.withValues(alpha: 0.96),
      ),
    );
  }
}
