import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/buttons/p_primary_button.dart';
import '../../../core/widgets/feedback/p_toast.dart';
import '../../../core/widgets/inputs/p_otp_field.dart';
import '../providers/auth_provider.dart';
import '../providers/auth_state.dart';

class VerifyEmailScreen extends ConsumerStatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  ConsumerState<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends ConsumerState<VerifyEmailScreen> {
  static const _otpResendDelay = Duration(seconds: 60);
  final _otpCtrl = TextEditingController();
  final _focusNode = FocusNode();

  PButtonState _buttonState = PButtonState.idle;
  POtpState _otpState = POtpState.idle;
  String? _otpErrorText;
  bool _otpComplete = false;
  bool _resending = false;
  Timer? _otpTimer;
  int _secondsRemaining = _otpResendDelay.inSeconds;

  @override
  void initState() {
    super.initState();
    _startOtpTimer();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _otpTimer?.cancel();
    _otpCtrl.dispose();
    _focusNode.dispose();
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

  Future<void> _verify() async {
    if (!_otpComplete || _buttonState == PButtonState.loading) return;
    setState(() => _buttonState = PButtonState.loading);

    final result = await ref.read(authProvider.notifier).verifyEmail(
          _otpCtrl.text,
        );
    if (!mounted) return;

    result.fold(
      onOk: (_) {
        final auth = ref.read(authProvider).valueOrNull;
        final isSettings = auth is AuthAuthenticated && auth.hasActiveStrategy;
        if (isSettings) {
          // Settings: router won't auto-redirect; show success briefly then go.
          setState(() {
            _buttonState = PButtonState.success;
            _otpState = POtpState.success;
          });
          Future<void>.delayed(const Duration(milliseconds: 420), () {
            if (!mounted) return;
            context.go(Routes.profile);
          });
        } else {
          // New user: navigate to success screen immediately so GoRouter's
          // redirect (which fires next frame) lands on /onboarding/... and
          // skips back to riskAppetite. The success screen auto-advances.
          context.go(Routes.verifyEmailSuccess);
        }
      },
      onErr: (message) {
        _otpCtrl.clear();
        setState(() {
          _buttonState = PButtonState.idle;
          _otpState = POtpState.error;
          _otpErrorText = 'Invalid OTP';
          _otpComplete = false;
        });
        _focusNode.requestFocus();
      },
    );
  }

  Future<void> _resend() async {
    if (_resending || _secondsRemaining > 0) return;
    setState(() => _resending = true);
    final result =
        await ref.read(authProvider.notifier).resendEmailVerification();
    if (!mounted) return;
    setState(() => _resending = false);
    result.fold(
      onOk: (_) {
        _startOtpTimer();
        PToast.success(context, 'Verification code sent');
      },
      onErr: (message) => PToast.error(context, message),
    );
  }

  Future<void> _goBack() async {
    if (context.canPop()) {
      context.pop();
      return;
    }
    final auth = ref.read(authProvider).valueOrNull;
    if (auth is AuthAuthenticated && auth.hasActiveStrategy) {
      context.go(Routes.profile);
      return;
    }
    await ref.read(authProvider.notifier).logout();
    if (!mounted) return;
    context.go(Routes.login);
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider).valueOrNull;
    final email = auth is AuthAuthenticated ? auth.email : 'your email';
    final isSettingsVerification =
        auth is AuthAuthenticated && auth.hasActiveStrategy;

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 390),
          child: Stack(
            children: [
              Positioned(
                key: const ValueKey('verify-email-back-button'),
                left: 22,
                top: 74,
                child: _AuthBackGlyph(onPressed: _goBack),
              ),
              Positioned(
                key: const ValueKey('verify-email-content'),
                left: 24,
                top: 130,
                child: SizedBox(
                  width: 342,
                  height: 220,
                  child: Stack(
                    children: [
                      _AuthInfoBlock(
                        title: 'Enter your OTP',
                        body: isSettingsVerification
                            ? 'A 6-digit OTP has been sent to your email. Please enter it below to verify your email.'
                            : 'A 6-digit OTP has been sent to $email. Please enter it below to verify your email.',
                      ),
                      Positioned(
                        left: 0,
                        top: 120,
                        child: POtpField(
                          controller: _otpCtrl,
                          focusNode: _focusNode,
                          state: _otpState,
                          onCompleted: (_) {
                            setState(() => _otpComplete = true);
                          },
                          onChanged: (value) {
                            if (_otpState != POtpState.idle) {
                              setState(() {
                                _otpState = POtpState.idle;
                                _otpErrorText = null;
                              });
                            }
                            setState(() => _otpComplete = value.length == 6);
                          },
                        ),
                      ),
                      if (_otpErrorText != null)
                        Positioned(
                          key: const ValueKey('verify-email-otp-error'),
                          left: 0,
                          top: 190,
                          child: _OtpErrorText(message: _otpErrorText!),
                        ),
                      Positioned(
                        key: const ValueKey('verify-email-otp-request'),
                        left: 0,
                        top: _otpErrorText == null ? 200 : 230,
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
                  state: _buttonState,
                  onPressed: _otpComplete ? _verify : null,
                  height: 48,
                  borderRadius: BorderRadius.circular(24),
                  textStyle: AppTypography.buttonLg,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OtpErrorText extends StatelessWidget {
  const _OtpErrorText({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 342,
      height: 20,
      child: Text(
        message,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTypography.body.copyWith(
          color: AppColors.lossRed,
          height: 20 / 14,
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
  });

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 342,
      height: 80,
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
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  height: 32 / 24,
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
              height: 40,
              child: Text(
                body,
                maxLines: 2,
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
            resending ? 'Sending...' : 'Request a new OTP',
            style: AppTypography.body.copyWith(
              color: disabled ? AppColors.textDisabled : AppColors.primary,
              fontWeight: FontWeight.w600,
              height: 20 / 14,
            ),
          ),
        ),
        if (secondsRemaining > 0) ...[
          const SizedBox(width: 4),
          Text(
            _formatOtpTime(secondsRemaining),
            style: AppTypography.body.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
              height: 20 / 14,
            ),
          ),
        ],
      ],
    );
  }
}

String _formatOtpTime(int seconds) {
  final minutes = seconds ~/ 60;
  final secs = (seconds % 60).toString().padLeft(2, '0');
  return '$minutes:$secs';
}
