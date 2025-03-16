import 'package:flutter/material.dart';
import 'package:todo_list/core/core.dart';
import 'package:todo_list/feature/todo/todo.dart';

class ItemRemoveButton extends StatelessWidget {
  const ItemRemoveButton({
    required this.controller,
    super.key,
  });

  final EditTodoItemController controller;

  Future<void> _removeItem(BuildContext context) async {
    final ok = await AppAlertDialog.show(
      context: context,
      titleText: 'Delete item',
      contentText: 'Are you sure you want to delete this item?',
    );
    if (ok == true) {
      controller.remove();
    }
  }

  @override
  Widget build(BuildContext context) => IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () => _removeItem(context),
      );
}
