import 'package:flutter/material.dart';
import 'package:todo_list/core/core.dart';
import 'package:todo_list/feature/todo/todo.dart';

class TodoDependencyContainer extends DependencyContainer {
  TodoDependencyContainer({required CoreDependencyContainer coreDependency})
      : _coreDependency = coreDependency;

  final CoreDependencyContainer _coreDependency;

  late final TodoItemsStorage todoItemsStorage;
  late final FileService fileService;

  @override
  Future<void> initialize() async {
    todoItemsStorage = TodoItemsStorageImpl(
      sharedPreferences: _coreDependency.sharedPreferences,
    );
    fileService = _coreDependency.fileService;
  }

  @override
  Future<void> dispose() async {
    await todoItemsStorage.dispose();
  }
}

class TodoDependencyScope extends InheritedWidget {
  const TodoDependencyScope({
    required super.child,
    required this.container,
    super.key,
  });

  final TodoDependencyContainer container;

  @override
  bool updateShouldNotify(covariant TodoDependencyScope oldWidget) =>
      oldWidget.container != container;

  static TodoDependencyContainer of(
    BuildContext context, {
    bool listen = false,
  }) {
    if (listen) {
      return context
          .dependOnInheritedWidgetOfExactType<TodoDependencyScope>()!
          .container;
    } else {
      final element = context
          .getElementForInheritedWidgetOfExactType<TodoDependencyScope>();
      assert(element != null, 'TodoDependencyScope not found in context');
      return (element!.widget as TodoDependencyScope).container;
    }
  }
}
