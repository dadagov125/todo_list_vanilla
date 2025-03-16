import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:todo_list/core/core.dart';
import 'package:todo_list/feature/todo/todo.dart';

class TodoItemsController extends AsyncStateController<TodoList> {
  TodoItemsController({
    required GetTodoItemsUseCase getItemsUseCase,
    required GetTodoItemsStreamUseCase getItemsStreamUseCase,
    required CreateTodoItemByNameUseCase createTodoItemByNameUseCase,
  })  : _createTodoItemByNameUseCase = createTodoItemByNameUseCase,
        _getItemsStreamUseCase = getItemsStreamUseCase,
        _getItemsUseCase = getItemsUseCase,
        super(AsyncS.initial(null)) {
    _streamSubscription = _getItemsStreamUseCase.execute().listen((items) {
      addTask((setValue) async {
        final prevState = value;
        final todoList = prevState.data ?? const TodoList(items: []);
        final itemsCopy = [...items];
        itemsCopy.sort(todoList.comparator.call);
        setValue(
          AsyncS.loaded(todoList.copyWith(items: itemsCopy)),
        );
      });
    });
  }

  final GetTodoItemsUseCase _getItemsUseCase;
  final GetTodoItemsStreamUseCase _getItemsStreamUseCase;
  final CreateTodoItemByNameUseCase _createTodoItemByNameUseCase;
  late final StreamSubscription _streamSubscription;

  void loadItems() {
    addTask((setValue) async {
      try {
        final prevState = value;
        setValue(AsyncS.loading(prevState));
        final items = await _getItemsUseCase.execute();
        setValue(
          AsyncS.loaded(TodoList(items: items)),
        );
      } on Object catch (e) {
        setValue(AsyncS.error(e));
      }
    });
  }

  void addNewItem(String name) {
    if (name.isEmpty) return;
    addTask((setValue) async {
      try {
        setValue(AsyncS.loading(value));

        await _createTodoItemByNameUseCase.execute(name);
      } on Object catch (e) {
        setValue(AsyncS.error(e));
      }
    });
  }

  void sort(TodoItemComparator comparator) {
    addTask(
      (setValue) async {
        try {
          value.mapOrNull(
            loaded: (state) {
              final todoList = state.data;
              final itemsCopy = [...todoList.items];
              itemsCopy.sort(comparator.call);
              setValue(
                AsyncS.loaded(
                  todoList.copyWith(items: itemsCopy, comparator: comparator),
                ),
              );
            },
          );
        } on Object catch (e) {
          setValue(AsyncS.error(e));
        }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _streamSubscription.cancel();
  }
}

class TodoItemsControllerScope extends StatefulWidget {
  const TodoItemsControllerScope({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  State<TodoItemsControllerScope> createState() =>
      _TodoItemsControllerScopeState();

  static TodoItemsController of(BuildContext context, {bool listen = false}) {
    if (listen) {
      return context
          .dependOnInheritedWidgetOfExactType<_InheritedTodoItemsController>()!
          .notifier!;
    } else {
      final element = context.getElementForInheritedWidgetOfExactType<
          _InheritedTodoItemsController>();

      assert(element != null, 'TodoItemsController not found in context');

      return (element!.widget as _InheritedTodoItemsController).notifier!;
    }
  }
}

class _TodoItemsControllerScopeState extends State<TodoItemsControllerScope> {
  late final TodoItemsController _controller;

  @override
  void initState() {
    super.initState();

    final itemsStorage = TodoDependency.of(context).todoItemsStorage;
    _controller = TodoItemsController(
      getItemsUseCase: GetTodoItemsUseCase(todoItemsStorage: itemsStorage),
      getItemsStreamUseCase:
          GetTodoItemsStreamUseCase(todoItemsStorage: itemsStorage),
      createTodoItemByNameUseCase: CreateTodoItemByNameUseCase(
        todoItemsStorage: itemsStorage,
      ),
    );

    _controller.loadItems();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) => _InheritedTodoItemsController(
        notifier: _controller,
        child: widget.child,
      );
}

class _InheritedTodoItemsController
    extends InheritedNotifier<TodoItemsController> {
  const _InheritedTodoItemsController({
    required super.child,
    required super.notifier,
  });
}
