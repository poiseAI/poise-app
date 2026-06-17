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
  const BaselineSyncScreen({super.key});

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
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(28, 26, 28, 28),
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 230,
                        height: 230,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Positioned.fill(
                              child: AnimatedBuilder(
                                animation: _pulseCtrl,
                                builder: (context, _) => CustomPaint(
                                  painter: _BaselineRingsPainter(
                                    progress: _pulseCtrl.value,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.20),
                                shape: BoxShape.circle,
                              ),
                              alignment: Alignment.center,
                              child: const SizedBox(
                                width: 28,
                                height: 28,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: Colors.white,
                                  strokeCap: StrokeCap.round,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 52),
                      Text(
                        'Building your baseline',
                        textAlign: TextAlign.center,
                        style: AppTypography.display2.copyWith(
                          color: Colors.white,
                          fontSize: 24,
                          height: 1.2,
                          letterSpacing: 0,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Poise is analyzing your last 30 days of trades to learn your patterns — so it can spot when you drift off-script.',
                        textAlign: TextAlign.center,
                        style: AppTypography.body.copyWith(
                          color: Colors.white,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
                const _BaselineChecklistRow(
                  text: 'Fetching 30 days of trade history',
                ),
                const SizedBox(height: 10),
                const _BaselineChecklistRow(
                  text: 'Calculating your discipline baseline',
                ),
                const SizedBox(height: 10),
                const _BaselineChecklistRow(
                  text: 'Setting up behavioural guardrails',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BaselineChecklistRow extends StatelessWidget {
  const _BaselineChecklistRow({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 56),
      padding: const EdgeInsets.all(16),
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
              style: AppTypography.bodySm.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w500,
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
      ..strokeWidth = 1.5
      ..color = Colors.white.withValues(alpha: 0.20);
    final pulsePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = Colors.white.withValues(alpha: 0.45);

    for (var i = 1; i <= 4; i++) {
      canvas.drawCircle(center, maxRadius * i / 4, ringPaint);
    }

    final pulseRadius = maxRadius * (0.18 + progress * 0.72);
    canvas.drawCircle(center, pulseRadius, pulsePaint);
  }

  @override
  bool shouldRepaint(covariant _BaselineRingsPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
