import 'module_run.dart';

enum BootStageStatus { success, warning, error, unknown }

class BootStage {
  final String name;
  final DateTime? startTime;
  final DateTime? endTime;
  final List<ModuleRun> modules;
  final BootStageStatus status;

  BootStage({
    required this.name,
    this.startTime,
    this.endTime,
    required this.modules,
    required this.status,
  });

  Duration? get duration => (startTime != null && endTime != null)
      ? endTime!.difference(startTime!)
      : null;

  int get totalModules => modules.length;

  int get failedModules =>
      modules.where((m) => m.status == ModuleStatus.error).length;
}
