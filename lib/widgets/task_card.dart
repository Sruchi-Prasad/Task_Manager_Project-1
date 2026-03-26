import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onTap;
  final String searchQuery;

  const TaskCard({
    super.key,
    required this.task,
    required this.onTap,
    this.searchQuery = '',
  });

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TaskProvider>(context, listen: false);
    final isBlocked = provider.isTaskBlocked(task.id);
    final blockingTaskTitle = provider.getBlockingTaskTitle(task.blockedBy);

    Color statusColor;
    switch (task.status) {
      case TaskStatus.todo:
        statusColor = Colors.blue;
        break;
      case TaskStatus.inProgress:
        statusColor = Colors.orange;
        break;
      case TaskStatus.done:
        statusColor = Colors.green;
        break;
    }

    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: isBlocked ? Colors.grey[200] : Colors.white,
      child: Opacity(
        opacity: isBlocked ? 0.6 : 1.0,
        child: InkWell(
          onTap: isBlocked ? null : onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: _highlightedText(
                        task.title,
                        searchQuery,
                        const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: statusColor.withAlpha((0.2 * 255).toInt()),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _statusText(task.status),
                        style: TextStyle(
                          color: statusColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  task.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.grey[600]),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          DateFormat('MMM dd, yyyy').format(task.dueDate),
                          style: const TextStyle(color: Colors.grey, fontSize: 13),
                        ),
                      ],
                    ),
                    if (isBlocked)
                      Row(
                        children: [
                          const Icon(Icons.lock, size: 16, color: Colors.red),
                          const SizedBox(width: 4),
                          Text(
                            'Blocked by: $blockingTaskTitle',
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _statusText(TaskStatus status) {
    switch (status) {
      case TaskStatus.todo:
        return 'TO-DO';
      case TaskStatus.inProgress:
        return 'IN PROGRESS';
      case TaskStatus.done:
        return 'DONE';
    }
  }

  Widget _highlightedText(String text, String query, TextStyle style) {
    if (query.isEmpty || !text.toLowerCase().contains(query.toLowerCase())) {
      return Text(text, style: style);
    }

    final matches = query.toLowerCase().allMatches(text.toLowerCase());
    if (matches.isEmpty) return Text(text, style: style);

    List<TextSpan> spans = [];
    int start = 0;

    for (var match in matches) {
      if (match.start > start) {
        spans.add(TextSpan(text: text.substring(start, match.start)));
      }
      spans.add(TextSpan(
        text: text.substring(match.start, match.end),
        style: const TextStyle(backgroundColor: Colors.yellow, color: Colors.black),
      ));
      start = match.end;
    }

    if (start < text.length) {
      spans.add(TextSpan(text: text.substring(start)));
    }

    return RichText(
      text: TextSpan(style: style.copyWith(color: Colors.black), children: spans),
    );
  }
}
