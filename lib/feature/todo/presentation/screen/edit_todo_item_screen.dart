import 'dart:io';

import 'package:flutter/material.dart';
import 'package:todo_list/core/core.dart';
import 'package:todo_list/feature/todo/todo.dart';

class EditTodoItemScreen extends StatefulWidget {
  const EditTodoItemScreen({super.key});

  @override
  State<EditTodoItemScreen> createState() => _EditTodoItemScreenState();
}

class _EditTodoItemScreenState extends State<EditTodoItemScreen> {
  void _openFilePicker(EditTodoItemController controller) async {
    await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Галерея'),
                onTap: () {
                  controller.addFile(FileSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Камера'),
                onTap: () {
                  controller.addFile(FileSource.camera);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _removeItem(EditTodoItemController controller) async {
    final ok = await AppAlertDialog.show(
      context: context,
      titleText: 'Delete item',
      contentText: 'Are you sure you want to delete this item?',
    );
    if (ok == true) {
      controller.remove();
    }
  }

  bool _popWhen(AsyncS<TodoItem?> previous, AsyncS<TodoItem?> current) =>
      (previous.isLoading && current.isInitial && current.data == null) ||
      (previous.data != null && previous.isLoading && current.isLoaded);

  void _pop(AsyncS<TodoItem?> current) {
    Navigator.pop(context);
  }

  Widget _getAttachments(TodoItem item, EditTodoItemController controller) =>
      Wrap(
        spacing: 4,
        runSpacing: 4,
        children: [
          ...item.attachments.map(
            (i) => GestureDetector(
              onTap: () {
                controller.removeFile(i);
              },
              child: Image.file(
                File(i),
                width: 75,
                height: 50,
              ),
            ),
          ),
          SizedBox(
            width: 50,
            height: 50,
            child: IconButton(
              style: const ButtonStyle(
                splashFactory: NoSplash.splashFactory,
              ),
              icon: const Icon(
                Icons.attach_file,
              ),
              onPressed: () => _openFilePicker(
                controller,
              ),
            ),
          ),
        ],
      );

  @override
  Widget build(BuildContext context) => Builder(
        builder: (context) {
          final controller = EditTodoItemControllerScope.of(context);
          return ValueListenableListener(
            listenable: controller,
            listenWhen: _popWhen,
            listen: _pop,
            child: ValueListenableBuilder(
              valueListenable: controller,
              builder: (context, value, child) {
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
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () => _removeItem(controller),
                              ),
                              const SizedBox(width: 16),
                            ],
                          ),
                          SliverFillRemaining(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: item != null
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
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
                                              controller.updateItem(
                                            item.copyWith(name: value),
                                          ),
                                        ),
                                        TextFormField(
                                          initialValue: item.description,
                                          enabled: !isLoading,
                                          decoration: const InputDecoration(
                                            labelText: 'Description',
                                          ),
                                          maxLines: 5,
                                          onChanged: (value) =>
                                              controller.updateItem(
                                            item.copyWith(description: value),
                                          ),
                                        ),
                                        const SizedBox(height: 24),
                                        const Text('Attachments'),
                                        _getAttachments(item, controller),
                                        const Spacer(),
                                        FilledButton(
                                          onPressed: controller.save,
                                          child: const Text('Save'),
                                        ),
                                      ],
                                    )
                                  : null,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isLoading)
                      const Center(child: CircularProgressIndicator()),
                  ],
                );
              },
            ),
          );
        },
      );
}
