import 'package:flutter/material.dart';
import 'package:todo_list/core/core.dart';
import 'package:todo_list/feature/todo/todo.dart';

class TodoItemsListSortButtons extends StatefulWidget {
  const TodoItemsListSortButtons({
    required this.state,
    super.key,
  });

  final AsyncS<TodoList> state;

  @override
  State<TodoItemsListSortButtons> createState() =>
      _TodoItemsListSortButtonsState();
}

class _TodoItemsListSortButtonsState extends State<TodoItemsListSortButtons> {
  List<DropdownMenuItem<TodoItemSortOption>> _getMenuItems() =>
      TodoItemSortOption.values
          .map((item) => DropdownMenuItem(value: item, child: Text(item.name)))
          .toList();

  void _order(TodoList todoList) {
    TodoItemsControllerScope.of(context).sort(
      TodoItemComparator(
        sortOption: todoList.comparator.sortOption,
        isAscending: !todoList.comparator.isAscending,
      ),
    );
  }

  void _sort(TodoItemSortOption? value, TodoList todoList) {
    TodoItemsControllerScope.of(context).sort(
      TodoItemComparator(
        sortOption: value!,
        isAscending: todoList.comparator.isAscending,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    final todoList = state.data;
    if (todoList == null) {
      return const SizedBox.shrink();
    }
    final isLoading = state.isLoading;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: !isLoading ? () => _order(todoList) : null,
          icon: Icon(
            todoList.comparator.isAscending
                ? Icons.arrow_downward
                : Icons.arrow_upward,
          ),
        ),
        DropdownButton(
          value: todoList.comparator.sortOption,
          items: _getMenuItems(),
          onChanged: !isLoading
              ? (TodoItemSortOption? value) => _sort(value, todoList)
              : null,
        ),
        const SizedBox(width: 16),
      ],
    );
  }
}
