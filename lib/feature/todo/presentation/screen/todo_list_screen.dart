import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_list/core/core.dart';
import 'package:todo_list/feature/todo/todo.dart';

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  final _itemsController = TodoItemsController();
  final _controller = TextEditingController();
  final _dateFormat = DateFormat('DD MMM HH:mm:ss');

  @override
  void initState() {
    super.initState();
    _itemsController.loadItems();
  }

  @override
  void dispose() {
    _itemsController.dispose();
    super.dispose();
  }

  void _createItem() {
    _itemsController.addNewItem(_controller.text);
    _controller.clear();
  }

  void _sort(TodoItemSortOption? value, TodoList todoList) {
    _itemsController.sort(
      TodoItemComparator(
        sortOption: value!,
        isAscending: todoList.comparator.isAscending,
      ),
    );
  }

  void _order(TodoList todoList) {
    _itemsController.sort(
      TodoItemComparator(
        sortOption: todoList.comparator.sortOption,
        isAscending: !todoList.comparator.isAscending,
      ),
    );
  }

  List<DropdownMenuItem<TodoItemSortOption>> _getMenuItems() =>
      TodoItemSortOption.values
          .map((item) => DropdownMenuItem(value: item, child: Text(item.name)))
          .toList();

  List<Widget> _getActions(AsyncS<TodoList> state) {
    final todoList = state.data;
    if (todoList == null) return [];
    final isLoading = state.isLoading;
    return [
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
    ];
  }

  Widget _getListTile(TodoItem todoItem) => ListTile(
        title: Text(
          todoItem.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          todoItem.description,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          spacing: 8,
          children: [
            Text(_dateFormat.format(todoItem.createdAt)),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.attach_file, size: 16),
                Text(todoItem.attachments.length.toString()),
              ],
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) => ValueListenableBuilder(
        valueListenable: _itemsController,
        builder: (context, value, child) {
          final isLoading = value.isLoading;
          final todoList = value.data;
          final items = todoList?.items ?? [];
          return Stack(
            children: [
              Scaffold(
                body: CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      title: const Text('Todo List'),
                      centerTitle: false,
                      pinned: true,
                      actions: _getActions(value),
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => _getListTile(items[index]),
                        childCount: items.length,
                      ),
                    ),
                    const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
                  ],
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: MediaQuery.viewInsetsOf(context).bottom,
                child: Material(
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    color: Theme.of(context).colorScheme.surfaceContainer,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: TextField(
                            enabled: !isLoading,
                            controller: _controller,
                            decoration: const InputDecoration(
                              hintText: 'Add new todo',
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: !isLoading ? _createItem : null,
                          icon: const Icon(Icons.add),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (isLoading) const Center(child: CircularProgressIndicator()),
            ],
          );
        },
      );
}
