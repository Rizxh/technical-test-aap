import 'package:flutter/material.dart';

import '../../domain/todo.dart';
import '../../domain/todo_status.dart';

class TodoFormResult {
  const TodoFormResult({
    required this.title,
    required this.description,
    required this.status,
  });

  final String title;
  final String description;
  final TodoStatus status;
}

class TodoFormSheet extends StatefulWidget {
  const TodoFormSheet({
    super.key,
    this.initial,
  });

  final Todo? initial;

  @override
  State<TodoFormSheet> createState() => _TodoFormSheetState();
}

class _TodoFormSheetState extends State<TodoFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descController;
  late TodoStatus _status;

  @override
  void initState() {
    super.initState();
    final i = widget.initial;
    _titleController = TextEditingController(text: i?.title ?? '');
    _descController = TextEditingController(text: i?.description ?? '');
    _status = i?.status ?? TodoStatus.pending;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.of(context).pop(
      TodoFormResult(
        title: _titleController.text.trim(),
        description: _descController.text.trim(),
        status: _status,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.initial != null;
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.paddingOf(context).bottom + 16,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              isEdit ? 'Edit Todo' : 'Tambah Todo',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Title wajib diisi';
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _descController,
              decoration: const InputDecoration(labelText: 'Description'),
              maxLines: 3,
              validator: (v) {
                if (v == null || v.trim().isEmpty) {
                  return 'Description wajib diisi';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Status',
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
            const SizedBox(height: 8),
            SegmentedButton<TodoStatus>(
              emptySelectionAllowed: false,
              segments: TodoStatus.values
                  .map(
                    (s) => ButtonSegment<TodoStatus>(
                      value: s,
                      label: Text(s.label),
                    ),
                  )
                  .toList(),
              selected: <TodoStatus>{_status},
              onSelectionChanged: (selection) {
                if (selection.isEmpty) return;
                setState(() => _status = selection.first);
              },
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: _submit,
              child: Text(isEdit ? 'Simpan' : 'Tambah'),
            ),
          ],
        ),
      ),
    );
  }
}

Future<TodoFormResult?> showTodoFormSheet(
  BuildContext context, {
  Todo? initial,
}) {
  return showModalBottomSheet<TodoFormResult>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (ctx) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(ctx).bottom,
        ),
        child: TodoFormSheet(initial: initial),
      );
    },
  );
}
