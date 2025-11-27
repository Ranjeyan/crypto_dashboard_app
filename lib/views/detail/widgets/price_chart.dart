import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../data/models/chart_data.dart';

class PriceChart extends StatelessWidget {
  final List<ChartData> data;
  final bool isPositive;

  const PriceChart({
    Key? key,
    required this.data,
    required this.isPositive,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const Center(child: Text('No data available'));
    }

    final spots = data
        .asMap()
        .entries
        .map((entry) => FlSpot(
      entry.key.toDouble(),
      entry.value.price,
    ))
        .toList();

    final minPrice = data.map((e) => e.price).reduce((a, b) => a < b ? a : b);
    final maxPrice = data.map((e) => e.price).reduce((a, b) => a > b ? a : b);

    final lineColor = isPositive ? Colors.green : Colors.red;
    final gradientStartColor = isPositive
        ? Colors.green.withValues(alpha: 0.3)
        : Colors.red.withValues(alpha: 0.3);
    final gradientEndColor = isPositive
        ? Colors.green.withValues(alpha: 0.0)
        : Colors.red.withValues(alpha: 0.0);

    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: false),
        titlesData: const FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        minX: 0,
        maxX: spots.length.toDouble() - 1,
        minY: minPrice * 0.99,
        maxY: maxPrice * 1.01,
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipItems: (List<LineBarSpot> touchedSpots) {
              return touchedSpots.map((lineBarSpot) {
                final formattedPrice = lineBarSpot.y.toStringAsFixed(3);

                return LineTooltipItem(
                  '\$$formattedPrice',
                  const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                );
              }).toList();
            },
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: lineColor,
            barWidth: 3,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  gradientStartColor,
                  gradientEndColor,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
      ),
    );
  }
}