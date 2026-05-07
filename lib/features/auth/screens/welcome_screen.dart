import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(flex: 2),
              // Logo + brand — animates on entry (#1 micro-interaction)
              _PoiseLogoMark()
                  .animate()
                  .scale(
                    begin: const Offset(0.8, 0.8),
                    end: const Offset(1.0, 1.0),
                    duration: 400.ms,
                    curve: Curves.easeOutBack,
                  )
                  .fadeIn(duration: 350.ms),
              const SizedBox(height: AppSpacing.xl),
              Text(
                'Trade with\nconfidence.',
                style: AppTypography.display1.copyWith(
                  color: AppColors.textPrimary,
                ),
              )
                  .animate(delay: 150.ms)
                  .fadeIn(duration: 350.ms)
                  .slideY(begin: 0.1, end: 0, curve: Curves.easeOutCubic),
              const SizedBox(height: AppSpacing.md),
              Text(
                'AI-powered risk management for every trade.',
                style: AppTypography.bodyLg.copyWith(
                  color: AppColors.textSecondary,
                ),
              )
                  .animate(delay: 220.ms)
                  .fadeIn(duration: 350.ms)
                  .slideY(begin: 0.1, end: 0, curve: Curves.easeOutCubic),
              const Spacer(flex: 3),
              FilledButton(
                onPressed: () => context.go(Routes.register),
                child: const Text('Get started'),
              )
                  .animate(delay: 350.ms)
                  .fadeIn(duration: 300.ms)
                  .slideY(begin: 0.15, end: 0, curve: Curves.easeOutCubic),
              const SizedBox(height: AppSpacing.md),
              Center(
                child: TextButton(
                  onPressed: () => context.go(Routes.login),
                  child: Text(
                    'Already have an account? Log in',
                    style: AppTypography.body.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              )
                  .animate(delay: 400.ms)
                  .fadeIn(duration: 300.ms),
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }
}

class _PoiseLogoMark extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: AppColors.accent,
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Center(
        child: Text(
          'P',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            height: 1.0,
          ),
        ),
      ),
    );
  }
}
