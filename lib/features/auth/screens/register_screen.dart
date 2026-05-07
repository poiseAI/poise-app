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

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();

  PButtonState _buttonState = PButtonState.idle;
  PFieldState _emailState = PFieldState.idle;
  PFieldState _passwordState = PFieldState.idle;
  String? _emailError;
  String? _passwordError;

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
    final ok = val.length >= 8;
    setState(() {
      _passwordState = ok ? PFieldState.valid : PFieldState.error;
      _passwordError = ok ? null : 'Password must be at least 8 characters';
    });
    return ok;
  }

  Future<void> _submit() async {
    final emailOk = _validateEmail(_emailCtrl.text.trim());
    final passOk = _validatePassword(_passwordCtrl.text);
    if (!emailOk || !passOk) return;

    setState(() => _buttonState = PButtonState.loading);

    final result = await ref.read(authProvider.notifier).register(
          _emailCtrl.text.trim(),
          _passwordCtrl.text,
        );

    if (!mounted) return;

    result.fold(
      onOk: (_) {
        setState(() => _buttonState = PButtonState.success);
        Future.delayed(const Duration(milliseconds: 600), () {
          if (mounted) context.go(Routes.home);
        });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.lg),
              const Text('Create account', style: AppTypography.h1),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Enter your details to get started.',
                style: AppTypography.bodyLg
                    .copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: AppSpacing.xxl),
              PTextField(
                controller: _emailCtrl,
                focusNode: _emailFocus,
                label: 'Email',
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                fieldState: _emailState,
                errorText: _emailError,
                autofocus: true,
                onChanged: (val) {
                  if (_emailState != PFieldState.idle) _validateEmail(val);
                },
                onEditingComplete: () => _passwordFocus.requestFocus(),
              ),
              const SizedBox(height: AppSpacing.md),
              PTextField(
                controller: _passwordCtrl,
                focusNode: _passwordFocus,
                label: 'Password',
                obscureText: true,
                textInputAction: TextInputAction.done,
                fieldState: _passwordState,
                errorText: _passwordError,
                onChanged: (val) {
                  if (_passwordState != PFieldState.idle) _validatePassword(val);
                },
                onEditingComplete: _submit,
              ),
              const SizedBox(height: AppSpacing.xl),
              PPrimaryButton(
                label: 'Create account',
                state: _buttonState,
                onPressed: _submit,
              ),
              const SizedBox(height: AppSpacing.lg),
              Center(
                child: TextButton(
                  onPressed: () => context.go(Routes.login),
                  child: Text(
                    'Already have an account? Log in',
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
    );
  }
}
