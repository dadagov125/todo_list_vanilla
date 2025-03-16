import 'dart:async';

import 'package:todo_list/core/core.dart';
import 'package:todo_list/feature/todo/todo.dart';

class GetTodoItemsUseCase extends UseCase<List<TodoItem>, void> {
  GetTodoItemsUseCase({
    required TodoItemsStorage todoItemsStorage,
  }) : _todoItemsStorage = todoItemsStorage;
  final TodoItemsStorage _todoItemsStorage;

  @override
  FutureOr<List<TodoItem>> execute([void params]) =>
      _todoItemsStorage.getItems();
}
