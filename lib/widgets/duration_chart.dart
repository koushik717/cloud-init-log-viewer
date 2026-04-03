import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/module_run.dart';
import '../theme.dart';
import '../constants.dart';

class DurationChart extends StatelessWidget {
  final List<ModuleRun> modules;

  const DurationChart({super.key, required this.modules});

  @override
  Widget build(BuildContext context) {
    final validModules = modules.where((m) => m.duration != null).toList();
    if (validModules.length < 2) {
      return const SizedBox.shrink();
    }

    validModules.sort((a, b) => b.duration!.compareTo(a.duration!));
    final topModules = validModules.take(8).toList();
    // Reverse for bottom-up building of chart but we want top at top, FlChart builds from bottom Y to top Y.
    // So if Y=0 is bottom, the 8th module should be at Y=0, 1st module at Y=7
    final chartModules = topModules.reversed.toList();

    double maxMs = chartModules.map((m) => m.duration!.inMilliseconds.toDouble()).reduce((a, b) => a > b ? a : b);

    return Container(
      height: 280,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Module Duration (ms)',
            style: TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: maxMs * 1.1,
                barTouchData: BarTouchData(enabled: false),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      getTitlesWidget: (value, meta) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            value.toInt().toString(),
                            style: const TextStyle(color: AppTheme.textSecondary, fontSize: 10),
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 100,
                      getTitlesWidget: (value, meta) {
                        if (value < 0 || value >= chartModules.length) return const SizedBox.shrink();
                        final index = value.toInt();
                        return Text(
                          chartModules[index].name,
                          style: const TextStyle(color: AppTheme.textPrimary, fontSize: 10),
                          overflow: TextOverflow.ellipsis,
                        );
                      },
                    ),
                  ),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(show: false),
                barGroups: List.generate(chartModules.length, (index) {
                  final module = chartModules[index];
                  Color barColor = AppTheme.success;
                  if (module.status == ModuleStatus.error) barColor = AppTheme.error;
                  else if (module.status == ModuleStatus.warning) barColor = AppTheme.warning;

                  return BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: module.duration!.inMilliseconds.toDouble(),
                        color: barColor,
                        width: 16,
                        borderRadius: BorderRadius.circular(4),
                      )
                    ],
                  );
                }),
              ),
              swapAnimationDuration: chartAnimationDuration,
            ),
          ),
        ],
      ),
    );
  }
}
