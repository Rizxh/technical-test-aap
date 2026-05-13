import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/theme/app_theme.dart';
import 'features/todo/data/todo_local_repository.dart';
import 'features/todo/presentation/pages/todo_home_page.dart';
import 'features/todo/presentation/todo_local_notifier.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final repository = TodoLocalRepository(prefs);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => TodoLocalNotifier(repository)..load(),
        ),
      ],
      child: const TodoLocalApp(),
    ),
  );
}

class TodoLocalApp extends StatelessWidget {
  const TodoLocalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo Local',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      home: const TodoHomePage(),
    );
  }
}
