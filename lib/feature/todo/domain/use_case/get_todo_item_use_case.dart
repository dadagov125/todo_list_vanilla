import 'dart:async';

import 'package:todo_list/core/core.dart';
import 'package:todo_list/feature/todo/todo.dart';

class GetTodoItemUseCase extends UseCase<TodoItem, int> {
  GetTodoItemUseCase({
    required TodoItemsStorage itemsStorage,
  }) : _itemsStorage = itemsStorage;

  final TodoItemsStorage _itemsStorage;

  @override
  FutureOr<TodoItem> execute([int? params]) async {
    if (params == null) {
      throw ArgumentError.notNull('params');
    }
    final items = await _itemsStorage.getItems();
    return items.firstWhere((element) => element.id == params);
  }
}
