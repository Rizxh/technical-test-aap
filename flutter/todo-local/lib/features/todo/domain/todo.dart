import 'todo_status.dart';

/// Domain model for a single todo item.
class Todo {
  const Todo({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.createdDate,
  });

  final String id;
  final String title;
  final String description;
  final TodoStatus status;
  final DateTime createdDate;

  Todo copyWith({
    String? id,
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

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'description': description,
      'status': status.name,
      'createdDate': createdDate.toIso8601String(),
    };
  }

  factory Todo.fromJson(Map<String, dynamic> json) {
    final statusRaw = json['status'] as String? ?? TodoStatus.pending.name;
    return Todo(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      status: TodoStatus.values.firstWhere(
        (s) => s.name == statusRaw,
        orElse: () => TodoStatus.pending,
      ),
      createdDate: DateTime.tryParse(json['createdDate'] as String? ?? '') ??
          DateTime.now(),
    );
  }
}
