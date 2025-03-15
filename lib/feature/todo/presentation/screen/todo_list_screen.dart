import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_list/feature/todo/todo.dart';

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
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
          const Duration(days: 1, hours: 2, minutes: 10, seconds: 30)),
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

  @override
  void initState() {
    super.initState();
    _sortItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: const Text('Todo List'),
            centerTitle: false,
            pinned: true,
            actions: [
              IconButton(
                onPressed: () {
                  setState(() {
                    _isAscending = !_isAscending;
                    _sortItems();
                  });
                },
                icon: Icon(
                  _isAscending ? Icons.arrow_downward : Icons.arrow_upward,
                ),
              ),
              DropdownButton(
                value: _sortOption,
                items: [
                  ...TodoItemSortOption.values.map(
                    (e) => DropdownMenuItem(
                      value: e,
                      child: Text(
                        e.name,
                      ),
                    ),
                  ),
                ],
                onChanged: (item) {
                  setState(() {
                    _sortOption = item!;
                    _sortItems();
                  });
                },
              ),
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
        ],
      ),
    );
  }
}
