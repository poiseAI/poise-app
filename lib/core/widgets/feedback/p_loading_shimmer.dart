import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';

/// Single shimmer-animated box.
class PShimmerBox extends StatelessWidget {
  const PShimmerBox({
    super.key,
    required this.width,
    required this.height,
    this.radius,
    this.heightVariance = 0,
  });

  final double width;
  final double height;
  final BorderRadius? radius;
  /// Adds ±heightVariance organic variation (#74).
  final double heightVariance;

  @override
  Widget build(BuildContext context) {
    final effectiveHeight = heightVariance > 0
        ? height + (Random().nextDouble() * heightVariance * 2 - heightVariance)
        : height;

    return Shimmer.fromColors(
      baseColor: AppColors.textDisabled.withValues(alpha: 0.18),
      highlightColor: AppColors.bgCard,
      child: Container(
        width: width,
        height: effectiveHeight,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: radius ?? AppRadius.cardRadius,
        ),
      ),
    );
  }
}

/// Full-width shimmer line (for text placeholders).
class PShimmerLine extends StatelessWidget {
  const PShimmerLine({
    super.key,
    this.width,
    this.height = 14,
    this.heightVariance = 4,
  });

  final double? width;
  final double height;
  final double heightVariance;

  @override
  Widget build(BuildContext context) {
    return PShimmerBox(
      width: width ?? double.infinity,
      height: height,
      radius: AppRadius.pillRadius,
      heightVariance: heightVariance,
    );
  }
}

/// Position card shimmer — matches PositionCard layout exactly.
class PPositionCardShimmer extends StatelessWidget {
  const PPositionCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.textDisabled.withValues(alpha: 0.15),
      highlightColor: AppColors.bgCard,
      child: Container(
        padding: AppSpacing.cardPadding,
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          borderRadius: AppRadius.cardRadius,
          border: Border.all(color: AppColors.borderLight),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: AppRadius.cardRadius,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 80,
                      height: 14,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 4),
                    Container(width: 56, height: 11, color: Colors.white),
                  ],
                ),
                const Spacer(),
                Container(width: 64, height: 20, color: Colors.white),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Container(width: double.infinity, height: 1, color: Colors.white),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Container(width: 72, height: 11, color: Colors.white),
                const Spacer(),
                Container(width: 72, height: 11, color: Colors.white),
                const Spacer(),
                Container(width: 72, height: 11, color: Colors.white),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Staggered list of position card shimmers.
class PPositionListShimmer extends StatelessWidget {
  const PPositionListShimmer({super.key, this.count = 4});
  final int count;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(count, (i) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: i < count - 1 ? AppSpacing.sm : 0,
          ),
          child: const PPositionCardShimmer(),
        );
      }),
    );
  }
}
