import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../core/constants/api_constants.dart';
import 'todo_remote_dto.dart';

class TodoRemoteApi {
  TodoRemoteApi({http.Client? client})
      : _client = client ?? http.Client(),
        _ownsClient = client == null;

  final http.Client _client;
  final bool _ownsClient;

  Uri _listUri({
    required int limit,
    required int skip,
    String? searchQuery,
  }) {
    final q = searchQuery?.trim() ?? '';
    if (q.isEmpty) {
      return Uri.parse('${ApiConstants.dummyJsonBase}/todos').replace(
        queryParameters: <String, String>{
          'limit': '$limit',
          'skip': '$skip',
        },
      );
    }
    return Uri.parse('${ApiConstants.dummyJsonBase}/todos/search').replace(
      queryParameters: <String, String>{
        'q': q,
        'limit': '$limit',
        'skip': '$skip',
      },
    );
  }

  Future<({List<TodoRemoteDto> todos, int total})> fetchTodos({
    required int limit,
    required int skip,
    String? searchQuery,
  }) async {
    final uri = _listUri(
      limit: limit,
      skip: skip,
      searchQuery: searchQuery,
    );

    final res = await _client.get(uri);
    _throwIfFailed(res);
    final map = jsonDecode(res.body) as Map<String, dynamic>;
    final list = (map['todos'] as List<dynamic>? ?? const <dynamic>[])
        .whereType<Map<String, dynamic>>()
        .map(TodoRemoteDto.fromJson)
        .toList();
    final total = (map['total'] as num?)?.toInt() ?? list.length;
    return (todos: list, total: total);
  }

  Future<TodoRemoteDto> addTodo({
    required String title,
    required bool completed,
  }) async {
    final uri = Uri.parse('${ApiConstants.dummyJsonBase}/todos/add');
    final res = await _client.post(
      uri,
      headers: const {'Content-Type': 'application/json'},
      body: jsonEncode(<String, Object?>{
        'todo': title,
        'completed': completed,
        'userId': 1,
      }),
    );
    _throwIfFailed(res);
    final map = jsonDecode(res.body) as Map<String, dynamic>;
    return TodoRemoteDto.fromJson(map);
  }

  Future<TodoRemoteDto> updateTodo({
    required int id,
    required String title,
    required bool completed,
  }) async {
    final uri = Uri.parse('${ApiConstants.dummyJsonBase}/todos/$id');
    final res = await _client.put(
      uri,
      headers: const {'Content-Type': 'application/json'},
      body: jsonEncode(<String, Object?>{
        'todo': title,
        'completed': completed,
      }),
    );
    _throwIfFailed(res);
    final map = jsonDecode(res.body) as Map<String, dynamic>;
    return TodoRemoteDto.fromJson(map);
  }

  Future<void> deleteTodo(int id) async {
    final uri = Uri.parse('${ApiConstants.dummyJsonBase}/todos/$id');
    final res = await _client.delete(uri);
    _throwIfFailed(res);
  }

  void _throwIfFailed(http.Response res) {
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw TodoApiException(
        'Request failed (${res.statusCode})',
        statusCode: res.statusCode,
      );
    }
  }

  void dispose() {
    if (_ownsClient) {
      _client.close();
    }
  }
}

class TodoApiException implements Exception {
  TodoApiException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  @override
  String toString() => 'TodoApiException: $message';
}
