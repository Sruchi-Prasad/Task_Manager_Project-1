import 'package:hive_flutter/hive_flutter.dart';
import '../models/task.dart';

class HiveService {
  static const String _taskBoxName = 'tasks';
  static const String _draftBoxName = 'drafts';

  Future<void> init() async {
    await Hive.initFlutter();
    
    // Register Adapters
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(TaskStatusAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(TaskAdapter());
    }

    await Hive.openBox<Task>(_taskBoxName);
    await Hive.openBox(_draftBoxName);
  }

  Box<Task> get taskBox => Hive.box<Task>(_taskBoxName);
  Box get draftBox => Hive.box(_draftBoxName);

  List<Task> getAllTasks() {
    return taskBox.values.toList();
  }

  Future<void> addTask(Task task) async {
    await taskBox.put(task.id, task);
  }

  Future<void> updateTask(Task task) async {
    await taskBox.put(task.id, task);
  }

  Future<void> deleteTask(String id) async {
    await taskBox.delete(id);
  }

  Future<void> clearAll() async {
    await taskBox.clear();
  }
}
