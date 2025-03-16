import 'package:flutter/material.dart';
import 'package:todo_list/feature/todo/todo.dart';

class EditItemFieldsForm extends StatelessWidget {
  const EditItemFieldsForm({
    required this.item,
    required this.isLoading,
    super.key,
  });

  final TodoItem item;
  final bool isLoading;

  @override
  Widget build(BuildContext context) => Form(
        child: Column(
          spacing: 16,
          children: [
            TextFormField(
              initialValue: item.name,
              enabled: !isLoading,
              decoration: const InputDecoration(
                labelText: 'Name',
              ),
              maxLines: 2,
              onChanged: (value) =>
                  EditTodoItemControllerScope.of(context).updateItem(
                item.copyWith(name: value),
              ),
            ),
            TextFormField(
              initialValue: item.description,
              enabled: !isLoading,
              decoration: const InputDecoration(
                labelText: 'Description',
              ),
              maxLines: 4,
              onChanged: (value) =>
                  EditTodoItemControllerScope.of(context).updateItem(
                item.copyWith(description: value),
              ),
            ),
          ],
        ),
      );
}
