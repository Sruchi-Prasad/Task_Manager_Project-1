import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../models/task.dart';
import '../widgets/task_card.dart';
import 'task_form_screen.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      context.read<TaskProvider>().setSearchQuery(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('My Tasks', style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        actions: [
          Consumer<TaskProvider>(
            builder: (context, provider, child) => PopupMenuButton<TaskStatus?>(
              icon: const Icon(Icons.filter_list),
              onSelected: (status) {
                provider.setFilterStatus(status);
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: null,
                  child: Row(
                    children: [
                      Icon(Icons.check, color: provider.filterStatus == null ? Colors.blue : Colors.transparent),
                      const SizedBox(width: 8),
                      const Text("All"),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: TaskStatus.todo,
                  child: Row(
                    children: [
                      Icon(Icons.check, color: provider.filterStatus == TaskStatus.todo ? Colors.blue : Colors.transparent),
                      const SizedBox(width: 8),
                      const Text("To-Do"),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: TaskStatus.inProgress,
                  child: Row(
                    children: [
                      Icon(Icons.check, color: provider.filterStatus == TaskStatus.inProgress ? Colors.blue : Colors.transparent),
                      const SizedBox(width: 8),
                      const Text("In Progress"),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: TaskStatus.done,
                  child: Row(
                    children: [
                      Icon(Icons.check, color: provider.filterStatus == TaskStatus.done ? Colors.blue : Colors.transparent),
                      const SizedBox(width: 8),
                      const Text("Done"),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Search tasks...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              ),
            ),
          ),
          Expanded(
            child: Consumer<TaskProvider>(
              builder: (context, provider, child) {
                final tasks = provider.tasks;
                
                if (tasks.isEmpty) {
                  return const Center(child: Text("No tasks found"));
                }
                
                return ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final task = tasks[index];
                    return TaskCard(
                      task: task,
                      searchQuery: provider.searchQuery,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TaskFormScreen(task: task),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TaskFormScreen()),
          );
        },
        label: const Text("Create Task"),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.blue[700],
      ),
    );
  }
}
