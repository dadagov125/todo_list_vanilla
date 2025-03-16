import 'package:flutter/material.dart';
import 'package:todo_list/core/core.dart';

class EditTodoItemControllerListener extends ValueListenableListener {
  EditTodoItemControllerListener({
    required super.listenable,
    required super.child,
    super.key,
  }) : super(
          listenWhen: (previous, current) =>
              (previous.isLoading &&
                  current.isInitial &&
                  current.data == null) ||
              (previous.data != null && previous.isLoading && current.isLoaded),
          listen: (context, current) {
            Navigator.pop(context);
          },
        );
}
