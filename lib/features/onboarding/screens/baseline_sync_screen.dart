import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_typography.dart';
import '../../auth/providers/auth_provider.dart';

class BaselineSyncScreen extends ConsumerStatefulWidget {
  const BaselineSyncScreen({super.key, this.autoComplete = true});

  final bool autoComplete;

  @override
  ConsumerState<BaselineSyncScreen> createState() => _BaselineSyncScreenState();
}

class _BaselineSyncScreenState extends ConsumerState<BaselineSyncScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseCtrl;
  Timer? _completeTimer;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat();
    if (!widget.autoComplete) return;
    _completeTimer = Timer(const Duration(milliseconds: 3500), () {
      if (!mounted) return;
      ref.read(authProvider.notifier).markHasActiveStrategy();
      context.go(Routes.home);
    });
  }

  @override
  void dispose() {
    _completeTimer?.cancel();
    _pulseCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: AppColors.primary,
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 390),
            child: Stack(
              children: [
                Positioned(
                  key: const ValueKey('baseline-rings'),
                  left: 27,
                  top: 39,
                  child: SizedBox(
                    width: 336,
                    height: 336,
                    child: AnimatedBuilder(
                      animation: _pulseCtrl,
                      builder: (context, _) => CustomPaint(
                        painter: _BaselineRingsPainter(
                          progress: _pulseCtrl.value,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  key: const ValueKey('baseline-loader'),
                  left: 171,
                  top: 183,
                  child: _BaselineLoader(progress: _pulseCtrl.value),
                ),
                const Positioned(
                  key: ValueKey('baseline-content'),
                  left: 24,
                  top: 397,
                  child: SizedBox(
                    width: 342,
                    height: 328,
                    child: Stack(
                      children: [
                        Positioned(
                          left: 0,
                          top: 0,
                          child: _BaselineCopy(),
                        ),
                        Positioned(
                          left: 0,
                          top: 136,
                          child: _BaselineChecklist(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BaselineLoader extends StatelessWidget {
  const _BaselineLoader({required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.18),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Transform.rotate(
        angle: progress * math.pi * 2,
        child: const SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 3,
            color: Colors.white,
            strokeCap: StrokeCap.round,
          ),
        ),
      ),
    );
  }
}

class _BaselineCopy extends StatelessWidget {
  const _BaselineCopy();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 342,
      height: 104,
      child: Stack(
        children: [
          Positioned(
            left: 24.5,
            top: 0,
            child: SizedBox(
              width: 293,
              height: 32,
              child: Text(
                'Building your baseline',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: AppTypography.display2.copyWith(
                  color: Colors.white,
                  fontSize: 24,
                  height: 1.33,
                  letterSpacing: 0,
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            top: 44,
            child: SizedBox(
              width: 342,
              height: 60,
              child: Text(
                'Poise is analyzing your last 30 days of trades to learn your patterns - so it can spot when you drift off-script.',
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: AppTypography.body.copyWith(
                  color: Colors.white,
                  height: 1.43,
                  letterSpacing: 0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BaselineChecklist extends StatelessWidget {
  const _BaselineChecklist();

  static const _items = [
    'Fetching 30 days of trade history',
    'Calculating your discipline baseline',
    'Setting up behavioural guardrails',
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 342,
      height: 192,
      child: Stack(
        children: [
          for (var index = 0; index < _items.length; index += 1)
            Positioned(
              left: 0,
              top: index * 68,
              child: _BaselineChecklistRow(
                key: ValueKey('baseline-check-row-$index'),
                text: _items[index],
              ),
            ),
        ],
      ),
    );
  }
}

class _BaselineChecklistRow extends StatelessWidget {
  const _BaselineChecklistRow({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 342,
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: AppRadius.cardRadius,
        border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_rounded,
              size: 16,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.body.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                height: 1.43,
                letterSpacing: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BaselineRingsPainter extends CustomPainter {
  const _BaselineRingsPainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = math.min(size.width, size.height) / 2;
    final ringPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = Colors.white.withValues(alpha: 0.18);
    final pulsePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..color = Colors.white.withValues(alpha: 0.32);

    for (var i = 1; i <= 6; i++) {
      canvas.drawCircle(center, maxRadius * i / 6, ringPaint);
    }

    final pulseRadius = maxRadius * (0.16 + progress * 0.84);
    canvas.drawCircle(center, pulseRadius, pulsePaint);
  }

  @override
  bool shouldRepaint(covariant _BaselineRingsPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
