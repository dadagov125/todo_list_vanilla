import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_list/feature/todo/todo.dart';

class TodoListItemTile extends StatefulWidget {
  const TodoListItemTile({
    required this.item,
    super.key,
  });

  final TodoItem item;

  @override
  State<TodoListItemTile> createState() => _TodoListItemTileState();
}

class _TodoListItemTileState extends State<TodoListItemTile> {
  final _dateFormat = DateFormat('DD MMM HH:mm:ss');

  @override
  Widget build(BuildContext context) => ListTile(
        onTap: () {
          Navigator.of(context).pushNamed(
            '/edit-todo-item',
            arguments: widget.item.id,
          );
        },
        key: ValueKey(widget.item.id),
        title: Text(
          widget.item.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          widget.item.description,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          spacing: 8,
          children: [
            Text(_dateFormat.format(widget.item.createdAt)),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.attach_file, size: 16),
                Text(widget.item.attachments.length.toString()),
              ],
            ),
          ],
        ),
      );
}
