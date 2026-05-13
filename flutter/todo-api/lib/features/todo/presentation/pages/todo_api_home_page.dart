import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/todo.dart';
import '../todo_api_notifier.dart';
import '../widgets/todo_filter_bar.dart';
import '../widgets/todo_form_sheet.dart';
import '../widgets/todo_list_tile.dart';
import '../widgets/todo_search_bar.dart';

class TodoApiHomePage extends StatefulWidget {
  const TodoApiHomePage({super.key});

  @override
  State<TodoApiHomePage> createState() => _TodoApiHomePageState();
}

class _TodoApiHomePageState extends State<TodoApiHomePage> {
  late final TextEditingController _searchController;
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    final n = context.read<TodoApiNotifier>();
    _searchController = TextEditingController(text: n.searchInput);
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final pos = _scrollController.position;
    if (pos.pixels >= pos.maxScrollExtent - 240) {
      context.read<TodoApiNotifier>().loadMore();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _openForm({Todo? todo}) async {
    final result = await showTodoFormSheet(context, initial: todo);
    if (!mounted || result == null) return;
    final notifier = context.read<TodoApiNotifier>();
    if (todo == null) {
      await notifier.createTodo(
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
        title: const Text('Todo API'),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            onPressed: () => context.read<TodoApiNotifier>().refresh(),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openForm(),
        child: const Icon(Icons.add),
      ),
      body: Consumer<TodoApiNotifier>(
        builder: (context, notifier, _) {
          if (notifier.isLoading && notifier.items.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              if (notifier.error != null)
                MaterialBanner(
                  content: Text(notifier.error!),
                  actions: [
                    TextButton(
                      onPressed: notifier.refresh,
                      child: const Text('Coba lagi'),
                    ),
                  ],
                ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: TodoSearchBar(
                  controller: _searchController,
                  onChanged: notifier.setSearchInput,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: TodoFilterBar(
                  filter: notifier.filter,
                  onChanged: notifier.setFilter,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Total API: ${notifier.total} · Ditampilkan: ${notifier.items.length}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: notifier.refresh,
                  child: notifier.visibleTodos.isEmpty
                      ? ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: const [
                            SizedBox(height: 120),
                            Center(child: Text('Tidak ada data.')),
                          ],
                        )
                      : ListView.builder(
                          controller: _scrollController,
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.all(16),
                          itemCount:
                              notifier.visibleTodos.length +
                                  (notifier.isLoadingMore ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index >= notifier.visibleTodos.length) {
                              return const Padding(
                                padding: EdgeInsets.symmetric(vertical: 16),
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }
                            final todo = notifier.visibleTodos[index];
                            return Padding(
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
                                          onPressed: () =>
                                              Navigator.pop(ctx, false),
                                          child: const Text('Batal'),
                                        ),
                                        FilledButton(
                                          onPressed: () =>
                                              Navigator.pop(ctx, true),
                                          child: const Text('Hapus'),
                                        ),
                                      ],
                                    ),
                                  );
                                  if (ok == true && context.mounted) {
                                    await context
                                        .read<TodoApiNotifier>()
                                        .deleteTodo(todo.id);
                                  }
                                },
                              ),
                            );
                          },
                        ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
