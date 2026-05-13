import '../domain/todo.dart';
import '../domain/todo_status.dart';
import 'todo_remote_api.dart';

class TodoRemoteRepository {
  TodoRemoteRepository(this._api);

  final TodoRemoteApi _api;

  Future<({List<Todo> items, int total})> fetchPage({
    required int limit,
    required int skip,
    String? searchQuery,
  }) async {
    final page = await _api.fetchTodos(
      limit: limit,
      skip: skip,
      searchQuery: searchQuery,
    );
    final items = page.todos
        .map((dto) => dto.toDomain(createdFallback: DateTime.now()))
        .toList();
    return (items: items, total: page.total);
  }

  Future<Todo> create({
    required String title,
    required String description,
    required TodoStatus status,
  }) async {
    final dto = await _api.addTodo(
      title: title,
      completed: status == TodoStatus.done,
    );
    return dto
        .toDomain(createdFallback: DateTime.now())
        .copyWith(description: description);
  }

  Future<Todo> update({
    required int id,
    required String title,
    required String description,
    required TodoStatus status,
  }) async {
    final dto = await _api.updateTodo(
      id: id,
      title: title,
      completed: status == TodoStatus.done,
    );
    return dto
        .toDomain(createdFallback: DateTime.now())
        .copyWith(description: description);
  }

  Future<void> delete(int id) => _api.deleteTodo(id);

  void dispose() {
    _api.dispose();
  }
}
