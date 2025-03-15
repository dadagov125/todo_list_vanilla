import 'package:todo_list/feature/todo/todo.dart';

class TodoList {
  const TodoList({
    required this.items,
    this.comparator = const TodoItemComparator(),
  });

  final List<TodoItem> items;

  final TodoItemComparator comparator;

  TodoList copyWith({
    List<TodoItem>? items,
    TodoItemComparator? comparator,
  }) =>
      TodoList(
        items: items ?? this.items,
        comparator: comparator ?? this.comparator,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TodoList &&
          runtimeType == other.runtimeType &&
          items == other.items &&
          comparator == other.comparator;

  @override
  int get hashCode => items.hashCode ^ comparator.hashCode;
}
