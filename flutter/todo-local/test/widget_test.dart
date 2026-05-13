import 'package:flutter_test/flutter_test.dart';

import 'package:todo_local/features/todo/domain/todo.dart';
import 'package:todo_local/features/todo/domain/todo_status.dart';

void main() {
  test('Todo serializes to JSON and back', () {
    final original = Todo(
      id: '1',
      title: 'Test',
      description: 'Desc',
      status: TodoStatus.pending,
      createdDate: DateTime.utc(2026, 1, 1),
    );
    final restored = Todo.fromJson(original.toJson());
    expect(restored.id, original.id);
    expect(restored.title, original.title);
    expect(restored.description, original.description);
    expect(restored.status, original.status);
    expect(restored.createdDate.toIso8601String(), original.createdDate.toIso8601String());
  });
}
