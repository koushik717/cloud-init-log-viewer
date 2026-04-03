enum LogLevel { debug, info, warning, error, critical }

class LogLine {
  final DateTime timestamp;
  final String component;
  final LogLevel level;
  final String message;

  LogLine({
    required this.timestamp,
    required this.component,
    required this.level,
    required this.message,
  });
}
