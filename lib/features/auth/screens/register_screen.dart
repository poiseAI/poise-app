import 'dart:async';
import 'dart:math' as math;

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
import '../widgets/password_requirements.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  final _nameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _confirmFocus = FocusNode();
  Timer? _passwordValidationTimer;

  PButtonState _buttonState = PButtonState.idle;
  PFieldState _nameState = PFieldState.idle;
  PFieldState _emailState = PFieldState.idle;
  PFieldState _passwordState = PFieldState.idle;
  PFieldState _confirmState = PFieldState.idle;
  String? _nameError;
  String? _emailError;
  String? _passwordError;
  String? _confirmError;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _emailFocus.addListener(_handleEmailFocusChanged);
    _passwordFocus.addListener(_handlePasswordFocusChanged);
  }

  @override
  void dispose() {
    _passwordValidationTimer?.cancel();
    _emailFocus.removeListener(_handleEmailFocusChanged);
    _passwordFocus.removeListener(_handlePasswordFocusChanged);
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    _nameFocus.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _confirmFocus.dispose();
    super.dispose();
  }

  void _handlePasswordFocusChanged() {
    if (!_passwordFocus.hasFocus &&
        _passwordCtrl.text.isNotEmpty &&
        !PasswordRequirements.isValid(_passwordCtrl.text)) {
      _passwordValidationTimer?.cancel();
      _validatePassword(_passwordCtrl.text);
      return;
    }
    if (mounted) setState(() {});
  }

  void _handleEmailFocusChanged() {
    if (!_emailFocus.hasFocus && _emailCtrl.text.trim().isNotEmpty) {
      _validateEmail(_emailCtrl.text.trim());
    }
  }

  bool _isNameValidValue(String val) {
    return val.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty).length >=
        2;
  }

  bool _isEmailValidValue(String val) {
    return RegExp(r'^[\w.+-]+@[\w-]+\.[a-zA-Z]{2,}$').hasMatch(val);
  }

  bool _isConfirmValidValue(String val) {
    return val.isNotEmpty && val == _passwordCtrl.text;
  }

  bool get _canSubmit =>
      _isNameValidValue(_nameCtrl.text) &&
      _isEmailValidValue(_emailCtrl.text.trim()) &&
      PasswordRequirements.isValid(_passwordCtrl.text) &&
      _isConfirmValidValue(_confirmCtrl.text);

  bool _validateName(String val) {
    final ok = _isNameValidValue(val);
    setState(() {
      _nameState = ok ? PFieldState.valid : PFieldState.error;
      _nameError = ok ? null : 'Enter your first and last name';
    });
    return ok;
  }

  bool _validateEmail(String val) {
    final ok = _isEmailValidValue(val);
    setState(() {
      _emailState = ok ? PFieldState.valid : PFieldState.error;
      _emailError = ok ? null : 'Enter a valid email address';
    });
    return ok;
  }

  bool _validatePassword(String val) {
    _passwordValidationTimer?.cancel();
    final ok = PasswordRequirements.isValid(val);
    setState(() {
      _passwordState = ok ? PFieldState.valid : PFieldState.error;
      _passwordError = ok ? null : 'Password does not meet all requirements';
    });
    return ok;
  }

  bool _validateConfirm(String val) {
    final ok = _isConfirmValidValue(val);
    setState(() {
      _confirmState = ok ? PFieldState.valid : PFieldState.error;
      _confirmError = ok ? null : 'Passwords do not match';
    });
    return ok;
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    final nameOk = _validateName(_nameCtrl.text);
    final emailOk = _validateEmail(_emailCtrl.text.trim());
    final passOk = _validatePassword(_passwordCtrl.text);
    final confirmOk = _validateConfirm(_confirmCtrl.text);
    if (!nameOk || !emailOk || !passOk || !confirmOk) return;

    setState(() {
      _buttonState = PButtonState.loading;
      _errorMessage = null;
    });

    final result = await ref.read(authProvider.notifier).register(
          _nameCtrl.text.trim(),
          _emailCtrl.text.trim(),
          _passwordCtrl.text,
        );

    if (!mounted) return;

    result.fold(
      onOk: (_) {
        setState(() => _buttonState = PButtonState.success);
        // Router redirect handles navigation once auth state emits
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
    final showPasswordRequirements =
        _passwordCtrl.text.isNotEmpty || _passwordFocus.hasFocus;

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: LayoutBuilder(
        builder: (context, constraints) {
          const designHeight = 844.0;
          final viewportHeight = constraints.maxHeight;
          final viewportWidth = math.min(390.0, constraints.maxWidth);
          final canvasHeight = math.max(designHeight, viewportHeight);
          final hasServerError = _errorMessage != null;

          return Center(
            child: SizedBox(
              width: viewportWidth,
              height: viewportHeight,
              child: SingleChildScrollView(
                physics: viewportHeight >= designHeight
                    ? const NeverScrollableScrollPhysics()
                    : const ClampingScrollPhysics(),
                child: SizedBox(
                  height: canvasHeight,
                  child: Stack(
                    children: [
                      const Positioned(
                        key: ValueKey('register-wordmark'),
                        left: 24,
                        top: 82,
                        child: PoiseWordmark(),
                      ),
                      const Positioned(
                        key: ValueKey('register-content'),
                        left: 24,
                        right: 24,
                        top: 156,
                        child: _RegisterIntro(),
                      ),
                      if (hasServerError)
                        Positioned(
                          key: const ValueKey('register-error-alert'),
                          left: 24,
                          right: 24,
                          top: 224,
                          child: _RegisterErrorAlert(message: _errorMessage!),
                        ),
                      Positioned(
                        left: 24,
                        right: 24,
                        top: hasServerError ? 304 : 240,
                        child: _RegisterForm(
                          nameCtrl: _nameCtrl,
                          emailCtrl: _emailCtrl,
                          passwordCtrl: _passwordCtrl,
                          confirmCtrl: _confirmCtrl,
                          nameFocus: _nameFocus,
                          emailFocus: _emailFocus,
                          passwordFocus: _passwordFocus,
                          confirmFocus: _confirmFocus,
                          nameState: _nameState,
                          emailState: _emailState,
                          passwordState: _passwordState,
                          confirmState: _confirmState,
                          nameError: _nameError,
                          emailError: _emailError,
                          passwordError: _passwordError,
                          confirmError: _confirmError,
                          showPasswordRequirements: showPasswordRequirements,
                          onNameChanged: (val) {
                            setState(() {
                              if (_errorMessage != null) _errorMessage = null;
                            });
                            if (_nameState != PFieldState.idle) {
                              _validateName(val);
                            }
                          },
                          onEmailChanged: (val) {
                            setState(() {
                              if (_errorMessage != null) _errorMessage = null;
                            });
                            if (_emailState != PFieldState.idle) {
                              _validateEmail(val);
                            }
                          },
                          onPasswordChanged: (val) {
                            _passwordValidationTimer?.cancel();
                            final passwordValid =
                                PasswordRequirements.isValid(val);
                            final passwordState = val.isEmpty
                                ? PFieldState.idle
                                : passwordValid
                                    ? PFieldState.valid
                                    : PFieldState.idle;
                            final confirmState = _confirmCtrl.text.isEmpty
                                ? PFieldState.idle
                                : _isConfirmValidValue(_confirmCtrl.text)
                                    ? PFieldState.valid
                                    : PFieldState.error;
                            setState(() {
                              _errorMessage = null;
                              _passwordState = passwordState;
                              _passwordError = null;
                              _confirmState = confirmState;
                              _confirmError = confirmState == PFieldState.error
                                  ? 'Passwords do not match'
                                  : null;
                            });
                            if (val.isNotEmpty && !passwordValid) {
                              _passwordValidationTimer =
                                  Timer(const Duration(seconds: 2), () {
                                if (!mounted) return;
                                _validatePassword(_passwordCtrl.text);
                              });
                            }
                          },
                          onConfirmChanged: (val) {
                            final confirmState = val.isEmpty
                                ? PFieldState.idle
                                : _isConfirmValidValue(val)
                                    ? PFieldState.valid
                                    : PFieldState.error;
                            setState(() {
                              _errorMessage = null;
                              _confirmState = confirmState;
                              _confirmError = confirmState == PFieldState.error
                                  ? 'Passwords do not match'
                                  : null;
                            });
                          },
                          onNameComplete: () => _emailFocus.requestFocus(),
                          onEmailComplete: () => _passwordFocus.requestFocus(),
                          onPasswordComplete: () =>
                              _confirmFocus.requestFocus(),
                          onConfirmComplete: _submit,
                        ),
                      ),
                      Positioned(
                        key: const ValueKey('register-bottom-actions'),
                        left: 16,
                        right: 16,
                        top: 724,
                        child: _RegisterActions(
                          canSubmit: _canSubmit,
                          buttonState: _buttonState,
                          onSubmit: _submit,
                          onLogin: () => context.go(Routes.login),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _RegisterIntro extends StatelessWidget {
  const _RegisterIntro();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Create your account',
          style: AppTypography.h2.copyWith(
            fontFamily: 'Orbitron',
            fontSize: 24,
            fontWeight: FontWeight.w700,
            height: 1.33,
            letterSpacing: 0,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Start your 14-day free trial. No credit card required',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTypography.body.copyWith(
            color: AppColors.textSecondary,
            height: 20 / 14,
          ),
        ),
      ],
    );
  }
}

class _RegisterErrorAlert extends StatelessWidget {
  const _RegisterErrorAlert({required this.message});

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

class _RegisterForm extends StatelessWidget {
  const _RegisterForm({
    required this.nameCtrl,
    required this.emailCtrl,
    required this.passwordCtrl,
    required this.confirmCtrl,
    required this.nameFocus,
    required this.emailFocus,
    required this.passwordFocus,
    required this.confirmFocus,
    required this.nameState,
    required this.emailState,
    required this.passwordState,
    required this.confirmState,
    required this.nameError,
    required this.emailError,
    required this.passwordError,
    required this.confirmError,
    required this.showPasswordRequirements,
    required this.onNameChanged,
    required this.onEmailChanged,
    required this.onPasswordChanged,
    required this.onConfirmChanged,
    required this.onNameComplete,
    required this.onEmailComplete,
    required this.onPasswordComplete,
    required this.onConfirmComplete,
  });

  final TextEditingController nameCtrl;
  final TextEditingController emailCtrl;
  final TextEditingController passwordCtrl;
  final TextEditingController confirmCtrl;
  final FocusNode nameFocus;
  final FocusNode emailFocus;
  final FocusNode passwordFocus;
  final FocusNode confirmFocus;
  final PFieldState nameState;
  final PFieldState emailState;
  final PFieldState passwordState;
  final PFieldState confirmState;
  final String? nameError;
  final String? emailError;
  final String? passwordError;
  final String? confirmError;
  final bool showPasswordRequirements;
  final ValueChanged<String> onNameChanged;
  final ValueChanged<String> onEmailChanged;
  final ValueChanged<String> onPasswordChanged;
  final ValueChanged<String> onConfirmChanged;
  final VoidCallback onNameComplete;
  final VoidCallback onEmailComplete;
  final VoidCallback onPasswordComplete;
  final VoidCallback onConfirmComplete;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PTextField(
          controller: nameCtrl,
          focusNode: nameFocus,
          label: 'Your name',
          hint: 'Your name',
          showLabelAbove: true,
          textInputAction: TextInputAction.next,
          fieldState: nameState,
          errorText: nameError,
          compact: true,
          showValidationIcon: false,
          onChanged: onNameChanged,
          onEditingComplete: onNameComplete,
        ),
        const SizedBox(height: 20),
        PTextField(
          controller: emailCtrl,
          focusNode: emailFocus,
          label: 'Email address',
          hint: 'Email address',
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
          label: 'Create password',
          hint: 'Enter password',
          showLabelAbove: true,
          obscureText: true,
          textInputAction: TextInputAction.next,
          fieldState: passwordState,
          errorText: passwordError,
          compact: true,
          showValidationIcon: false,
          onChanged: onPasswordChanged,
          onEditingComplete: onPasswordComplete,
        ),
        SizedBox(height: showPasswordRequirements ? 12 : 20),
        if (showPasswordRequirements) ...[
          PasswordRequirements(password: passwordCtrl.text),
          const SizedBox(height: 20),
        ],
        PTextField(
          controller: confirmCtrl,
          focusNode: confirmFocus,
          label: 'Confirm password',
          hint: 'Repeat password',
          showLabelAbove: true,
          obscureText: true,
          textInputAction: TextInputAction.done,
          fieldState: confirmState,
          errorText: confirmError,
          compact: true,
          showValidationIcon: false,
          onChanged: onConfirmChanged,
          onEditingComplete: onConfirmComplete,
        ),
      ],
    );
  }
}

class _RegisterActions extends StatelessWidget {
  const _RegisterActions({
    required this.canSubmit,
    required this.buttonState,
    required this.onSubmit,
    required this.onLogin,
  });

  final bool canSubmit;
  final PButtonState buttonState;
  final VoidCallback onSubmit;
  final VoidCallback onLogin;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 342,
          child: PPrimaryButton(
            label: 'Continue',
            state: buttonState,
            onPressed: canSubmit ? onSubmit : null,
            height: 48,
            borderRadius: BorderRadius.circular(24),
            textStyle: AppTypography.buttonLg,
            disabledLabelColor: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          key: const ValueKey('register-auth-switch'),
          width: 358,
          height: 20,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onLogin,
            child: Center(
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Already have an account? ',
                      style: AppTypography.body.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w500,
                        height: 20 / 14,
                      ),
                    ),
                    TextSpan(
                      text: 'Log in',
                      style: AppTypography.body.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                        height: 20 / 14,
                      ),
                    ),
                  ],
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: AppTypography.body.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w500,
                  height: 20 / 14,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
