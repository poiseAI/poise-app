import 'dart:math' as math;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';

class PnlBarChart extends StatelessWidget {
  const PnlBarChart({
    super.key,
    required this.values,
    this.labels,
    this.height = 120,
    this.barWidth = 12,
    this.showLabels = false,
  });

  final List<double> values;
  final List<String>? labels;
  final double height;
  final double barWidth;
  final bool showLabels;

  @override
  Widget build(BuildContext context) {
    if (values.isEmpty) return SizedBox(height: height);

    final maxAbs = values.map((v) => v.abs()).reduce(math.max);
    final maxY = maxAbs == 0 ? 1.0 : maxAbs * 1.15;

    final groups = List.generate(values.length, (i) {
      final v = values[i];
      return BarChartGroupData(
        x: i,
        barRods: [
          BarChartRodData(
            toY: v,
            fromY: 0,
            color: v >= 0 ? AppColors.profitGreen : AppColors.lossRed,
            width: barWidth,
            borderRadius: BorderRadius.circular(3),
          ),
        ],
      );
    });

    return SizedBox(
      height: height,
      child: BarChart(
        BarChartData(
          maxY: maxY,
          minY: -maxY,
          barGroups: groups,
          barTouchData: const BarTouchData(enabled: false),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: maxY,
            getDrawingHorizontalLine: (_) => FlLine(
              color: AppColors.textDisabled.withValues(alpha: 0.3),
              strokeWidth: 0.5,
            ),
          ),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            leftTitles: const AxisTitles(),
            rightTitles: const AxisTitles(),
            topTitles: const AxisTitles(),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: showLabels && labels != null,
                getTitlesWidget: (value, meta) {
                  final idx = value.toInt();
                  if (labels == null || idx >= labels!.length) {
                    return const SizedBox.shrink();
                  }
                  return Text(
                    labels![idx],
                    style: AppTypography.caption
                        .copyWith(color: AppColors.textSecondary),
                  );
                },
              ),
            ),
          ),
        ),
        duration: const Duration(milliseconds: 200),
      ),
    );
  }
}
