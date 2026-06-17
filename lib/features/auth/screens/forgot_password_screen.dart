import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
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
      appBar: AppBar(
        centerTitle: false,
        title: const Text('Forgot password'),
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
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      'Reset your password',
                      style: AppTypography.h2.copyWith(
                        fontFamily: 'Orbitron',
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        height: 1.2,
                        letterSpacing: 0,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'Enter the email associated with your account and we\'ll send a code to reset your password.',
                      style: AppTypography.bodyLg.copyWith(
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
                      const SizedBox(height: AppSpacing.xxl),
                    ],
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
                      onChanged: (val) {
                        if (_errorMessage != null) {
                          setState(() => _errorMessage = null);
                        }
                        if (_emailState != PFieldState.idle) _validate();
                      },
                      onEditingComplete: _submit,
                    ),
                    const Spacer(),
                    PPrimaryButton(
                      label: 'Reset password',
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
      ),
    );
  }
}
