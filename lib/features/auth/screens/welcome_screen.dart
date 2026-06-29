import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/router/routes.dart';
import '../../../core/storage/preferences.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';

class WelcomeScreen extends ConsumerStatefulWidget {
  const WelcomeScreen({super.key});

  @override
  ConsumerState<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends ConsumerState<WelcomeScreen> {
  Future<void> _continueTo(String route) async {
    final prefs = await ref.read(appPreferencesProvider.future);
    await prefs.setHasSeenWelcome();
    if (!mounted) return;
    context.go(route);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.screenPadding,
          child: Column(
            children: [
              const Spacer(flex: 4),
              Image.asset(
                'assets/images/head-welcome.png',
                width: 176,
                height: 176,
                fit: BoxFit.contain,
                filterQuality: FilterQuality.high,
              ),
              const Spacer(flex: 4),
              Text(
                'The Trading Operating System',
                textAlign: TextAlign.center,
                style: AppTypography.display2.copyWith(
                  color: AppColors.primary,
                  fontFamily: 'Orbitron',
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  height: 1.22,
                  letterSpacing: 0,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Stop losing to emotional mistakes. Poise enforces your strategy and discipline by evaluating every trade before it is executed.',
                textAlign: TextAlign.center,
                style: AppTypography.bodySm.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.35,
                  letterSpacing: 0,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              const _PageDots(),
              const Spacer(flex: 3),
              const SizedBox(height: AppSpacing.xl),
              SizedBox(
                width: double.infinity,
                height: 40,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    shape: const StadiumBorder(),
                    textStyle: AppTypography.buttonSm,
                  ),
                  onPressed: () => _continueTo(Routes.register),
                  child: const Text('Get Started'),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              SizedBox(
                width: double.infinity,
                height: 40,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    shape: const StadiumBorder(),
                    textStyle: AppTypography.buttonSm,
                  ),
                  onPressed: () => _continueTo(Routes.login),
                  child: const Text('Log in'),
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

class _PageDots extends StatelessWidget {
  const _PageDots();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          margin: const EdgeInsets.symmetric(horizontal: 5),
          width: 5,
          height: 5,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }
}
