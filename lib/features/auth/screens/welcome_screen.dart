import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/router/routes.dart';
import '../../../core/storage/preferences.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

class WelcomeScreen extends ConsumerStatefulWidget {
  const WelcomeScreen({super.key});

  @override
  ConsumerState<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends ConsumerState<WelcomeScreen> {
  final _pageController = PageController();
  Timer? _autoSlideTimer;
  int _currentPage = 0;

  static const _slides = [
    _WelcomeSlide(
      image: 'assets/images/onboarding_trading_os.png',
      title: 'The Trading Operating System',
      body:
          'Stop losing to emotional mistakes. Poise enforces your strategy and discipline by evaluating every trade before it is executed.',
      imageSize: 500,
      imageTop: 58,
      imageLeftOffset: -55,
    ),
    _WelcomeSlide(
      image: 'assets/images/onboarding_guardrails.png',
      title: 'Automated Risk Guardrails',
      body:
          'Define your limits—daily loss, max leverage, % risk per trade—and Poise automatically blocks trades that violate your rules.',
      imageSize: 442,
      imageTop: 68,
      imageLeftOffset: -26,
    ),
    _WelcomeSlide(
      image: 'assets/images/onboarding_ai_coaching.png',
      title: 'Real-Time AI Coaching',
      body:
          'Get immediate feedback on emotional patterns like overtrading or revenge trading. Chat with Poise AI before you execute to stay consistent.',
      imageSize: 390,
      imageTop: 97,
      imageLeftOffset: 0,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _startAutoSlideTimer();
  }

  @override
  void dispose() {
    _autoSlideTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoSlideTimer() {
    _autoSlideTimer?.cancel();
    _autoSlideTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (!mounted || !_pageController.hasClients) return;
      final nextPage = (_currentPage + 1) % _slides.length;
      _pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeOutCubic,
      );
    });
  }

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
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 390),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final heightScale = constraints.maxHeight / 844;
              final slideScale = heightScale.clamp(0.86, 1.0);

              return Stack(
                children: [
                  PageView.builder(
                    controller: _pageController,
                    itemCount: _slides.length,
                    onPageChanged: (value) {
                      setState(() => _currentPage = value);
                      _startAutoSlideTimer();
                    },
                    itemBuilder: (context, index) => _SlidePage(
                      slide: _slides[index],
                      scale: slideScale,
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    top: 655 * slideScale,
                    child: _PageDots(currentPage: _currentPage),
                  ),
                  Positioned(
                    left: 24,
                    right: 24,
                    bottom: (56 * heightScale).clamp(40, 56),
                    child: _WelcomeActions(
                      onGetStarted: () => _continueTo(Routes.register),
                      onLogin: () => _continueTo(Routes.login),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _WelcomeSlide {
  const _WelcomeSlide({
    required this.image,
    required this.title,
    required this.body,
    required this.imageSize,
    required this.imageTop,
    required this.imageLeftOffset,
  });

  final String image;
  final String title;
  final String body;
  final double imageSize;
  final double imageTop;
  final double imageLeftOffset;
}

class _SlidePage extends StatelessWidget {
  const _SlidePage({required this.slide, required this.scale});

  final _WelcomeSlide slide;
  final double scale;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: slide.imageTop * scale,
          left: slide.imageLeftOffset,
          child: Image.asset(
            slide.image,
            width: slide.imageSize,
            height: slide.imageSize,
            fit: BoxFit.contain,
            filterQuality: FilterQuality.high,
          ),
        ),
        Positioned(
          left: 32,
          right: 29,
          top: 495 * scale,
          child: Column(
            children: [
              Text(
                slide.title,
                textAlign: TextAlign.center,
                style: AppTypography.display2.copyWith(
                  color: AppColors.primary,
                  fontFamily: 'Orbitron',
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  height: 1.6,
                  letterSpacing: 0,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                slide.body,
                textAlign: TextAlign.center,
                style: AppTypography.bodySm.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.67,
                  letterSpacing: 0,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _WelcomeActions extends StatelessWidget {
  const _WelcomeActions({
    required this.onGetStarted,
    required this.onLogin,
  });

  final VoidCallback onGetStarted;
  final VoidCallback onLogin;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: double.infinity,
          height: 44,
          child: FilledButton(
            style: FilledButton.styleFrom(
              shape: const StadiumBorder(),
              textStyle: AppTypography.button,
            ),
            onPressed: onGetStarted,
            child: const Text('Get Started'),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 44,
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              shape: const StadiumBorder(),
              textStyle: AppTypography.button,
            ),
            onPressed: onLogin,
            child: const Text('Log in'),
          ),
        ),
      ],
    );
  }
}

class _PageDots extends StatelessWidget {
  const _PageDots({required this.currentPage});

  final int currentPage;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        final active = index == currentPage;
        final distance = (index - currentPage).abs();
        final size = active
            ? 9.0
            : distance == 1
                ? 7.0
                : 5.0;

        return AnimatedContainer(
          key: ValueKey('welcome-dot-$index'),
          duration: const Duration(milliseconds: 180),
          margin: const EdgeInsets.symmetric(horizontal: 8),
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: active
                ? AppColors.primary
                : AppColors.primary.withValues(alpha: 0.22),
          ),
        );
      }),
    );
  }
}
