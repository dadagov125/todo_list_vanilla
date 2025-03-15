import 'package:flutter/material.dart';
import 'package:todo_list/core/core.dart';

class TodoDependencyContainer extends DependencyInitializer {
  TodoDependencyContainer({required CoreDependencyContainer coreDependency})
      : _coreDependency = coreDependency;

  final CoreDependencyContainer _coreDependency;

  @override
  Future<void> initialize() async {}
}

class TodoDependency extends InheritedWidget {
  const TodoDependency({
    required super.child,
    required this.container,
    super.key,
  });

  final TodoDependencyContainer container;

  @override
  bool updateShouldNotify(covariant TodoDependency oldWidget) =>
      oldWidget.container != container;

  static TodoDependencyContainer of(
    BuildContext context, {
    bool listen = false,
  }) {
    if (listen) {
      return context
          .dependOnInheritedWidgetOfExactType<TodoDependency>()!
          .container;
    } else {
      final element =
          context.getElementForInheritedWidgetOfExactType<TodoDependency>();

      assert(element != null, 'TodoDependency not found in context');

      return (element!.widget as TodoDependency).container;
    }
  }
}
