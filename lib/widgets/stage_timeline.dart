import 'package:flutter/material.dart';
import '../models/boot_stage.dart';
import '../models/module_run.dart'; // Needed if referencing ModuleStatus explicitly but it's from boot_stage
import '../theme.dart';

class StageTimeline extends StatelessWidget {
  final List<BootStage> stages;

  const StageTimeline({super.key, required this.stages});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: List.generate(stages.length * 2 - 1, (index) {
          if (index.isOdd) {
            return const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Icon(Icons.arrow_forward_ios, size: 16, color: AppTheme.textSecondary),
            );
          }
          final stageIndex = index ~/ 2;
          return Expanded(child: _StageBox(stage: stages[stageIndex]));
        }),
      ),
    );
  }
}

class _StageBox extends StatelessWidget {
  final BootStage stage;

  const _StageBox({required this.stage});

  @override
  Widget build(BuildContext context) {
    Color borderColor = AppTheme.surface;
    Color statusColor = AppTheme.success;

    if (stage.status == BootStageStatus.error) {
      borderColor = AppTheme.error;
      statusColor = AppTheme.error;
    } else if (stage.status == BootStageStatus.warning) {
      borderColor = AppTheme.warning;
      statusColor = AppTheme.warning;
    }

    final durationStr = stage.duration != null
        ? '${(stage.duration!.inMilliseconds / 1000).toStringAsFixed(1)}s'
        : '--';

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.card,
        border: Border.all(color: borderColor, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            stage.name,
            style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textPrimary, fontSize: 13),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.circle, size: 10, color: statusColor),
              const SizedBox(width: 4),
              Text(
                durationStr,
                style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
              ),
              const SizedBox(width: 8),
              Text(
                '${stage.totalModules} mod',
                style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
              ),
            ],
          )
        ],
      ),
    );
  }
}
