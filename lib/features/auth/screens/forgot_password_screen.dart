import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/buttons/p_primary_button.dart';
import '../../../core/widgets/inputs/p_text_field.dart';
import '../data/auth_api.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _emailCtrl = TextEditingController();
  PButtonState _buttonState = PButtonState.idle;
  PFieldState _emailState = PFieldState.idle;
  String? _emailError;
  String? _errorMessage;

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  bool _validate() {
    final ok = RegExp(r'^[\w.+-]+@[\w-]+\.[a-zA-Z]{2,}$')
        .hasMatch(_emailCtrl.text.trim());
    setState(() {
      _emailState = ok ? PFieldState.valid : PFieldState.error;
      _emailError = ok ? null : 'Enter a valid email address';
    });
    return ok;
  }

  Future<void> _submit() async {
    if (!_validate()) return;
    setState(() {
      _buttonState = PButtonState.loading;
      _errorMessage = null;
    });

    final result =
        await ref.read(authApiProvider).forgotPassword(_emailCtrl.text.trim());

    if (!mounted) return;

    result.fold(
      onOk: (_) {
        setState(() => _buttonState = PButtonState.success);
        Future.delayed(const Duration(milliseconds: 400), () {
          if (mounted) {
            context.push(
              Routes.resetPassword,
              extra: _emailCtrl.text.trim(),
            );
            setState(() => _buttonState = PButtonState.idle);
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

  void _goBack() {
    if (context.canPop()) {
      context.pop();
      return;
    }
    context.go(Routes.login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 390),
          child: Stack(
            children: [
              Positioned(
                key: const ValueKey('forgot-back-button'),
                left: 22,
                top: 66,
                child: _BackGlyph(onPressed: _goBack),
              ),
              Positioned(
                key: const ValueKey('forgot-content'),
                left: 24,
                top: 134,
                child: SizedBox(
                  width: 342,
                  height: 194,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _ForgotIntro(),
                      const SizedBox(height: 40),
                      PTextField(
                        controller: _emailCtrl,
                        label: 'Email address',
                        hint: 'Enter email',
                        showLabelAbove: true,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.done,
                        fieldState: _emailState,
                        errorText: _emailError,
                        autofocus: true,
                        compact: true,
                        showValidationIcon: false,
                        onChanged: (val) {
                          if (_errorMessage != null) {
                            setState(() => _errorMessage = null);
                          }
                          if (_emailState != PFieldState.idle) _validate();
                        },
                        onEditingComplete: _submit,
                      ),
                    ],
                  ),
                ),
              ),
              if (_errorMessage != null)
                Positioned(
                  left: 24,
                  top: 342,
                  right: 24,
                  child: _ForgotError(message: _errorMessage!),
                ),
              Positioned(
                key: const ValueKey('forgot-bottom-actions'),
                left: 24,
                right: 24,
                top: 728,
                child: _ForgotActions(
                  buttonState: _buttonState,
                  onSubmit: _submit,
                  onLogin: () => context.go(Routes.login),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BackGlyph extends StatelessWidget {
  const _BackGlyph({required this.onPressed});

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

class _ForgotIntro extends StatelessWidget {
  const _ForgotIntro();

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
                'Reset your password',
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
              height: 40,
              child: Text(
                'Enter the email linked to your account and we\'ll send you a code to reset your password.',
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

class _ForgotActions extends StatelessWidget {
  const _ForgotActions({
    required this.buttonState,
    required this.onSubmit,
    required this.onLogin,
  });

  final PButtonState buttonState;
  final VoidCallback onSubmit;
  final VoidCallback onLogin;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: Column(
        children: [
          PPrimaryButton(
            label: 'Send code',
            state: buttonState,
            onPressed: onSubmit,
            height: 48,
            borderRadius: BorderRadius.circular(24),
            textStyle: AppTypography.button,
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: onLogin,
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: const Size(95, 20),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              'Back to Log in',
              style: AppTypography.bodySm.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
                height: 1.67,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ForgotError extends StatelessWidget {
  const _ForgotError({required this.message});

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
