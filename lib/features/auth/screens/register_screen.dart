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
  void dispose() {
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
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const PoiseWordmark(),
                    const SizedBox(height: 38),
                    Text(
                      'Create your account',
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
                      'Start your 14-day free trial. No credit card required',
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
                      controller: _nameCtrl,
                      focusNode: _nameFocus,
                      label: 'Your name',
                      hint: 'Olaide Gbeyide',
                      showLabelAbove: true,
                      textInputAction: TextInputAction.next,
                      fieldState: _nameState,
                      errorText: _nameError,
                      compact: true,
                      showValidationIcon: false,
                      onChanged: (val) {
                        setState(() {
                          if (_errorMessage != null) _errorMessage = null;
                        });
                        if (_nameState != PFieldState.idle) _validateName(val);
                      },
                      onEditingComplete: () => _emailFocus.requestFocus(),
                    ),
                    const SizedBox(height: 14),
                    PTextField(
                      controller: _emailCtrl,
                      focusNode: _emailFocus,
                      label: 'Email address',
                      hint: 'olaide@poise.com',
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
                        if (_emailState != PFieldState.idle) {
                          _validateEmail(val);
                        }
                      },
                      onEditingComplete: () => _passwordFocus.requestFocus(),
                    ),
                    const SizedBox(height: 14),
                    PTextField(
                      controller: _passwordCtrl,
                      focusNode: _passwordFocus,
                      label: 'Create password',
                      hint: 'Enter password',
                      showLabelAbove: true,
                      obscureText: true,
                      textInputAction: TextInputAction.next,
                      fieldState: _passwordState,
                      errorText: _passwordError,
                      compact: true,
                      showValidationIcon: false,
                      onChanged: (val) {
                        final passwordState = val.isEmpty
                            ? PFieldState.idle
                            : PasswordRequirements.isValid(val)
                                ? PFieldState.valid
                                : PFieldState.error;
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
                      },
                      onEditingComplete: () => _confirmFocus.requestFocus(),
                    ),
                    const SizedBox(height: 8),
                    PasswordRequirements(password: _passwordCtrl.text),
                    const SizedBox(height: 14),
                    PTextField(
                      controller: _confirmCtrl,
                      focusNode: _confirmFocus,
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
                      onEditingComplete: _submit,
                    ),
                    const Spacer(),
                    const SizedBox(height: 28),
                    PPrimaryButton(
                      label: 'Continue',
                      state: _buttonState,
                      onPressed: _canSubmit ? _submit : null,
                      height: 44,
                      borderRadius: BorderRadius.circular(22),
                      textStyle: AppTypography.button,
                    ),
                    const SizedBox(height: 12),
                    Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Already have an account?',
                            style: AppTypography.bodySm.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          TextButton(
                            onPressed: () => context.go(Routes.login),
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.only(left: 4),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Text(
                              'Log in',
                              style: AppTypography.bodySm.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
