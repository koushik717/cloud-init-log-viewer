import 'boot_stage.dart';
import 'log_line.dart';

class ParseResult {
  final List<BootStage> stages;
  final List<LogLine> allLines;
  final DateTime? bootStart;
  final DateTime? bootEnd;
  final Duration? totalBootTime;
  final String cloudInitVersion;
  final int totalErrors;
  final int totalWarnings;
  final bool hasErrors;

  ParseResult({
    required this.stages,
    required this.allLines,
    this.bootStart,
    this.bootEnd,
    this.totalBootTime,
    required this.cloudInitVersion,
    required this.totalErrors,
    required this.totalWarnings,
    required this.hasErrors,
  });
}
