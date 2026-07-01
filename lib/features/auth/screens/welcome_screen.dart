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
      titleLeft: 64,
      titleWidth: 265,
      infoTop: 495,
    ),
    _WelcomeSlide(
      image: 'assets/images/onboarding_guardrails.png',
      title: 'Automated Risk Guardrails',
      body:
          'Define your limits—daily loss, max leverage, % risk per trade—and Poise automatically blocks trades that violate your rules.',
      imageSize: 442,
      imageTop: 68,
      imageLeftOffset: -26,
      titleLeft: 32,
      titleWidth: 329,
      infoTop: 495,
    ),
    _WelcomeSlide(
      image: 'assets/images/onboarding_ai_coaching.png',
      title: 'Real-Time AI Coaching',
      body:
          'Get immediate feedback on emotional patterns like overtrading or revenge trading. Chat with Poise AI before you execute to stay consistent.',
      imageSize: 390,
      imageTop: 97,
      imageLeftOffset: 0,
      titleLeft: 105,
      titleWidth: 183,
      infoTop: 497,
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
              final actionTop =
                  constraints.maxHeight >= 844 ? 688.0 : 688 * slideScale;

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
                    top: actionTop,
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
    required this.titleLeft,
    required this.titleWidth,
    required this.infoTop,
  });

  final String image;
  final String title;
  final String body;
  final double imageSize;
  final double imageTop;
  final double imageLeftOffset;
  final double titleLeft;
  final double titleWidth;
  final double infoTop;
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
          left: slide.titleLeft,
          top: slide.infoTop * scale,
          width: slide.titleWidth,
          height: 64,
          child: Text(
            slide.title,
            textAlign: TextAlign.center,
            style: AppTypography.display2.copyWith(
              color: AppColors.primary,
              fontFamily: 'Orbitron',
              fontSize: 24,
              fontWeight: FontWeight.w600,
              height: 32 / 24,
              letterSpacing: 0,
            ),
          ),
        ),
        Positioned(
          left: 32,
          top: (slide.infoTop + 76) * scale,
          width: 329,
          height: 60,
          child: Text(
            slide.body,
            textAlign: TextAlign.center,
            style: AppTypography.body.copyWith(
              color: AppColors.textSecondary,
              fontSize: 14,
              fontWeight: FontWeight.w400,
              height: 20 / 14,
              letterSpacing: 0,
            ),
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
              textStyle: AppTypography.buttonLg,
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
              textStyle: AppTypography.buttonLg,
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
    final metrics = _DotMetrics.forPage(currentPage);

    return Center(
      child: SizedBox(
        width: metrics.width,
        height: 9,
        child: Stack(
          children: [
            for (var index = 0; index < 3; index += 1)
              Positioned(
                left: metrics.lefts[index],
                top: metrics.tops[index],
                child: AnimatedContainer(
                  key: ValueKey('welcome-dot-$index'),
                  duration: const Duration(milliseconds: 180),
                  width: metrics.sizes[index],
                  height: metrics.sizes[index],
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: index == currentPage
                        ? AppColors.primary
                        : AppColors.primary.withValues(alpha: 0.22),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _DotMetrics {
  const _DotMetrics({
    required this.width,
    required this.lefts,
    required this.tops,
    required this.sizes,
  });

  final double width;
  final List<double> lefts;
  final List<double> tops;
  final List<double> sizes;

  static _DotMetrics forPage(int page) => switch (page) {
        0 => const _DotMetrics(
            width: 53,
            lefts: [0, 25, 48],
            tops: [0, 1, 2],
            sizes: [9, 7, 5],
          ),
        1 => const _DotMetrics(
            width: 55,
            lefts: [0, 23, 48],
            tops: [1, 0, 1],
            sizes: [7, 9, 7],
          ),
        _ => const _DotMetrics(
            width: 53,
            lefts: [0, 23, 44],
            tops: [2, 1, 0],
            sizes: [5, 7, 9],
          ),
      };
}
