import 'package:todo_list/core/core.dart';
import 'package:todo_list/feature/todo/todo.dart';

abstract class TodoItemsStorage implements Disposable {
  const TodoItemsStorage();
  Future<List<TodoItem>> getItems();

  Stream<List<TodoItem>> watchItems();

  Future<void> saveItems(List<TodoItem> items);

  Future<void> clear();
}
