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

class ResetPasswordScreen extends ConsumerStatefulWidget {
  const ResetPasswordScreen({super.key, required this.email});

  final String email;

  @override
  ConsumerState<ResetPasswordScreen> createState() =>
      _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
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

  @override
  void dispose() {
    _otpCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  bool _validatePassword() {
    final ok = _passCtrl.text.length >= 8;
    setState(() {
      _passState = ok ? PFieldState.valid : PFieldState.error;
      _passError = ok ? null : 'At least 8 characters required';
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
        PToast.success(context, 'Password reset. Sign in with your new password.');
        Future.delayed(const Duration(milliseconds: 600), () {
          if (mounted) context.go(Routes.login);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
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
              const SizedBox(height: AppSpacing.xl),
              PTextField(
                controller: _passCtrl,
                label: 'New password',
                obscureText: true,
                textInputAction: TextInputAction.next,
                fieldState: _passState,
                errorText: _passError,
                onChanged: (val) {
                  if (_passState != PFieldState.idle) _validatePassword();
                },
              ),
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
