import 'log_line.dart';

enum ModuleStatus { success, warning, error, unknown }

class ModuleRun {
  final String name;
  final DateTime startTime;
  final DateTime? endTime;
  final ModuleStatus status;
  final List<LogLine> lines;

  ModuleRun({
    required this.name,
    required this.startTime,
    this.endTime,
    required this.status,
    required this.lines,
  });

  Duration? get duration =>
      endTime != null ? endTime!.difference(startTime) : null;

  int get warningCount =>
      lines.where((l) => l.level == LogLevel.warning).length;

  int get errorCount => lines
      .where((l) => l.level == LogLevel.error || l.level == LogLevel.critical)
      .length;
}
