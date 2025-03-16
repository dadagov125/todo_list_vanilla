import 'package:flutter/material.dart';
import 'package:todo_list/feature/todo/todo.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        themeMode: ThemeMode.system,
        title: 'Todo list Demo',
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        initialRoute: '/todo-items',
        routes: {
          '/todo-items': (context) => const TodoItemsControllerScope(
                child: TodoListScreen(),
              ),
          '/edit-todo-item': (context) {
            final itemId = ModalRoute.of(context)?.settings.arguments as int;
            return EditTodoItemControllerScope(
              itemId: itemId,
              child: const EditTodoItemScreen(),
            );
          },
        },
      );
}
