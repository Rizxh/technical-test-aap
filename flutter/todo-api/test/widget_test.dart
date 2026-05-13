import 'package:flutter_test/flutter_test.dart';

import 'package:todo_api/features/todo/data/todo_remote_dto.dart';
import 'package:todo_api/features/todo/domain/todo_status.dart';

void main() {
  test('TodoRemoteDto maps DummyJSON shape to domain', () {
    final dto = TodoRemoteDto.fromJson(<String, dynamic>{
      'id': 12,
      'todo': 'Sample',
      'completed': true,
    });
    final domain = dto.toDomain(createdFallback: DateTime.utc(2026, 2, 2));
    expect(domain.id, 12);
    expect(domain.title, 'Sample');
    expect(domain.status, TodoStatus.done);
    expect(domain.createdDate, DateTime.utc(2026, 2, 2));
  });
}
