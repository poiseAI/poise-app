import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
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
  final _otpCtrl = TextEditingController();
  final _focusNode = FocusNode();

  PButtonState _buttonState = PButtonState.idle;
  POtpState _otpState = POtpState.idle;
  bool _otpComplete = false;
  bool _resending = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _otpCtrl.dispose();
    _focusNode.dispose();
    super.dispose();
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
        setState(() {
          _buttonState = PButtonState.success;
          _otpState = POtpState.success;
        });
        Future<void>.delayed(const Duration(milliseconds: 420), () {
          if (!mounted) return;
          Navigator.of(context).pushReplacement(
            MaterialPageRoute<void>(
              builder: (_) => const _EmailVerifiedSuccessScreen(),
            ),
          );
        });
      },
      onErr: (message) {
        setState(() {
          _buttonState = PButtonState.error;
          _otpState = POtpState.error;
          _otpComplete = false;
        });
        PToast.error(context, message);
        Future<void>.delayed(const Duration(milliseconds: 420), () {
          if (!mounted) return;
          setState(() {
            _buttonState = PButtonState.idle;
            _otpState = POtpState.idle;
          });
          _otpCtrl.clear();
          _focusNode.requestFocus();
        });
      },
    );
  }

  Future<void> _resend() async {
    if (_resending) return;
    setState(() => _resending = true);
    final result =
        await ref.read(authProvider.notifier).resendEmailVerification();
    if (!mounted) return;
    setState(() => _resending = false);
    result.fold(
      onOk: (_) => PToast.success(context, 'Verification code sent'),
      onErr: (message) => PToast.error(context, message),
    );
  }

  Future<void> _goBack() async {
    if (context.canPop()) {
      context.pop();
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify new email address'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: _goBack,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.md),
              Text(
                'A 6-digit OTP has been sent to $email. Please enter it below to verify your email.',
                style: AppTypography.body.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              const Text('Enter OTP', style: AppTypography.label),
              const SizedBox(height: AppSpacing.sm),
              POtpField(
                controller: _otpCtrl,
                focusNode: _focusNode,
                state: _otpState,
                onCompleted: (_) {
                  setState(() => _otpComplete = true);
                  _verify();
                },
                onChanged: (value) {
                  if (_otpState != POtpState.idle) {
                    setState(() => _otpState = POtpState.idle);
                  }
                  setState(() => _otpComplete = value.length == 6);
                },
              ),
              const Spacer(),
              Center(
                child: TextButton(
                  onPressed: _resending ? null : _resend,
                  child: Text(_resending ? 'Sending...' : 'Request a new OTP'),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              PPrimaryButton(
                label: 'Verify email',
                state: _buttonState,
                onPressed: _otpComplete ? _verify : null,
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmailVerifiedSuccessScreen extends ConsumerWidget {
  const _EmailVerifiedSuccessScreen();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.screenPadding,
          child: Column(
            children: [
              const Spacer(flex: 2),
              Image.asset(
                'assets/images/success_person_check.png',
                width: 190,
                height: 190,
                fit: BoxFit.contain,
                filterQuality: FilterQuality.high,
              ).animate().fadeIn(duration: 240.ms).scale(
                    begin: const Offset(0.92, 0.92),
                    end: const Offset(1, 1),
                    curve: Curves.easeOutBack,
                  ),
              const Spacer(),
              const Text(
                'Email Verified Successfully',
                textAlign: TextAlign.center,
                style: AppTypography.h2,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Click continue below to proceed',
                textAlign: TextAlign.center,
                style: AppTypography.body.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const Spacer(flex: 2),
              PPrimaryButton(
                label: 'Done',
                onPressed: () {
                  final auth = ref.read(authProvider).valueOrNull;
                  if (auth is AuthAuthenticated && auth.hasActiveStrategy) {
                    context.go(Routes.home);
                  } else {
                    context.go(Routes.riskAppetite);
                  }
                },
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }
}
