import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/buttons/p_primary_button.dart';
import '../../../core/widgets/feedback/p_toast.dart';
import '../../../core/widgets/inputs/p_otp_field.dart';
import '../../../core/widgets/inputs/p_text_field.dart';
import '../data/auth_api.dart';
import '../widgets/password_requirements.dart';

class ResetPasswordScreen extends ConsumerStatefulWidget {
  const ResetPasswordScreen({super.key, required this.email});

  final String email;

  @override
  ConsumerState<ResetPasswordScreen> createState() =>
      _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  static const _otpResendDelay = Duration(seconds: 60);
  final _otpCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  PButtonState _buttonState = PButtonState.idle;
  POtpState _otpState = POtpState.idle;
  PFieldState _passState = PFieldState.idle;
  PFieldState _confirmState = PFieldState.idle;
  String? _passError;
  String? _confirmError;
  bool _otpComplete = false;
  bool _resending = false;
  Timer? _otpTimer;
  int _secondsRemaining = _otpResendDelay.inSeconds;

  @override
  void initState() {
    super.initState();
    _startOtpTimer();
  }

  @override
  void dispose() {
    _otpTimer?.cancel();
    _otpCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  void _startOtpTimer() {
    _otpTimer?.cancel();
    setState(() => _secondsRemaining = _otpResendDelay.inSeconds);
    _otpTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_secondsRemaining <= 1) {
        timer.cancel();
        setState(() => _secondsRemaining = 0);
        return;
      }
      setState(() => _secondsRemaining -= 1);
    });
  }

  bool _validatePassword() {
    final ok = PasswordRequirements.isValid(_passCtrl.text);
    setState(() {
      _passState = ok ? PFieldState.valid : PFieldState.error;
      _passError = ok ? null : 'Password does not meet all requirements';
    });
    return ok;
  }

  bool _validateConfirm() {
    final ok = _confirmCtrl.text == _passCtrl.text;
    setState(() {
      _confirmState = ok ? PFieldState.valid : PFieldState.error;
      _confirmError = ok ? null : 'Passwords do not match';
    });
    return ok;
  }

  Future<void> _submit() async {
    if (!_otpComplete) return;
    final passOk = _validatePassword();
    final confirmOk = _validateConfirm();
    if (!passOk || !confirmOk) return;

    setState(() => _buttonState = PButtonState.loading);

    final result = await ref.read(authApiProvider).resetPassword(
          email: widget.email,
          otp: _otpCtrl.text,
          newPassword: _passCtrl.text,
        );

    if (!mounted) return;

    result.fold(
      onOk: (_) {
        setState(() => _buttonState = PButtonState.success);
        Future.delayed(const Duration(milliseconds: 600), () {
          if (mounted) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute<void>(
                builder: (_) => const _PasswordUpdatedSuccessScreen(),
              ),
            );
          }
        });
      },
      onErr: (e) {
        setState(() {
          _buttonState = PButtonState.error;
          _otpState = POtpState.error;
        });
        PToast.error(context, e.userMessage);
        Future.delayed(const Duration(milliseconds: 400), () {
          if (mounted) {
            setState(() {
              _buttonState = PButtonState.idle;
              _otpState = POtpState.idle;
            });
            _otpCtrl.clear();
          }
        });
      },
    );
  }

  Future<void> _resend() async {
    if (_resending || _secondsRemaining > 0) return;
    setState(() => _resending = true);

    final result = await ref.read(authApiProvider).forgotPassword(widget.email);

    if (!mounted) return;
    setState(() => _resending = false);
    result.fold(
      onOk: (_) {
        _otpCtrl.clear();
        setState(() {
          _otpComplete = false;
          _otpState = POtpState.idle;
        });
        _startOtpTimer();
        PToast.success(context, 'Reset code sent');
      },
      onErr: (e) => PToast.error(context, e.userMessage),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.email.trim().isEmpty) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: () => context.go(Routes.login),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: AppSpacing.screenPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppSpacing.lg),
                const Text('Reset password', style: AppTypography.display2),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Enter your email first so Poise can send a reset code.',
                  style: AppTypography.bodyLg.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const Spacer(),
                PPrimaryButton(
                  label: 'Enter email',
                  onPressed: () => context.go(Routes.forgotPassword),
                ),
                const SizedBox(height: AppSpacing.lg),
              ],
            ),
          ),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.lg),
              const Text('Enter new password', style: AppTypography.display2),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Check your email for a 6-digit code.',
                style: AppTypography.bodyLg
                    .copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: AppSpacing.xxl),
              Center(
                child: POtpField(
                  controller: _otpCtrl,
                  state: _otpState,
                  onCompleted: (val) => setState(() => _otpComplete = true),
                  onChanged: (_) {
                    if (_otpState != POtpState.idle) {
                      setState(() => _otpState = POtpState.idle);
                    }
                    setState(() => _otpComplete = false);
                  },
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Center(
                child: TextButton(
                  onPressed:
                      _resending || _secondsRemaining > 0 ? null : _resend,
                  child: Text(
                    _resending
                        ? 'Sending...'
                        : _secondsRemaining > 0
                            ? 'Request a new OTP in ${_formatOtpTime(_secondsRemaining)}'
                            : 'Request a new OTP',
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              PTextField(
                controller: _passCtrl,
                label: 'New password',
                obscureText: true,
                textInputAction: TextInputAction.next,
                fieldState: _passState,
                errorText: _passError,
                onChanged: (val) {
                  setState(() {});
                  if (_passState != PFieldState.idle) {
                    _validatePassword();
                  }
                  if (_confirmState != PFieldState.idle) {
                    _validateConfirm();
                  }
                },
              ),
              const SizedBox(height: AppSpacing.sm),
              PasswordRequirements(password: _passCtrl.text),
              const SizedBox(height: AppSpacing.md),
              PTextField(
                controller: _confirmCtrl,
                label: 'Confirm password',
                obscureText: true,
                textInputAction: TextInputAction.done,
                fieldState: _confirmState,
                errorText: _confirmError,
                onChanged: (val) {
                  if (_confirmState != PFieldState.idle) _validateConfirm();
                },
                onEditingComplete: _submit,
              ),
              const SizedBox(height: AppSpacing.xl),
              PPrimaryButton(
                label: 'Reset password',
                state: _buttonState,
                onPressed: _otpComplete ? _submit : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PasswordUpdatedSuccessScreen extends StatelessWidget {
  const _PasswordUpdatedSuccessScreen();

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
                'Your password has been reset successfully, you can now proceed to log in.',
                textAlign: TextAlign.center,
                style: AppTypography.body.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.45,
                ),
              ),
              const Spacer(flex: 2),
              PPrimaryButton(
                label: 'Login',
                onPressed: () => context.go(Routes.login),
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }
}

String _formatOtpTime(int seconds) {
  final minutes = seconds ~/ 60;
  final secs = (seconds % 60).toString().padLeft(2, '0');
  return '$minutes:$secs';
}
