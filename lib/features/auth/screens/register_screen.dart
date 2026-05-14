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

  bool _validateName(String val) {
    final ok =
        val.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty).length >= 2;
    setState(() {
      _nameState = ok ? PFieldState.valid : PFieldState.error;
      _nameError = ok ? null : 'Enter your first and last name';
    });
    return ok;
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
    final ok = PasswordRequirements.isValid(val);
    setState(() {
      _passwordState = ok ? PFieldState.valid : PFieldState.error;
      _passwordError = ok ? null : 'Password does not meet all requirements';
    });
    return ok;
  }

  bool _validateConfirm(String val) {
    final ok = val == _passwordCtrl.text;
    setState(() {
      _confirmState = ok ? PFieldState.valid : PFieldState.error;
      _confirmError = ok ? null : 'Passwords do not match';
    });
    return ok;
  }

  Future<void> _submit() async {
    final nameOk = _validateName(_nameCtrl.text);
    final emailOk = _validateEmail(_emailCtrl.text.trim());
    final passOk = _validatePassword(_passwordCtrl.text);
    final confirmOk = _validateConfirm(_confirmCtrl.text);
    if (!nameOk || !emailOk || !passOk || !confirmOk) return;

    setState(() => _buttonState = PButtonState.loading);

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
        setState(() => _buttonState = PButtonState.error);
        PToast.error(context, e);
        Future.delayed(const Duration(milliseconds: 400), () {
          if (mounted) setState(() => _buttonState = PButtonState.idle);
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
      appBar: AppBar(
        title: const Text('Sign up'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: _goBack,
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
                  const SizedBox(height: AppSpacing.md),
                  const Text('Enter Details', style: AppTypography.h2),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'Enter your details to create an account.',
                    style: AppTypography.body
                        .copyWith(color: AppColors.textSecondary),
                  ),
                  SizedBox(
                      height: constraints.maxHeight > 720
                          ? AppSpacing.xxl
                          : AppSpacing.lg),
                  PTextField(
                    controller: _nameCtrl,
                    focusNode: _nameFocus,
                    label: 'Your name',
                    textInputAction: TextInputAction.next,
                    fieldState: _nameState,
                    errorText: _nameError,
                    autofocus: true,
                    onChanged: (val) {
                      if (_nameState != PFieldState.idle) _validateName(val);
                    },
                    onEditingComplete: () => _emailFocus.requestFocus(),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  PTextField(
                    controller: _emailCtrl,
                    focusNode: _emailFocus,
                    label: 'Email address',
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    fieldState: _emailState,
                    errorText: _emailError,
                    onChanged: (val) {
                      if (_emailState != PFieldState.idle) _validateEmail(val);
                    },
                    onEditingComplete: () => _passwordFocus.requestFocus(),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  PTextField(
                    controller: _passwordCtrl,
                    focusNode: _passwordFocus,
                    label: 'Create password',
                    obscureText: true,
                    textInputAction: TextInputAction.next,
                    fieldState: _passwordState,
                    errorText: _passwordError,
                    onChanged: (val) {
                      setState(() {});
                      if (_passwordState != PFieldState.idle) {
                        _validatePassword(val);
                      }
                      if (_confirmState != PFieldState.idle) {
                        _validateConfirm(_confirmCtrl.text);
                      }
                    },
                    onEditingComplete: () => _confirmFocus.requestFocus(),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  PasswordRequirements(password: _passwordCtrl.text),
                  const SizedBox(height: AppSpacing.md),
                  PTextField(
                    controller: _confirmCtrl,
                    focusNode: _confirmFocus,
                    label: 'Confirm password',
                    hint: 'Repeat password',
                    obscureText: true,
                    textInputAction: TextInputAction.done,
                    fieldState: _confirmState,
                    errorText: _confirmError,
                    onChanged: (val) {
                      if (_confirmState != PFieldState.idle) {
                        _validateConfirm(val);
                      }
                    },
                    onEditingComplete: _submit,
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  PPrimaryButton(
                    label: 'Continue',
                    state: _buttonState,
                    onPressed: _submit,
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
