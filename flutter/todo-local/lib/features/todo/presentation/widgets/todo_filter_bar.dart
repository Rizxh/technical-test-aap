import 'package:flutter/material.dart';

import '../../domain/todo_filter.dart';

class TodoFilterBar extends StatelessWidget {
  const TodoFilterBar({
    super.key,
    required this.filter,
    required this.onChanged,
  });

  final TodoFilter filter;
  final ValueChanged<TodoFilter> onChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: TodoFilter.values.map((f) {
          final selected = filter == f;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(f.label),
              selected: selected,
              onSelected: (_) => onChanged(f),
            ),
          );
        }).toList(),
      ),
    );
  }
}
