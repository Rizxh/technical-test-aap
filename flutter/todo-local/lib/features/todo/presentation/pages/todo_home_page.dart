import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/todo.dart';
import '../todo_local_notifier.dart';
import '../widgets/todo_filter_bar.dart';
import '../widgets/todo_form_sheet.dart';
import '../widgets/todo_list_tile.dart';
import '../widgets/todo_search_bar.dart';

class TodoHomePage extends StatefulWidget {
  const TodoHomePage({super.key});

  @override
  State<TodoHomePage> createState() => _TodoHomePageState();
}

class _TodoHomePageState extends State<TodoHomePage> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    final n = context.read<TodoLocalNotifier>();
    _searchController = TextEditingController(text: n.searchQuery);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _openForm({Todo? todo}) async {
    final result = await showTodoFormSheet(context, initial: todo);
    if (!mounted || result == null) return;
    final notifier = context.read<TodoLocalNotifier>();
    if (todo == null) {
      await notifier.addTodo(
        title: result.title,
        description: result.description,
        status: result.status,
      );
    } else {
      await notifier.updateTodo(
        todo.copyWith(
          title: result.title,
          description: result.description,
          status: result.status,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo Local'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openForm(),
        child: const Icon(Icons.add),
      ),
      body: Consumer<TodoLocalNotifier>(
        builder: (context, notifier, _) {
          if (notifier.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return RefreshIndicator(
            onRefresh: notifier.load,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (notifier.loadError != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: MaterialBanner(
                      content: Text(notifier.loadError!),
                      actions: [
                        TextButton(
                          onPressed: notifier.load,
                          child: const Text('Coba lagi'),
                        ),
                      ],
                    ),
                  ),
                TodoSearchBar(
                  controller: _searchController,
                  onChanged: notifier.setSearchQuery,
                ),
                const SizedBox(height: 12),
                TodoFilterBar(
                  filter: notifier.filter,
                  onChanged: notifier.setFilter,
                ),
                const SizedBox(height: 16),
                if (notifier.visibleTodos.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 48),
                    child: Center(
                      child: Text('Belum ada todo yang cocok.'),
                    ),
                  )
                else
                  ...notifier.visibleTodos.map(
                    (todo) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: TodoListTile(
                        todo: todo,
                        onEdit: () => _openForm(todo: todo),
                        onDelete: () async {
                          final ok = await showDialog<bool>(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text('Hapus todo?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(ctx, false),
                                  child: const Text('Batal'),
                                ),
                                FilledButton(
                                  onPressed: () => Navigator.pop(ctx, true),
                                  child: const Text('Hapus'),
                                ),
                              ],
                            ),
                          );
                          if (ok == true && context.mounted) {
                            await context
                                .read<TodoLocalNotifier>()
                                .deleteTodo(todo.id);
                          }
                        },
                        onToggleStatus: () =>
                            notifier.toggleStatus(todo.id),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
