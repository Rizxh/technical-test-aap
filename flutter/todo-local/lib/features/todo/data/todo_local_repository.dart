import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants/app_storage.dart';
import '../domain/todo.dart';

/// Persists todos as JSON in [SharedPreferences].
class TodoLocalRepository {
  TodoLocalRepository(this._prefs);

  final SharedPreferences _prefs;

  Future<List<Todo>> loadTodos() async {
    final raw = _prefs.getString(AppStorage.todoItemsKey);
    if (raw == null || raw.isEmpty) {
      return <Todo>[];
    }
    final decoded = jsonDecode(raw);
    if (decoded is! List<dynamic>) {
      return <Todo>[];
    }
    return decoded
        .whereType<Map<String, dynamic>>()
        .map(Todo.fromJson)
        .toList();
  }

  Future<void> saveTodos(List<Todo> todos) async {
    final encoded = jsonEncode(todos.map((e) => e.toJson()).toList());
    await _prefs.setString(AppStorage.todoItemsKey, encoded);
  }
}
