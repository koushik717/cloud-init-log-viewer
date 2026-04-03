import 'package:flutter/material.dart';
import '../models/parse_result.dart';
import '../theme.dart';

class SummaryBar extends StatelessWidget {
  final ParseResult result;

  const SummaryBar({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final bootTimeStr = result.totalBootTime != null
        ? '${(result.totalBootTime!.inMilliseconds / 1000).toStringAsFixed(1)}s'
        : 'Unknown';
    
    final totalModules = result.stages.expand((s) => s.modules).length;

    return Row(
      children: [
        Expanded(
          child: _StatCard(
            label: 'Total boot time',
            value: bootTimeStr,
            icon: Icons.timer,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _StatCard(
            label: 'Modules run',
            value: '$totalModules',
            icon: Icons.view_module,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _StatCard(
            label: 'Warnings',
            value: '${result.totalWarnings}',
            icon: Icons.warning,
            color: result.totalWarnings > 0 ? AppTheme.warning : AppTheme.textSecondary,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _StatCard(
            label: 'Errors',
            value: '${result.totalErrors}',
            icon: Icons.error,
            color: result.totalErrors > 0 ? AppTheme.error : AppTheme.success,
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: AppTheme.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
