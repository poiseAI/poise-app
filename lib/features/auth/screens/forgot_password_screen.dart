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
    setState(() => _buttonState = PButtonState.loading);

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
        setState(() => _buttonState = PButtonState.error);
        PToast.error(context, e.userMessage);
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
        centerTitle: false,
        title: const Text('Forgot Password'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
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
              const Text('Reset your password', style: AppTypography.h4),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Enter your email and we\'ll send a reset code.',
                style: AppTypography.bodyLg
                    .copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: AppSpacing.xxl),
              PTextField(
                controller: _emailCtrl,
                label: 'Email',
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.done,
                fieldState: _emailState,
                errorText: _emailError,
                autofocus: true,
                onChanged: (val) {
                  if (_emailState != PFieldState.idle) _validate();
                },
                onEditingComplete: _submit,
              ),
              const SizedBox(height: AppSpacing.xl),
              PPrimaryButton(
                label: 'Reset password',
                state: _buttonState,
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
