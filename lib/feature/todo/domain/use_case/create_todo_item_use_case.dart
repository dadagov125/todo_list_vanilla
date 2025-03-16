import 'dart:async';
import 'dart:math';

import 'package:todo_list/core/core.dart';
import 'package:todo_list/feature/todo/todo.dart';

class CreateTodoItemByNameUseCase extends UseCase<void, String> {
  CreateTodoItemByNameUseCase({
    required TodoItemsStorage todoItemsStorage,
  }) : _todoItemsStorage = todoItemsStorage;
  final TodoItemsStorage _todoItemsStorage;

  @override
  FutureOr<void> execute([String? params]) async {
    if (params == null) {
      throw ArgumentError('Params cannot be null');
    }

    final dateTime = DateTime.now();

    final id = Random().nextInt(1000000 - 1000) + 1000;

    final newItem = TodoItem(
      id: dateTime.millisecondsSinceEpoch + id,
      name: params,
      description: '',
      createdAt: dateTime,
      attachments: [],
    );

    final items = await _todoItemsStorage.getItems();
    items.add(newItem);

    await _todoItemsStorage.saveItems(items);
  }
}
