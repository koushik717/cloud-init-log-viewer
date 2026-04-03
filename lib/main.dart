import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/log_provider.dart';
import 'screens/input_screen.dart';
import 'screens/results_screen.dart';
import 'theme.dart';
import 'constants.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => LogProvider(),
      child: const CloudInitLogViewerApp(),
    ),
  );
}

class CloudInitLogViewerApp extends StatelessWidget {
  const CloudInitLogViewerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appTitle,
      theme: AppTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      home: Consumer<LogProvider>(
        builder: (context, provider, child) {
          if (provider.state == AppState.empty || provider.state == AppState.error || provider.state == AppState.parsing) {
            return const Scaffold(
              body: InputScreen(),
            );
          } else if (provider.state == AppState.loaded) {
            return const ResultsScreen();
          }
          return const Scaffold(
            body: Center(child: Text('Unknown state')),
          );
        },
      ),
    );
  }
}
