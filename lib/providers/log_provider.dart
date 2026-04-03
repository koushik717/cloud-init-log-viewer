import 'package:flutter/material.dart';
import '../models/module_run.dart';
import '../models/parse_result.dart';
import '../services/log_parser.dart';

enum AppState { empty, parsing, loaded, error }

class LogProvider extends ChangeNotifier {
  AppState _state = AppState.empty;
  ParseResult? _result;
  String? _errorMessage;
  String? _rawLog;
  ModuleRun? _selectedModule;
  String _searchQuery = '';

  AppState get state => _state;
  ParseResult? get result => _result;
  String? get errorMessage => _errorMessage;
  ModuleRun? get selectedModule => _selectedModule;
  String get searchQuery => _searchQuery;

  Future<void> loadLog(String rawLog) async {
    _rawLog = rawLog;
    _state = AppState.parsing;
    _errorMessage = null;
    notifyListeners();

    // Small delay to allow UI to update to parsing state
    await Future.delayed(const Duration(milliseconds: 100));

    try {
      final res = LogParser.parse(rawLog);
      _result = res;
      _state = AppState.loaded;
    } catch (e) {
      _state = AppState.error;
      _errorMessage = e.toString();
    }
    notifyListeners();
  }

  void selectModule(ModuleRun? module) {
    _selectedModule = module;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    if (_selectedModule != null && query.isNotEmpty && !_selectedModule!.name.toLowerCase().contains(query.toLowerCase())) {
      _selectedModule = null; // deselect if filtered out
    }
    notifyListeners();
  }

  List<ModuleRun> get filteredModules {
    if (_result == null) return [];
    final allModules = _result!.stages.expand((s) => s.modules).toList();
    if (_searchQuery.isEmpty) return allModules;
    
    final query = _searchQuery.toLowerCase();
    return allModules.where((m) => m.name.toLowerCase().contains(query)).toList();
  }

  void reset() {
    _state = AppState.empty;
    _result = null;
    _errorMessage = null;
    _rawLog = null;
    _selectedModule = null;
    _searchQuery = '';
    notifyListeners();
  }
}
