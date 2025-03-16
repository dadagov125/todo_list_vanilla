import 'dart:io';

import 'package:flutter/material.dart';
import 'package:todo_list/core/core.dart';
import 'package:todo_list/feature/todo/todo.dart';

class ItemAttachments extends StatelessWidget {
  const ItemAttachments({
    required this.item,
    super.key,
  });

  final TodoItem item;

  void _openFilePicker(
    BuildContext context,
  ) async {
    await showModalBottomSheet(
      context: context,
      builder: (_) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Галерея'),
                onTap: () {
                  EditTodoItemControllerScope.of(context)
                      .addFile(FileSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Камера'),
                onTap: () {
                  EditTodoItemControllerScope.of(context)
                      .addFile(FileSource.camera);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 16,
        children: [
          const Text('Attachments'),
          Wrap(
            spacing: 4,
            runSpacing: 4,
            children: [
              ...item.attachments.map(
                (i) => GestureDetector(
                  onTap: () {
                    EditTodoItemControllerScope.of(context).removeFile(i);
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
                  onPressed: () => _openFilePicker(context),
                ),
              ),
            ],
          ),
        ],
      );
}
