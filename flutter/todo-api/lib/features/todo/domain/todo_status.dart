enum TodoStatus {
  pending,
  done,
}

extension TodoStatusX on TodoStatus {
  String get label => switch (this) {
        TodoStatus.pending => 'Pending',
        TodoStatus.done => 'Done',
      };
}
