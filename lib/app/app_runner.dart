import 'package:flutter/material.dart';
import 'package:todo_list/app/di.dart';
import 'package:todo_list/core/core.dart';
import 'package:todo_list/feature/todo/todo.dart';

class AppRunner extends StatefulWidget {
  const AppRunner({
    required this.containers,
    required this.child,
    super.key,
  });

  final AppDependencyContainers containers;
  final Widget child;

  @override
  State<AppRunner> createState() => _AppRunnerState();
}

class _AppRunnerState extends State<AppRunner> {
  @override
  Widget build(BuildContext context) => CoreDependency(
        container: widget.containers.coreDependency,
        child: TodoDependency(
          container: widget.containers.todoDependency,
          child: widget.child,
        ),
      );
}
