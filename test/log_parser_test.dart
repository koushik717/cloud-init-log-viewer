import 'package:flutter_test/flutter_test.dart';
import '../lib/services/log_parser.dart';
import '../lib/models/log_line.dart';
import '../lib/models/module_run.dart';

void main() {
  group('LogParser', () {
    const String sampleLog = '''
2024-01-15 10:23:40,100 - cloudinit.sources - INFO - cloud-init v. 23.4 running 'init-local' at Mon, 15 Jan 2024
2024-01-15 10:23:40,200 - cloudinit.stages - INFO - running init-local
2024-01-15 10:23:40,300 - cloudinit.stages - INFO - Running module local-hostname
2024-01-15 10:23:40,450 - cloudinit.modules.cc_hostname - DEBUG - Setting hostname to ubuntu-server
2024-01-15 10:23:40,500 - cloudinit.stages - INFO - Running module ssh
2024-01-15 10:23:40,800 - cloudinit.modules.cc_ssh - DEBUG - Generating SSH keys
2024-01-15 10:23:41,100 - cloudinit.modules.cc_ssh - WARNING - SSH key already exists, skipping
2024-01-15 10:23:41,200 - cloudinit.stages - INFO - running 'init'
2024-01-15 10:23:41,300 - cloudinit.stages - INFO - Running module users-groups
2024-01-15 10:23:41,500 - cloudinit.modules.cc_users_groups - DEBUG - Adding user ubuntu
2024-01-15 10:23:41,700 - cloudinit.modules.cc_users_groups - DEBUG - Adding user to sudo group
2024-01-15 10:23:41,900 - cloudinit.stages - INFO - Running module write-files
2024-01-15 10:23:42,000 - cloudinit.modules.cc_write_files - DEBUG - Writing /etc/docker/daemon.json
2024-01-15 10:23:42,100 - cloudinit.stages - INFO - running 'modules:config'
2024-01-15 10:23:42,200 - cloudinit.stages - INFO - Running module timezone
2024-01-15 10:23:42,300 - cloudinit.modules.cc_timezone - DEBUG - Setting timezone to UTC
2024-01-15 10:23:42,400 - cloudinit.stages - INFO - Running module ntp
2024-01-15 10:23:42,500 - cloudinit.modules.cc_ntp - DEBUG - Configuring NTP servers
2024-01-15 10:23:42,700 - cloudinit.stages - INFO - Running module packages
2024-01-15 10:23:43,000 - cloudinit.modules.cc_packages - ERROR - Failed to install docker.io: connection refused
2024-01-15 10:23:43,100 - cloudinit.stages - INFO - running 'modules:final'
2024-01-15 10:23:43,200 - cloudinit.stages - INFO - Running module final-message
2024-01-15 10:23:43,300 - cloudinit.modules.cc_final_message - INFO - Boot complete
2024-01-15 10:23:43,400 - cloudinit.stages - INFO - Running module runcmd
2024-01-15 10:23:43,600 - cloudinit.modules.cc_runcmd - DEBUG - Running: systemctl enable docker
2024-01-15 10:23:43,900 - cloudinit.modules.cc_runcmd - DEBUG - Running: systemctl start docker
2024-01-15 10:23:44,200 - cloudinit.modules.cc_runcmd - INFO - All commands completed successfully
''';

    test('parseLine returns null for malformed input', () {
      expect(LogParser.parseLine('malformed line without format'), isNull);
    });

    test('parseLine correctly parses timestamp and levels', () {
      final dbgLine = LogParser.parseLine('2024-01-15 10:23:40,100 - comp - DEBUG - msg');
      expect(dbgLine?.timestamp, DateTime(2024, 1, 15, 10, 23, 40, 100));
      expect(dbgLine?.level, LogLevel.debug);

      final errLine = LogParser.parseLine('2024-01-15 10:23:40,100 - comp - ERROR - msg');
      expect(errLine?.level, LogLevel.error);
    });

    test('parse() finds all 4 boot stages', () {
      final result = LogParser.parse(sampleLog);
      expect(result.stages.length, 4);
      expect(result.stages.map((s) => s.name).toList(), [
        'init-local',
        'init',
        'modules:config',
        'modules:final'
      ]);
    });

    test('parse() correctly groups lines into modules', () {
      final result = LogParser.parse(sampleLog);
      final initStage = result.stages[1]; // init stage
      expect(initStage.modules.length, 2); // users-groups, write-files
      expect(initStage.modules[0].name, 'users-groups');
      expect(initStage.modules[0].lines.length, 3); // The 'Running module...', 'Adding user ubuntu', 'Adding user to sudo'
    });

    test('parse() correctly identifies module with ERROR as failed', () {
      final result = LogParser.parse(sampleLog);
      final configStage = result.stages[2]; // modules:config
      final packagesModule = configStage.modules.last; // packages
      expect(packagesModule.name, 'packages');
      expect(packagesModule.status, ModuleStatus.error);
      expect(result.totalErrors, 1);
    });

    test('parse() correctly calculates total boot time', () {
      final result = LogParser.parse(sampleLog);
      // first time is 40,100, last is 44,200. diff is 4100ms
      expect(result.totalBootTime?.inMilliseconds, 4100);
    });

    test('parse() extracts cloud-init version', () {
      final result = LogParser.parse(sampleLog);
      expect(result.cloudInitVersion, '23.4');
    });

    test('parse() handles empty string input gracefully', () {
      final result = LogParser.parse('');
      expect(result.stages.length, 0);
      expect(result.allLines.length, 0);
    });

    test('parse() handles log with only one stage', () {
      final log = '''
2024-01-15 10:23:40,100 - source - INFO - running 'init-local'
2024-01-15 10:23:40,300 - stages - INFO - Running module local-hostname
''';
      final result = LogParser.parse(log);
      expect(result.stages.length, 1);
      expect(result.stages[0].modules.length, 1);
    });
  });
}
