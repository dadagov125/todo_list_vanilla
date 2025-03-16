import 'dart:async';

import 'package:todo_list/core/core.dart';
import 'package:todo_list/feature/todo/domain/domain.dart';

class RemoveTodoItemUseCase extends UseCase<void, int> {
  RemoveTodoItemUseCase({
    required TodoItemsStorage itemsStorage,
  }) : _itemsStorage = itemsStorage;

  final TodoItemsStorage _itemsStorage;

  @override
  FutureOr<void> execute([int? params]) async {
    if (params == null) {
      throw ArgumentError.notNull('params');
    }
    final items = await _itemsStorage.getItems();
    items.removeWhere((element) => element.id == params);
    await _itemsStorage.saveItems(items);
  }
}
