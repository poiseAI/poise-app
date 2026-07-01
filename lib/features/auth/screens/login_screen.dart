import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/brand/poise_wordmark.dart';
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

  @override
  Widget build(BuildContext context) {
    final canSubmit =
        _emailCtrl.text.trim().isNotEmpty && _passwordCtrl.text.isNotEmpty;

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 390),
          child: Stack(
            children: [
              const Positioned(
                key: ValueKey('login-wordmark'),
                left: 24,
                top: 82,
                child: PoiseWordmark(),
              ),
              const Positioned(
                key: ValueKey('login-content'),
                left: 24,
                right: 24,
                top: 162,
                child: _LoginIntro(),
              ),
              if (_errorMessage != null)
                Positioned(
                  key: const ValueKey('login-error-alert'),
                  left: 24,
                  right: 23,
                  top: 262,
                  child: _LoginErrorAlert(message: _errorMessage!),
                ),
              Positioned(
                left: 24,
                right: 24,
                top: _errorMessage == null ? 266 : 334,
                child: _LoginForm(
                  emailCtrl: _emailCtrl,
                  passwordCtrl: _passwordCtrl,
                  emailFocus: _emailFocus,
                  passwordFocus: _passwordFocus,
                  emailState: _emailState,
                  passwordState: _passwordState,
                  emailError: _emailError,
                  passwordError: _passwordError,
                  onEmailChanged: (val) {
                    setState(() {
                      if (_errorMessage != null) _errorMessage = null;
                    });
                    if (_emailState != PFieldState.idle) _validateEmail(val);
                  },
                  onPasswordChanged: (val) {
                    setState(() {
                      if (_errorMessage != null) _errorMessage = null;
                    });
                    if (_passwordState != PFieldState.idle) {
                      _validatePassword(val);
                    }
                  },
                  onEmailComplete: () => _passwordFocus.requestFocus(),
                  onPasswordComplete: _submit,
                ),
              ),
              Positioned(
                left: 24,
                top: _errorMessage == null ? 454 : 522,
                child: _ForgotPasswordLink(
                  onPressed: () => context.push(Routes.forgotPassword),
                ),
              ),
              Positioned(
                key: const ValueKey('login-bottom-actions'),
                left: 24,
                right: 24,
                top: 728,
                child: _LoginActions(
                  canSubmit: canSubmit,
                  buttonState: _buttonState,
                  onSubmit: _submit,
                  onRegister: () => context.go(Routes.register),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoginIntro extends StatelessWidget {
  const _LoginIntro();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome back',
            style: AppTypography.h2.copyWith(
              fontFamily: 'Orbitron',
              fontSize: 24,
              fontWeight: FontWeight.w700,
              height: 1.33,
              letterSpacing: 0,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Log into your Poise account to access your dashboard and trading tools',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.bodySm.copyWith(
              color: AppColors.textSecondary,
              height: 1.67,
              letterSpacing: 0,
            ),
          ),
        ],
      ),
    );
  }
}

class _LoginErrorAlert extends StatelessWidget {
  const _LoginErrorAlert({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      width: double.infinity,
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

class _LoginForm extends StatelessWidget {
  const _LoginForm({
    required this.emailCtrl,
    required this.passwordCtrl,
    required this.emailFocus,
    required this.passwordFocus,
    required this.emailState,
    required this.passwordState,
    required this.emailError,
    required this.passwordError,
    required this.onEmailChanged,
    required this.onPasswordChanged,
    required this.onEmailComplete,
    required this.onPasswordComplete,
  });

  final TextEditingController emailCtrl;
  final TextEditingController passwordCtrl;
  final FocusNode emailFocus;
  final FocusNode passwordFocus;
  final PFieldState emailState;
  final PFieldState passwordState;
  final String? emailError;
  final String? passwordError;
  final ValueChanged<String> onEmailChanged;
  final ValueChanged<String> onPasswordChanged;
  final VoidCallback onEmailComplete;
  final VoidCallback onPasswordComplete;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PTextField(
          controller: emailCtrl,
          focusNode: emailFocus,
          label: 'Email',
          hint: 'you@email.com',
          showLabelAbove: true,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          fieldState: emailState,
          errorText: emailError,
          compact: true,
          showValidationIcon: false,
          onChanged: onEmailChanged,
          onEditingComplete: onEmailComplete,
        ),
        const SizedBox(height: 20),
        PTextField(
          controller: passwordCtrl,
          focusNode: passwordFocus,
          label: 'Password',
          hint: 'Enter your password',
          showLabelAbove: true,
          obscureText: true,
          textInputAction: TextInputAction.done,
          fieldState: passwordState,
          errorText: passwordError,
          compact: true,
          showObscureToggle: true,
          showValidationIcon: false,
          onChanged: onPasswordChanged,
          onEditingComplete: onPasswordComplete,
        ),
      ],
    );
  }
}

class _ForgotPasswordLink extends StatelessWidget {
  const _ForgotPasswordLink({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
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
          height: 1.67,
        ),
      ),
    );
  }
}

class _LoginActions extends StatelessWidget {
  const _LoginActions({
    required this.canSubmit,
    required this.buttonState,
    required this.onSubmit,
    required this.onRegister,
  });

  final bool canSubmit;
  final PButtonState buttonState;
  final VoidCallback onSubmit;
  final VoidCallback onRegister;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PPrimaryButton(
          label: 'Login',
          state: buttonState,
          onPressed: canSubmit ? onSubmit : null,
          height: 48,
          borderRadius: BorderRadius.circular(24),
          textStyle: AppTypography.button,
        ),
        const SizedBox(height: 12),
        Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(
              "Don't have an account?",
              style: AppTypography.bodySm.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
                height: 1.67,
              ),
            ),
            TextButton(
              onPressed: onRegister,
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
                  height: 1.67,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
