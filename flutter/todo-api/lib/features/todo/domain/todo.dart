import 'todo_status.dart';

/// Domain entity mapped from DummyJSON.
class Todo {
  const Todo({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.createdDate,
  });

  final int id;
  final String title;
  final String description;
  final TodoStatus status;
  final DateTime createdDate;

  Todo copyWith({
    int? id,
    String? title,
    String? description,
    TodoStatus? status,
    DateTime? createdDate,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      createdDate: createdDate ?? this.createdDate,
    );
  }
}
