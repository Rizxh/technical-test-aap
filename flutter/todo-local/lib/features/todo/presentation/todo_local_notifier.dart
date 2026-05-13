import 'package:flutter/foundation.dart';

import '../data/todo_local_repository.dart';
import '../domain/todo.dart';
import '../domain/todo_filter.dart';
import '../domain/todo_status.dart';

class TodoLocalNotifier extends ChangeNotifier {
  TodoLocalNotifier(this._repository);

  final TodoLocalRepository _repository;

  List<Todo> _todos = <Todo>[];
  String _searchQuery = '';
  TodoFilter _filter = TodoFilter.all;
  String? _loadError;
  bool _isLoading = false;

  List<Todo> get todos => List.unmodifiable(_todos);
  String get searchQuery => _searchQuery;
  TodoFilter get filter => _filter;
  String? get loadError => _loadError;
  bool get isLoading => _isLoading;

  List<Todo> get visibleTodos {
    final q = _searchQuery.trim().toLowerCase();
    return _todos.where((todo) {
      final matchesFilter = switch (_filter) {
        TodoFilter.all => true,
        TodoFilter.done => todo.status == TodoStatus.done,
        TodoFilter.pending => todo.status == TodoStatus.pending,
      };
      final matchesSearch =
          q.isEmpty || todo.title.toLowerCase().contains(q);
      return matchesFilter && matchesSearch;
    }).toList();
  }

  Future<void> load() async {
    _isLoading = true;
    _loadError = null;
    notifyListeners();
    try {
      _todos = await _repository.loadTodos();
    } on FormatException catch (e) {
      _loadError = 'Gagal membaca data: ${e.message}';
      _todos = <Todo>[];
    } catch (e) {
      _loadError = 'Gagal memuat data lokal.';
      _todos = <Todo>[];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setSearchQuery(String value) {
    _searchQuery = value;
    notifyListeners();
  }

  void setFilter(TodoFilter value) {
    _filter = value;
    notifyListeners();
  }

  Future<void> addTodo({
    required String title,
    required String description,
    required TodoStatus status,
  }) async {
    final todo = Todo(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: title.trim(),
      description: description.trim(),
      status: status,
      createdDate: DateTime.now(),
    );
    _todos = <Todo>[todo, ..._todos];
    await _persist();
  }

  Future<void> updateTodo(Todo updated) async {
    _todos = _todos
        .map((t) => t.id == updated.id ? updated : t)
        .toList(growable: false);
    await _persist();
  }

  Future<void> deleteTodo(String id) async {
    _todos = _todos.where((t) => t.id != id).toList(growable: false);
    await _persist();
  }

  Future<void> toggleStatus(String id) async {
    _todos = _todos.map((t) {
      if (t.id != id) return t;
      final next = t.status == TodoStatus.done
          ? TodoStatus.pending
          : TodoStatus.done;
      return t.copyWith(status: next);
    }).toList(growable: false);
    await _persist();
  }

  Future<void> _persist() async {
    await _repository.saveTodos(_todos);
    notifyListeners();
  }
}
