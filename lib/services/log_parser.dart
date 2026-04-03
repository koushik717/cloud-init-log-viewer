import '../models/log_line.dart';
import '../models/module_run.dart';
import '../models/boot_stage.dart';
import '../models/parse_result.dart';

class LogParser {
  static final RegExp _lineRegex = RegExp(
      r'^(\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2},\d{3})\s+-\s+(.*?)\s+-\s+(DEBUG|INFO|WARNING|ERROR|CRITICAL)\s+-\s+(.*)$');

  static LogLine? parseLine(String rawLine) {
    final match = _lineRegex.firstMatch(rawLine.trim());
    if (match == null) return null;

    final dateStr = match.group(1)!.replaceFirst(',', '.');
    final timestamp = DateTime.tryParse(dateStr);
    if (timestamp == null) return null;

    final component = match.group(2)!;
    final levelStr = match.group(3)!;
    final message = match.group(4)!;

    LogLevel level;
    switch (levelStr) {
      case 'DEBUG':
        level = LogLevel.debug;
        break;
      case 'INFO':
        level = LogLevel.info;
        break;
      case 'WARNING':
        level = LogLevel.warning;
        break;
      case 'ERROR':
        level = LogLevel.error;
        break;
      case 'CRITICAL':
        level = LogLevel.critical;
        break;
      default:
        level = LogLevel.info;
    }

    return LogLine(
      timestamp: timestamp,
      component: component,
      level: level,
      message: message,
    );
  }

  static ParseResult parse(String rawLog) {
    final lines = rawLog.split('\n');
    final parsedLines = <LogLine>[];

    for (final line in lines) {
      final parsed = parseLine(line);
      if (parsed != null) {
        parsedLines.add(parsed);
      }
    }

    String cloudInitVersion = 'Unknown';
    int totalErrors = 0;
    int totalWarnings = 0;

    final stages = <BootStage>[];
    String? currentStageName;
    DateTime? stageStartTime;
    List<ModuleRun> currentModules = [];

    String? currentModuleName;
    DateTime? moduleStartTime;
    List<LogLine> currentModuleLines = [];

    void finalizeModule(DateTime? endTime) {
      if (currentModuleName != null && moduleStartTime != null) {
        ModuleStatus status = ModuleStatus.success;
        bool hasWarning = false;

        for (var l in currentModuleLines) {
          if (l.level == LogLevel.error || l.level == LogLevel.critical) {
            status = ModuleStatus.error;
          } else if (l.level == LogLevel.warning && status != ModuleStatus.error) {
            hasWarning = true;
          }
        }
        if (hasWarning && status != ModuleStatus.error) {
          status = ModuleStatus.warning;
        }

        currentModules.add(ModuleRun(
          name: currentModuleName!,
          startTime: moduleStartTime!,
          endTime: endTime,
          status: status,
          lines: List.from(currentModuleLines),
        ));
      }
      currentModuleName = null;
      moduleStartTime = null;
      currentModuleLines.clear();
    }

    void finalizeStage(DateTime? endTime) {
      finalizeModule(endTime);
      if (currentStageName != null) {
        BootStageStatus status = BootStageStatus.success;
        bool hasWarning = false;

        for (var m in currentModules) {
          if (m.status == ModuleStatus.error) {
            status = BootStageStatus.error;
          } else if (m.status == ModuleStatus.warning && status != BootStageStatus.error) {
            hasWarning = true;
          }
        }
        if (hasWarning && status != BootStageStatus.error) {
          status = BootStageStatus.warning;
        }

        stages.add(BootStage(
          name: currentStageName!,
          startTime: stageStartTime,
          endTime: endTime,
          modules: List.from(currentModules),
          status: status,
        ));
      }
      currentStageName = null;
      stageStartTime = null;
      currentModules.clear();
    }

    for (final line in parsedLines) {
      if (line.level == LogLevel.error || line.level == LogLevel.critical) {
        totalErrors++;
      } else if (line.level == LogLevel.warning) {
        totalWarnings++;
      }

      if (line.message.contains('cloud-init v.')) {
        final verMatch = RegExp(r'cloud-init v\.\s+([\d\.]+)').firstMatch(line.message);
        if (verMatch != null) {
          cloudInitVersion = verMatch.group(1)!;
        }
      }

      final msg = line.message;
      if (msg.contains("running 'init-local'")) {
        finalizeStage(line.timestamp);
        currentStageName = 'init-local';
        stageStartTime = line.timestamp;
      } else if (msg.contains("running 'init'")) {
        finalizeStage(line.timestamp);
        currentStageName = 'init';
        stageStartTime = line.timestamp;
      } else if (msg.contains("running 'modules:config'")) {
        finalizeStage(line.timestamp);
        currentStageName = 'modules:config';
        stageStartTime = line.timestamp;
      } else if (msg.contains("running 'modules:final'")) {
        finalizeStage(line.timestamp);
        currentStageName = 'modules:final';
        stageStartTime = line.timestamp;
      }

      if (msg.startsWith('Running module ')) {
        finalizeModule(line.timestamp);
        currentModuleName = msg.replaceFirst('Running module ', '').trim();
        moduleStartTime = line.timestamp;
      }

      if (currentModuleName != null) {
        currentModuleLines.add(line);
      }
    }

    if (parsedLines.isNotEmpty) {
      finalizeStage(parsedLines.last.timestamp);
    }

    DateTime? bootStart = parsedLines.isNotEmpty ? parsedLines.first.timestamp : null;
    DateTime? bootEnd = parsedLines.isNotEmpty ? parsedLines.last.timestamp : null;
    Duration? bootTime = (bootStart != null && bootEnd != null) ? bootEnd.difference(bootStart) : null;

    return ParseResult(
      stages: stages,
      allLines: parsedLines,
      bootStart: bootStart,
      bootEnd: bootEnd,
      totalBootTime: bootTime,
      cloudInitVersion: cloudInitVersion,
      totalErrors: totalErrors,
      totalWarnings: totalWarnings,
      hasErrors: totalErrors > 0,
    );
  }
}
