import 'package:flutter/material.dart';
import 'package:todo_list/feature/todo/todo.dart';

class EditTodoItemScreen extends StatelessWidget {
  const EditTodoItemScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = EditTodoItemControllerScope.of(context);
    return EditTodoItemControllerListener(
      listenable: controller,
      child: ValueListenableBuilder(
        valueListenable: controller,
        builder: (context, value, _) {
          final isLoading = value.isLoading;
          final item = value.data;
          return Stack(
            children: [
              Scaffold(
                body: CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      title: const Text('Edit todo item'),
                      pinned: true,
                      actions: [
                        ItemRemoveButton(
                          controller: controller,
                        ),
                        const SizedBox(width: 16),
                      ],
                    ),
                    SliverFillRemaining(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: item != null
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                spacing: 16,
                                children: [
                                  EditItemFieldsForm(
                                    item: item,
                                    controller: controller,
                                    isLoading: isLoading,
                                  ),
                                  ItemAttachments(
                                    item: item,
                                    controller: controller,
                                  ),
                                  const Spacer(),
                                  FilledButton(
                                    onPressed: controller.save,
                                    child: const Text('Save'),
                                  ),
                                ],
                              )
                            : const SizedBox(),
                      ),
                    ),
                  ],
                ),
              ),
              if (isLoading) const Center(child: CircularProgressIndicator()),
            ],
          );
        },
      ),
    );
  }
}
