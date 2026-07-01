import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/buttons/p_primary_button.dart';
import '../../../core/widgets/feedback/p_success_seal.dart';
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

  _ResetPasswordStep _step = _ResetPasswordStep.otp;
  PButtonState _buttonState = PButtonState.idle;
  POtpState _otpState = POtpState.idle;
  PFieldState _passState = PFieldState.idle;
  PFieldState _confirmState = PFieldState.idle;
  String? _passError;
  String? _confirmError;
  String? _errorMessage;
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

    setState(() {
      _buttonState = PButtonState.loading;
      _errorMessage = null;
    });

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
          _buttonState = PButtonState.idle;
          _errorMessage = e.userMessage;
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
        backgroundColor: AppColors.bgPrimary,
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 390),
            child: Stack(
              children: [
                Positioned(
                  key: const ValueKey('reset-back-button'),
                  left: 22,
                  top: 74,
                  child:
                      _AuthBackGlyph(onPressed: () => context.go(Routes.login)),
                ),
                const Positioned(
                  left: 24,
                  top: 134,
                  child: _AuthInfoBlock(
                    title: 'Reset your password',
                    body:
                        'Enter your email first so Poise can send a reset code.',
                    height: 80,
                  ),
                ),
                Positioned(
                  left: 24,
                  right: 24,
                  top: 724,
                  child: PPrimaryButton(
                    label: 'Enter email',
                    onPressed: () => context.go(Routes.forgotPassword),
                    height: 48,
                    borderRadius: BorderRadius.circular(24),
                    textStyle: AppTypography.button,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
    final isPasswordStep = _step == _ResetPasswordStep.password;

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 390),
          child: Stack(
            children: [
              Positioned(
                key: const ValueKey('reset-back-button'),
                left: 22,
                top: 74,
                child: _AuthBackGlyph(
                  onPressed: () {
                    if (isPasswordStep) {
                      setState(() => _step = _ResetPasswordStep.otp);
                    } else if (context.canPop()) {
                      context.pop();
                    }
                  },
                ),
              ),
              if (!isPasswordStep) ...[
                Positioned(
                  key: const ValueKey('reset-otp-content'),
                  left: 24,
                  top: 130,
                  child: SizedBox(
                    width: 342,
                    height: 220,
                    child: Stack(
                      children: [
                        const _AuthInfoBlock(
                          title: 'Enter OTP',
                          body:
                              'A 6-digit OTP has been sent to your email. Please enter it below to verify your email.',
                          height: 80,
                        ),
                        Positioned(
                          left: 0,
                          top: 120,
                          child: POtpField(
                            controller: _otpCtrl,
                            state: _otpState,
                            onCompleted: (val) => setState(() {
                              _otpComplete = true;
                            }),
                            onChanged: (_) {
                              if (_otpState != POtpState.idle) {
                                setState(() => _otpState = POtpState.idle);
                              }
                              setState(() => _otpComplete = false);
                            },
                          ),
                        ),
                        Positioned(
                          key: const ValueKey('reset-otp-request'),
                          left: 0,
                          top: 200,
                          child: _RequestOtpRow(
                            resending: _resending,
                            secondsRemaining: _secondsRemaining,
                            onPressed: _resend,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: 24,
                  right: 24,
                  top: 724,
                  child: PPrimaryButton(
                    label: 'Verify',
                    onPressed: _otpComplete
                        ? () => setState(
                              () => _step = _ResetPasswordStep.password,
                            )
                        : null,
                    height: 48,
                    borderRadius: BorderRadius.circular(24),
                    textStyle: AppTypography.button,
                  ),
                ),
              ] else ...[
                Positioned(
                  key: const ValueKey('reset-password-content'),
                  left: 24,
                  top: 134,
                  child: SizedBox(
                    width: 342,
                    height: 356,
                    child: Stack(
                      children: [
                        const _AuthInfoBlock(
                          title: 'Create a new password',
                          body: 'Enter a new secure password for your account',
                          height: 60,
                        ),
                        Positioned(
                          left: 0,
                          top: 100,
                          child: SizedBox(
                            width: 342,
                            height: 256,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                PTextField(
                                  controller: _passCtrl,
                                  label: 'New password',
                                  showLabelAbove: true,
                                  obscureText: true,
                                  textInputAction: TextInputAction.next,
                                  fieldState: _passState,
                                  errorText: _passError,
                                  compact: true,
                                  showValidationIcon: false,
                                  onChanged: (val) {
                                    setState(() {
                                      if (_errorMessage != null) {
                                        _errorMessage = null;
                                      }
                                    });
                                    if (_passState != PFieldState.idle) {
                                      _validatePassword();
                                    }
                                    if (_confirmState != PFieldState.idle) {
                                      _validateConfirm();
                                    }
                                  },
                                ),
                                const SizedBox(height: 12),
                                SizedBox(
                                  width: 342,
                                  height: 72,
                                  child: _ResetPasswordRequirements(
                                    password: _passCtrl.text,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                PTextField(
                                  controller: _confirmCtrl,
                                  label: 'Confirm password',
                                  hint: 'Repeat password',
                                  showLabelAbove: true,
                                  obscureText: true,
                                  textInputAction: TextInputAction.done,
                                  fieldState: _confirmState,
                                  errorText: _confirmError,
                                  compact: true,
                                  showValidationIcon: false,
                                  onChanged: (val) {
                                    setState(() {
                                      if (_errorMessage != null) {
                                        _errorMessage = null;
                                      }
                                    });
                                    if (_confirmState != PFieldState.idle) {
                                      _validateConfirm();
                                    }
                                  },
                                  onEditingComplete: _submit,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (_errorMessage != null)
                  Positioned(
                    left: 24,
                    right: 24,
                    top: 532,
                    child: _ResetError(message: _errorMessage!),
                  ),
                Positioned(
                  left: 24,
                  right: 24,
                  top: 724,
                  child: PPrimaryButton(
                    label: 'Save',
                    state: _buttonState,
                    onPressed: _otpComplete ? _submit : null,
                    height: 48,
                    borderRadius: BorderRadius.circular(24),
                    textStyle: AppTypography.button,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

enum _ResetPasswordStep { otp, password }

class _PasswordUpdatedSuccessScreen extends StatelessWidget {
  const _PasswordUpdatedSuccessScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 390),
          child: Stack(
            children: [
              const Positioned(
                key: ValueKey('reset-success-seal'),
                left: 95,
                top: 166,
                child: PSuccessSeal(size: 200),
              ),
              Positioned(
                key: const ValueKey('reset-success-copy'),
                left: 24,
                top: 458,
                child: SizedBox(
                  width: 342,
                  height: 116,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 23,
                        top: 0,
                        child: SizedBox(
                          width: 296,
                          height: 64,
                          child: Text(
                            'Your password has been updated',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: AppTypography.h2.copyWith(
                              fontFamily: 'Orbitron',
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              height: 1.33,
                              letterSpacing: 0,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 0,
                        top: 76,
                        child: SizedBox(
                          width: 342,
                          height: 40,
                          child: Text(
                            'Your password has been reset successfully, you can now proceed to log in.',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: AppTypography.bodySm.copyWith(
                              color: AppColors.textSecondary,
                              height: 1.67,
                              letterSpacing: 0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 23,
                right: 25,
                top: 724,
                child: PPrimaryButton(
                  label: 'Log in',
                  onPressed: () => context.go(Routes.login),
                  height: 48,
                  borderRadius: BorderRadius.circular(24),
                  textStyle: AppTypography.button,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AuthBackGlyph extends StatelessWidget {
  const _AuthBackGlyph({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onPressed,
      child: const SizedBox(
        width: 24,
        height: 24,
        child: Icon(Icons.arrow_back_rounded, size: 24),
      ),
    );
  }
}

class _AuthInfoBlock extends StatelessWidget {
  const _AuthInfoBlock({
    required this.title,
    required this.body,
    required this.height,
  });

  final String title;
  final String body;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 342,
      height: height,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: 0,
            child: SizedBox(
              width: 342,
              height: 32,
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.h2.copyWith(
                  fontFamily: 'Orbitron',
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  height: 1.6,
                  letterSpacing: 0,
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            top: 40,
            child: SizedBox(
              width: 342,
              height: height > 60 ? 40 : 20,
              child: Text(
                body,
                maxLines: height > 60 ? 2 : 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.bodySm.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.67,
                  letterSpacing: 0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RequestOtpRow extends StatelessWidget {
  const _RequestOtpRow({
    required this.resending,
    required this.secondsRemaining,
    required this.onPressed,
  });

  final bool resending;
  final int secondsRemaining;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final disabled = resending || secondsRemaining > 0;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextButton(
          onPressed: disabled ? null : onPressed,
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: const Size(132, 20),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            resending
                ? 'Sending...'
                : secondsRemaining > 0
                    ? 'Request a new OTP'
                    : 'Request a new OTP',
            style: AppTypography.bodySm.copyWith(
              color: disabled ? AppColors.textDisabled : AppColors.primary,
              fontWeight: FontWeight.w700,
              height: 1.67,
            ),
          ),
        ),
        if (secondsRemaining > 0) ...[
          const SizedBox(width: 4),
          Text(
            _formatOtpTime(secondsRemaining),
            style: AppTypography.bodySm.copyWith(
              color: AppColors.textSecondary,
              height: 1.67,
            ),
          ),
        ],
      ],
    );
  }
}

class _ResetError extends StatelessWidget {
  const _ResetError({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: AppColors.lossRedBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.lossRed.withValues(alpha: 0.22)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.error_outline_rounded,
            size: 20,
            color: AppColors.lossRed,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.bodySm.copyWith(color: AppColors.lossRed),
            ),
          ),
        ],
      ),
    );
  }
}

class _ResetPasswordRequirements extends StatelessWidget {
  const _ResetPasswordRequirements({required this.password});

  final String password;

  bool get _hasMinLength => password.length >= 8;
  bool get _hasNumber => RegExp(r'\d').hasMatch(password);
  bool get _hasUppercase => RegExp(r'[A-Z]').hasMatch(password);
  bool get _hasLowercase => RegExp(r'[a-z]').hasMatch(password);
  bool get _hasSymbol => RegExp(r'[^A-Za-z0-9]').hasMatch(password);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Text(
          'Requires at least:',
          style: AppTypography.labelSm.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w600,
            height: 1.8,
            letterSpacing: 0,
          ),
        ),
        Positioned(
          left: 0,
          top: 24,
          child: SizedBox(
            width: 342,
            height: 48,
            child: Wrap(
              spacing: 4,
              runSpacing: 4,
              children: [
                _ResetRequirementChip(
                  width: 113,
                  label: '8 characters long',
                  met: _hasMinLength,
                ),
                _ResetRequirementChip(
                  width: 65,
                  label: '1 number',
                  met: _hasNumber,
                ),
                _ResetRequirementChip(
                  width: 116,
                  label: '1 uppercase letter',
                  met: _hasUppercase,
                ),
                _ResetRequirementChip(
                  width: 113,
                  label: '1 lowercase letter',
                  met: _hasLowercase,
                ),
                _ResetRequirementChip(
                  width: 63,
                  label: '1 symbol',
                  met: _hasSymbol,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ResetRequirementChip extends StatelessWidget {
  const _ResetRequirementChip({
    required this.width,
    required this.label,
    required this.met,
  });

  final double width;
  final String label;
  final bool met;

  @override
  Widget build(BuildContext context) {
    final color = met ? AppColors.profitGreen : AppColors.lossRed;
    final bg = met ? AppColors.profitGreenBg : AppColors.lossRedBg;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 160),
      width: width,
      height: 22,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: bg,
        border: Border.all(color: color.withValues(alpha: 0.35)),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTypography.labelSm.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
          height: 1,
          letterSpacing: 0,
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
