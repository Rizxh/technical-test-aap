enum TodoFilter {
  all,
  done,
  pending,
}

extension TodoFilterX on TodoFilter {
  String get label => switch (this) {
        TodoFilter.all => 'All',
        TodoFilter.done => 'Done',
        TodoFilter.pending => 'Pending',
      };
}
