import 'package:flutter/material.dart';
import 'package:todo_list/feature/home/home.dart';
import 'package:todo_list/feature/todo/presentation/screen/todo_list_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        themeMode: ThemeMode.system,
        title: 'Todo list Demo',
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        home: const TodoListScreen(),
      );
}
