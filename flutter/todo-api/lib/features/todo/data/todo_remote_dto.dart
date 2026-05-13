import '../domain/todo.dart';
import '../domain/todo_status.dart';

/// Raw JSON shape from DummyJSON `/todos` endpoints.
class TodoRemoteDto {
  const TodoRemoteDto({
    required this.id,
    required this.todo,
    required this.completed,
  });

  final int id;
  final String todo;
  final bool completed;

  factory TodoRemoteDto.fromJson(Map<String, dynamic> json) {
    return TodoRemoteDto(
      id: (json['id'] as num?)?.toInt() ?? 0,
      todo: json['todo'] as String? ?? '',
      completed: json['completed'] as bool? ?? false,
    );
  }

  Todo toDomain({DateTime? createdFallback}) {
    return Todo(
      id: id,
      title: todo,
      description: todo,
      status: completed ? TodoStatus.done : TodoStatus.pending,
      createdDate: createdFallback ?? DateTime.now(),
    );
  }
}
