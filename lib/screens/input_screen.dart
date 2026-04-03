import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/log_provider.dart';
import '../theme.dart';
import '../constants.dart';

class InputScreen extends StatefulWidget {
  const InputScreen({super.key});

  @override
  State<InputScreen> createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<LogProvider>();
    final isParsing = provider.state == AppState.parsing;

    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 800),
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.cloud, color: AppTheme.ubuntuOrange, size: 36),
                SizedBox(width: 12),
                Text(
                  'cloud-init',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
                Text(
                  ' Log Viewer',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w300,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Container(
              height: 300,
              decoration: BoxDecoration(
                color: AppTheme.background,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppTheme.textSecondary.withOpacity(0.3)),
              ),
              child: TextField(
                controller: _controller,
                maxLines: null,
                enabled: !isParsing,
                style: const TextStyle(fontFamily: 'monospace', color: AppTheme.textPrimary),
                decoration: const InputDecoration(
                  hintText: pasteHint,
                  hintStyle: TextStyle(color: AppTheme.textSecondary),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(16),
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (provider.state == AppState.error) ...[
              Text(
                provider.errorMessage ?? 'An error occurred',
                style: const TextStyle(color: AppTheme.error),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
            ],
            if (isParsing)
              const Center(
                child: Column(
                  children: [
                    CircularProgressIndicator(color: AppTheme.ubuntuOrange),
                    SizedBox(height: 16),
                    Text('Analyzing...', style: TextStyle(color: AppTheme.textSecondary)),
                  ],
                ),
              )
            else
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      _controller.text = sampleLog;
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.textPrimary,
                      side: const BorderSide(color: AppTheme.ubuntuWarmGrey),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    ),
                    child: const Text(sampleLogButtonLabel),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () {
                      if (_controller.text.trim().isNotEmpty) {
                        provider.loadLog(_controller.text);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.ubuntuOrange,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    ),
                    child: const Text(parseButtonLabel),
                  ),
                ],
              ),
            const SizedBox(height: 32),
            const Text(
              'Find your log at /var/log/cloud-init.log on any Ubuntu system\nOr generate one with: cloud-init collect-logs',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppTheme.textSecondary, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
