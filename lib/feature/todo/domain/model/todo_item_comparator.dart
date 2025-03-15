import 'package:todo_list/core/core.dart';
import 'package:todo_list/feature/todo/todo.dart';

class TodoItemComparator extends Comparator<TodoItem> {
  const TodoItemComparator({
    this.sortOption = TodoItemSortOption.date,
    this.isAscending = false,
  });

  final TodoItemSortOption sortOption;

  final bool isAscending;

  @override
  int call(TodoItem a, TodoItem b) {
    int comparison;
    if (sortOption == TodoItemSortOption.date) {
      comparison = a.createdAt.compareTo(b.createdAt);
    } else {
      comparison = a.name.compareTo(b.name);
    }
    return isAscending ? comparison : -comparison;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TodoItemComparator &&
          runtimeType == other.runtimeType &&
          sortOption == other.sortOption &&
          isAscending == other.isAscending;

  @override
  int get hashCode => sortOption.hashCode ^ isAscending.hashCode;
}
