import 'package:todo_list/core/core.dart';
import 'package:todo_list/feature/todo/todo.dart';

class AppDependencyContainers extends DependencyContainer {
  AppDependencyContainers();

  late final CoreDependencyContainer coreDependency;
  late final TodoDependencyContainer todoDependency;

  @override
  Future<void> initialize() async {
    coreDependency = CoreDependencyContainer();
    await coreDependency.initialize();

    todoDependency = TodoDependencyContainer(coreDependency: coreDependency);
    await todoDependency.initialize();
  }

  @override
  Future<void> dispose() async {
    await todoDependency.dispose();
    await coreDependency.dispose();
  }
}
