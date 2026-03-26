import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';

class TaskFormScreen extends StatefulWidget {
  final Task? task;

  const TaskFormScreen({super.key, this.task});

  @override
  State<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  DateTime? _selectedDate;
  TaskStatus _selectedStatus = TaskStatus.todo;
  String? _selectedBlockedBy;

  @override
  void initState() {
    super.initState();
    final provider = context.read<TaskProvider>();
    
    if (widget.task != null) {
      _titleController = TextEditingController(text: widget.task!.title);
      _descriptionController = TextEditingController(text: widget.task!.description);
      _selectedDate = widget.task!.dueDate;
      _selectedStatus = widget.task!.status;
      _selectedBlockedBy = widget.task!.blockedBy;
    } else {
      _titleController = TextEditingController(text: provider.draftTitle);
      _descriptionController = TextEditingController(text: provider.draftDescription);
      _selectedDate = provider.draftDueDate;
      _selectedBlockedBy = provider.draftBlockedBy;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _saveDraft() {
    if (widget.task == null) {
      context.read<TaskProvider>().updateDraft(
            title: _titleController.text,
            description: _descriptionController.text,
            dueDate: _selectedDate,
            blockedBy: _selectedBlockedBy,
            status: _selectedStatus,
          );
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _saveDraft();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TaskProvider>();
    final allTasks = provider.tasks.where((t) => t.id != widget.task?.id).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task == null ? 'Create Task' : 'Edit Task'),
        actions: [
          if (widget.task != null)
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () async {
                await provider.deleteTask(widget.task!.id);
                if (context.mounted) Navigator.pop(context);
              },
            ),
        ],
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(labelText: 'Title', border: OutlineInputBorder()),
                    onChanged: (_) => _saveDraft(),
                    validator: (value) => value == null || value.isEmpty ? 'Please enter a title' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(labelText: 'Description', border: OutlineInputBorder()),
                    maxLines: 3,
                    onChanged: (_) => _saveDraft(),
                    validator: (value) => value == null || value.isEmpty ? 'Please enter a description' : null,
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    title: Text(_selectedDate == null 
                        ? 'Select Due Date' 
                        : 'Due Date: ${DateFormat('MMM dd, yyyy').format(_selectedDate!)}'),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: () => _selectDate(context),
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<TaskStatus>(
                    value: _selectedStatus,
                    decoration: const InputDecoration(labelText: 'Status', border: OutlineInputBorder()),
                    items: TaskStatus.values.map((status) {
                      return DropdownMenuItem(value: status, child: Text(status.name.toUpperCase()));
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _selectedStatus = value);
                        _saveDraft();
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String?>(
                    value: _selectedBlockedBy,
                    decoration: const InputDecoration(
                      labelText: 'Blocked By',
                      border: OutlineInputBorder(),
                      helperText: 'Select a task that must be done first',
                    ),
                    items: [
                      const DropdownMenuItem(value: null, child: Text('None')),
                      ...allTasks.map((t) => DropdownMenuItem(value: t.id, child: Text(t.title))),
                    ],
                    onChanged: (value) {
                      setState(() => _selectedBlockedBy = value);
                      _saveDraft();
                    },
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: provider.isLoading ? null : () async {
                        if (_formKey.currentState!.validate()) {
                          if (widget.task == null) {
                            provider.draftTitle = _titleController.text;
                            provider.draftDescription = _descriptionController.text;
                            provider.draftDueDate = _selectedDate;
                            provider.draftBlockedBy = _selectedBlockedBy;
                            await provider.addTask();
                          } else {
                            final updatedTask = widget.task!.copyWith(
                              title: _titleController.text,
                              description: _descriptionController.text,
                              dueDate: _selectedDate,
                              status: _selectedStatus,
                              blockedBy: _selectedBlockedBy,
                            );
                            await provider.updateTask(updatedTask);
                          }
                          if (context.mounted) Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[700],
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: provider.isLoading 
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(widget.task == null ? 'CREATE' : 'UPDATE'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (provider.isLoading)
            Container(
              color: Colors.black26,
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}
