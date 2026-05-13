import 'dart:async';

import 'package:flutter/foundation.dart';

import '../data/todo_remote_repository.dart';
import '../domain/todo.dart';
import '../domain/todo_filter.dart';
import '../domain/todo_status.dart';

class TodoApiNotifier extends ChangeNotifier {
  TodoApiNotifier(this._repository);

  final TodoRemoteRepository _repository;

  static const int pageSize = 10;

  final List<Todo> _items = <Todo>[];
  int _total = 0;
  bool _isLoading = false;
  bool _isLoadingMore = false;
  String? _error;
  TodoFilter _filter = TodoFilter.all;
  String _searchInput = '';
  String _committedSearch = '';
  Timer? _debounce;

  List<Todo> get items => List.unmodifiable(_items);
  int get total => _total;
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  String? get error => _error;
  TodoFilter get filter => _filter;
  String get searchInput => _searchInput;

  bool get hasMore => _items.length < _total;

  List<Todo> get visibleTodos {
    return _items.where((todo) {
      return switch (_filter) {
        TodoFilter.all => true,
        TodoFilter.done => todo.status == TodoStatus.done,
        TodoFilter.pending => todo.status == TodoStatus.pending,
      };
    }).toList();
  }

  Future<void> init() => refresh();

  void setFilter(TodoFilter value) {
    _filter = value;
    notifyListeners();
  }

  void setSearchInput(String value) {
    _searchInput = value;
    notifyListeners();
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 450), () {
      _committedSearch = value.trim();
      unawaited(refresh());
    });
  }

  Future<void> refresh() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final page = await _repository.fetchPage(
        limit: pageSize,
        skip: 0,
        searchQuery: _committedSearch.isEmpty ? null : _committedSearch,
      );
      _items
        ..clear()
        ..addAll(page.items);
      _total = page.total;
    } catch (e) {
      _error = 'Gagal memuat data dari API.';
      _items.clear();
      _total = 0;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMore() async {
    if (!_canLoadMore()) return;
    _isLoadingMore = true;
    notifyListeners();
    try {
      final page = await _repository.fetchPage(
        limit: pageSize,
        skip: _items.length,
        searchQuery: _committedSearch.isEmpty ? null : _committedSearch,
      );
      _items.addAll(page.items);
      _total = page.total;
    } catch (e) {
      _error = 'Gagal memuat halaman berikutnya.';
    } finally {
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  bool _canLoadMore() {
    if (_isLoading || _isLoadingMore) return false;
    if (_items.length >= _total) return false;
    return true;
  }

  Future<void> createTodo({
    required String title,
    required String description,
    required TodoStatus status,
  }) async {
    _error = null;
    notifyListeners();
    try {
      await _repository.create(
        title: title,
        description: description,
        status: status,
      );
      await refresh();
    } catch (e) {
      _error = 'Gagal menambah todo.';
      notifyListeners();
    }
  }

  Future<void> updateTodo(Todo todo) async {
    _error = null;
    notifyListeners();
    try {
      await _repository.update(
        id: todo.id,
        title: todo.title,
        description: todo.description,
        status: todo.status,
      );
      await refresh();
    } catch (e) {
      _error = 'Gagal memperbarui todo.';
      notifyListeners();
    }
  }

  Future<void> deleteTodo(int id) async {
    _error = null;
    notifyListeners();
    try {
      await _repository.delete(id);
      await refresh();
    } catch (e) {
      _error = 'Gagal menghapus todo.';
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _repository.dispose();
    super.dispose();
  }
}
