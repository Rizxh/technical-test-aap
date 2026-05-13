import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';
import 'features/todo/data/todo_remote_api.dart';
import 'features/todo/data/todo_remote_repository.dart';
import 'features/todo/presentation/pages/todo_api_home_page.dart';
import 'features/todo/presentation/todo_api_notifier.dart';

void main() {
  final api = TodoRemoteApi();
  final repository = TodoRemoteRepository(api);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => TodoApiNotifier(repository)..init(),
        ),
      ],
      child: const TodoApiApp(),
    ),
  );
}

class TodoApiApp extends StatelessWidget {
  const TodoApiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo API',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      home: const TodoApiHomePage(),
    );
  }
}
