import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
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
  final _controller = PageController();
  int _page = 0;
  bool _showSplash = true;

  static const _pages = [
    _WelcomePageData(
      asset: 'assets/images/onboarding_plant.png',
      title: 'Trading Operating System',
      body:
          'Plan, review, and execute every trade with discipline. Poise checks your rules before emotion gets a vote.',
    ),
    _WelcomePageData(
      asset: 'assets/images/onboarding_shield.png',
      title: 'Automated Risk Guardrails',
      body:
          'Set daily loss, leverage, and risk-per-trade limits. Poise blocks trades that break the guardrails you chose.',
    ),
    _WelcomePageData(
      asset: 'assets/images/onboarding_light_bulb.png',
      title: 'Real-Time AI Coaching',
      body:
          'Spot patterns like overtrading and revenge trading early. Chat with Poise AI before execution to stay consistent.',
    ),
  ];

  @override
  void initState() {
    super.initState();
    Future<void>.delayed(const Duration(milliseconds: 950), () {
      if (mounted) setState(() => _showSplash = false);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _continueTo(String route) async {
    final prefs = await ref.read(appPreferencesProvider.future);
    await prefs.setHasSeenWelcome();
    if (!mounted) return;
    context.go(route);
  }

  @override
  Widget build(BuildContext context) {
    if (_showSplash) return const _IntroSplash();

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.screenPadding,
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  itemCount: _pages.length,
                  onPageChanged: (value) => setState(() => _page = value),
                  itemBuilder: (context, index) => _WelcomeSlide(
                    data: _pages[index],
                    active: index == _page,
                  ),
                ),
              ),
              _PageDots(count: _pages.length, selected: _page),
              const SizedBox(height: AppSpacing.xl),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: FilledButton(
                  onPressed: () => _continueTo(Routes.register),
                  child: const Text('Get Started'),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: OutlinedButton(
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

class _IntroSplash extends StatelessWidget {
  const _IntroSplash();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.candlestick_chart_rounded,
                  color: Colors.white, size: 38),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'poise',
                style: AppTypography.display2.copyWith(
                  color: Colors.white,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WelcomePageData {
  const _WelcomePageData({
    required this.asset,
    required this.title,
    required this.body,
  });

  final String asset;
  final String title;
  final String body;
}

class _WelcomeSlide extends StatelessWidget {
  const _WelcomeSlide({required this.data, required this.active});

  final _WelcomePageData data;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Spacer(flex: 3),
        _OnboardingArt(asset: data.asset, active: active),
        const Spacer(flex: 4),
        Text(
          data.title,
          textAlign: TextAlign.center,
          style: AppTypography.display2.copyWith(
            color: AppColors.primary,
            fontFamily: 'Inter',
            fontSize: 30,
            fontWeight: FontWeight.w700,
            height: 1.16,
            letterSpacing: 0,
          ),
        )
            .animate(target: active ? 1 : 0)
            .fadeIn(duration: 260.ms, curve: Curves.easeOut)
            .slideY(begin: 0.12, end: 0, duration: 320.ms),
        const SizedBox(height: AppSpacing.md),
        Text(
          data.body,
          textAlign: TextAlign.center,
          style: AppTypography.h2.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w400,
            fontSize: 16,
            height: 1.5,
            letterSpacing: 0,
          ),
        )
            .animate(target: active ? 1 : 0)
            .fadeIn(delay: 60.ms, duration: 260.ms, curve: Curves.easeOut)
            .slideY(begin: 0.12, end: 0, duration: 320.ms),
        const Spacer(flex: 2),
      ],
    );
  }
}

class _OnboardingArt extends StatelessWidget {
  const _OnboardingArt({required this.asset, required this.active});

  final String asset;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 280,
      child: Center(
        child: AnimatedScale(
          duration: const Duration(milliseconds: 360),
          curve: Curves.easeOutCubic,
          scale: active ? 1 : 0.9,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 260),
            opacity: active ? 1 : 0.42,
            child: Image.asset(
              asset,
              width: 236,
              height: 236,
              fit: BoxFit.contain,
              filterQuality: FilterQuality.high,
            )
                .animate(
                  target: active ? 1 : 0,
                  onPlay: (controller) => controller.repeat(reverse: true),
                )
                .moveY(
                  begin: -5,
                  end: 5,
                  duration: 2200.ms,
                  curve: Curves.easeInOut,
                )
                .shimmer(
                  delay: 450.ms,
                  duration: 1200.ms,
                  color: Colors.white.withValues(alpha: 0.34),
                ),
          ),
        ),
      ),
    );
  }
}

class _PageDots extends StatelessWidget {
  const _PageDots({required this.count, required this.selected});

  final int count;
  final int selected;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        count,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          margin: const EdgeInsets.symmetric(horizontal: 10),
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: selected == index ? AppColors.primary : AppColors.brand100,
          ),
        ),
      ),
    );
  }
}
