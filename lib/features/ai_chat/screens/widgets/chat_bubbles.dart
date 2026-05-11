import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

class UserBubble extends StatelessWidget {
  const UserBubble({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width * 0.75,
        ),
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md, vertical: AppSpacing.sm),
        decoration: const BoxDecoration(
          color: AppColors.brand600,
          borderRadius: AppRadius.bubbleOutgoing,
        ),
        child: Text(
          text,
          style: AppTypography.body.copyWith(color: Colors.white),
        ),
      ),
    )
        .animate()
        .scale(
          begin: const Offset(0.85, 0.85),
          end: const Offset(1, 1),
          alignment: Alignment.centerRight,
          curve: Curves.easeOutBack,
          duration: 250.ms,
        )
        .fadeIn(duration: 150.ms);
  }
}

class AiBubble extends StatelessWidget {
  const AiBubble({
    super.key,
    required this.text,
    required this.isStreaming,
  });

  final String text;
  final bool isStreaming;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width * 0.82,
        ),
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md, vertical: AppSpacing.sm),
        decoration: const BoxDecoration(
          color: Color(0xFFEAF4FF),
          borderRadius: AppRadius.bubbleIncoming,
        ),
        child: text.isEmpty && isStreaming
            ? const TypingIndicator()
            : RichText(
                text: TextSpan(
                  style: AppTypography.body,
                  children: [
                    TextSpan(text: text),
                    if (isStreaming) const WidgetSpan(child: _BlinkingCursor()),
                  ],
                ),
              ),
      ),
    ).animate().fadeIn(duration: 200.ms);
  }
}

class _BlinkingCursor extends StatefulWidget {
  const _BlinkingCursor();

  @override
  State<_BlinkingCursor> createState() => _BlinkingCursorState();
}

class _BlinkingCursorState extends State<_BlinkingCursor>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 530),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) => Opacity(
        opacity: _ctrl.value,
        child: Container(
          width: 2,
          height: 16,
          margin: const EdgeInsets.only(left: 2),
          color: AppColors.accentPurple,
        ),
      ),
    );
  }
}

class TypingIndicator extends StatefulWidget {
  const TypingIndicator({super.key});

  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 20,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(3, (i) {
          return AnimatedBuilder(
            animation: _ctrl,
            builder: (_, __) {
              final phase = ((_ctrl.value - i * 0.15) % 1.0).clamp(0.0, 1.0);
              final bounce = phase < 0.5 ? phase * 2 : (1.0 - phase) * 2;
              return Container(
                width: 7,
                height: 7,
                margin: const EdgeInsets.symmetric(horizontal: 2),
                decoration: const BoxDecoration(
                  color: AppColors.textSecondary,
                  shape: BoxShape.circle,
                ),
                transform: Matrix4.translationValues(0, -bounce * 6, 0),
              );
            },
          );
        }),
      ),
    );
  }
}
