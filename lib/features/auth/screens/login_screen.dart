import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/buttons/p_primary_button.dart';
import '../../../core/widgets/feedback/p_toast.dart';
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
  final _totpCtrl = TextEditingController();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _totpFocus = FocusNode();

  PButtonState _buttonState = PButtonState.idle;
  PFieldState _emailState = PFieldState.idle;
  PFieldState _passwordState = PFieldState.idle;
  String? _emailError;
  String? _passwordError;
  bool _showTotp = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _totpCtrl.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _totpFocus.dispose();
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
    final emailOk = _validateEmail(_emailCtrl.text.trim());
    final passOk = _validatePassword(_passwordCtrl.text);
    if (!emailOk || !passOk) return;

    setState(() => _buttonState = PButtonState.loading);

    final result = await ref.read(authProvider.notifier).login(
          _emailCtrl.text.trim(),
          _passwordCtrl.text,
          totpToken:
              _showTotp && _totpCtrl.text.length == 6 ? _totpCtrl.text : null,
        );

    if (!mounted) return;

    result.fold(
      onOk: (_) {
        setState(() => _buttonState = PButtonState.success);
        // Router handles redirect based on auth state
      },
      onErr: (e) {
        final msg = e.toLowerCase();
        if (msg.contains('totp') ||
            msg.contains('2fa') ||
            msg.contains('authenticator') ||
            msg.contains('one-time')) {
          setState(() {
            _buttonState = PButtonState.idle;
            _showTotp = true;
          });
          Future.delayed(const Duration(milliseconds: 100), () {
            if (mounted) _totpFocus.requestFocus();
          });
          return;
        }
        setState(() => _buttonState = PButtonState.error);
        PToast.error(context, e);
        Future.delayed(const Duration(milliseconds: 400), () {
          if (mounted) setState(() => _buttonState = PButtonState.idle);
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            padding: AppSpacing.screenPadding,
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: constraints.maxHeight * 0.10),
                  const Center(child: _PoiseMark()),
                  const SizedBox(height: AppSpacing.xl),
                  const Text('Welcome back', style: AppTypography.h1),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'Sign in to keep every trade inside your plan.',
                    style: AppTypography.bodyLg
                        .copyWith(color: AppColors.textSecondary),
                  ),
                  SizedBox(
                      height: constraints.maxHeight > 720
                          ? AppSpacing.xxl
                          : AppSpacing.xl),
                  PTextField(
                    controller: _emailCtrl,
                    focusNode: _emailFocus,
                    label: 'Email address',
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    fieldState: _emailState,
                    errorText: _emailError,
                    autofocus: true,
                    onChanged: (val) {
                      if (_emailState != PFieldState.idle) {
                        _validateEmail(val);
                      }
                    },
                    onEditingComplete: () => _passwordFocus.requestFocus(),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  PTextField(
                    controller: _passwordCtrl,
                    focusNode: _passwordFocus,
                    label: 'Password',
                    obscureText: true,
                    textInputAction:
                        _showTotp ? TextInputAction.next : TextInputAction.done,
                    fieldState: _passwordState,
                    errorText: _passwordError,
                    onChanged: (val) {
                      if (_passwordState != PFieldState.idle) {
                        _validatePassword(val);
                      }
                    },
                    onEditingComplete:
                        _showTotp ? () => _totpFocus.requestFocus() : _submit,
                  ),
                  if (_showTotp) ...[
                    const SizedBox(height: AppSpacing.md),
                    PTextField(
                      controller: _totpCtrl,
                      focusNode: _totpFocus,
                      label: '2FA code',
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                      onEditingComplete: _submit,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'Enter the 6-digit code from your authenticator app.',
                      style: AppTypography.bodySm
                          .copyWith(color: AppColors.textSecondary),
                    ),
                  ],
                  const SizedBox(height: AppSpacing.sm),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => context.push(Routes.forgotPassword),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        'Forgot password?',
                        style: AppTypography.bodySm
                            .copyWith(color: AppColors.primary),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  PPrimaryButton(
                    label: 'Log in',
                    state: _buttonState,
                    onPressed: _submit,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Center(
                    child: TextButton(
                      onPressed: () => context.go(Routes.register),
                      child: Text(
                        "Don't have an account? Sign up",
                        style: AppTypography.body
                            .copyWith(color: AppColors.textSecondary),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PoiseMark extends StatelessWidget {
  const _PoiseMark();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 82,
      height: 82,
      decoration: BoxDecoration(
        color: AppColors.brand500,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.brand500.withValues(alpha: 0.18),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(
            Icons.shield_rounded,
            size: 46,
            color: Colors.white.withValues(alpha: 0.96),
          ),
          const Icon(
            Icons.show_chart_rounded,
            size: 24,
            color: AppColors.brand500,
          ),
        ],
      ),
    );
  }
}
