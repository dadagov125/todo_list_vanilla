import 'package:todo_list/feature/todo/todo.dart';

abstract class TodoItemsStorage {
  Future<List<TodoItem>> getItems();

  Stream<List<TodoItem>> watchItems();

  Future<void> saveItems(List<TodoItem> items);

  Future<void> clear();
}
