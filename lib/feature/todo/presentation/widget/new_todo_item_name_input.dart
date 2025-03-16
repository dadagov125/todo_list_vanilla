import 'package:flutter/material.dart';
import 'package:todo_list/feature/todo/todo.dart';

class NewTodoItemNameInput extends StatefulWidget {
  const NewTodoItemNameInput({
    required this.isLoading,
    super.key,
  });

  final bool isLoading;

  @override
  State<NewTodoItemNameInput> createState() => _NewTodoItemNameInputState();
}

class _NewTodoItemNameInputState extends State<NewTodoItemNameInput> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void _createItem() {
    FocusManager.instance.primaryFocus?.unfocus();
    TodoItemsControllerScope.of(context).addNewItem(_controller.text);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) => Material(
        child: Container(
          padding: const EdgeInsets.all(24),
          color: Theme.of(context).colorScheme.surfaceContainer,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: TextField(
                  onTapOutside: (_) {
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  enabled: !widget.isLoading,
                  textInputAction: TextInputAction.send,
                  controller: _controller,
                  decoration: const InputDecoration(
                    hintText: 'Add new todo',
                  ),
                  onSubmitted: (_) => _createItem(),
                ),
              ),
              IconButton(
                onPressed: !widget.isLoading ? _createItem : null,
                icon: const Icon(Icons.send),
              ),
            ],
          ),
        ),
      );
}
