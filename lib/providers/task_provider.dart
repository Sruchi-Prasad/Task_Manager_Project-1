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
  TaskStatus draftStatus = TaskStatus.todo;

  TaskProvider(this._hiveService) {
    _loadTasks();
    _loadDraft();
  }

  void _loadDraft() {
    final box = _hiveService.draftBox;
    draftTitle = box.get('title', defaultValue: '');
    draftDescription = box.get('description', defaultValue: '');
    final dueDateTimestamp = box.get('dueDate');
    if (dueDateTimestamp != null) {
      draftDueDate = DateTime.fromMillisecondsSinceEpoch(dueDateTimestamp);
    }
    draftBlockedBy = box.get('blockedBy');
    final statusIndex = box.get('statusIndex');
    if (statusIndex != null) {
      draftStatus = TaskStatus.values[statusIndex];
    }
  }

  void updateDraft({
    String? title,
    String? description,
    DateTime? dueDate,
    String? blockedBy,
    TaskStatus? status,
  }) {
    final box = _hiveService.draftBox;
    if (title != null) {
      draftTitle = title;
      box.put('title', title);
    }
    if (description != null) {
      draftDescription = description;
      box.put('description', description);
    }
    if (dueDate != null) {
      draftDueDate = dueDate;
      box.put('dueDate', dueDate.millisecondsSinceEpoch);
    }
    if (blockedBy != null) {
      draftBlockedBy = blockedBy;
      box.put('blockedBy', blockedBy);
    }
    if (status != null) {
      draftStatus = status;
      box.put('statusIndex', status.index);
    }
    notifyListeners();
  }

  List<Task> get tasks {
    final query = _searchQuery.trim().toLowerCase();
    
    var filtered = _tasks.where((task) {
      final matchesSearch = query.isEmpty || task.title.toLowerCase().contains(query);
      
      // Using explicit enum comparison or null check
      final bool matchesFilter;
      if (_filterStatus == null) {
        matchesFilter = true;
      } else {
        matchesFilter = task.status == _filterStatus;
      }
      
      return matchesSearch && matchesFilter;
    }).toList();
    
    // Debug print (visible in flutter run shell)
    debugPrint('Filtering. Search: "$query", Status: $_filterStatus, Result count: ${filtered.length}');
    
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
    if (_filterStatus == status) return;
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
      status: draftStatus,
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
    draftStatus = TaskStatus.todo;
    _hiveService.draftBox.clear();
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
