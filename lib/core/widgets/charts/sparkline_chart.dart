import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class SparklineChart extends StatelessWidget {
  const SparklineChart({
    super.key,
    required this.values,
    this.height = 40,
    this.width,
  });

  final List<double> values;
  final double height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    if (values.length < 2) {
      return SizedBox(height: height, width: width);
    }

    final isPositive = values.last >= values.first;
    final lineColor = isPositive ? AppColors.profitGreen : AppColors.lossRed;

    final spots = List.generate(
      values.length,
      (i) => FlSpot(i.toDouble(), values[i]),
    );

    return SizedBox(
      height: height,
      width: width,
      child: LineChart(
        LineChartData(
          lineTouchData: const LineTouchData(enabled: false),
          gridData: const FlGridData(show: false),
          titlesData: const FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              curveSmoothness: 0.35,
              color: lineColor,
              barWidth: 1.5,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                color: lineColor.withValues(alpha: 0.12),
              ),
            ),
          ],
        ),
        duration: Duration.zero,
      ),
    );
  }
}
