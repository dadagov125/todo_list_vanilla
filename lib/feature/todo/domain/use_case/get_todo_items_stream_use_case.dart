import 'package:todo_list/core/core.dart';
import 'package:todo_list/feature/todo/todo.dart';

class GetTodoItemsStreamUseCase extends UseCaseStream<List<TodoItem>, void> {
  GetTodoItemsStreamUseCase({
    required TodoItemsStorage todoItemsStorage,
  }) : _todoItemsStorage = todoItemsStorage;
  final TodoItemsStorage _todoItemsStorage;

  @override
  Stream<List<TodoItem>> execute([void params]) =>
      _todoItemsStorage.watchItems();
}
