import 'dart:async';

import 'package:todo_list/core/core.dart';
import 'package:todo_list/feature/todo/todo.dart';

class SaveTodoItemUseCase extends UseCase<void, TodoItem> {
  SaveTodoItemUseCase({
    required TodoItemsStorage itemsStorage,
  }) : _itemsStorage = itemsStorage;
  final TodoItemsStorage _itemsStorage;

  @override
  Future<void> execute([TodoItem? params]) async {
    if (params == null) {
      throw ArgumentError.notNull('params');
    }
    final items = await _itemsStorage.getItems();

    final index = items.indexWhere((element) => element.id == params.id);
    items[index] = params;
    await _itemsStorage.saveItems(items);
  }
}
