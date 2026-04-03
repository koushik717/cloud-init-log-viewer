import 'package:flutter/material.dart';
import '../models/boot_stage.dart';
import '../models/module_run.dart';
import '../theme.dart';

class ModuleList extends StatelessWidget {
  final List<BootStage> stages;
  final ModuleRun? selectedModule;
  final Function(ModuleRun) onModuleSelected;
  final String searchQuery;

  const ModuleList({
    super.key,
    required this.stages,
    required this.selectedModule,
    required this.onModuleSelected,
    required this.searchQuery,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> listItems = [];
    final activeQuery = searchQuery.toLowerCase();

    for (var stage in stages) {
      final filteredModules = stage.modules.where((m) => m.name.toLowerCase().contains(activeQuery)).toList();
      if (filteredModules.isEmpty) continue;

      listItems.add(
        Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 8),
          child: Row(
            children: [
              Text(
                stage.name,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.ubuntuOrange,
                ),
              ),
              const Spacer(),
              Text(
                '${filteredModules.length} modules',
                style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
              ),
            ],
          ),
        ),
      );

      for (var module in filteredModules) {
        final isSelected = selectedModule == module;
        
        IconData statusIcon = Icons.check_circle;
        Color statusColor = AppTheme.success;
        if (module.status == ModuleStatus.error) {
          statusIcon = Icons.cancel;
          statusColor = AppTheme.error;
        } else if (module.status == ModuleStatus.warning) {
          statusIcon = Icons.warning;
          statusColor = AppTheme.warning;
        }

        final durationStr = module.duration != null ? '${module.duration!.inMilliseconds}ms' : '--';

        listItems.add(
          InkWell(
            onTap: () => onModuleSelected(module),
            child: Container(
              color: isSelected ? AppTheme.surface : AppTheme.background,
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
              child: Row(
                children: [
                  Icon(statusIcon, color: statusColor, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      module.name,
                      style: TextStyle(
                        color: isSelected ? AppTheme.textPrimary : AppTheme.textPrimary.withOpacity(0.9),
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                  Text(
                    durationStr,
                    style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13),
                  ),
                  if (module.warningCount > 0) ...[
                    const SizedBox(width: 8),
                    _Badge(count: module.warningCount, color: AppTheme.warning),
                  ],
                  if (module.errorCount > 0) ...[
                    const SizedBox(width: 4),
                    _Badge(count: module.errorCount, color: AppTheme.error),
                  ],
                ],
              ),
            ),
          )
        );
      }
    }

    if (listItems.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: Text('No modules match search', style: TextStyle(color: AppTheme.textSecondary)),
        ),
      );
    }

    return ListView(
      padding: EdgeInsets.zero,
      children: listItems,
    );
  }
}

class _Badge extends StatelessWidget {
  final int count;
  final Color color;

  const _Badge({required this.count, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Text(
        '$count',
        style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }
}
