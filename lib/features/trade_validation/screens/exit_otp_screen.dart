import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/inputs/p_otp_field.dart';
import '../providers/exit_otp_provider.dart';

class ExitOtpScreen extends ConsumerStatefulWidget {
  const ExitOtpScreen({super.key, required this.positionId});
  final String positionId;

  @override
  ConsumerState<ExitOtpScreen> createState() => _ExitOtpScreenState();
}

class _ExitOtpScreenState extends ConsumerState<ExitOtpScreen>
    with TickerProviderStateMixin {
  late final AnimationController _lockCtrl;
  late final AnimationController _shakeCtrl;
  late final Animation<double> _shakeAnim;
  late final AnimationController _celebCtrl;

  @override
  void initState() {
    super.initState();

    _lockCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();

    _shakeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _shakeAnim = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0, end: -16), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -16, end: 16), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 16, end: -16), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -16, end: 16), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 16, end: 0), weight: 1),
    ]).animate(CurvedAnimation(parent: _shakeCtrl, curve: Curves.easeOut));

    _celebCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
  }

  @override
  void dispose() {
    _lockCtrl.dispose();
    _shakeCtrl.dispose();
    _celebCtrl.dispose();
    super.dispose();
  }

  void _onCompleted(String otp) {
    ref.read(exitOtpProvider(widget.positionId).notifier).verify(otp);
  }

  @override
  Widget build(BuildContext context) {
    final otpState = ref.watch(exitOtpProvider(widget.positionId));

    ref.listen(exitOtpProvider(widget.positionId), (prev, next) {
      if (next.wrongCode && prev?.wrongCode != true) {
        HapticFeedback.heavyImpact();
        _shakeCtrl.forward(from: 0);
      }
      if (next.success && prev?.success != true) {
        HapticFeedback.mediumImpact();
        _celebCtrl.forward();
        final router = GoRouter.of(context);
        Future.delayed(const Duration(milliseconds: 1500), () {
          if (mounted) router.go(Routes.home);
        });
      }
    });

    if (otpState.success) {
      return Scaffold(
        backgroundColor: AppColors.bgPrimary,
        body: Center(child: _SuccessBody(ctrl: _celebCtrl)),
      );
    }

    final otpFieldState = otpState.wrongCode ? POtpState.error : POtpState.idle;

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
        title: const Text('Confirm Exit'),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: AppColors.borderLight),
        ),
      ),
      body: SafeArea(
        top: false,
        child: Padding(
          padding: AppSpacing.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: AppSpacing.lg),

              // Padlock animation (#51)
              AnimatedBuilder(
                animation: _lockCtrl,
                builder: (_, __) {
                  final t = Curves.easeOutBack.transform(
                    math.min(_lockCtrl.value, 1.0),
                  );
                  return Opacity(
                    opacity: t,
                    child: Transform.scale(
                      scale: 0.5 + (t * 0.5),
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: AppColors.lossRed.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.lossRed.withValues(alpha: 0.3),
                            width: 2,
                          ),
                        ),
                        child: const Icon(
                          Icons.lock_open_rounded,
                          size: 36,
                          color: AppColors.lossRed,
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: AppSpacing.lg),

              const Text('Enter OTP', style: AppTypography.h2)
                  .animate(delay: 200.ms)
                  .fadeIn(duration: 300.ms)
                  .slideY(begin: 0.1, end: 0),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Enter the OTP sent to your email.',
                style:
                    AppTypography.body.copyWith(color: AppColors.textSecondary),
                textAlign: TextAlign.center,
              ).animate(delay: 300.ms).fadeIn(duration: 300.ms),
              const SizedBox(height: AppSpacing.xxl),

              // OTP field with shake (#20, 52)
              AnimatedBuilder(
                animation: _shakeAnim,
                builder: (_, child) => Transform.translate(
                    offset: Offset(_shakeAnim.value, 0), child: child),
                child: POtpField(
                  length: 6,
                  state: otpFieldState,
                  onCompleted: _onCompleted,
                  onChanged: (_) {
                    ref
                        .read(exitOtpProvider(widget.positionId).notifier)
                        .resetWrongCode();
                  },
                ),
              ),

              if (otpState.wrongCode) ...[
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Incorrect code. Please try again.',
                  style:
                      AppTypography.caption.copyWith(color: AppColors.lossRed),
                )
                    .animate()
                    .fadeIn(duration: 200.ms)
                    .slideY(begin: -0.3, end: 0),
              ],

              if (otpState.error != null) ...[
                const SizedBox(height: AppSpacing.sm),
                Text(
                  otpState.error!,
                  style:
                      AppTypography.caption.copyWith(color: AppColors.lossRed),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _SuccessBody extends StatelessWidget {
  const _SuccessBody({required this.ctrl});
  final AnimationController ctrl;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedBuilder(
          animation: ctrl,
          builder: (_, __) {
            final t = Curves.easeOutBack.transform(ctrl.value);
            return Opacity(
              opacity: ctrl.value,
              child: Transform.scale(
                scale: t,
                child: Container(
                  width: 96,
                  height: 96,
                  decoration: const BoxDecoration(
                    color: AppColors.profitGreen,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check_rounded,
                      color: Colors.white, size: 48),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: AppSpacing.lg),
        const Text('Exit requested!', style: AppTypography.h2)
            .animate(delay: 300.ms)
            .fadeIn(duration: 300.ms),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'Your exit request has been submitted.',
          style: AppTypography.body.copyWith(color: AppColors.textSecondary),
        ).animate(delay: 400.ms).fadeIn(duration: 300.ms),
      ],
    );
  }
}
