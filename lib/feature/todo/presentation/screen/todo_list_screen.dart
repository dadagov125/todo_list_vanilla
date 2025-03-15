import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_list/feature/todo/todo.dart';

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  final _controller = TextEditingController();
  final _dateFormat = DateFormat('DD MMM HH:mm:ss');

  bool _isAscending = false;

  TodoItemSortOption _sortOption = TodoItemSortOption.date;

  final List<TodoItem> _todoItems = [
    TodoItem(
      name: 'name3',
      description: 'description 233333',
      createdAt: DateTime.now(),
      attachments: ['attachment1', 'attachment2'],
    ),
    TodoItem(
      name: 'name2',
      description: 'description2',
      createdAt: DateTime.now().subtract(
        const Duration(days: 1, hours: 2, minutes: 10, seconds: 30),
      ),
      attachments: [],
    ),
    TodoItem(
      name: 'name3 sd sd sd sd fs df sd fs df sdfasdfsdfasdfa'
          'sdfasdfsadfsad'
          ' fsdafasdfsadf sadfasdf sadfsadf sadfsadfsdaf ',
      description:
          'description3 s s sd sd sd sd sd sd sd sa s dasd sadacfsdfasdfsadf'
          'asdfsadfsd fsd fsadfsadfsadfsda fsdafsdafsadfsadfs adf as'
          'df asd f asdf sad ',
      createdAt: DateTime.now().subtract(const Duration(days: 2, minutes: 30)),
      attachments: [],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _sortItems();
  }

  void _sortItems() {
    _todoItems.sort((a, b) {
      int comparison;
      if (_sortOption == TodoItemSortOption.date) {
        comparison = a.createdAt.compareTo(b.createdAt);
      } else {
        comparison = a.name.compareTo(b.name);
      }
      return _isAscending ? comparison : -comparison;
    });
  }

  void _addNewItem() {
    final name = _controller.text;
    if (name.isNotEmpty) {
      setState(() {
        _todoItems.add(
          TodoItem(
            name: name,
            description: '',
            createdAt: DateTime.now(),
            attachments: [],
          ),
        );
        _sortItems();
      });
      _controller.clear();
    }
  }

  void _changeSortOrder() {
    setState(() {
      _isAscending = !_isAscending;
      _sortItems();
    });
  }

  void _changeSortOption(item) {
    setState(() {
      _sortOption = item!;
      _sortItems();
    });
  }

  DropdownMenuItem<TodoItemSortOption> _mapSortMenuItem(
    TodoItemSortOption item,
  ) =>
      DropdownMenuItem(value: item, child: Text(item.name));

  Widget get _sortMenu => DropdownButton(
        value: _sortOption,
        items: TodoItemSortOption.values.map(_mapSortMenuItem).toList(),
        onChanged: _changeSortOption,
      );

  @override
  Widget build(BuildContext context) => Stack(
        children: [
          Scaffold(
            body: CustomScrollView(
              slivers: [
                SliverAppBar(
                  title: const Text('Todo List'),
                  centerTitle: false,
                  pinned: true,
                  actions: [
                    IconButton(
                      onPressed: _changeSortOrder,
                      icon: Icon(
                        _isAscending
                            ? Icons.arrow_downward
                            : Icons.arrow_upward,
                      ),
                    ),
                    _sortMenu,
                    const SizedBox(width: 16),
                  ],
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final todoItem = _todoItems[index];
                      return ListTile(
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
                    },
                    childCount: _todoItems.length,
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
                        controller: _controller,
                        decoration: const InputDecoration(
                          hintText: 'Add new todo',
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: _addNewItem,
                      icon: const Icon(Icons.add),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
}
