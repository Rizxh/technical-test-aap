import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/todo.dart';
import '../../domain/todo_status.dart';

class TodoListTile extends StatelessWidget {
  const TodoListTile({
    super.key,
    required this.todo,
    required this.onEdit,
    required this.onDelete,
  });

  final Todo todo;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateStr = DateFormat.yMMMd().add_jm().format(todo.createdDate);
    final isDone = todo.status == TodoStatus.done;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              todo.title,
              style: theme.textTheme.titleMedium?.copyWith(
                decoration: isDone ? TextDecoration.lineThrough : null,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              todo.description,
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Chip(
                  label: Text(todo.status.label),
                  visualDensity: VisualDensity.compact,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    dateStr,
                    style: theme.textTheme.bodySmall,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                TextButton(onPressed: onEdit, child: const Text('Edit')),
                TextButton(onPressed: onDelete, child: const Text('Hapus')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
