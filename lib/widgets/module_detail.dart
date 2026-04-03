import 'package:flutter/material.dart';
import '../models/module_run.dart';
import '../models/log_line.dart';
import '../theme.dart';

class ModuleDetail extends StatelessWidget {
  final ModuleRun? selectedModule;

  const ModuleDetail({super.key, required this.selectedModule});

  @override
  Widget build(BuildContext context) {
    if (selectedModule == null) {
      return const Center(
        child: Text(
          'Select a module to see details',
          style: TextStyle(color: AppTheme.textSecondary, fontSize: 16),
        ),
      );
    }

    final module = selectedModule!;
    Color statusColor = AppTheme.success;
    String statusText = 'Success';
    if (module.status == ModuleStatus.error) {
      statusColor = AppTheme.error;
      statusText = 'Error';
    } else if (module.status == ModuleStatus.warning) {
      statusColor = AppTheme.warning;
      statusText = 'Warning';
    }

    final durationStr = module.duration != null ? '${module.duration!.inMilliseconds}ms' : 'Unknown';

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                module.name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(width: 16),
              Chip(
                label: Text(statusText, style: const TextStyle(fontWeight: FontWeight.bold)),
                backgroundColor: statusColor.withOpacity(0.2),
                labelStyle: TextStyle(color: statusColor),
                side: BorderSide(color: statusColor),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _DetailStat('Duration', durationStr),
              const SizedBox(width: 24),
              _DetailStat('Lines', '${module.lines.length}'),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(color: AppTheme.surface, thickness: 2),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              itemCount: module.lines.length,
              itemBuilder: (context, index) {
                final line = module.lines[index];
                return _LogLineView(line: line);
              },
            ),
          )
        ],
      ),
    );
  }
}

class _DetailStat extends StatelessWidget {
  final String label;
  final String value;
  const _DetailStat(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
        const SizedBox(height: 2),
        Text(value, style: const TextStyle(color: AppTheme.textPrimary, fontSize: 16, fontWeight: FontWeight.w600)),
      ],
    );
  }
}

class _LogLineView extends StatelessWidget {
  final LogLine line;
  const _LogLineView({required this.line});

  @override
  Widget build(BuildContext context) {
    Color badgeColor;
    switch (line.level) {
      case LogLevel.debug:
        badgeColor = AppTheme.ubuntuCoolGrey;
        break;
      case LogLevel.info:
        badgeColor = Colors.blue;
        break;
      case LogLevel.warning:
        badgeColor = AppTheme.warning;
        break;
      case LogLevel.error:
        badgeColor = AppTheme.error;
        break;
      case LogLevel.critical:
        badgeColor = Colors.red[900]!;
        break;
    }

    final timeStr = '${line.timestamp.hour.toString().padLeft(2, '0')}:'
        '${line.timestamp.minute.toString().padLeft(2, '0')}:'
        '${line.timestamp.second.toString().padLeft(2, '0')}';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 70,
            child: Text(
              timeStr,
              style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13),
            ),
          ),
          Container(
            width: 60,
            alignment: Alignment.center,
            margin: const EdgeInsets.symmetric(horizontal: 8),
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: badgeColor,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              line.level.name.toUpperCase(),
              style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(
              line.message,
              style: const TextStyle(color: AppTheme.textPrimary, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
