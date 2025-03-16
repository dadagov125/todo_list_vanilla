import 'package:flutter/material.dart';
import 'package:todo_list/app/di.dart';
import 'package:todo_list/core/core.dart';
import 'package:todo_list/feature/todo/todo.dart';

class AppRunner extends StatefulWidget {
  const AppRunner({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  State<AppRunner> createState() => _AppRunnerState();
}

class _AppRunnerState extends State<AppRunner> {
  final _containers = AppDependencyContainers();

  late final Future<void> _appInitializeFuture;

  @override
  void initState() {
    super.initState();
    _appInitializeFuture = Future.wait([_containers.initialize()]);
  }

  @override
  void dispose() {
    _containers.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => FutureBuilder(
        future: _appInitializeFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const SizedBox.shrink();
          }
          if (snapshot.error != null) {
            return MaterialApp(
              home: Scaffold(
                body: Center(
                  child: Text('Error: ${snapshot.error}'),
                ),
              ),
            );
          }
          return CoreDependencyScope(
            container: _containers.coreDependency,
            child: TodoDependencyScope(
              container: _containers.todoDependency,
              child: widget.child,
            ),
          );
        },
      );
}
