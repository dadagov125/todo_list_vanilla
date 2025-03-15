import 'package:flutter/material.dart';
import 'package:todo_list/feature/home/home.dart';
import 'package:todo_list/feature/todo/presentation/screen/todo_list_screen.dart';

class App extends StatelessWidget {
  const App({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const TodoListScreen()
    );
  }
}
