import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../models/task.dart';
import '../services/hive_service.dart';

class TaskProvider with ChangeNotifier {
  final HiveService _hiveService;
  List<Task> _tasks = [];
  bool _isLoading = false;
  String _searchQuery = '';
  TaskStatus? _filterStatus;

  // Form Draft Data
  String draftTitle = '';
  String draftDescription = '';
  DateTime? draftDueDate;
  String? draftBlockedBy;

  TaskProvider(this._hiveService) {
    _loadTasks();
  }

  List<Task> get tasks {
    var filtered = _tasks.where((task) {
      final matchesSearch = task.title.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesFilter = _filterStatus == null || task.status == _filterStatus;
      return matchesSearch && matchesFilter;
    }).toList();
    return filtered;
  }

  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;
  TaskStatus? get filterStatus => _filterStatus;

  void _loadTasks() {
    _tasks = _hiveService.getAllTasks();
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setFilterStatus(TaskStatus? status) {
    _filterStatus = status;
    notifyListeners();
  }

  Future<void> addTask() async {
    if (draftTitle.isEmpty) return;

    _isLoading = true;
    notifyListeners();

    // Simulate 2-second delay
    await Future.delayed(const Duration(seconds: 2));

    final newTask = Task(
      id: const Uuid().v4(),
      title: draftTitle,
      description: draftDescription,
      dueDate: draftDueDate ?? DateTime.now(),
      status: TaskStatus.todo,
      blockedBy: draftBlockedBy,
    );

    await _hiveService.addTask(newTask);
    _tasks.add(newTask);
    
    // Clear draft
    _clearDraft();
    
    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateTask(Task task) async {
    _isLoading = true;
    notifyListeners();

    // Simulate 2-second delay
    await Future.delayed(const Duration(seconds: 2));

    await _hiveService.updateTask(task);
    final index = _tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      _tasks[index] = task;
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> deleteTask(String id) async {
    await _hiveService.deleteTask(id);
    _tasks.removeWhere((t) => t.id == id);
    notifyListeners();
  }

  void _clearDraft() {
    draftTitle = '';
    draftDescription = '';
    draftDueDate = null;
    draftBlockedBy = null;
  }

  bool isTaskBlocked(String taskId) {
    final task = _tasks.firstWhere((t) => t.id == taskId);
    if (task.blockedBy == null) return false;
    
    try {
      final blockingTask = _tasks.firstWhere((t) => t.id == task.blockedBy);
      return blockingTask.status != TaskStatus.done;
    } catch (e) {
      return false; // Blocking task not found
    }
  }

  String? getBlockingTaskTitle(String? blockingTaskId) {
    if (blockingTaskId == null) return null;
    try {
      return _tasks.firstWhere((t) => t.id == blockingTaskId).title;
    } catch (e) {
      return null;
    }
  }
}
