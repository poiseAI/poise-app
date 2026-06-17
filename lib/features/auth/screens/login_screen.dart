import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/buttons/p_primary_button.dart';
import '../../../core/widgets/inputs/p_text_field.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();

  PButtonState _buttonState = PButtonState.idle;
  PFieldState _emailState = PFieldState.idle;
  PFieldState _passwordState = PFieldState.idle;
  String? _emailError;
  String? _passwordError;
  String? _errorMessage;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  bool _validateEmail(String val) {
    final ok = RegExp(r'^[\w.+-]+@[\w-]+\.[a-zA-Z]{2,}$').hasMatch(val);
    setState(() {
      _emailState = ok ? PFieldState.valid : PFieldState.error;
      _emailError = ok ? null : 'Enter a valid email address';
    });
    return ok;
  }

  bool _validatePassword(String val) {
    final ok = val.isNotEmpty;
    setState(() {
      _passwordState = ok ? PFieldState.valid : PFieldState.error;
      _passwordError = ok ? null : 'Password is required';
    });
    return ok;
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    final emailOk = _validateEmail(_emailCtrl.text.trim());
    final passOk = _validatePassword(_passwordCtrl.text);
    if (!emailOk || !passOk) return;

    setState(() {
      _buttonState = PButtonState.loading;
      _errorMessage = null;
    });

    final result = await ref.read(authProvider.notifier).login(
          _emailCtrl.text.trim(),
          _passwordCtrl.text,
        );

    if (!mounted) return;

    result.fold(
      onOk: (_) {
        setState(() => _buttonState = PButtonState.success);
      },
      onErr: (e) {
        setState(() {
          _buttonState = PButtonState.idle;
          _errorMessage = e;
        });
      },
    );
  }

  void _goBack() {
    if (context.canPop()) {
      context.pop();
      return;
    }
    context.go(Routes.welcomeBack);
  }

  @override
  Widget build(BuildContext context) {
    final canSubmit = _emailCtrl.text.trim().isNotEmpty &&
        _passwordCtrl.text.isNotEmpty;

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(
        toolbarHeight: 48,
        backgroundColor: AppColors.bgPrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: _goBack,
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _PoiseWordmark(),
                    const SizedBox(height: 28),
                    Text(
                      'Welcome back',
                      style: AppTypography.h2.copyWith(
                        fontFamily: 'Orbitron',
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        height: 1.2,
                        letterSpacing: 0,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Log into your Poise account to access your dashboard and trading tools',
                      style: AppTypography.bodySm.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    if (_errorMessage != null) ...[
                      const SizedBox(height: 14),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 13,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.lossRedBg,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: AppColors.lossRed.withValues(alpha: 0.22),
                          ),
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
                                _errorMessage!,
                                style: AppTypography.bodySm.copyWith(
                                  color: AppColors.lossRed,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                    ] else ...[
                      const SizedBox(height: 22),
                    ],
                    PTextField(
                      controller: _emailCtrl,
                      focusNode: _emailFocus,
                      label: 'Email',
                      hint: 'you@email.com',
                      showLabelAbove: true,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      fieldState: _emailState,
                      errorText: _emailError,
                      compact: true,
                      showValidationIcon: false,
                      onChanged: (val) {
                        setState(() {
                          if (_errorMessage != null) _errorMessage = null;
                        });
                        if (_emailState != PFieldState.idle) _validateEmail(val);
                      },
                      onEditingComplete: () => _passwordFocus.requestFocus(),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    PTextField(
                      controller: _passwordCtrl,
                      focusNode: _passwordFocus,
                      label: 'Password',
                      hint: 'Enter your password',
                      showLabelAbove: true,
                      obscureText: true,
                      textInputAction: TextInputAction.done,
                      fieldState: _passwordState,
                      errorText: _passwordError,
                      compact: true,
                      showObscureToggle: true,
                      showValidationIcon: false,
                      onChanged: (val) {
                        setState(() {
                          if (_errorMessage != null) _errorMessage = null;
                        });
                        if (_passwordState != PFieldState.idle) {
                          _validatePassword(val);
                        }
                      },
                      onEditingComplete: _submit,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    TextButton(
                      onPressed: () => context.push(Routes.forgotPassword),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        'Forgot password?',
                        style: AppTypography.buttonSm.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
              child: PPrimaryButton(
                label: 'Login',
                state: _buttonState,
                onPressed: canSubmit ? _submit : null,
                height: 44,
                borderRadius: BorderRadius.circular(22),
                textStyle: AppTypography.button,
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    "Don't have an account?",
                    style: AppTypography.bodySm.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextButton(
                    onPressed: () => context.go(Routes.register),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.only(left: 4),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      'Sign up',
                      style: AppTypography.bodySm.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _PoiseWordmark extends StatelessWidget {
  const _PoiseWordmark();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(
          width: 18,
          height: 22,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _LogoBar(height: 12),
              SizedBox(width: 2),
              _LogoBar(height: 18),
              SizedBox(width: 2),
              _LogoBar(height: 14),
            ],
          ),
        ),
        const SizedBox(width: 5),
        Text(
          'poise',
          style: AppTypography.h2.copyWith(
            color: AppColors.primary,
            fontFamily: 'Orbitron',
            fontWeight: FontWeight.w700,
            fontSize: 20,
            height: 1,
            letterSpacing: 0,
          ),
        ),
      ],
    );
  }
}

class _LogoBar extends StatelessWidget {
  const _LogoBar({required this.height});

  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 4,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(1),
      ),
    );
  }
}
