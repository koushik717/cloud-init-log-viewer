import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/log_provider.dart';
import '../widgets/summary_bar.dart';
import '../widgets/stage_timeline.dart';
import '../widgets/module_list.dart';
import '../widgets/module_detail.dart';
import '../widgets/duration_chart.dart';
import '../theme.dart';

class ResultsScreen extends StatelessWidget {
  const ResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<LogProvider>();
    final result = provider.result;

    if (result == null) return const SizedBox.shrink();

    final allModules = result.stages.expand((s) => s.modules).toList();
    final isSearchActive = provider.searchQuery.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: provider.reset,
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Boot Analysis', style: TextStyle(fontSize: 18)),
            Text(
              'cloud-init v. ${result.cloudInitVersion}',
              style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
            ),
          ],
        ),
        actions: [
          Container(
            width: 200,
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            decoration: BoxDecoration(
              color: AppTheme.background,
              borderRadius: BorderRadius.circular(4),
            ),
            child: TextField(
              onChanged: provider.setSearchQuery,
              style: const TextStyle(color: AppTheme.textPrimary, fontSize: 14),
              decoration: const InputDecoration(
                hintText: 'Search modules...',
                hintStyle: TextStyle(color: AppTheme.textSecondary),
                prefixIcon: Icon(Icons.search, color: AppTheme.textSecondary, size: 18),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          )
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 800;

          if (isWide) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SummaryBar(result: result),
                        StageTimeline(stages: result.stages),
                        if (isSearchActive)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              'Showing ${provider.filteredModules.length} of ${allModules.length} modules',
                              style: const TextStyle(color: AppTheme.textSecondary, fontStyle: FontStyle.italic),
                            ),
                          ),
                        Expanded(
                          child: ModuleList(
                            stages: result.stages,
                            selectedModule: provider.selectedModule,
                            onModuleSelected: provider.selectModule,
                            searchQuery: provider.searchQuery,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 16.0, right: 16.0, bottom: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (allModules.length >= 2 && !isSearchActive) ...[
                          DurationChart(modules: allModules),
                          const SizedBox(height: 16),
                        ],
                        Expanded(child: ModuleDetail(selectedModule: provider.selectedModule)),
                      ],
                    ),
                  ),
                ),
              ],
            );
          } else {
            return Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SummaryBar(result: result),
                      StageTimeline(stages: result.stages),
                      if (isSearchActive)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            'Showing ${provider.filteredModules.length} of ${allModules.length} modules',
                            style: const TextStyle(color: AppTheme.textSecondary, fontStyle: FontStyle.italic),
                          ),
                        ),
                      Expanded(
                        child: ModuleList(
                          stages: result.stages,
                          selectedModule: provider.selectedModule,
                          onModuleSelected: provider.selectModule,
                          searchQuery: provider.searchQuery,
                        ),
                      ),
                    ],
                  ),
                ),
                if (provider.selectedModule != null)
                  Positioned.fill(
                    child: Container(
                      color: AppTheme.background.withOpacity(0.9),
                      padding: const EdgeInsets.only(top: 40),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.topRight,
                            child: IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () => provider.selectModule(null),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: ModuleDetail(selectedModule: provider.selectedModule),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            );
          }
        },
      ),
    );
  }
}
